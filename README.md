# psobb-beat-timer
A simple timer to display the time remaining for/until a .beat event in PSOBB.

# What's the point of this?
I got sick of using other methods of figuring out how long until I could use Divine Punishment (or how much longer it was still available), so I wrote a simple plugin that displays the following:
- The current .beat time (synchronized with the system clock)
- The amount of time until the next .beat event

# What's a .beat event?
#### .beat events can be described as follows:

- If the hundreds place of the current .beat time is even (EG 678), Divine Punishment is available. The countdown timer will represent the amount of time remaining until Divine Punishment is unavailable (in green).

- If the hundreds place of the current .beat time is odd (EG 152), Divine Punishment is unavailable. The countdown timer will represent the amount of time remaining until Divine Punishment is available (in red).

# Preview
![beat-timer-prieview-v 0 2](https://github.com/user-attachments/assets/7ede7a32-1fbb-4d9c-bfa6-eb9a5f9df9e6)
<br>
<br>
![beat-timer-active](https://github.com/user-attachments/assets/c86b80b0-6543-48ef-a219-38e4334e301d)


# Installation
1. Install the [**addon plugin**](https://github.com/HybridEidolon/psobbaddonplugin) for PSOBB.
2. Download this repository by clicking [**here**](https://github.com/nnasteff1/psobb-beat-timer/archive/main.zip).
3. Copy the "Beat Timer" directory into the /addons directory in your PSOBB directory.


# Credits

Many thanks to Seth Clydesdale - I used his [**Coordinate Viewer**](https://github.com/SethClydesdale/psobb-coordinate-viewer/) plugin as a template for this plugin.

Additional thanks to Soly for his work in creating/maintaining the 
[**PSOBB Addon Plugin**](https://github.com/HybridEidolon/psobbaddonplugin) library.

# Changelog

v1.0.0 
- Initial addon version

v1.0.1 
- Updated timer to only show single hour digits (1:00:00 vs 01:00:00)
- Updated timer to truncate if no hours remain in the timer (1:00:00 -> 59:59)

v1.0.2
- Fixed a bug related to wrong color being displayed due to improper check for .beat event
- Added 10-minute warning colorization to timer
- Expanded menu + option to disable all colors
- Allowed for custom colors for .beat clock, timer and 10 minute warning
- Added ability to hide the .beat clock
- Swapped the .beat clock and timer locations in the display
- Traded out text input for click-drag sliders in font scaling + size/position values
