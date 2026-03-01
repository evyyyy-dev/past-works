# Deterministic Dungeon Generator

> Modular dungeon generation with deterministic seeds and collision-safe placement.

---

## Features

**Core System**
- Deterministic (seed-based) generation
- Collision validation
- Easily expandable, weighted room system
- Backtracking support for dead-end recovery

**Tooling**
- Interactive state-machine driven control panel
- Manual seed + room count input
- Runtime regeneration & cleanup

---

## Showcase

[![Watch showcase](https://img.youtube.com/vi/OdpghMGbseU/0.jpg)](https://www.youtube.com/watch?v=OdpghMGbseU)

---

## Architecture

```
Workspace
 ├─ LoadedRooms                     │ The folder where all loaded rooms are inside of.
 └─ GeneratorModel
     └─ ControlPanel
         └─ SurfaceGui
            ├─ Frame   
            │   └─ InputContainer
            │       ├─ RoomInput   │ Number input for the amount of rooms to generate.
            │       └─ SeedInput   │ Number input for the seed, if nothing is specified it uses a random seed.
            └─ StartButton

ReplicatedStorage
 ├─ Modules
 │   ├─ Core
 │   │   └─ Generator               │ The main module that handles placing, collision checking, backtracking, and more.
 │   └─ Utils
 │       └─ Shared                  │ Shared variables used across 2+ scripts.
 ├─ Rooms
 │   └─ ExampleRoom
 │       ├─  Connectors             │ A folder containing both  └─start and end connectors, used for placement
 │       │  ├─ StartConnector       │ The StartConnector pivots to the previous room's EndConnector.
 │       │  └─ EndConnector
 │       ├─ Geometry
 │       │  ├─ Walls
 │       │  └─ Floor
 │       ├─ Props
 │       └─ MetadataValues          │ Metadata of the room containing it's weight (chance to get picked) and type.
 ├─ ModuleRegistry                  │ Centralized module access, so renaming a module requires updating only one variable.
 └─ StartGeneratingEvent

ServerScriptServie
 └─ RoomGeneration                  │ State machine that initializes, generates, and if needed, erases the whole dungeon.
```

---

## Code snippets

Check out [code-snippets.lua](https://github.com/evyyyy-dev/past-works/blob/main/dungeon-generator/code-snippets.lua) for code examples.

---

## Why I Made This

I made this because I wanted to build something bigger and more organized than my previous projects.

My goal here wasn't to make it just generate rooms, but to design a modular and expandable system that could grow over time.

This was my first time making a deterministic dungeon generator, and I treated it as a way to improve my architectural decisions and performance awareness.

## What I Learned

This project helped me better understand state-driven systems and how generation flow can be structured cleanly.

I also learned how small decisions can significantly impact performance. My original approach cloned and positioned the complete room models to test for collisions. I later refactored this to use `GetPartsInBoundBox` as an imaginary bounding box before instantiation, which reduced unnecessary operations and improved efficiency.

In addition, I gained more experience working with metadata-driven architecture instead of hardcoded logic. Designing the system around room metadata made it a lot easier to extend and maintain.

Lastly, I became more intentional about writing cleaner code by simplifying conditionals, reducing redundancy, and organizing logic in a way that improves readability.

## What I'd Improve

The main area I would improve is the backtracking system. It currently only allows 3 recovery attempts before terminating generation. Expanding this into a more dynamic backtracking system would make the generator more resilient.

I would also consider changing the layout generation entirely — generating only the full layout first, validating it, and only then cloning and positioning the final room models. This could optimize performance even further and make the system more scalable.

---

> ✅ **Status:** Complete *(further improvements may be made)*
