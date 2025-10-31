"""MCP Server startup script"""

import sys
import os
from pathlib import Path

# Add project root to path
project_root = Path(__file__).parent.parent.parent
sys.path.insert(0, str(project_root))

# Now import and run the server
from mcp.server.server import main
import asyncio

if __name__ == "__main__":
    asyncio.run(main())

