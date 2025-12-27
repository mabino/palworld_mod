Context
- Adds a "FunnyHat" GameObject to every Pal at scene load via mod/AddFunnyHat.cs (BepInEx plugin). The plugin falls back to a procedural magenta cylinder if no prefab is found.

Next actions (next iteration)
- Build: compile mod/AddFunnyHat.cs into a DLL referencing UnityEngine.dll and BepInEx.dll; copy the DLL to BepInEx/plugins.
- Prefab: provide Assets/Resources/funny_hat.prefab (name: "funny_hat") in the game to replace the procedural hat, or update the plugin to load an AssetBundle.
- Tuning: adjust localPosition/localScale in the prefab or plugin to fit specific Pal models; consider per-model prefabs later.

Testing
- Start the game with BepInEx; confirm plugin startup in BepInEx/LogOutput.log (log line contains "FunnyHat plugin started").
- Load a scene with Pals and verify each Pal has a child GameObject named "FunnyHat" positioned on the head.

Developer hints
- The plugin currently finds Pals using GameObject.FindGameObjectsWithTag("Pal"); if Pals are not tagged, search by name or component instead.
- Use UnityEngine.dll and BepInEx.dll from the game/BepInEx install when building; target the Unity-compatible .NET runtime.
- Keep changes minimal: attach at most one hat per Pal and skip if already present.

Files
- mod/AddFunnyHat.cs (source)
- README.md (install/test/developer instructions)

Next acceptance criteria
- A built DLL that loads in-game and visibly adds hats to Pals, or log confirmation that hats were attached.
