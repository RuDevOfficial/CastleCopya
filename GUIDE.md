<p align="center">
  <img src="https://i.imgur.com/0wNakQS.png" width="400" alt="CastleCopya logo">
</p>

# A Guide for CastleCopya

This file is meant to be a supplement for you to understand the project as soon as possible, if there is something that has not been explicitly explained and should be added here you can contact me on [bluesky](https://bsky.app/profile/ru-dev-official.itch.io).

# Guide Order

- Folder Structure
- The Main Scene
- The Player Character
- The Camera System
- Execution Loop
- Subweapon Composition
- Enemy Composition

## Folder Structure

This project is organized in a set of folders for easy browsing and comprehension. The _addons_ and _ai_ folders are standard godot ones you can see at any other project. The _banks_ and _FMOD_ folders contains the exported banks and the project respectively, which shouldn't be modified or moved (in the case you do you'll need to specify again where the banks are in FMOD's project settings).

| Folder  | Description  | Color |
| ------------- |----|-|
| Collider | Capsule collider used to collide with only the stage | |

## The Main Scene

This is the starting scene that the game goes to and is meant to be executed at all times, whole levels are instanciated inside, contains multiple non-global manager classes, all UI, the player, the camera and contains some audio nodes.

![Screenshot](https://i.imgur.com/MoHO8IZ.png)

If you need to add non-global manager classes or add new UI for a new state like "Options" this is the place.

## The Player Character

Due to using Castlevania I as a base for this template project the player can walk, crouch, idle, jump, attack (w/t crouching), use subweapons and use stairs.

In order for all states to share the necessary information and make changes the player class contains a __core__ resource called _player_resource_. This resource contains all the data.

This object is part of the Main scene, and it's not removed and instanciated every time the player dies, the game changes states... it is reused.

![image](https://i.imgur.com/2oaHpMt.png)

This object contains both a capsule-shaped collider with a _ground_ mask, both a hitbox (whip, gray) and hurtbox (self, green) and an interact area 2D with a _stair_entrance_ mask.

When it comes to sprites it contains both an upper and lower sprites, whip and a fullbody sprite (used for the death pose).

![image](https://i.imgur.com/iqE3bJW.png)

#### Node Composition 
| Node  | Description  |
| ------------- |----|
| Collider | Capsule collider used to collide with only the stage |
| Components - Health | Script by [LimboAI](https://github.com/limbonaut/limboai) (modified), tracks the current health of the player | 
| Components - Flicker | Connects to the Health's signals in order to flicker  when the player is damaged |
| Managers - Subweapon Manager| Manages everything related to subweapons, tracking the current one and current hearts (ammo)|
| FSM (+ all childs) | Base State & State Machine class by [Bitlytic](https://www.youtube.com/@Bitlytic). The Finite State Machine the player uses to interact with the world |
| Contact - Hitbox | Script by [LimboAI](https://github.com/limbonaut/limboai). Area where the player can hit enemies and projectiles |
| Contact - Hurtbox | Script by [LimboAI](https://github.com/limbonaut/limboai). Area where the player can get hit by enemies and projectiles |
| Contact - InteractArea | Area used to interact with stairs when pressing up and/or down (W & S) |
| Sprites (+ all children) | Self explanatory, the player is divided by 2 sprites (upper & lower body) |
| Animation (+ all children) | Self explanatory, contains all children related to sprite animation and event timeline triggers |
| Timers - AttackTimer | Timer tied to the amount of time that takes to attack again after another |
| Timers - DeadTimer | Timer tied to the amount of time it takes to respawn after dying|
| Timers - SubweaponCooldownTimer | Self explanatory, time it takes to throw a subweapon after another |
| Sounds (+ all children) | Sounds triggered by animation events |

#### State Descriptions
| State  | Description  | Connections |
| ------------- |----|----|
| Normal | Starting state, allows for horizontal movement while grounded, can jump in this state and use subweapons | Attack, Dead |
| Stairs | Player movement when moving on top of stairs. You can attack in this state too! | Normal, Dead |
| Attack | State where the player is attacking, can't move or cancel it | Normal, Dead |
| Crouch | Crouching state, can't move but change directions and attack | Normal, Attack, Dead |
| Damaged | Timed state, can't move and regains control when grounded | Normal, Dead |
| Dead | Timed state, can't move or do anything | Normal |

## The Camera System
