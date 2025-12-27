# Funny Hat Palworld Mod

_Last updated: 2025-12-27T20:15:54.425Z_

## What this mod does
Adds a small hat to every Pal at scene load. If a Resources prefab named `funny_hat` is present it will be used; otherwise the plugin creates a simple magenta cylinder at runtime.

## Quick install (user)
1. Install BepInEx for Palworld (recommended).
2. Build the DLL from `mod/AddFunnyHat.cs` and copy the resulting DLL into `BepInEx/plugins`.
3. (Optional) Place a prefab at `Assets/Resources/funny_hat.prefab` to override the procedural hat.
4. Start Palworld and open a scene that contains Pals.

## Quick test (user)
- Open `BepInEx/LogOutput.log` and confirm you see:
  - `FunnyHat plugin started.` and either `Hat prefab found` or `Procedural funny_hat prefab created at runtime.`
- In-game, select a Pal and look for a child GameObject named `FunnyHat` under the Pal's transform.

## Developer build steps
- Create a C# class library targeting the same .NET runtime as the game.
- Reference `UnityEngine.dll` and `BepInEx.dll` from the game or BepInEx installation.
- Include `mod/AddFunnyHat.cs` in the project and build the DLL.
- Copy the DLL to `BepInEx/plugins` and launch the game.

### How to compile the DLL
Below are two quick ways to compile the plugin. Adjust paths and target framework to match your Palworld installation.

Option A — Visual Studio / Rider (recommended)
1. Create a new Class Library project (C#) and set the Target Framework to match the game's runtime (e.g., .NET Framework 4.x).
2. Add `mod/AddFunnyHat.cs` to the project.
3. Add references to `UnityEngine.dll` and `BepInEx.dll` from the game's installation or your BepInEx folder.
4. Build -> Build Solution. Copy the produced `.dll` from the project's `bin/Debug` or `bin/Release` folder into `BepInEx/plugins`.

Option B — dotnet CLI (when compatible)
1. Create a folder and run: `dotnet new classlib -n FunnyHat`.
2. Replace the generated Class1.cs with `mod/AddFunnyHat.cs` and edit the project file to target the correct framework.
3. Add references to the Unity and BepInEx assemblies by editing the `.csproj` or placing the DLLs in a known path and using `<Reference Include="..." />` entries.
4. Run `dotnet build -c Release` and copy the output DLL into `BepInEx/plugins`.

Notes: use the same runtime and compatible assembly versions as the game; mismatches will prevent the plugin from loading.

## Troubleshooting
- No hats: ensure the game's Pal objects are tagged `Pal` or edit the plugin to match the game's identifiers.
- Plugin loaded but no hats: open `BepInEx/LogOutput.log` for errors and confirm the plugin logged the procedural-prefab message if no external prefab was found.
- To customize the hat: add `Assets/Resources/funny_hat.prefab` (exact name: `funny_hat`).

## Notes
This is a minimal proof-of-concept to iterate quickly. Contributions to improve fit, visuals, or placement on specific Pal models are welcome.

Quick install (user)
1. Install BepInEx (or your preferred Unity mod loader) for Palworld.
2. Build the plugin DLL from mod/AddFunnyHat.cs (see developer steps) and copy the compiled DLL into BepInEx/plugins.
3. Add a Unity prefab called `funny_hat` to the game's Resources (Assets/Resources/funny_hat.prefab) so the plugin can load it at runtime. If you don't have a prefab, see developer guidance to create a simple mesh at runtime.
4. Start the game and verify hats appear on Pals.

Quick test (user)
- Check BepInEx/LogOutput.log for plugin load messages. In-game, inspect any Pal to confirm a child GameObject named `FunnyHat` exists.

Developer build steps
- Create a C# class library project that targets the same .NET runtime as the game (commonly .NET Framework or a compatible profile). Reference the following assemblies from the game's installation or BepInEx installation:
  - UnityEngine.dll
  - BepInEx.dll (if using BepInEx)
- Add mod/AddFunnyHat.cs to the project and build to produce a DLL.
- Place the resulting DLL in BepInEx/plugins and start the game.

Notes
- This is a minimal scaffold to get iteration going; the plugin will fall back to creating a simple procedural magenta cylinder at runtime if a `funny_hat` prefab isn't found in Resources. Next iteration: provide a refined prefab or improve positioning for specific Pal models.
