---
title: "Sega Genesis Collection"
date: 2026-05-21
draft: false
weight: 4
description: "A near-complete Sega Genesis cartridge library, and the software I built to catalog and organize it."
---

I've spent years assembling a complete Sega Genesis cartridge library. As of now I'm two games short of the full set — a piano game and a notoriously rare health title — close enough to feel finished, far enough to keep the hunt interesting.

A collection that size stops being something you *own* and becomes something you have to *manage*. So I built the software for it.

## The tools

- **GameScan** — a SwiftUI / SwiftData iOS app. Point the phone at a cartridge, the Vision framework reads the barcode, and the app matches it against the catalog, tracks each game's physical location down to bookshelf, shelf, and position, and publishes scan events over MQTT into the rest of my home setup.
- **genesis-organizer** — a Python tool that handles the physical layer. It takes the catalog and generates shelf maps, printable checklists with per-game locations, rotated spine labels that match the physical cases, and genre lists that feed 3D-printed shelf dividers.

Both were vibe-coded — built fast and conversationally with an AI agent, then refined into something I actually use.

## Why it matters to me

This is the same instinct behind [Frykin Industries](/projects/frykin-industries/): software meeting the physical world. A collection isn't finished when the games are on the shelf — it's finished when you can put your hand on any one of them in seconds. Closing the loop between a digital catalog and four real bookshelves turned out to be the genuinely interesting engineering problem, and the most satisfying part to get right.

*Stack: Swift · SwiftUI · SwiftData · Vision Framework · MQTT · Python*
