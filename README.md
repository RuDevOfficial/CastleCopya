CastleCopya is a non-commercial template project for Godot meant to save you time from developing a castlevania-like game! It contains all the necessary basic features so you can get right to modifying it and adding your own spin to the formula!

This project tries to mimic the original Castlevania features (including knockback!), but not with 100% accuracy.

# Core Features
| Feature  | Description | Global
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

## Camera Manager
This system works by...

# The Player Character

Due to using Castlevania I as a base for this template project the player can walk, crouch, idle, jump, attack (w/t crouching), use subweapons and use stairs.

In order for all states to share the necessary information and make changes the player class contains a __core__ resource called _player_resource_. This resource contains all the data.

![image](https://i.imgur.com/2oaHpMt.png)

This object contains both a capsule-shaped collider with a _ground_ mask, both a hitbox (whip, gray) and hurtbox (self, green) and an interact area 2D with a _stair_entrance_ mask.

When it comes to sprites it contains both an upper and lower sprites, whip and a fullbody sprite (used for the death pose).

![image](https://i.imgur.com/iqE3bJW.png)

# Execution Loop

If we take the main menu as the starting point, we can see how each class is connected.


# Supported Godot Versions

| 3.X  | 4.X |
| ------------- |:-------------:|
| Unsupported     | 4.4.1     |

# Credits
|Graphics|Audio & Sound Effects| Godot Plugins |
|-|:-:|:-:|
|Konami (Castlevania I) | Konami (Castlevania I) | FMOD Studio GDExtension|
|[Programancer](https://programancer.itch.io/) - Paid Commercial|| [LimboAI](https://github.com/limbonaut/limboai) |

# Warning
All graphical assets are a combination of paid itch.io assets and ripped assets from Konami's Castlevania. If you are planning to do a commercial game make sure you've completely changed or removed all of them!

All sound (music & sound) assets are ripped from Castlevania I, make sure you remove them as well if you are doing a commercial product!

__I don't take any responsability for any problems you might encounter if you have failed to remove all copyrighted assets__
