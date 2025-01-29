# psobb-beat-timer
A simple timer to display the time remaining for/until a .beat event in PSOBB.

# Purpose
This plugin displays:
- The current .beat time (synchronized with the system clock)
- The amount of time until the next .beat event

#### .beat events can be described as follows:

- If the hundreth value of the current .beat time is even, Divine Punishment is available. The countdown timer will represent the amount of time remaining until Divine Punishment is unavailable.

- If the hundreth value of the current .beat time is odd, Divine Punishment is unavailable. The countdown timer will represent the amount of time remaining until Divine Punishment is available.

# Preview
need some images

# Installation
1. Install the [**addon plugin**](https://github.com/HybridEidolon/psobbaddonplugin) for PSOBB.
2. Download this repository by clicking [**here**](https://github.com/nnasteff1/psobb-beat-timer/archive/main.zip).
3. Copy the "Beat Timer" directory into the /addons directory in your PSOBB directory.

# Credits

Many thanks to Seth Clydesdale - I used his [**Coordinate Viewer**](https://github.com/SethClydesdale/psobb-coordinate-viewer/) plugin as a template for this plugin.

Additional thanks to Soly for his work in creating/maintaining the 
[**PSOBB Addon Plugin**](https://github.com/HybridEidolon/psobbaddonplugin) library.