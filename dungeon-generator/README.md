# Deterministic Dungeon Generator (DOORS-inspired)

Modular dungeon generation with deterministic seeds and collision-safe placement.

## Features
* Seeded generation
* Collision validation
* Easily expandable, weighted room system
* Backtracking support (in case generation gets completely stuck)

## Videos & Images
#### Showcase:
--i'll probably rework this video later

[![Watch showcase](https://img.youtube.com/vi/OdpghMGbseU/0.jpg)](https://www.youtube.com/watch?v=OdpghMGbseU)

## Architecture
```
ReplicatedStorage
 ├─ Modules 
 │   ├─ Core
 │   │   └─ Generator │ The main module that handles placing, collision checking, backtracking, and more.
 │   └─ Utils
 │       └─ Shared    │ One place for variables used by 2 scripts or more.
 │  ModuleRegistry    │ For easy module access across scripts, so renaming a module requires updating only one variable.
 └─ StartGeneratingEvent

ServerScriptServie
 └─ RoomGeneration    │ State machine that initializes, generates, and if needed, erases the whole dungeon
```

## Code snippets
Check (code-snippets.md)[HYPERLINK-TO-THE-FILE] for code examples!

## Why I made this

uh... cuz... :3 <--- (this little goober is the reason why I made this)

## Status
Complete 
