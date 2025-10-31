"""MCP Server for Electric Sheep Toolset - Main Entry Point"""

import asyncio
import json
import subprocess
import sys
from pathlib import Path
from typing import Any, Dict, List

try:
    from mcp.server.fastmcp import FastMCP
    from mcp.server.models import InitializationOptions
except ImportError:
    try:
        from mcp.server import Server
        from mcp.server.stdio import stdio_server
        from mcp.types import Tool, TextContent
        FastMCP = None
    except ImportError:
        raise ImportError(
            "MCP SDK not found. Install with: pip install mcp"
        )

from .tool_registry import ToolRegistry


def create_server(registry: ToolRegistry):
    """Create MCP server instance"""
    
    if FastMCP is not None:
        # Use FastMCP (simpler API)
        mcp = FastMCP("electric-sheep")
        
        # Register operations as tools
        operations = registry.get_operations()
        
        for op in operations:
            op_code = op['code']
            op_name = op.get('name', op_code)
            op_desc = op.get('description', '')
            
            # Create dynamic tool handler with proper closure
            def make_handler(op_code_inner: str, reg: ToolRegistry):
                def handler(**kwargs: Any) -> str:
                    """Execute operation"""
                    return execute_operation_sync(reg, op_code_inner, kwargs)
                handler.__name__ = op_code_inner.replace(':', '_').replace('-', '_')
                handler.__doc__ = op_desc
                return handler
            
            tool_handler = make_handler(op_code, registry)
            mcp.tool(name=op_code, description=op_desc)(tool_handler)
        
        return mcp
    
    else:
        # Use standard MCP SDK
        server = Server("electric-sheep")
        
        @server.list_tools()
        async def list_tools() -> List[Tool]:
            """List all available tools"""
            operations = registry.get_operations()
            tools = []
            
            for op in operations:
                properties = {}
                required = []
                
                for param in op.get('parameters', []):
                    param_name = param['name']
                    param_type = param.get('type', 'string')
                    
                    json_type = 'string'
                    if 'int' in param_type:
                        json_type = 'integer'
                    elif 'float' in param_type or 'number' in param_type:
                        json_type = 'number'
                    elif 'boolean' in param_type or 'bool' in param_type:
                        json_type = 'boolean'
                    elif 'array' in param_type:
                        json_type = 'array'
                    
                    properties[param_name] = {
                        'type': json_type,
                        'description': param.get('description', '')
                    }
                    
                    if param.get('default') is not None:
                        properties[param_name]['default'] = param.get('default')
                    
                    if param.get('required', False):
                        required.append(param_name)
                
                tools.append(Tool(
                    name=op['code'],
                    description=op.get('description', op.get('name', '')),
                    inputSchema={
                        'type': 'object',
                        'properties': properties,
                        'required': required
                    }
                ))
            
            return tools
        
        @server.call_tool()
        async def call_tool(name: str, arguments: Dict[str, Any]) -> List[TextContent]:
            """Execute a tool"""
            result = execute_operation_sync(registry, name, arguments)
            return [TextContent(type="text", text=result)]
        
        return server


def execute_operation_sync(
    registry: ToolRegistry,
    operation_code: str,
    arguments: Dict[str, Any]
) -> str:
    """Execute an operation synchronously"""
    try:
        # Find the operation
        operations = registry.get_operations()
        operation = next((op for op in operations if op['code'] == operation_code), None)
        
        if not operation:
            return json.dumps({
                "error": f"Operation '{operation_code}' not found",
                "available_operations": [op['code'] for op in operations]
            }, indent=2)
        
        # Get tool info
        tool_id = operation['tool_id']
        tool_info = registry.get_tool(tool_id)
        
        if not tool_info:
            return f"Error: Tool '{tool_id}' not found"
        
        # Build script path
        tool_path = tool_info['path']
        script_path = tool_path / operation['entry_point']
        
        if not script_path.exists():
            return f"Error: Script not found: {script_path}"
        
        # Prepare PowerShell command
        ps_args = []
        for param_name, param_value in arguments.items():
            if param_name == 'operation_code':
                continue
            
            # Format as PowerShell parameter
            if isinstance(param_value, bool):
                if param_value:
                    ps_args.append(f"-{param_name}")
            elif isinstance(param_value, list):
                # Convert array to PowerShell array format
                array_str = ','.join(str(v) for v in param_value)
                ps_args.append(f"-{param_name} @({array_str})")
            else:
                # Escape quotes in string values
                escaped_value = str(param_value).replace('"', '`"')
                ps_args.append(f"-{param_name} \"{escaped_value}\"")
        
        # Execute PowerShell script
        cmd = [
            'powershell.exe',
            '-ExecutionPolicy', 'Bypass',
            '-File', str(script_path),
            *ps_args
        ]
        
        # Change to workspace directory
        workspace_root = registry.workspace_root
        cwd = str(workspace_root)
        
        # Run the command
        result = subprocess.run(
            cmd,
            cwd=cwd,
            capture_output=True,
            text=True,
            encoding='utf-8',
            errors='replace',
            timeout=3600  # 1 hour timeout
        )
        
        # Return result
        output_parts = []
        
        if result.stdout:
            output_parts.append(f"Output:\n{result.stdout}")
        
        if result.stderr:
            output_parts.append(f"Errors:\n{result.stderr}")
        
        if result.returncode != 0:
            output_parts.append(f"Exit code: {result.returncode}")
        
        if not output_parts:
            output_parts.append("Operation completed successfully")
        
        return "\n".join(output_parts)
        
    except subprocess.TimeoutExpired:
        return "Error: Operation timed out after 1 hour"
    except Exception as e:
        import traceback
        return f"Error executing operation: {str(e)}\n{traceback.format_exc()}"


async def main():
    """Main entry point"""
    # Get workspace root from command line or use default
    workspace_root = sys.argv[1] if len(sys.argv) > 1 else None
    
    registry = ToolRegistry(workspace_root)
    server = create_server(registry)
    
    if FastMCP is not None:
        # FastMCP uses run() method
        server.run()
    else:
        # Standard MCP uses stdio_server
        async with stdio_server() as (read_stream, write_stream):
            await server.run(
                read_stream,
                write_stream,
                InitializationOptions(
                    server_name="electric-sheep",
                    server_version="1.0.0",
                    capabilities=server.get_capabilities()
                )
            )


if __name__ == "__main__":
    asyncio.run(main())
