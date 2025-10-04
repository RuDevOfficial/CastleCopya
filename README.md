<p align="center">
  <img src="https://i.imgur.com/yz5RhBs.png" width="400" alt="CastleCopya logo">
</p>

# CastleCopya - Castlevania-inspired template project for Godot 4

>**🛈 Supported Godot Engine:**  **4.4.1**

CastleCopya is a non-commercial template project for Godot meant to save you time from developing a castlevania-like game! It contains all the necessary basic features so you can get right to modifying it and adding your own spin to the formula!

If you want to show your appreciation or need help feel free to follow me on [bluesky](https://bsky.app/profile/ru-dev-official.itch.io) and send me a DM!

Want to play some of my games? Check out my [Itch.io](https://ru-dev-official.itch.io/) page!

Want a **guide**? Read it [here](https://github.com/RuDevOfficial/CastleCopya/blob/main/GUIDE.md)!

## Installation

## Core Features / Classes
| Feature / Class  | Description | Global
| ------------- |:-------------:|:-:|
| Camera Manager    | Manages the game's camera during the gameplay state via camera paths     | No |
| Game State Manager | Tasked with executing signals on each game's state | Yes |
| Stage Manager| Manages everything related to levels/stages, does not support level skipping or selecting | Yes |
| Save & Loading | Generates the appropriate data inside %appdata%'s Godot folder and manages saves | Yes |
| Enemy Manager | Keeps tabs of all instantiated enemies | Yes |
| Signal Bus | Tasked with keeping all signals for easy access | Yes |
| Transition Manager | Creates transitions between game state changes and player death / victory | No |
| Audio Manager | Allows for both music and sound effect generation by using FMOD | Yes |
| Spawner Manager | Spawns enemies continuously over time, is activated or deactivated via 2D areas | Yes |

## Credits
|Graphics|Audio & Sound Effects| Godot Plugins |
|-|:-:|:-:|
|Konami (Castlevania I) | Konami (Castlevania I) | [FMOD Studio GDExtension](https://github.com/utopia-rise/fmod-gdextension) |
|[Programancer](https://programancer.itch.io/) - Paid Commercial|| [LimboAI](https://github.com/limbonaut/limboai) |

## Warning
All graphical assets are a combination of paid itch.io assets and ripped assets from Konami's Castlevania. If you are planning to do a commercial game make sure you've completely changed or removed all of them!

All sound (music & sound) assets are ripped from Castlevania I, make sure you remove them as well if you are doing a commercial product!

__I don't take any responsability for any problems you might encounter if you have failed to remove all copyrighted assets__
