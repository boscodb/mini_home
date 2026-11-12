Write-Host "=========================================="
Write-Host " Hello World from post-switch PowerShell! "
Write-Host "=========================================="

# Check candidate locations where Docker may be installed
$candidatePaths = @(
    "/usr/local/bin",
    "/opt/homebrew/bin",
    "$HOME/.docker/bin",
    "/usr/bin"
)

$dockerPath = $null

if (Get-Command docker -ErrorAction SilentlyContinue) {
    $dockerPath = (Get-Command docker).Source
} else {
    foreach ($dir in $candidatePaths) {
        $target = Join-Path $dir "docker"
        if (Test-Path $target) {
            $dockerPath = $target
            # Docker is found; now update PATH with its location
            $env:PATH = "$dir`:$env:PATH"
            break
        }
    }
}

if ($dockerPath) {
    Write-Host "Docker found at: $dockerPath"
    Write-Host "Running Docker hello-world container..."
    docker run --rm hello-world
} else {
    Write-Host "Docker was not found on this machine. Skipping container execution."
}



