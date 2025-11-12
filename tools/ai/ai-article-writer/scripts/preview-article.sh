#!/bin/bash
# Preview Article Script (macOS/Linux)
# Opens generated HTML article in browser for local preview

ARTICLE_PATH="${1:-../../../docs/ai-first-repository-guide.html}"
REGENERATE=false
PORT=8080

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -r|--regenerate)
            REGENERATE=true
            shift
            ;;
        -p|--port)
            PORT="$2"
            shift 2
            ;;
        *)
            ARTICLE_PATH="$1"
            shift
            ;;
    esac
done

echo "=== Article Preview ==="

# Get script directory and resolve paths
SCRIPT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOOL_ROOT="$(cd "$SCRIPT_ROOT/.." && pwd)"
REPO_ROOT="$(cd "$TOOL_ROOT/../../.." && pwd)"

# Resolve article path
if [[ ! "$ARTICLE_PATH" =~ ^/ ]]; then
    ARTICLE_PATH="$REPO_ROOT/$ARTICLE_PATH"
fi

# Regenerate HTML if requested
if [ "$REGENERATE" = true ]; then
    echo ""
    echo "Regenerating HTML..."
    
    MARKDOWN_PATH="${ARTICLE_PATH%.html}.md"
    
    if [ ! -f "$MARKDOWN_PATH" ]; then
        echo "Error: Markdown file not found: $MARKDOWN_PATH" >&2
        exit 1
    fi
    
    cd "$TOOL_ROOT"
    node src/article-viewer.js --markdown "$MARKDOWN_PATH" --output "$ARTICLE_PATH"
    
    if [ $? -ne 0 ]; then
        echo "Error: Failed to regenerate HTML" >&2
        exit 1
    fi
    
    echo "HTML regenerated successfully!"
fi

# Check if HTML file exists
if [ ! -f "$ARTICLE_PATH" ]; then
    echo "Error: HTML file not found: $ARTICLE_PATH" >&2
    echo ""
    echo "Tip: Use -r or --regenerate to generate HTML from markdown"
    exit 1
fi

echo ""
echo "Article: $ARTICLE_PATH"

# Get directory containing the HTML file
ARTICLE_DIR="$(dirname "$ARTICLE_PATH")"
ARTICLE_FILE="$(basename "$ARTICLE_PATH")"

# Check for available HTTP server
if command -v python3 &> /dev/null; then
    SERVER_CMD="python3"
elif command -v python &> /dev/null; then
    SERVER_CMD="python"
elif command -v node &> /dev/null; then
    if command -v http-server &> /dev/null; then
        SERVER_CMD="http-server"
    else
        echo ""
        echo "Installing http-server for preview..."
        npm install -g http-server
        SERVER_CMD="http-server"
    fi
else
    echo "Warning: No HTTP server found. Opening file directly (some features may not work)."
    SERVER_CMD=""
fi

if [ -n "$SERVER_CMD" ]; then
    echo ""
    echo "Starting local server..."
    echo "Server will be available at: http://localhost:$PORT/$ARTICLE_FILE"
    echo "Press Ctrl+C to stop the server"
    
    cd "$ARTICLE_DIR"
    
    if [ "$SERVER_CMD" = "python3" ] || [ "$SERVER_CMD" = "python" ]; then
        # Python HTTP server
        $SERVER_CMD -m http.server "$PORT" &
        SERVER_PID=$!
        sleep 2
        open "http://localhost:$PORT/$ARTICLE_FILE" 2>/dev/null || xdg-open "http://localhost:$PORT/$ARTICLE_FILE" 2>/dev/null
        echo ""
        echo "Server started! Browser should open automatically."
        echo "To stop the server, press Ctrl+C or run: kill $SERVER_PID"
        wait $SERVER_PID
    else
        # Node.js http-server
        http-server -p "$PORT" -o "/$ARTICLE_FILE"
    fi
else
    # Open file directly
    echo ""
    echo "Opening file in browser..."
    open "$ARTICLE_PATH" 2>/dev/null || xdg-open "$ARTICLE_PATH" 2>/dev/null
    echo "File opened! Note: Some features may not work when opening file directly."
fi

echo ""
echo "=== Preview Started ==="

