# Gamedev Scripts

A collection of scripts in Lua and Ruby that I've made over my game development years.

More information can be found on [the website](https://IMP1.github.io/gamedev-scripts).

## RPG Maker Scripts

### Storage Boxes

This allows for containers to exist which can hold items. You can deposit item into, and withdraw 
items from, these containers, and a window for transfering items is also included. With some of the 
add-ons, you can also give these containers limits, and item-type filters, and allow for items to be
randomly stolen from them.

[Script](https://gist.githubusercontent.com/IMP1/e34da652dad98b9fe8151bcc042bb7a8/raw/9dcc5299d137e85f3e5970fe92e48ba23c7d7e94/Storage%2520Boxes.rb) | 
[Usage & Help](https://forums.rpgmakerweb.com/index.php?threads/storage-boxes.27727/) |
[License](https://github.com/IMP1/gamedev-scripts/tree/master/ruby/storage-boxes#License)

## LÖVE Scripts

### Basic Device Subscription Manager (BDSM) [v0.1.0]

An Input Management library, made to work vaguely similarly to Unity's InputSystem.
Devices are managed separately which provides standardised input events and states.

[Script](https://raw.githubusercontent.com/IMP1/gamedev-scripts/master/lua/bdsm/bdsm.lua) | 
[Usage & Help](https://github.com/IMP1/gamedev-scripts/tree/master/lua/bdsm#Usage) | 
[License](https://github.com/IMP1/gamedev-scripts/tree/master/lua/bdsm#License)

### Bricks [v0.0.0]

A GUI library, made to use a heriarchical structure similar to HTML.

### Bumble

A pathfinding library, using a "navmesh" of polygons for pixel-based, rather than grid-based, 
movement.

### Conductor

A scene-management library, which can handle "stacked" scenes and background processing of scenes.

### Safeword

A simple bare-bones save-game management library. It can only save tables, strings, numbers, 
booleans, and so is best suited for simple game-related data, like player progress.

### Screenshake

A simple screenshake library, handling different shakes strength in the horizontal and vertical 
directions. It can also handle one-off shakes and "rumbles" which last until they are removed.

### Settings

Similar to [Safeword](#Safeword), this handles saved data, although this allows the option to 
provide default values upon loading, and so is best suited to saving user-settings, like window 
sizes and volume values.

### Sweet Nothings

An language-translation library, which attempts to make internationalisation as easy as possible.
This creates entries in language files for every piece of internationalised text, so that when 
translation is done, you know what you need to translate, and it's all in one place.

### Tween

A simple tweening library. It acts on tables' fields, rather than just single numbers.

### Vector

A library for vectors, including 2D and 3D.

### Voyeur

A camera/viewport library.
