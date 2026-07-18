# ============================================================
# Simple PowerShell Web Server
# Allows viewing the site locally without Node.js or Python.
# Run this in PowerShell: .\server.ps1
# ============================================================

$port = 8080
$url = "http://localhost:$port/"
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($url)

try {
    $listener.Start()
    Write-Host "---" -ForegroundColor Green
    Write-Host "Fikr Magazine Local Server" -ForegroundColor Cyan
    Write-Host "Running at: $url" -ForegroundColor Yellow
    Write-Host "Press Ctrl+C to Stop" -ForegroundColor Gray
    Write-Host "---" -ForegroundColor Green

    # Open browser automatically
    Start-Process $url

    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response

        $path = $request.Url.LocalPath
        if ($path -eq "/") { $path = "/index.html" }
        
        Write-Host "Request: $($request.HttpMethod) $path" -ForegroundColor Gray

        # Trim leading slash to ensure Join-Path works correctly relative to $PWD
        $relativePath = $path.TrimStart("/")
        $filePath = Join-Path $PWD $relativePath
        
        if (Test-Path $filePath -PathType Leaf) {
            $extension = [System.IO.Path]::GetExtension($filePath).ToLower()
            $contentType = switch ($extension) {
                ".html"  { "text/html; charset=utf-8" }
                ".css"   { "text/css" }
                ".js"    { "application/javascript" }
                ".mjs"   { "application/javascript" }
                ".png"   { "image/png" }
                ".jpg"   { "image/jpeg" }
                ".jpeg"  { "image/jpeg" }
                ".gif"   { "image/gif" }
                ".svg"   { "image/svg+xml" }
                ".ico"   { "image/x-icon" }
                ".json"  { "application/json" }
                ".woff"  { "font/woff" }
                ".woff2" { "font/woff2" }
                default  { "application/octet-stream" }
            }

            $content = [System.IO.File]::ReadAllBytes($filePath)
            $response.Headers.Add("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0")
            $response.Headers.Add("Pragma", "no-cache")
            $response.Headers.Add("Expires", "0")
            $response.ContentType = $contentType
            $response.ContentLength64 = $content.Length
            $response.OutputStream.Write($content, 0, $content.Length)
        }
        else {
            $response.StatusCode = 404
            $errorMsg = [System.Text.Encoding]::UTF8.GetBytes("404 - File Not Found")
            $response.OutputStream.Write($errorMsg, 0, $errorMsg.Length)
        }
        $response.Close()
    }
}
catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
finally {
    if ($null -ne $listener) {
        $listener.Stop()
    }
}
