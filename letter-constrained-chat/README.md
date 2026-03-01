# Letter-Constrained Chat Filtering System

> DESCRIPTION TBD

---

## Features
**TITLE TODO**
- THING

---

## Showcase

[![Watch showcase](https://img.youtube.com/vi/jh2TKaVG0Fk/0.jpg)](https://www.youtube.com/watch?v=jh2TKaVG0Fk)

---

## Architecture

```
ReplicatedStorage
 ├─ Modules
 │   ├─ Chat
 │   │   ├─ Client
 │   │   │  ├─ ChatEffects
 │   │   │  ├─ ChatInput
 │   │   │  └─ ChatUI
 │   │   └─ Server
 │   │      └─ ChatServer
 │   └─ Main
 │       ├─ PrizePool
 │       └─ PlayerData
 ├─ Events
 │   └─ Remotes
 │       ├─ ClientReady
 │       ├─ ReceiveMessage
 │       ├─ SendMessage
 │       └─ UpdateText
 ├─ Functions
 │   └─ Remotes
 │       └─ GetRandomLetter
 ├─ Templates
 │   ├─ Letter
 │   └─ ChatMessage
 ├─ EventRegistry
 └─ ModuleRegistry

ServerScriptServie
 └─ ChatService

 StarterGui
 ├─ LettersGui
 │   └─ Container
 ├─ ChatGui
 │   └─ Frame
 │       ├─ ScrollContainer
 │       └─ ChatBox
 └─ Roll
     └─ Spin

StarterCharacterScripts
 └─ DisableChat

StarterPlayerScripts
 └─ ChatController
```

---

## Code snippets

Check out [code-snippets.lua](https://github.com/evyyyy-dev/past-works/blob/main/letter-constrained-chat/code-snippets.lua) for code examples.

---

## Why I Made This

TODO

## What I Learned

TODO

## What I'd Improve

TODO

---

> ✅ **Status:** Complete
