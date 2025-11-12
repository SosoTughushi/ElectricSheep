# MemCP Integration Guide

MemCP (Memory Context Protocol) provides persistent memory for AI conversations, enabling your assistant to remember context across sessions.

## What is MemCP?

MemCP is an MCP server that:
- **Stores memories** from conversations in a Neo4j knowledge graph
- **Retrieves context** automatically or on demand
- **Works alongside** your Electric Sheep MCP server
- **Enables continuity** - your AI remembers past conversations

## Quick Installation

### Step 1: Run Setup Script

```powershell
cd mcp
.\memcp-setup.ps1
```

This will:
- Check Python version (requires 3.10+)
- Install MemCP via pip
- Create configuration templates
- Generate setup guide

### Step 2: Set Up Neo4j Database

MemCP requires a Neo4j database. Choose one:

**Option A: Docker (Recommended)**
```powershell
docker run -d `
    --name neo4j-memcp `
    -p 7474:7474 -p 7687:7687 `
    -e NEO4J_AUTH=neo4j/your_password_here `
    neo4j:latest
```

**Option B: Neo4j Desktop**
1. Download from https://neo4j.com/download/
2. Install and create a new database
3. Note your password

### Step 3: Configure Environment

```powershell
cd mcp\tools\mcp\memcp
Copy-Item .env.example .env
# Edit .env with your favorite editor
```

Edit `.env` and set:
- `NEO4J_PASSWORD`: Your Neo4j password
- `OPENAI_API_KEY`: Your OpenAI API key
- `ANTHROPIC_API_KEY`: (Optional) Your Anthropic API key

### Step 4: Start MemCP Server

```powershell
cd mcp\tools\mcp\memcp
memcp
```

The server will start on `http://localhost:8000`

### Step 5: Configure MCP Client

Add MemCP to your Cursor MCP configuration (`%APPDATA%\Cursor\mcp.json`):

```json
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
```

### Step 6: Restart Cursor

Restart Cursor IDE to load the new MCP server configuration.

## Usage

### Explicit Memory Commands

Tell your AI to remember something:

```
"Remember that this conversation was about installing MemCP"
"Store this: I prefer Python over JavaScript"
"Save this conversation as 'MCP memory discussion'"
```

### Automatic Memory

MemCP automatically captures context from conversations and builds a knowledge graph. No explicit commands needed!

### Retrieving Memories

Ask your AI to recall information:

```
"What did we discuss about MCP servers?"
"What is my favorite programming language?"
"Recall our conversation about MemCP installation"
```

## How It Works

1. **MemCP Server**: Runs independently on port 8000
2. **Neo4j Database**: Stores memories as a knowledge graph
3. **MCP Client**: Connects to both Electric Sheep and MemCP servers
4. **AI Assistant**: Uses MemCP tools to store/retrieve memories

## Architecture

```
┌─────────────┐
│   Cursor    │
│   (MCP      │
│   Client)   │
└──────┬──────┘
       │
   ┌───┴───┐
   │       │
   │       │ SSE
   │       │
┌──▼──┐ ┌──▼────┐
│Electric│ │ MemCP │
│ Sheep │ │ Server│
│ MCP   │ │ :8000 │
│Server │ └───┬───┘
└───────┘     │
              │
         ┌────▼────┐
         │  Neo4j  │
         │Database │
         └─────────┘
```

## Troubleshooting

### Server Won't Start

**Check Neo4j is running:**
```powershell
# Docker
docker ps | Select-String neo4j

# Or check Neo4j Desktop
```

**Verify .env file:**
```powershell
cd mcp\tools\mcp\memcp
Get-Content .env
# Ensure NEO4J_PASSWORD and OPENAI_API_KEY are set
```

### Connection Errors

**Ensure MemCP server is running:**
```powershell
# Check if port 8000 is in use
netstat -an | Select-String ":8000"
```

**Start MemCP server before Cursor:**
1. Start MemCP: `cd mcp\tools\mcp\memcp; memcp`
2. Wait for "Server started" message
3. Then start Cursor

### Memory Not Working

**Check server logs:**
- Look for errors in the MemCP server console
- Verify Neo4j connection works
- Ensure OpenAI API key is valid

**Test Neo4j connection:**
```powershell
# If using Docker
docker exec -it neo4j-memcp cypher-shell -u neo4j -p your_password
```

## Configuration Files

- **`.env`**: Environment variables (Neo4j, API keys)
- **`.env.example`**: Template with placeholders
- **`SETUP_GUIDE.md`**: Detailed setup instructions

## Files Created

After running `memcp-setup.ps1`:

```
mcp/
├── memcp-setup.ps1              # Installation script
├── memcp-config-example.json     # MCP config example
└── tools/mcp/memcp/
    ├── .env.example             # Environment template
    └── SETUP_GUIDE.md           # Detailed guide
```

## More Information

- **GitHub**: https://github.com/evanmschultz/memcp
- **Documentation**: https://mcp.altinors.com
- **Neo4j**: https://neo4j.com/docs/

## Next Steps

After setup:
1. ✅ Start MemCP server
2. ✅ Configure MCP client
3. ✅ Restart Cursor
4. ✅ Test with: "Remember that we set up MemCP today"
5. ✅ Verify: "What did we set up today?"

Enjoy persistent memory in your AI conversations! 🧠✨

