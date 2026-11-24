"""Vérifie l'ordre des schémas par rapport à la solution analytique et trace l'erreur."""
import re
import subprocess

import matplotlib.pyplot as plt
import numpy as np

hs = [0.1, 0.05, 0.025, 0.0125, 0.00625]
err = np.array([[float(x) for x in re.findall(r"Erreur totale \(\w+\) :\s+(\S+)",
      subprocess.run(["./main", str(h)], capture_output=True, text=True, check=True).stdout)] for h in hs])
for j, (nom, attendu) in enumerate([("Euler", 1), ("Heun", 2), ("RK4", None), ("AB2", 2)]):
    ordre = np.log2(err[-2, j] / err[-1, j])
    print(f"{nom:6s} " + " ".join(f"{e:.2e}" for e in err[:, j]) + (f"  ordre {ordre:.2f}" if attendu else "  exact à l'arrondi"))
    assert abs(ordre - attendu) < 0.1 if attendu else err[:, j].max() < 1e-15
    plt.loglog(hs, err[:, j], "o-", label=nom)
plt.xlabel("h (m)")
plt.ylabel("erreur quadratique moyenne (m)")
plt.legend()
plt.grid(which="both", alpha=0.3)
plt.savefig("convergence.png", dpi=150, bbox_inches="tight")
