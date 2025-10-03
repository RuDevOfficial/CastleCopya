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
