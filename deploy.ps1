param(
    [string]$EnvFile = ".env.deploy",
    [switch]$Prod
)

Write-Host "Starting Vercel deployment script..."

if (-not (Test-Path $EnvFile)) {
    throw "Environment file '$EnvFile' was not found. Create it from .env.deploy.example."
}

Get-Content $EnvFile | ForEach-Object {
    if ($_ -match '^[#\s]') { return }
    if ($_ -match '^(?<key>[^=]+)=(?<value>.*)$') {
        $key = $matches['key'].Trim()
        $value = $matches['value'].Trim()
        [Environment]::SetEnvironmentVariable($key, $value)
    }
}

if (-not $env:VERCEL_TOKEN) {
    throw "VERCEL_TOKEN is not set. Ensure it exists inside $EnvFile."
}

if (-not (Get-Command vercel -ErrorAction SilentlyContinue)) {
    throw "The 'vercel' CLI is not installed or not on PATH. Install via 'npm install -g vercel'."
}

$arguments = @("deploy", "--yes", "--token", $env:VERCEL_TOKEN)
if ($Prod) {
    $arguments += "--prod"
}

# Provide clear feedback during deployment
Write-Host "Running: vercel $($arguments -join ' ')"
vercel @arguments
