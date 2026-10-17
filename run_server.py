import http.server
import socketserver
import os

os.chdir(os.path.dirname(os.path.abspath(__file__)))
PORT = 8089

Handler = http.server.SimpleHTTPRequestHandler
Handler.extensions_map.update({
    ".json": "application/json",
    ".png": "image/png",
    ".wav": "audio/wav",
    ".luau": "text/plain",
})

socketserver.TCPServer.allow_reuse_address = True
print(f"Serving Danganronpa assets at http://localhost:{PORT}")
print(f"Directory: {os.getcwd()}")
with socketserver.TCPServer(("", PORT), Handler) as httpd:
    httpd.serve_forever()
