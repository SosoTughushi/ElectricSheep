# Start Proxy Server for Cursor-Ollama Integration
# Starts a proxy server to translate Cursor API requests to Ollama format

param(
    [int]$ProxyPort = 8000
)

Write-Host "=== Proxy Server Setup ===" -ForegroundColor Cyan
Write-Host ""

# Check if Ollama is installed
if (-not (Get-Command ollama -ErrorAction SilentlyContinue)) {
    Write-Host "✗ Ollama is not installed!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install Ollama first:" -ForegroundColor Yellow
    Write-Host "  .\scripts\install-ollama.ps1" -ForegroundColor White
    exit 1
}

Write-Host "✓ Ollama is installed" -ForegroundColor Green
Write-Host ""

# Check if Python is available
if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Host "✗ Python is not installed!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Proxy server requires Python 3.8+." -ForegroundColor Yellow
    Write-Host "Download Python from: https://www.python.org/downloads/" -ForegroundColor White
    Write-Host ""
    Write-Host "Alternatively, you can use Ollama directly without a proxy." -ForegroundColor Yellow
    Write-Host "See: .\docs\CURSOR_SETUP.md" -ForegroundColor White
    exit 1
}

Write-Host "✓ Python is installed" -ForegroundColor Green
$pythonVersion = python --version
Write-Host "  Version: $pythonVersion" -ForegroundColor Gray
Write-Host ""

Write-Host "=== Proxy Server Options ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Option 1: Simple Python Proxy (Recommended for quick setup)" -ForegroundColor Yellow
Write-Host "  This script will create a simple proxy server." -ForegroundColor Gray
Write-Host ""
Write-Host "Option 2: CursorCustomModels (More features)" -ForegroundColor Yellow
Write-Host "  Install from: https://github.com/rinadelph/CursorCustomModels" -ForegroundColor Gray
Write-Host ""

$choice = Read-Host "Use simple proxy? (Y/N)"

if ($choice -eq 'Y' -or $choice -eq 'y') {
    Write-Host ""
    Write-Host "Creating simple proxy server..." -ForegroundColor Yellow
    
    $proxyScript = @"
import sys
from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import urllib.request
import urllib.parse

OLLAMA_URL = "http://localhost:11434"
PROXY_PORT = $ProxyPort

class ProxyHandler(BaseHTTPRequestHandler):
    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length)
        
        try:
            request_data = json.loads(post_data.decode('utf-8'))
            
            # Translate OpenAI format to Ollama format
            if '/chat/completions' in self.path:
                messages = request_data.get('messages', [])
                model = request_data.get('model', 'nsfw-3b')
                
                # Convert messages to prompt
                prompt = ""
                for msg in messages:
                    role = msg.get('role', 'user')
                    content = msg.get('content', '')
                    if role == 'system':
                        prompt += f"System: {content}\n\n"
                    elif role == 'user':
                        prompt += f"User: {content}\n\n"
                    elif role == 'assistant':
                        prompt += f"Assistant: {content}\n\n"
                
                # Call Ollama API
                ollama_data = {
                    "model": model,
                    "prompt": prompt.strip(),
                    "stream": False
                }
                
                req = urllib.request.Request(
                    f"{OLLAMA_URL}/api/generate",
                    data=json.dumps(ollama_data).encode('utf-8'),
                    headers={'Content-Type': 'application/json'}
                )
                
                with urllib.request.urlopen(req) as response:
                    ollama_response = json.loads(response.read().decode('utf-8'))
                    response_text = ollama_response.get('response', '')
                
                # Convert Ollama response to OpenAI format
                openai_response = {
                    "id": "chatcmpl-" + str(hash(response_text))[:8],
                    "object": "chat.completion",
                    "created": 1234567890,
                    "model": model,
                    "choices": [{
                        "index": 0,
                        "message": {
                            "role": "assistant",
                            "content": response_text
                        },
                        "finish_reason": "stop"
                    }],
                    "usage": {
                        "prompt_tokens": len(prompt.split()),
                        "completion_tokens": len(response_text.split()),
                        "total_tokens": len(prompt.split()) + len(response_text.split())
                    }
                }
                
                self.send_response(200)
                self.send_header('Content-Type', 'application/json')
                self.end_headers()
                self.wfile.write(json.dumps(openai_response).encode('utf-8'))
                return
                
        except Exception as e:
            self.send_response(500)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            error_response = {"error": str(e)}
            self.wfile.write(json.dumps(error_response).encode('utf-8'))
    
    def do_GET(self):
        if self.path == '/models':
            # Return available models
            try:
                req = urllib.request.Request(f"{OLLAMA_URL}/api/tags")
                with urllib.request.urlopen(req) as response:
                    ollama_models = json.loads(response.read().decode('utf-8'))
                    models = ollama_models.get('models', [])
                    
                    openai_models = {
                        "data": [{
                            "id": model['name'],
                            "object": "model",
                            "created": 1234567890,
                            "owned_by": "ollama"
                        } for model in models]
                    }
                    
                    self.send_response(200)
                    self.send_header('Content-Type', 'application/json')
                    self.end_headers()
                    self.wfile.write(json.dumps(openai_models).encode('utf-8'))
                    return
            except:
                pass
        
        self.send_response(404)
        self.end_headers()
    
    def log_message(self, format, *args):
        print(f"[{self.address_string()}] {format % args}")

if __name__ == '__main__':
    server = HTTPServer(('localhost', PROXY_PORT), ProxyHandler)
    print(f"Proxy server running on http://localhost:{PROXY_PORT}")
    print(f"Connecting to Ollama at {OLLAMA_URL}")
    print("Press Ctrl+C to stop")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\nShutting down proxy server...")
        server.shutdown()
"@
    
    $proxyScriptPath = "$PSScriptRoot\proxy_server.py"
    $proxyScript | Out-File -FilePath $proxyScriptPath -Encoding UTF8
    
    Write-Host "✓ Proxy server script created" -ForegroundColor Green
    Write-Host "  Path: $proxyScriptPath" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Starting proxy server..." -ForegroundColor Yellow
    Write-Host "  Port: $ProxyPort" -ForegroundColor Gray
    Write-Host "  Ollama URL: http://localhost:11434" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Keep this window open while using Cursor." -ForegroundColor Yellow
    Write-Host "Press Ctrl+C to stop the server." -ForegroundColor Gray
    Write-Host ""
    
    python $proxyScriptPath
} else {
    Write-Host ""
    Write-Host "For CursorCustomModels setup, see:" -ForegroundColor Yellow
    Write-Host "  https://github.com/rinadelph/CursorCustomModels" -ForegroundColor White
    Write-Host ""
    Write-Host "Or use Ollama directly without a proxy:" -ForegroundColor Yellow
    Write-Host "  See: .\docs\CURSOR_SETUP.md" -ForegroundColor White
}

Write-Host ""

