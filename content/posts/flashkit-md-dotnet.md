---
title: "Porting a Sega Cart Programmer to Modern .NET (with an AI)"
date: 2026-07-22
draft: false
tags: ["dotnet", "retro-gaming", "open-source", "ai", "engineering"]
description: "I took krikzz's Windows-only FlashKit MD cart programmer and ported it to .NET 10 with cross-platform support, three UIs, and a proper release pipeline. 25 versions in 5 days, with Claude doing the coding and me doing the driving."
---

I've been building the complete North American Sega Genesis collection for about a decade now. That's a story for another time, but it means I [stream retro games on Twitch](https://twitch.tv/jfryman), dump ROMs for preservation, and flash homebrew onto dev carts. The tool for all of that is [krikzz's FlashKit MD programmer](https://krikzz.com/our-products/accessories/flashkitmd.html), a small board that reads and writes Genesis/Mega Drive carts over USB serial.

The problem is that krikzz's client only runs on Windows. The original C# code targets an old .NET Framework, uses WinForms, and calls into Windows-specific serial APIs. If you're on Linux or macOS, your options are a VM or a dedicated Windows box just for cart work.

I've been wanting to fix this for a while. Last week I sat down with Claude and did it. Five days later, the project was at version 1.9.3 with a GUI, a TUI, a CLI, cross-platform releases, Flatpak packaging, code signing, and hardware validation on all three platforms.

## How I Used the AI

Let me be upfront about this, because I think the details matter more than "I used AI."

I used [Claude Code](https://docs.anthropic.com/en/docs/claude-code) with [Claude Fable 5](https://www.anthropic.com/claude/fable), Anthropic's frontier model built for long-horizon coding work. All the code is C#. Claude wrote it; I drove the loops, made the decisions, and did the taste-making.

That distinction matters. Claude is fast and competent at generating functional code. What it's not great at is knowing when "functional" isn't good enough. It would build a GUI that technically worked and call it done. I'd look at it and say: the status indicators need to match between the GUI and TUI. The transaction log entries need to be bordered cards, not text lines. The file picker should suggest a filename based on the cart header. Tab needs to walk every interactive element, not get trapped in a panel.

Those requirements emerged iteratively. I didn't have a spec. I had taste, and I applied it in loops: build a thing, use the thing, notice what's wrong, fix it. Repeat. Each cycle, I'd push Claude to make the two interactive front-ends consistent, and that pressure is what eventually produced the shared Presentation layer. It wasn't architected upfront; it fell out of insisting that the GUI and TUI behave identically.

The framework choices came from Claude too. I started with a goal: make this cross-platform. Claude chose .NET 8 as the starting point, which was reasonable. It chose Avalonia for the GUI. I didn't pick those; I described what I wanted and let the AI make the technical calls. Later, when I added the TUI (partly because I was having fun, partly to see how Claude would handle splitting the concerns), Terminal.Gui had requirements that pushed us to .NET 10. That upgrade was driven by the work, not by a plan.

What Claude absolutely could not do was test on physical hardware across platforms. That was mine, and it was the most important part of the project.

I built a [hardware validation checklist](https://github.com/jfryman/flashkit-md-dotnet/blob/main/docs/hardware-validation.md) ordered from least to most destructive: `info` on a known cart, `read-rom` and compare MD5s, `read-ram`/`write-ram` round-trip, and finally `write-rom` to a flash cart with a console boot test. Then I ran through it on all three platforms with real cartridges: Action 52, Shining Force 2, Sonic 3, Blaster Master 2.

The results had to be byte-identical across platforms and to the original Windows client. On Windows, I dumped the same Shining Force 2 cart with both my port and krikzz's original client minutes apart: `fc /b` showed no differences. Since the Linux and macOS dumps already matched the Windows dump, that one cross-check cleared the verification for all three platforms.

Some of the most interesting discoveries came from this process. I found that my FlashKit flash carts have no save RAM populated, so games play but can't save. I discovered "ghost saves": when you flash a 2 MB ROM over a 4 MB one, the stale data left above the image gets read as corrupted save slots on console. That finding led to the `--full-erase` flag. The macOS FTDI `tcdrain` hang that wedged `write-rom` on exit? Found that on hardware too, not in any test suite. The fix (discard the output queue, abandon a stuck close) changed the architecture of how the GUI manages serial sessions.

The AI made it faster to get to "something to test." But the validation was hands-on, and it's where the real bugs lived.

## Reading the Changelog

I kept a [detailed changelog](https://github.com/jfryman/flashkit-md-dotnet/blob/main/CHANGELOG.md) throughout the project, following [mitchellh's HashiCorp style](https://github.com/hashicorp/terraform/blob/main/CHANGELOG.md): versioned sections with FEATURES / IMPROVEMENTS / BUG FIXES headings and component-prefixed entries. Every user-visible change gets an entry in the same commit as the change.

This turned out to be one of the best decisions I made, and not for the usual reasons. Yes, it's good discipline and it makes releases easy (the release workflow extracts the section for release notes automatically). But more importantly, it made working with an AI agent dramatically easier. The changelog became a shared record of what had been done and what state the project was in. Instead of re-explaining context every session, I could point Claude at the changelog and say "here's where we are."

The changelog also tells the story of the project better than I could summarize it. Twenty-five versions across five days, and you can see the arc clearly:


**Make it work (0.9.0 to 1.0.0, Day 1).** The initial port was CLI-only, targeting .NET 8. Within hours I hit the first yak shave: the serial-port native library wasn't embedded in the single-file binary, so every serial open failed with a dlopen error. Then macOS killed the unsigned arm64 binary on launch. Then `write-rom` hung on macOS exit because the FTDI driver's `tcdrain` wedges after large flash writes. Each of those bugs got fixed, and by 1.0.0 I had hardware validation on all three platforms with dumps byte-identical to the original Windows client.

**Make it right (1.1.0 to 1.6.0, Days 1-3).** This is where it got fun. Added safety features (flash chip detection before erase, so you can't accidentally try to write a retail cart). Built the Avalonia GUI. Then kept pushing: live device tracking, auto-dump for archiving a collection, auto-write for dev loops, a proper transaction log. Packaged it as a macOS .app bundle. Added Flatpak for Linux. Set up code signing and notarization. Then I wanted a TUI, which meant extracting the shared Presentation layer, which meant upgrading to .NET 10.

**Make it fast (1.6.1 to 1.9.3, Days 3-4).** With three front-ends sharing a core library and a presentation layer, I could focus on polish and hardening. Trimmed the binaries (the CLI went from 39 MB to 13 MB). Added compiled XAML bindings so trimming was safe. Brought in the full .NET analyzer suite with warnings-as-errors. Added accessibility (screen reader support, live regions, keyboard mnemonics). Fixed TUI layout issues on small terminals. Each of these was a "the feature works, now make it right" pass.

The yak shaves are the interesting part. Every platform-specific bug forced a structural improvement: the macOS dylib embedding failure led to a publish-time check that fails the build if any native library escapes the single-file bundle. The Flatpak Wayland crash led to proper socket grants. None of these were planned. They were friction, and each one left the project stronger.

## Removing Friction as a Development Philosophy

I spent a disproportionate amount of time on CI and the release pipeline relative to the feature work. That was deliberate.

`eng/ci.sh` builds with warnings-as-errors and runs the full test suite. `eng/publish.sh` cross-publishes self-contained binaries for all five targets (linux-x64, linux-arm64, osx-x64, osx-arm64, win-x64) from any host, assembles the macOS .app bundle, and fails if anything looks wrong. The release workflow builds everything, signs what can be signed, packages the Flatpak, extracts changelog notes, and publishes. Push a tag, get a release.

The test suite runs entirely in memory against a fake device that emulates the programmer firmware. No hardware, no sleeps, no clock dependencies. CI takes seconds. The wire-format tests hardcode the original client's exact byte sequences, so they act as a contract: if the protocol drifts, the tests break.

This investment paid for itself immediately. When I was iterating on features with Claude, I could make a change, run `eng/ci.sh`, and know within seconds whether I'd broken something. The layered architecture (Core → Presentation → GUI/TUI/CLI) meant that a feature added to the core was automatically available in all three front-ends, and tested once. I could focus the iteration loops on taste and UX instead of "does this still work."

That's the real leverage of working with an AI coding agent. It's not that the AI writes code faster (it does, but that's table stakes). It's that if you build the right scaffolding around it (tests, CI, a changelog, clear layering), you can iterate at a pace that would be unsustainable solo. The AI handles the volume; you handle the direction and the quality bar.

## What It Does

Three interfaces, same core library:

**GUI** (`flashkit-md-gui`): Plug in the programmer, and the status bar shows when it's detected. Cart details refresh automatically. Read/Write ROM and RAM, plus two batch modes: auto-dump (every cart you insert gets dumped to a folder, named from its header) and auto-write (every flash cart you insert gets reprogrammed). IPS patching built in for both directions.

**TUI** (`flashkit-md-tui`): The same functionality rendered for the terminal. Tab-navigable panels, in-terminal file browser, colored status indicators matching the GUI's palette. Useful over SSH.

**CLI** (`flashkit-md`): `info`, `read-rom`, `write-rom`, `read-ram`, `write-ram`, `bake-save` (programs a save snapshot into flash for SRAM-less carts). Every operation prints CRC32, MD5, and SHA-1 for verification against No-Intro databases.

All builds are self-contained single files. No .NET runtime to install.

## What I'm Not Sure About

The project got some unexpected attention after I [posted about it on X](https://x.com/jfryman/status/2079639142426656922). I tagged krikzz (all credit for the hardware and original client goes to them), they retweeted it, some .NET community folks picked it up, and it hit 10,000 views in 12 hours.

I'm honestly not sure what to make of that. The actual download numbers are modest: a handful so far. I don't know if the attention is because people genuinely need a cross-platform FlashKit client, or because "guy ports niche hardware tool with AI in 5 days" is an interesting story, or some combination. The retro preservation community is small and dedicated, and people have been using VMs and Wine to run krikzz's Windows client for years, so maybe there's real demand.

There's more I could do: sign the binaries for platforms where I haven't set up credentials yet, publish to package managers, submit to Flathub properly. But I want to be careful about scope. This is an enhancement of someone else's work, built with significant AI assistance and some token spend. I'm trying not to overstate the novelty here.

## Try It

The project is [on GitHub](https://github.com/jfryman/flashkit-md-dotnet). Releases include self-contained binaries for Linux (x64/arm64, including Flatpak), macOS (Apple Silicon and Intel), and Windows. If you have a FlashKit MD programmer, try it. If you find bugs, [open an issue](https://github.com/jfryman/flashkit-md-dotnet/issues). And if you don't have the hardware, go [buy one from krikzz](https://krikzz.com/our-products/accessories/flashkitmd.html). They make great stuff.
