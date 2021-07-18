# Caek

This file will tell you where to look and to look for what code.

Server: src/server/GameComponents
Client: src/client

## Game Components

- Server/Player.lua is an object that is instantiated everytime a player joins the cake minigame. This object is automatically deleted once the player leaves the game, or he respawns.
- Server/PlayerManager.lua is responsible for caching player object and make sure there is only one player object created for each indivitual player.
- Server/GameController.lua is responsible for loading every module and starting the minigame. 

## Cake Components

CC: Server/CakeComponents

- CC/Cake.lua contains code for Cake Generation
- CC/CakeEnums.lua contains code for storing cake models such as bases and cake colour codes such as 

## Kitchen Components

KC: Server/KitchenComponents

- KC/MachineController.lua is responsible for assigning functions that need to be run for each machine
- KC/Machines.lua holds code that has to be run for each machine when the machine is used by the player
- KC/Messages.lua hold messages that player sees when they interact with the machines
- KC/Selector.lua is a Object that is specifically written for selector machines
- KC/Tray.lua is object that can be instantiated to give a tray to a player.


