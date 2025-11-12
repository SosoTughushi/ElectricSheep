# MemCP Quick Start

Get MemCP running in 5 minutes!

## Prerequisites

- ✅ Python 3.10+ (you have Python 3.12.4)
- ✅ Docker (for Neo4j) OR Neo4j Desktop
- ✅ OpenAI API key

## Installation Steps

### 1. Install MemCP (Already Done! ✅)

```powershell
pip install memcp
```

**Status**: ✅ Installed at `C:\Users\pc\anaconda3\Scripts\memcp.exe`

### 2. Set Up Neo4j Database

**Option A: Docker (Fastest)**
```powershell
docker run -d `
    --name neo4j-memcp `
    -p 7474:7474 -p 7687:7687 `
    -e NEO4J_AUTH=neo4j/your_password_here `
    neo4j:latest
```

**Option B: Neo4j Desktop**
1. Download: https://neo4j.com/download/
2. Install and create database
3. Note your password

### 3. Create Configuration Directory

```powershell
# Create config directory
mkdir -Force $env:USERPROFILE\.memcp
cd $env:USERPROFILE\.memcp

# Create .env file
@"
NEO4J_URI=bolt://localhost:7687
NEO4J_USER=neo4j
NEO4J_PASSWORD=your_password_here
OPENAI_API_KEY=your_openai_api_key_here
"@ | Out-File -FilePath .env -Encoding UTF8
```

**Edit `.env`** and replace:
- `your_password_here` → Your Neo4j password
- `your_openai_api_key_here` → Your OpenAI API key

### 4. Start MemCP Server

```powershell
# Set environment variables
$env:NEO4J_PASSWORD = "your_password_here"
$env:OPENAI_API_KEY = "your_openai_api_key_here"

# Start server
memcp
```

Server will start on `http://localhost:8000`

### 5. Configure Cursor

Edit `%APPDATA%\Cursor\mcp.json`:

```json
{
  "mcpServers": {
    "electric-sheep": {
      "command": "python",
      "args": ["-m", "mcp.server.server"],
      "cwd": "E:\\Soso\\Projects\\electric-sheep"
    },
    "MemCP": {
      "transport": "sse",
      "url": "http://localhost:8000/sse"
    }
  }
}
```

### 6. Restart Cursor

Close and reopen Cursor IDE.

## Test It!

1. **Store a memory:**
   ```
   "Remember that we installed MemCP today"
   ```

2. **Retrieve it:**
   ```
   "What did we install today?"
   ```

## Troubleshooting

**Server won't start?**
- Check Neo4j is running: `docker ps` or check Neo4j Desktop
- Verify environment variables are set
- Check port 8000 is free: `netstat -an | Select-String ":8000"`

**Connection errors?**
- Start MemCP server BEFORE starting Cursor
- Verify server is running: Open http://localhost:8000 in browser

**Memory not working?**
- Check MemCP server console for errors
- Verify Neo4j connection
- Ensure OpenAI API key is valid

## Next Steps

- See `README-MEMCP.md` for detailed guide
- See `SETUP.md` for full MCP setup instructions

---

**That's it!** Your AI can now remember conversations! 🧠✨

