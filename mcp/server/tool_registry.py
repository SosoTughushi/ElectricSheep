"""Tool registry loader for MCP server"""

import json
import os
from pathlib import Path
from typing import Dict, List, Optional, Any


class ToolRegistry:
    """Loads and manages tool definitions from registry and manifests"""
    
    def __init__(self, workspace_root: Optional[str] = None):
        if workspace_root is None:
            # Try to find workspace root by looking for .toolset/registry.json
            # Start from current file and go up until we find it
            current = Path(__file__).resolve()
            workspace_root = current.parent.parent.parent
            
            # Verify registry exists, if not try current directory
            if not (workspace_root / ".toolset" / "registry.json").exists():
                # Try current working directory
                cwd = Path.cwd()
                if (cwd / ".toolset" / "registry.json").exists():
                    workspace_root = cwd
        else:
            workspace_root = Path(workspace_root)
        
        self.workspace_root = workspace_root
        self.registry_path = workspace_root / ".toolset" / "registry.json"
        self.tools: Dict[str, Dict[str, Any]] = {}
        self._load_registry()
    
    def _load_registry(self):
        """Load tool registry and manifests"""
        if not self.registry_path.exists():
            raise FileNotFoundError(f"Registry not found: {self.registry_path}")
        
        with open(self.registry_path, 'r', encoding='utf-8') as f:
            registry = json.load(f)
        
        # Load each tool's manifest
        for tool_info in registry.get('tools', []):
            tool_id = tool_info['id']
            tool_path = self.workspace_root / tool_info['path']
            manifest_path = tool_path / "MANIFEST.json"
            
            if manifest_path.exists():
                with open(manifest_path, 'r', encoding='utf-8') as f:
                    manifest = json.load(f)
                
                # Merge registry info with manifest
                self.tools[tool_id] = {
                    **manifest,
                    'path': tool_path,
                    'category': tool_info.get('category', manifest.get('category')),
                    'status': tool_info.get('status', 'active')
                }
            else:
                # Fallback to registry info only
                self.tools[tool_id] = {
                    **tool_info,
                    'path': tool_path
                }
    
    def get_tools(self) -> Dict[str, Dict[str, Any]]:
        """Get all registered tools"""
        return self.tools
    
    def get_tool(self, tool_id: str) -> Optional[Dict[str, Any]]:
        """Get a specific tool by ID"""
        return self.tools.get(tool_id)
    
    def get_tools_by_category(self, category: str) -> List[Dict[str, Any]]:
        """Get all tools in a category"""
        return [
            tool for tool in self.tools.values()
            if tool.get('category') == category
        ]
    
    def get_operations(self) -> List[Dict[str, Any]]:
        """Get all operations from all tools"""
        operations = []
        
        for tool_id, tool_info in self.tools.items():
            # Generate operations from entry points
            entry_points = tool_info.get('entry_points', {})
            primary = entry_points.get('primary')
            alternatives = entry_points.get('alternatives', [])
            
            # Create operation for primary entry point
            if primary:
                # Generate operation code from script name (e.g., "launch-tool.ps1" -> "launch-tool")
                script_stem = Path(primary).stem.replace('_', '-').replace('.', '-')
                # Remove common prefixes/suffixes for cleaner codes
                script_stem = script_stem.replace('-script', '').replace('-main', '')
                op_code = f"{tool_id}:{script_stem}" if script_stem else f"{tool_id}:primary"
                
                operations.append({
                    'code': op_code,
                    'name': f"{tool_info.get('name', tool_id)} - {Path(primary).stem}",
                    'description': tool_info.get('description', ''),
                    'tool_id': tool_id,
                    'entry_point': primary,
                    'parameters': tool_info.get('parameters', [])
                })
            
            # Create operations for alternatives
            for idx, alt in enumerate(alternatives):
                script_stem = Path(alt).stem.replace('_', '-').replace('.', '-')
                script_stem = script_stem.replace('-script', '').replace('-main', '')
                op_code = f"{tool_id}:{script_stem}" if script_stem else f"{tool_id}:alt{idx+1}"
                
                operations.append({
                    'code': op_code,
                    'name': f"{tool_info.get('name', tool_id)} - {Path(alt).stem}",
                    'description': tool_info.get('description', ''),
                    'tool_id': tool_id,
                    'entry_point': alt,
                    'parameters': tool_info.get('parameters', [])
                })
            
            # Create common operations based on tool type
            if tool_id == 'bambu-lab-affinity':
                operations.extend([
                    {
                        'code': 'bambu-lab:launch',
                        'name': 'Launch Bambu Lab',
                        'description': 'Launch Bambu Lab with automatic CPU affinity fix',
                        'tool_id': tool_id,
                        'entry_point': 'scripts/bambulab-launcher.ps1',
                        'parameters': tool_info.get('parameters', [])
                    },
                    {
                        'code': 'bambu-lab:set-affinity',
                        'name': 'Set Bambu Lab Affinity',
                        'description': 'Set CPU affinity for running Bambu Lab process',
                        'tool_id': tool_id,
                        'entry_point': 'scripts/set-bambulab-affinity.ps1',
                        'parameters': tool_info.get('parameters', [])
                    },
                    {
                        'code': 'bambu-lab:find-installation',
                        'name': 'Find Bambu Studio Installation',
                        'description': 'Find Bambu Studio installation path',
                        'tool_id': tool_id,
                        'entry_point': 'scripts/find-bambustudio.ps1',
                        'parameters': []
                    }
                ])
            elif tool_id == 'cpu-affinity-check':
                operations.append({
                    'code': 'cpu-affinity:check',
                    'name': 'Check CPU Affinity',
                    'description': 'Check CPU affinity for processes',
                    'tool_id': tool_id,
                    'entry_point': 'scripts/check-affinity.ps1',
                    'parameters': tool_info.get('parameters', [])
                })
            elif tool_id == 'musubi-tuner':
                operations.extend([
                    {
                        'code': 'musubi-tuner:wan:cache-latents',
                        'name': 'Cache Wan Latents',
                        'description': 'Cache VAE latents for Wan training',
                        'tool_id': tool_id,
                        'entry_point': 'scripts/wan-cache-latents.ps1',
                        'parameters': []
                    },
                    {
                        'code': 'musubi-tuner:wan:cache-text-encoder',
                        'name': 'Cache Wan Text Encoder',
                        'description': 'Cache text encoder outputs for Wan training',
                        'tool_id': tool_id,
                        'entry_point': 'scripts/wan-cache-text-encoder.ps1',
                        'parameters': []
                    },
                    {
                        'code': 'musubi-tuner:wan:train',
                        'name': 'Train Wan LoRA',
                        'description': 'Train LoRA model using Wan architecture',
                        'tool_id': tool_id,
                        'entry_point': 'scripts/wan-train.ps1',
                        'parameters': []
                    },
                    {
                        'code': 'musubi-tuner:wan:generate',
                        'name': 'Generate with Wan',
                        'description': 'Generate video with Wan model',
                        'tool_id': tool_id,
                        'entry_point': 'scripts/wan-generate.ps1',
                        'parameters': []
                    }
                ])
        
        return operations

