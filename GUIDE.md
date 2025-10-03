<p align="center">
  <img src="https://i.imgur.com/0wNakQS.png" width="400" alt="CastleCopya logo">
</p>

# A Guide for CastleCopya

This file is meant to be a supplement for you to understand the project as soon as possible, if there is something that has not been explicitly explained and should be added here you can contact me on [bluesky](https://bsky.app/profile/ru-dev-official.itch.io).

# Guide Order

- Folder Structure
- Execution Loop
- The Main Scene
- The Player Character
- The Camera System
- Level Structure
- Subweapon Structure
- Enemy Structure
- Stair Structure
- The Resources

## Folder Structure

This project is organized in a set of folders for easy browsing and comprehension. The _addons_ and _ai_ folders are standard godot ones you can see at any other project. The _banks_ and _FMOD_ folders contains the exported banks and the project respectively, which shouldn't be modified or moved (in the case you do you'll need to specify again where the banks are in FMOD's project settings).

![Folder Structure](https://i.imgur.com/ZwCtd9d.png)

## Execution Loop

The whole execution loop begins inside the Game State Manager class, which handles all logic related to state switching between the main menu, intro cutscenes, intermissions and gameplay. Critical classes subscribe to events tied to the start and exit of each state (such as *on_enter_menu* and *on_exit_menu*) which activates or deactivates them.

| State  | Description | Scripts connected to On Enter & Exit Signals| 
| ------------- |----   |-|
| Ready | Starting state, inmediatle switches to *Menu* | none       | 
| Menu | Main menu state | menu_ui.gd |
| Options | Options state, currently unused | none |
| Intro | State where all intro cutscene logic is triggered | none |
| Intermission | Transitional state used to link levels together | intermission_ui.gd |
| Gameplay | State where the player goes through a level | camera_manager.gd, transition_event_manager.gd, gameplay_ui.gd|

**This are state transitions that can happen in the game:**
- Player opens the game -> Ready state
- Player selects play -> Ready to Intro state (first time) | Ready to Gameplay state
- Player dies -> Gameplay to Gameplay state
- Player collects the orb -> Gameplay to Intermission state
- Intermission (next stage animation) plays -> Intermission to Gameplay state


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

This system (inside the *CameraManager* node in *Main.tscn*) gets any 2D camera and it forces to be within the bounds of a path, this path can either go horizontally or vertically and can be connected one after another and can stop & resume tracking the player.

When the game triggers a door transition this system is momentarily paused to allow for a smooth transition between separated paths (see the *_process* method on the _camera_manager.gd_ script)

### Camera Paths

A camera path is a script that inherits the Path2D node and contains the following boolean options:
- Connects to Previous Path: If the player reaches the start of the current path, do we go one step back to the previous?
- Connects to Next Path: If the player reaches the end of the current path, do we go to the next one?
- Is Last Path: Is this the last path of the level?

![Example Path](https://i.imgur.com/Qmvzer9.png)

When the camera system recognizes that the **current path is the last one** the camera stays completely still and generates one of 2 _EndEvents_: none (spawns an orb inmediatle that upon collection finishes the level) and boss (spawns a boss you have to defeat in order to get the same orb).

The order of each path is decided by the child order, in order to ensure each one is correctly placed make sure to rename them with just numbers.

### Warping

There is only one way to ignore the path order and it's with _Warps_. This object contains an _Area2D_ that checks for a player collision, and a _Point_, which is where the player is teleported to. A warp can choose which path index to go to. You can make one direction teleports by only adding one warp, or add 2 in order to allow a return.

![Warp Example](https://i.imgur.com/EkUF7ll.png)

This warp can also be tied to a set of stairs and specified if it's an entrance (is tied to the beginning of the set of stairs) or not. Depending on the answer the player will be put more at the beginning or end of the stair's direction vector.

**It is recommended** to rename _Warps_ apropriately to easily recognize if they are connected or not. For example with **Warp_0_0** and **Warp_0_1** or **Warp_A_0** and **Warp_A_1** we know that they are related.

## Level Structure

Levels must follow the same structure as seen in the example *0_entrance_hall.tscn*. These are made of multiple child nodes, which include: Entities, TileMap, Paths, PlayerSpawnPosition, OrbSpawnPosition and BossSpawnPosition.

It is adviced to place any entities in their respective child nodes in order to organize all objects a level might contain, such as Enemies, Whippables (such as blocks and candles), Stairs, Doors, Warps, Generators and Triggers.

The TileMap node should contain all level graphics, including any layer that contains static hazards such as spikes, and the Paths node must contain all camera paths for the levels, explained in the section "**The Camera System**".

Finally the starting player position, the place where the orb spawns after a EndEvent is triggered/boss is defeated and the place where the boss itself appears have a dedicated Node.

![Example](https://i.imgur.com/07A0pAi.png)

**It's recommended to just duplicate a level scene such as the one shown and modify it later than building one from scratch.**

## Subweapon Structure

Subweapons are one of the key pillars for any castlevania-like game. In order to fully implement one you must make the following files:
- Subweapon Data Resource
- Subweapon Resource
- Subweapon Icon
- Consumable Script
- Consumable Scene
- Subweapon Scene

### Subweapon Data Resource

This resource contains all data related to the subweapon's before a subweapon scene is instantiated: icon, throw delay, cooldown, cost, animation speed, scene and both grounded and airborn throw offsets.
- **Throw Delay**: The time it takes to actually spawn it
- **Cooldown**: The time it takes to throw one after another
- **Cost**: The amount of hearts it consumes before it's thrown
- **Vertical Ground Throw Offset**: Positional offset applied when thrown while grounded
- **Vertical Air Throw Offset**: Positional offset applied when thrown while in the air
- **Scene**: The packaged scene that will be instantiated

![example](https://i.imgur.com/CdndQ6T.png)

### Subweapon Resource

This resource contains only the necessary data for the instanciated subweapon. Only contains lifetime, damage, speed and sound key.
- **Lifetime**: The amount of time it takes before it stops updating (*does not queue_free() by default*)
- **Damage**: Self explanatory
- **Speed**: Self explanatory
- **Sound** Key: String key used to generate a sound via the AudioManager global script

