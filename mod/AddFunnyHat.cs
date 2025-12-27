using BepInEx;
using UnityEngine;
using UnityEngine.SceneManagement;

[BepInPlugin("com.example.palworld.funnyhat", "Funny Hat", "0.1.0")]
public class AddFunnyHat : BaseUnityPlugin
{
    private GameObject hatPrefab;

    void Start()
    {
        // Attempt to load a prefab named "funny_hat" from Resources
        hatPrefab = Resources.Load<GameObject>("funny_hat");
        Logger.LogInfo("FunnyHat plugin started. Hat prefab " + (hatPrefab != null ? "found" : "not found"));

        // If no prefab found, procedurally generate a reusable hat prototype
        if (hatPrefab == null)
        {
            CreateProceduralHatPrefab();
            Logger.LogInfo("Procedural funny_hat prefab created at runtime.");
        }

        SceneManager.sceneLoaded += OnSceneLoaded;
    }

    private void CreateProceduralHatPrefab()
    {
        var proto = GameObject.CreatePrimitive(PrimitiveType.Cylinder);
        var col = proto.GetComponent<Collider>();
        if (col != null) Destroy(col);
        proto.name = "funny_hat";
        proto.transform.localScale = new Vector3(0.5f, 0.2f, 0.5f);
        var rdr = proto.GetComponent<Renderer>();
        if (rdr != null) rdr.material.color = Color.magenta;
        // Hide prototype from scene and prevent accidental save
        proto.hideFlags = HideFlags.HideAndDontSave;
        hatPrefab = proto;
    }

    private void OnSceneLoaded(Scene scene, LoadSceneMode mode)
    {
        AttachHatsToAllPals();
    }

    private void AttachHatsToAllPals()
    {
        // Uses tag "Pal" — adjust to match actual game object tagging/naming
        var pals = GameObject.FindGameObjectsWithTag("Pal");
        foreach (var pal in pals)
        {
            if (pal.transform.Find("FunnyHat") != null) continue; // already has one

            GameObject hat = null;
            if (hatPrefab != null)
            {
                hat = Instantiate(hatPrefab, pal.transform);
                if (hat != null)
                {
                    hat.SetActive(true);
                    hat.transform.SetParent(pal.transform, false);
                }
            }
            else
            {
                // Procedurally create a simple cylinder hat
                hat = GameObject.CreatePrimitive(PrimitiveType.Cylinder);
                if (hat.GetComponent<Collider>() != null) Destroy(hat.GetComponent<Collider>());
                hat.transform.SetParent(pal.transform, false);
                hat.transform.localScale = new Vector3(0.5f, 0.2f, 0.5f);
            }

            if (hat == null) continue;
            hat.name = "FunnyHat";
            // Positioning is intentionally simple; adjust offset to fit models
            hat.transform.localPosition = new Vector3(0f, 1.0f, 0f);
            hat.transform.localRotation = Quaternion.identity;
            // Try to tint the hat if it has a renderer
            var rdr = hat.GetComponent<Renderer>();
            if (rdr != null) rdr.material.color = Color.magenta;
        }
    }
}
