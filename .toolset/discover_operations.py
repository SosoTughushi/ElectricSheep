#!/usr/bin/env python3
"""
Operations Discovery Script
Query available operations in the Electric Sheep toolset.
"""

import json
import sys
from pathlib import Path

def load_operations():
    """Load operations registry."""
    ops_file = Path(__file__).parent / "operations.json"
    with open(ops_file, 'r', encoding='utf-8') as f:
        return json.load(f)

def list_all_operations(operations_data):
    """List all operations."""
    print("Available Operations:\n")
    for op in operations_data['operations']:
        print(f"  {op['code']:<35} {op['name']}")
        print(f"    {op['description']}")
        print()

def list_by_category(operations_data, category=None):
    """List operations by category."""
    if category:
        ops = [op for op in operations_data['operations'] if op['category'] == category]
        print(f"Operations in category '{category}':\n")
    else:
        print("Operations by Category:\n")
        for cat_name, cat_info in operations_data['categories'].items():
            print(f"  {cat_name.upper()}: {cat_info['description']}")
            ops = [op for op in operations_data['operations'] if op['category'] == cat_name]
            for op in ops:
                print(f"    - {op['code']}: {op['name']}")
            print()
        return
    
    for op in ops:
        print(f"  {op['code']:<35} {op['name']}")
        print(f"    {op['description']}")
        print()

def get_operation(operations_data, code):
    """Get detailed information about a specific operation."""
    op = next((o for o in operations_data['operations'] if o['code'] == code), None)
    if not op:
        print(f"Operation '{code}' not found.", file=sys.stderr)
        return
    
    print(f"Operation: {op['name']}")
    print(f"Code: {op['code']}")
    print(f"Description: {op['description']}")
    print(f"Category: {op['category']}")
    print(f"Tool: {op['tool']}")
    print(f"Entry Point: {op['entry_point']}")
    print(f"Privacy: {op['privacy']}")
    print(f"Tags: {', '.join(op['tags'])}")
    print("\nParameters:")
    for param_name, param_info in op['parameters'].items():
        req = "required" if param_info.get('required', False) else "optional"
        param_type = param_info.get('type', 'unknown')
        source = param_info.get('source', 'parameter')
        print(f"  {param_name} ({param_type}, {req}, source: {source})")
        if 'description' in param_info:
            print(f"    {param_info['description']}")

def main():
    """Main entry point."""
    operations_data = load_operations()
    
    if len(sys.argv) == 1:
        # No arguments - list all
        list_all_operations(operations_data)
    elif sys.argv[1] == "--category" or sys.argv[1] == "-c":
        # List by category
        category = sys.argv[2] if len(sys.argv) > 2 else None
        list_by_category(operations_data, category)
    elif sys.argv[1] == "--code" or sys.argv[1] == "-o":
        # Get specific operation
        code = sys.argv[2] if len(sys.argv) > 2 else None
        if not code:
            print("Usage: discover_operations.py --code <operation_code>", file=sys.stderr)
            sys.exit(1)
        get_operation(operations_data, code)
    elif sys.argv[1] == "--help" or sys.argv[1] == "-h":
        print("Operations Discovery Tool")
        print("\nUsage:")
        print("  python discover_operations.py                    # List all operations")
        print("  python discover_operations.py --category        # List by category")
        print("  python discover_operations.py --category system  # List system operations")
        print("  python discover_operations.py --code <code>       # Get operation details")
        print("\nExamples:")
        print("  python discover_operations.py --code bambu-lab:launch")
        print("  python discover_operations.py --category ai")
    else:
        print(f"Unknown option: {sys.argv[1]}", file=sys.stderr)
        print("Use --help for usage information.", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()

