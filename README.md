# Pokémon Black \& White Tracker for Archipelago

## Features (for v0.3.14 of the apworld and later)

* Key Items Tracking
* Item Locations Tracking
* Event Tracking
* Auto-Tabbing
* Split Mode
* Hint Highlighting
* Settings Display for most settings
  * You can manually hide some of the commonly excluded locations in the Location Visibility section of the settings pop-up
* Encounters Tracking
  * You can decide whether to show all Pokémon and track them automatically or to only show encounters which are Dexsanity checks
* Evolution Logic Display
* Pokésearch

## Split Mode
This tool allows you to either display one singular map at a time or the overworld map and a submap at the same time. Click on the `SPLT` icon to change the tracker to the following modes:
- `Split Map - OFF`: The tracker only displays one tab.
- `Split Map - ON`: The tracker displays the submaps on the left and the Overworld/Pokédex tabs on the right.
- `Split Map - Reverse`: The tracker displays the Overworld/Pokédex tabs on the left and the submaps on the right.

## Auto-Tabbing
When enabled, the tracker will change the displayed map to match the state of the game. With `Split Map - ON` and `Split Map - Reverse`, only the submap tab will be switched. Click on the `AUTO` icon located in the Tools grid to turn on/off auto-tabbing. 

## Hint Tracking
This pack features a hint tracking system with three different modes: `ON`, `Advanced` and `OFF`. You can change the mode in the Tools grid by clicking on the `HINT` icon.
- `ON`: Hinted locations will appear on the overworld map and the submaps with a colored glow that corresponds to the priority of the items they hold.
- `Advanced`: Hinted progression locations will appear on the overworld map and the submaps with a golden glow. Other hinted items will be marked as cleared.
- `OFF`: Turns off the hint tracking feature.

## Pokémon Tracking
This pack has four different modes to track Pokémon. You can cycle through them by clicking on the Pokémon Tracking icon located in the Tools section of the tracker.
- `REQ`: The default behaviour. Only Pokémon that have sanity locations will be accounted for in the encounter diamonds. If more than one type of sanity is enabled, an extra diamond will be added to each submap to display how many catches/seens/shinies are left. Trainer team locations will also be updated to show how many Pokémon they have that you need to see.
- `ALL`: The counts on encounter diamonds will only decrement when you catch a Pokémon. If you have a sanity that requires to see shiny Pokémon, the counts will also not decrement until you've seen needed shinies. Trainer teams will be updated as new Pokémon are seen.
- `PROG`: The palex00 mode. Nobody knows what it does except him. (It does the same thing as `ALL`, but it also progressively removes non required wild Pokémon as they are seen.)
- `OFF`: Turn off Pokémon tracking for a manual tracking.

Please note that pre-evolutions are currently never accounted for in any of the modes. If evolutions are in logic, you may have to catch something that isn't tracked.
For example, let's say Pikachu is a dexsanity location but Pichu isn't. Pichu is available as a land encounter on Route 1. It will not be tracked in REQ mode, but you might need to catch it anyway to evolve it and get its dexsanity check. In this scenario, switching between `REQ` and `ALL` could be helpful to know how many Pokémon are actually available in a zone.

## Pokésearch
While connected to a slot, you can search for a specific Pokémon by entering its Pokédex ID and clicking on the Enter button. You can find a list of all IDs [here](https://bulbapedia.bulbagarden.net/wiki/List_of_Pok%C3%A9mon_by_National_Pok%C3%A9dex_number). When performing a search, the map settings will change to only show the encounter slots that contain the searched Pokémon. Click on the cancel button to cancel a search.
Some useful IDs:
- `585` (Deerling)
- `492` (Shaymin)
- `649` (Genesect)
- `251` (Celebi)
- `243, 244, 245` (Raikou, Entei, Suicune)
- `641, 642` (Tornadus, Thundurus)
- `546` (Cottonee)
- `548` (Petilil)
- `572, 573` (Minccino, Cinccino)
- `525` (Boldore)
- `132` (Ditto)

## Blue Square Logic
Some item locations will appear in blue in the tracker. PopTracker doesn't know if these locations are currently in logic. Some of them will stay blue at all times, and some of them will turn green once their conditions are met. Please refer to Universal Tracker if you need to know if these locations are in logic.

The following locations will turn green once their conditions are met:
```
    - "Castelia City - Item from scientist in building in northern street for seeing 20 Pokémon"
    - "Driftveil City - Item from man for seeing more than 50 pokémon"
    - "Lacunosa Town - Item from girl for showing a Shaymin"
    - "Nuvema Town - TM from Professor Juniper for seeing 115 species"
    - "Nuvema Town - TM from Professor Juniper for seeing 25 species"
    - "Nuvema Town - TM from Professor Juniper for seeing 60 species"
    - "P2 Laboratory - Item from scientist #1"
    - "P2 Laboratory - Item from scientist #2"
```

The following locations will stay blue at all times:
```
    - "Castelia City - Item from harlequin in Studio Castelia"
    - "Driftveil City - Item from lady asking for a pokémon knowing a certain TM move"
    - "Pinwheel Forest Outside - Item from challenge rock"
    - "Route 6 - Item from scientist for all Deerling forms"
    - "Village Bridge - Item from fisherman for showing a certain pokémon caught today #1"
    - "Village Bridge - Item from fisherman for showing a certain pokémon caught today #2"
    - "Village Bridge - Item from fisherman for showing a certain pokémon caught today #3"
    - "Village Bridge - Item from fisherman for showing a certain pokémon caught today #4"
    - "Village Bridge - Item from fisherman for showing a certain pokémon caught today #5"
```
## Location Visibility Lists

You can manually show or hide the following groups of locations by clicking on their corresponding icon in the settings pop-up. You should only consider hiding a location if you excluded it in your YAML.
- Show/Hide Abyssal Ruins Locations (46 locations)
```
    - "Abyssal Ruins items"
```
- Show/Hide Pokédex Appraisal Locations (6 locations)
```
    - "Castelia City - Item from scientist in building in northern street"
    - "Driftveil City - Item from man for seeing more than 50 pokémon"
    - "Nuvema Town - TM from Professor Juniper for seeing 115 species"
    - "Nuvema Town - TM from Professor Juniper for seeing 25 species"
    - "Nuvema Town - TM from Professor Juniper for seeing 60 species"
    - "Route 6 - Item from scientist for all Deerling forms"
```
- Show/Hide Breeders and Rangers Locations (24 locations)
```
    - "Desert Resort - Item from ranger Jaden"
    - "Desert Resort - Item from ranger Mylene"
    - "Moor of Icirrus - Item from ranger Chloris"
    - "Moor of Icirrus - Item from ranger Harry"
    - "Pinwheel Forest - Item from ranger Audra"
    - "Pinwheel Forest - Item from ranger Forrest"
    - "Pinwheel Forest - Item from ranger Irene"
    - "Pinwheel Forest - Item from ranger Miguel"
    - "Route 1 - Item from ranger Brenda"
    - "Route 1 - Item from ranger Claude"
    - "Route 11 - Item from ranger Crofton"
    - "Route 11 - Item from ranger Thalia"
    - "Route 12 - Item from breeder Ethel"
    - "Route 12 - Item from breeder Eustace"
    - "Route 15 - Item from ranger Keith"
    - "Route 15 - Item from ranger Shelly"
    - "Route 3 - Item from pokémon breeder Adelaide"
    - "Route 3 - Item from pokémon breeder Galen"
    - "Route 6 - Item from ranger Richard"
    - "Route 6 - Item from ranger Shanti"
    - "Route 7 - Item from ranger Mary"
    - "Route 7 - Item from ranger Pedro"
    - "Route 8 - Item from ranger Annie"
    - "Route 8 - Item from ranger Lewis"
```
- Show/Hide Winter or All Season Items Locations (12-17 locations)
```
-- Winter Locations
    - "Dragonspiral Tower - Item near entrance (Winter)"
    - "Icirrus City - Hidden item west of pokémon center (Winter)"
    - "Icirrus City - Item from the former Team Rocket member's wife (Winter)"
    - "Icirrus City - Item west of pokémon center (Winter)"
    - "Icirrus City - South hidden item #1 (Winter)"
    - "Icirrus City - South hidden item #2 (Winter)"
    - "Icirrus City - South hidden item #3 (Winter)"
    - "Twist Mountain - Lower floor little east cave item (Winter)"
    - "Twist Mountain - Main floor east hidden item (Winter)"
    - "Twist Mountain - Main floor north hidden item #1 (Winter)"
    - "Twist Mountain - Main floor north hidden item #2 (Winter)"
    - "Twist Mountain - Middle floor north cave item (Winter)"

-- Spring/Summer/Autumn Locations
    - "Moor of Icirrus - Hidden item behind boulder (Spring/Summer/Autumn)"
    - "Moor of Icirrus - South east item (Spring/Summer/Autumn)"
    - "Route 8 - West hidden item (Spring/Summer/Autumn)"
    - "Twist Mountain - Lower floor north west cave hidden item (Spring/Summer/Autumn)"
    - "Twist Mountain - Lower floor north west cave item (Spring/Summer/Autumn)"
```

## AI Usage Disclosure
This project does not contain AI generated art or assets.
Claude (an LLM) was used to:
- Generate a small amount of code to fix a performance issue
- Complete tedious tasks
- Debug code
- Explain MIT code from other trackers

This should not represent more than 5% of the work done for the entire project. Everything was reviewed and tested by the team.
