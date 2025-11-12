# MemCP Setup Guide

## Installation Complete!

MemCP has been installed to: tools\mcp\memcp

## Next Steps

### 1. Set Up Neo4j Database

MemCP requires a Neo4j database. You have two options:

#### Option A: Docker (Recommended)
`powershell
docker run -d 
    --name neo4j-memcp 
    -p 7474:7474 -p 7687:7687 
    -e NEO4J_AUTH=neo4j/your_password_here 
    neo4j:latest
`

#### Option B: Install Neo4j Desktop
1. Download from https://neo4j.com/download/
2. Install and create a new database
3. Note your password

### 2. Configure Environment Variables

1. Copy .env.example to .env:
   `powershell
   Copy-Item .env.example .env
   `

2. Edit .env and fill in:
   - NEO4J_PASSWORD: Your Neo4j password
   - OPENAI_API_KEY: Your OpenAI API key
   - ANTHROPIC_API_KEY: (Optional) Your Anthropic API key

### 3. Start MemCP Server

`powershell
cd tools\mcp\memcp
memcp
`

Or if installed via git:
`powershell
cd tools\mcp\memcp
python memcp.py
`

The server will start on http://localhost:8000

### 4. Configure MCP Client

Add to your Cursor MCP configuration (%APPDATA%\Cursor\mcp.json):

`json
{
  "mcpServers": {
    "electric-sheep": {
      "command": "python",
      "args": ["-m", "mcp.server.server"],
      "cwd": "YOUR_WORKSPACE_ROOT"
    },
    "MemCP": {
      "transport": "sse",
      "url": "http://localhost:8000/sse"
    }
  }
}
`

### 5. Restart Cursor

Restart Cursor IDE to load the new MCP server configuration.

## Usage

Once configured, you can:

- **Explicit memory**: "Remember that this conversation was about installing MemCP"
- **Automatic memory**: MemCP will automatically capture context from conversations
- **Retrieve memories**: "What did we discuss about MCP servers?"

## Troubleshooting

### Server won't start
- Check Neo4j is running: docker ps or check Neo4j Desktop
- Verify .env file exists and has correct values
- Check port 8000 is not in use

### Connection errors
- Ensure MemCP server is running before starting Cursor
- Check firewall settings for port 8000
- Verify SSE transport is supported by your MCP client

### Memory not working
- Check MemCP server logs for errors
- Verify Neo4j connection in .env
- Ensure OpenAI API key is valid

## More Information

- GitHub: https://github.com/evanmschultz/memcp
- Documentation: https://mcp.altinors.com
