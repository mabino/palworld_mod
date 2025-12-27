<#
  Funny Hat build/install PowerShell helper
  Generated: 2025-12-27T21:08:40.785Z
#>

function Write-Info($msg){ Write-Host $msg -ForegroundColor Cyan }
function Write-Success($msg){ Write-Host $msg -ForegroundColor Green }
function Write-Warn($msg){ Write-Host $msg -ForegroundColor Yellow }
function Write-Err($msg){ Write-Host $msg -ForegroundColor Red }

Write-Info "Build and install FunnyHat plugin (PowerShell)"

$defaultPlugins = "$env:USERPROFILE\Palworld\BepInEx\plugins"
$plugins = Read-Host "Enter path to BepInEx plugins folder [$defaultPlugins]"
if ([string]::IsNullOrWhiteSpace($plugins)) { $plugins = $defaultPlugins }

if (-not (Test-Path -Path $plugins -PathType Container)) {
    Write-Warn "Plugins folder not found: $plugins"
    $yn = Read-Host "Create it? (y/N)"
    if ($yn -match '^[Yy]') {
        New-Item -ItemType Directory -Path $plugins -Force | Out-Null
        Write-Success "Created: $plugins"
    }
    else {
        Write-Err "Abort."
        exit 1
    }
}

# Use dotnet if available
if (Get-Command dotnet -ErrorAction SilentlyContinue) {
    Write-Success "dotnet detected."
    $use = Read-Host "Use dotnet CLI to build? (Y/n)"
    if ([string]::IsNullOrWhiteSpace($use)) { $use = 'Y' }
    if ($use -match '^[Yy]') {
        $tmp = Join-Path -Path $PSScriptRoot -ChildPath '.tmp_build'
        if (Test-Path $tmp) { Remove-Item -Recurse -Force $tmp }
        New-Item -ItemType Directory -Path $tmp | Out-Null

        Write-Info "Creating temporary project..."
        dotnet new classlib -lang C# -o $tmp -n FunnyHat --force | Out-Null
        Copy-Item -Path (Join-Path $PSScriptRoot '..\mod\AddFunnyHat.cs') -Destination $tmp -Force

        $unitydll = Read-Host "Path to UnityEngine.dll (e.g. C:\Path\To\Palworld_Data\Managed\UnityEngine.dll)"
        $bepinexdll = Read-Host "Path to BepInEx.dll (e.g. C:\Path\To\BepInEx\core\BepInEx.dll)"

        $csproj = @"
<Project Sdk=\"Microsoft.NET.Sdk\">
  <PropertyGroup>
    <TargetFramework>net48</TargetFramework>
    <AssemblyName>FunnyHat</AssemblyName>
    <OutputType>Library</OutputType>
  </PropertyGroup>
  <ItemGroup>
    <Reference Include=\"UnityEngine\">
      <HintPath>$unitydll</HintPath>
    </Reference>
    <Reference Include=\"BepInEx\">
      <HintPath>$bepinexdll</HintPath>
    </Reference>
  </ItemGroup>
</Project>
"@
        $csprojPath = Join-Path $tmp 'FunnyHat.csproj'
        $csproj | Set-Content -Path $csprojPath -Encoding UTF8

        Write-Info "Building project (Release)..."
        try {
            dotnet build $tmp -c Release | Write-Host
        }
        catch {
            Write-Err "dotnet build failed. Check paths and target framework."
            exit 1
        }

        $dll = Get-ChildItem -Path (Join-Path $tmp 'bin\Release') -Recurse -Filter 'FunnyHat.dll' | Select-Object -First 1
        if (-not $dll) { Write-Err "Built DLL not found."; exit 1 }

        Copy-Item -Path $dll.FullName -Destination $plugins -Force
        Write-Success "Copied: $($dll.FullName) to $plugins"

        # cleanup
        Remove-Item -Recurse -Force $tmp
        Write-Success "Build and install complete."
        exit 0
    }
}

Write-Warn "dotnet CLI not used or not available. Follow these manual steps:"
Write-Host "1) Create a Class Library project in Visual Studio targeting the game's runtime (e.g., .NET Framework 4.x)."
Write-Host "2) Add mod/AddFunnyHat.cs to the project and reference UnityEngine.dll and BepInEx.dll."
Write-Host "3) Build the project and copy the resulting DLL into $plugins"
exit 0
