"""Startup script for MCP server"""

import sys
import subprocess
from pathlib import Path

# Get project root
project_root = Path(__file__).parent.parent.parent

# Run the server module
subprocess.run([
    sys.executable,
    "-m",
    "mcp.server.server"
], cwd=str(project_root))

