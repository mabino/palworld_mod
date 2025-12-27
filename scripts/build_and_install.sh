#!/usr/bin/env bash
set -euo pipefail

# Colors
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
RED="\033[31m"
RESET="\033[0m"

echo -e "${BLUE}Build and install FunnyHat plugin${RESET}"

read -p "Enter path to BepInEx plugins folder [~/Palworld/BepInEx/plugins]: " plugins
plugins=${plugins:-~/Palworld/BepInEx/plugins}
plugins=$(eval echo "${plugins}")

if [ ! -d "$plugins" ]; then
  echo -e "${YELLOW}Plugins folder not found:${RESET} $plugins"
  read -p "Create it? (y/N) " yn
  if [[ "${yn}" =~ ^[Yy]$ ]]; then
    mkdir -p "$plugins"
    echo -e "${GREEN}Created:${RESET} $plugins"
  else
    echo -e "${RED}Abort.${RESET}"
    exit 1
  fi
fi

if command -v dotnet >/dev/null 2>&1; then
  echo -e "${GREEN}dotnet detected.${RESET}"
  read -p "Use dotnet CLI to build? (Y/n) " use
  use=${use:-Y}
  if [[ "$use" =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}Preparing temporary build workspace...${RESET}"
    tmp="./scripts/.tmp_build"
    rm -rf "$tmp"
    mkdir -p "$tmp"
    dotnet new classlib -lang C# -o "$tmp" -n FunnyHat --force >/dev/null
    cp mod/AddFunnyHat.cs "$tmp/"

    echo "Specify path to UnityEngine.dll (e.g. /path/to/Palworld/Palworld_Data/Managed/UnityEngine.dll):"
    read -p "UnityEngine.dll path: " unitydll
    unitydll=$(eval echo "$unitydll")
    echo "Specify path to BepInEx.dll (e.g. /path/to/BepInEx/core/BepInEx.dll):"
    read -p "BepInEx.dll path: " bepinexdll
    bepinexdll=$(eval echo "$bepinexdll")

    cat > "$tmp/FunnyHat.csproj" <<EOF
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <TargetFramework>net48</TargetFramework>
    <AssemblyName>FunnyHat</AssemblyName>
    <OutputType>Library</OutputType>
  </PropertyGroup>
  <ItemGroup>
    <Reference Include="UnityEngine">
      <HintPath>$unitydll</HintPath>
    </Reference>
    <Reference Include="BepInEx">
      <HintPath>$bepinexdll</HintPath>
    </Reference>
  </ItemGroup>
</Project>
EOF

    echo -e "${BLUE}Building...${RESET}"
    if ! dotnet build "$tmp" -c Release; then
      echo -e "${RED}dotnet build failed.${RESET} Check paths and target framework."
      exit 1
    fi

    dll=$(find "$tmp/bin/Release" -type f -name "FunnyHat.dll" | head -n1)
    if [ -z "$dll" ]; then
      echo -e "${RED}Built DLL not found.${RESET}"
      exit 1
    fi

    cp "$dll" "$plugins/"
    echo -e "${GREEN}Copied:${RESET} $dll to $plugins"
    echo -e "${GREEN}Build and install complete.${RESET}"
    # Clean up temporary workspace
    rm -rf "$tmp"
    exit 0
  fi
fi

echo -e "${YELLOW}dotnet CLI not used or not available.${RESET} Follow these manual steps:"
echo "1) Create a Class Library project in Visual Studio targeting the game's runtime (e.g., .NET Framework 4.x)."
echo "2) Add mod/AddFunnyHat.cs to the project and reference UnityEngine.dll and BepInEx.dll."
echo "3) Build the project and copy the resulting DLL into $plugins"
exit 0
