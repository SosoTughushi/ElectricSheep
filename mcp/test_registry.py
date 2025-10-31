"""Test script for MCP server tool registry"""

import sys
from pathlib import Path

# Add project root to path
project_root = Path(__file__).parent.parent.parent
sys.path.insert(0, str(project_root))

from mcp.server.tool_registry import ToolRegistry

def test_registry():
    """Test tool registry loading"""
    print("Testing Tool Registry...")
    print(f"Project root: {project_root}")
    
    try:
        registry = ToolRegistry()
        print("✓ Registry loaded successfully")
        
        # Test tool loading
        tools = registry.get_tools()
        print(f"✓ Found {len(tools)} tools")
        
        for tool_id, tool_info in tools.items():
            print(f"  - {tool_id}: {tool_info.get('name', 'Unknown')}")
        
        # Test operations
        operations = registry.get_operations()
        print(f"\n✓ Found {len(operations)} operations")
        
        print("\nOperations by category:")
        categories = {}
        for op in operations:
            tool_id = op['tool_id']
            tool_info = registry.get_tool(tool_id)
            category = tool_info.get('category', 'unknown')
            if category not in categories:
                categories[category] = []
            categories[category].append(op['code'])
        
        for category, ops in categories.items():
            print(f"\n  {category.upper()}:")
            for op_code in ops:
                op = next((o for o in operations if o['code'] == op_code), None)
                if op:
                    print(f"    - {op_code}: {op.get('name', '')}")
        
        print("\n✓ All tests passed!")
        return True
        
    except Exception as e:
        print(f"✗ Error: {e}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == "__main__":
    success = test_registry()
    sys.exit(0 if success else 1)

