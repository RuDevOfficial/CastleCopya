<p align="center">
  <img src="https://i.imgur.com/0wNakQS.png" width="400" alt="CastleCopya logo">
</p>

# A Guide for CastleCopya

This file is meant to be a supplement for you to understand the project as soon as possible, if there is something that has not been explicitly explained (or badly explained, english is not my main language) and should be added here you can contact me on [bluesky](https://bsky.app/profile/ru-dev-official.itch.io).

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
- Save & Loading
- The Signal Bus

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

### Doors

Doors are another method to connect separated paths. They are made of a StaticBody2D root with a *door.gd* script attached, and has a Collider, Sprite, Area2D and AnimationPlayer as children.

![door](https://i.imgur.com/Zy5ABl3.png)

To add them to a level place it somewhere inbetween two horizontal camera paths, and select the next camera path index.

![door add](https://i.imgur.com/Ji5yJ9u.png)

**Note**: The current implementation only works for horizontal scrolling.

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
- Consumable Scene
- Subweapon Scene

### Subweapon Data Resource

This resource contains all data related to the subweapon's before a subweapon scene is instantiated: icon, throw delay, cooldown, cost, animation speed, scene and both grounded and airborn throw offsets.
- **Throw Delay**: The time it takes to actually spawn it
- **Cooldown**: The time it takes to throw one after another
- **Cost**: The amount of hearts it consumes before it's thrown
- **Vertical Ground Throw Offset**: Positional offset applied when thrown while grounded
- **Vertical Air Throw Offset**: Positional offset applied when thrown while in the air
- **Scene**: The packaged scene that will be instanciated

![example](https://i.imgur.com/CdndQ6T.png)

### Subweapon Resource

This resource contains only the necessary data for the instanciated subweapon. Only contains lifetime, damage, speed and sound key.
- **Lifetime**: The amount of time it takes before *queue_free()* is triggered
- **Damage**: Self explanatory
- **Speed**: Self explanatory
- **Sound** Key: String key used to generate a sound via the AudioManager global script

![example](https://i.imgur.com/X7cf9s7.png)

### Consumable Scene

You could initialize the player alongside a default subweapon by going to the player's *Subweapon Manager* and applying a subweapon data, but you will often find them by breaking candles. This means there needs to be a collectable that changes the player's current subweapon, these fall in the umbrella term called "consumables" (such as hearts), and are triggered when the player collides with the object's area.

All currently implemented subweapons inherit from the base class *consumable.gd* called *consumable_subweapon.gd*, but a different one can be created, overwritting the *consume_item()* method for extra functionality (like spawning some particles when collecting a specific consumable).

![example](https://i.imgur.com/FaZg07w.png)

This scene is made of 3 nodes with a Rigidbody2D node as their root, CollisionShape2D, Sprite2D and Trigger.

![example](https://i.imgur.com/ge7i9w9.png)

### Subweapon Scene

This is the actual projectile that the player will spawn upon use. The root is a Rigidbody2D with the *subweapon.gd* script and contains a Collider, Sprite, Hitbox and AnimationPlayer nodes.

![example](https://i.imgur.com/E3pGuJR.png)

As you can see all implemented subweapons do not contain their own script, but instead they use *modifiers*. These modifiers affect the behaviour of the projectile in different points:
- On Ready (Modify)
- On Thrown
- On Update (Process)
- On PhysicsUpdate (Physics Process)
- On Contact (Area Entered)
- On Lifetime Reached

They are applied inside the *subweapon.gd* script tied to the scene's root inside an array. Since they are resources you don't need to save each one, but generate it on the fly.

For example there's the Knife subweapon, which contains the following modifiers: throw_linear, throw_flip_direction and throw_offset. First one sets the velocity vector to be only in the x axis, flip direction changes the sprite's flip_h boolean depending on the horizontal speed and the throw_offset just applies a vector 2 offset depending on the direction.

![example](https://i.imgur.com/yu23OLB.png)

So, if you wanted to make a weapon that both moves in a linear fashion while also moving in circles you could mix a linear modifier only triggered when thrown alongside a circular modifier that updates on each physics frame.

**Make sure to add the apropriate subweapon resource in the script!**

## Enemy Structure

When an enemy is instanciated it's added inside *EnemyManager*'s enemy list, which disables or enables enemies (while also removing generated ones) at specific points (like disabling all enemies once the black curtain is at 100% opacity after the player's character dies).

![code example](https://i.imgur.com/eG4KMUI.png)

For an enemy to be considered valid a Rigidbody2D must be the root and include the following children: Collider, Sprite, BTPlayer, AnimationPlayer, VisibleOnScreenEnabler, Health & Flicker, Hurtbox & Hitbox and Particles.

![example](https://i.imgur.com/aOroRla.png)

The scene's root contains the *enemy.gd* script, which requrires an *enemy_data_resource*. This resource has all the important **read-only** data used to propagate the necessary information to their respective components, so you only need to modify the data resource.

![example](https://i.imgur.com/Zps3AQa.png)

Enemy behavior is not built in the enemy script, but rather executed inside the BTPlayer, a tool used to create AI behaviors via [behaviour trees](https://robohub.org/introduction-to-behavior-trees/). This allows the dev to build and reuse common behaviors that other enemies can use.

To understand how LimboAI works you can read about it [here](https://github.com/limbonaut/limboai).

## Stair Structure

![stairs](https://i.imgur.com/VfuWkxf.png)

Currently stairs are built with 3 key nodes: Sprites, Triggers & Path.
- Sprites hold all individual sprites for each step (although they are hidden in favour of tilemap sprites).
- Triggers contain the entry and exit points. If the player's *InteractArea* is colliding with the entry or exit point areas and presses W or S (depending on the stair orientation) they will switch to the stair movement state.
- Path is the actual path the player character will move through.

### The Path

For the player character to follow the path they snap to the *Follow* node's global position, this node's position is updated by adding or removing delta_time (alongside a multiplier) depending on the path's direction vector and the player's input.

![example](https://i.imgur.com/mKpDSkG.png)

**Note**: *The current system has a side effect where the player character would reach the top of the stairs at the same time independently of how short or large they are, which should be corrected in a future update*.

## Save & Loading

This template has a built-in save & loading manager that allows for multiple save files (although only the first one is ever used) and easy data additions, and all this is inside the *SaveManager* class (*save_manager_global.gd*).

These files are saved on your AppData\Roaming\Godot\app_userdata\CastleCopya, and there are two types:
- game_data.txt: Holds all save-independent data, such as the current selected save file index. If you need to add things like options data this is the place to do so.
- saves/save_game_X.txt (X is any number): Specific save-file data. Currently only contains if the player already saw the intro cutscene or not and the current level they are in.

When the game is open, the manager looks for these files: if game_data does not exist it's generated, if not a single save_data exists only one is generated. If the files already exist they are converted to their proper resources, which are SavefileDataResource and GameDataResource.

### Adding new data to Savefile and GameData resources

To add new game data is as easy as going to the *game_data_resource.gd* script, declaring a new value, adding a new dictionary entry with their corresponding default value and add assign it again on the *dictionary_to_game_data(dictionary)* method.

![game_data](https://i.imgur.com/gGRluYw.png)

The same applies to the **SavefileDataResource**.

![save_file](https://i.imgur.com/UKpWTpw.png)

### Methods

|Name| Description|
|-|-|
|preload_savefiles() | Checks for the saves directory, converts any saves to SavefileDataResource and adds it to the *save_files* array |
|get_current_save_file_on_load()| Locates existing or generates a new game_data file, converts it to GameDataResource and obtains their LAST_SAVE_DATA_INDEX value |
|check_for_existing_data()| Checks if the saves directory already exists|
|generate_savefile_data()| Checks the amount of files inside the saves folder and generates a new savefile .txt file |
|save_savefile_data(**index : int**)| Converts all resource values to their respective .txt file, given an index |
|load_savefile_data(**index : int**)| Loads all values from the respective .txt file to a resource, given an index |
|get_current_savefile_data()| Self explanatory, returns a SavefileDataResource |
|overwrite_current_savefile_data_values(**key : String, value, do_save : bool**)| Overwrites specific dictionary values  from the current savefile. The parameter *do_save* allows to also save the savefile data upon overwrite |
|overwrite_savefile_data_values(**index : int, key : String, value, do_save : bool**)| Same as the previous, but you can choose an index |
|clear_savefile_data(**index : int**)| Self explanatory |

### Usage Example

This class does not generate the existing data by itself, instead the **GStateManager** class calls *check_for_existing_data()* on runtime. When entering the **gameplay** state it calls *get_current_savefile_data()* and uses the *CURRENT_LEVEL* value as an entry parameter for the *StageManager* class.

![example](https://i.imgur.com/lyP2Gcy.png)

Another example is the play_button is connected to a method that gets the current gameplay data, and depending if the intro has already been viewed it decides to play the introduction cutscene or not.

![example](https://i.imgur.com/Y8WWv9F.png)

## The Signal Bus

In case you are new to Godot, signal buses are an easy way to emit and connect to signals from any other class. This is made by creating a global class which only holds signals. This is what the **SignalBus** on this project is.

![signal bus](https://i.imgur.com/kkMyIk3.png)
