Funny Hat Palworld Mod

What this mod does
- Adds a small hat to every Pal at scene load. If a Resources prefab named `funny_hat` is present, it will be used; otherwise the plugin creates a simple magenta cylinder at runtime.

Quick install (user)
1. Install BepInEx for Palworld (recommended).
2. Build the DLL from mod/AddFunnyHat.cs and copy the resulting DLL into BepInEx/plugins.
3. (Optional) Place a prefab at Assets/Resources/funny_hat.prefab to override the procedural hat.
4. Start Palworld and open a scene that contains Pals.

Quick test (user)
- Check BepInEx/LogOutput.log for these lines:
  - "FunnyHat plugin started." and either "Hat prefab found" or "Procedural funny_hat prefab created at runtime.".
- In-game, select a Pal and look for a child GameObject named `FunnyHat` under the Pal's transform.

Developer build steps
- Create a C# class library targeting the same .NET runtime as the game.
- Reference UnityEngine.dll and BepInEx.dll from the game or BepInEx installation.
- Include mod/AddFunnyHat.cs in the project and build the DLL.
- Copy the DLL to BepInEx/plugins and launch the game.

Troubleshooting
- No hats: ensure the game's Pal objects are tagged "Pal" or edit the plugin to match the game's identifiers.
- Plugin loaded but no hats: open BepInEx/LogOutput.log for errors and confirm the plugin logged the procedural-prefab message if no external prefab was found.
- To customize the hat: add Assets/Resources/funny_hat.prefab (exact name: `funny_hat`).

Notes
- This is a minimal proof-of-concept to iterate quickly. Contributions to improve fit, visuals, or placement on specific Pal models are welcome.

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
