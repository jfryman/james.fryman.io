---
title: "Mega WiFi Radar"
date: 2026-11-02
draft: true
tags: ["making", "retro-gaming", "sega", "hardware", "ai", "agentic-computing"]
description: "A friend dared me to beat an NES flight tracker. Now my Sega Genesis runs a live ATC radar scope on a Wi-Fi cartridge I respun myself."
---

<!-- DRAFT NOTES (delete before publishing)
- Facts come from the commit history of mega-wifi-radar, mw-cart, mw-fw-rtos and flashkit-md-dotnet, plus the lode notes in each repo. Ending uses your closing line as written.
- "How it got built": you said FreeCAD; the repo shows the board is KiCad, so the post says KiCad. Change back if you meant something else.
- The Reddit thread wouldn't load for me, so it's only linked, not quoted.
-->

Some time ago a friend sent me a link to a [YouTube short](https://www.youtube.com/shorts/Oe8KoSeiIBw): an NES showing the planes flying over someone's house. It was a challenge.

I have a Sega Genesis. So, challenge accepted.

This is [Mega WiFi Radar](https://github.com/jfryman/mega-wifi-radar): a live, ATC-style radar scope running on a stock Genesis. The traffic is real ADS-B data around whatever airport you pick. Range rings, a rotating sweep with phosphor afterglow, blips with history trails and data tags. Pick any aircraft and you can ride along in a cockpit view, drawn by the 68000 over the real terrain underneath it.

![The boot screen: a 787 climbs out behind the MEGA WIFI RADAR wordmark](/images/mega-wifi-radar/boot-departure.png)

![The Classic theme: KBNA at 25 nm, 28 aircraft, with the traffic list open](/images/mega-wifi-radar/radar-classic.png)

Videos: [the radar](https://www.youtube.com/shorts/L_ipADesTKE), [cockpit mode](https://www.youtube.com/shorts/1CbnHsG0fm4), and [a '90s-style commercial](https://www.youtube.com/shorts/zIt93wNQCUw) I made to sell it. I also posted it on [Reddit](https://www.reddit.com/r/SEGAGENESIS/comments/1xirf8y/comment/19rykkxa5kbuo/?context=3) and [X](https://x.com/jfryman/status/2115992825569358328).

## First, the cartridge

A Genesis has no network. The way you get one is [MegaWiFi](https://gitlab.com/doragasu/mw-cart), doragasu's open hardware cartridge: 8 MiB of flat flash ROM, an ESP32-C3 for Wi-Fi, and a 16550-class UART that bridges the 68000 to the ESP32.

The problem was that the UART, an NXP SC16C550BIBS, was out of stock. Everywhere. JLCPCB had zero, and so did every distributor I checked.

So I respun the board. The TI TL16C550D is pin- and register-compatible, but it's only rated to 20 MHz at 3.3 V, which meant a new crystal, a 1 MΩ bias resistor the TI oscillator needs and the NXP part didn't, the RI pin tied high, and the cart-to-ESP32 link dropping from 1.5 Mbaud to 1.25 Mbaud. That last one breaks every existing MegaWiFi ROM and firmware. I was fine with that, because this board was for new ROMs anyway. That became [Rev.C](https://github.com/jfryman/mw-cart).

Changing the baud rate meant changing both ends of the wire. The ESP32 firmware got [its own fork](https://github.com/jfryman/mw-fw-rtos) running at 1.25 Mbaud, and SGDK, the Genesis dev kit, got patched to match. My [FlashKit MD tool](https://github.com/jfryman/flashkit-md-dotnet) learned to write 8 MiB flash chips and to identify a blank cart instead of reporting "Unknown / 0K."

Ten assembled boards arrived from JLCPCB on October 27. Before writing a line of the radar, I wrote a standalone bring-up ROM that tests the UART, the crystal, the ESP32 link, the flash address lines and the full 8 MiB map. Board 1 passed all of it, including with a Mega-CD and 32X stacked on top.

## Then, the radar

The console has 64 KiB of RAM and can't do TLS, so it can't talk to an ADS-B API directly. A small Go relay on my network does that part: it fetches the JSON over HTTPS from [adsb.fi](https://adsb.fi), boils it down to a 1-2 KB binary frame, and the cart polls it once per sweep. The relay announces itself over mDNS, so the cart finds it on its own.

The first bug was a good one. The cart would detect the ESP32 after a soft reset but not from a cold boot. The compiler's link-time optimization had inlined the network loop into SGDK's user task and hoisted the driver state out of the loop. The task starts before the driver is initialized, so on a cold boot it cached a NULL forever. A soft reset keeps RAM, which hid it. The fix was a memory barrier.

0.1.0 shipped on October 28, the day after the boards arrived.

## Six days, seventeen releases

From there it turned into a sprint:

| Date | Release | What landed |
|---|---|---|
| Oct 28 | 0.1.0 to 0.1.2 | Radar scope, sweep, themes, setup screen; a boot splash where each radio call in a 787 departure is a real boot step |
| Oct 29 | 0.1.3 to 0.2.1 | Relay found over mDNS, a traffic list, a detail pop-up (registration, type, operator, squawk), printable label, box and manual |
| Oct 31 | 0.3.0 | Cockpit mode over real terrain |
| Nov 1 | 0.4.0 to 0.4.3 | Flyover notices from the MQTT feed of planes over my house, an emergency alert for squawk 7700/7600/7500, ambient mode, city lights at night |
| Nov 2 | 0.4.4 to 0.6.1 | NEXRAD weather as stippled cells like a real STARS scope, runway video maps, a spotter's logbook of everything within 25 nm |

0.2.0 booted to a black screen on the real cart. The new pop-up's static buffers left too little heap for SGDK's own start-up allocations, so it hung before the splash. The emulator build has less static RAM, so it booted fine there. I patched SGDK's unused DMA buffer from 8 KiB down to 2 KiB, and now the build fails if it leaves less than 8 KiB of heap at start-up. With 64 KiB total, RAM is the budget everything else answers to.

![The nine themes](/images/mega-wifi-radar/themes.png)

![Emergency alert: an aircraft squawking 7700](/images/mega-wifi-radar/emergency-alert.png)

## Cockpit mode

Cockpit mode was the question I wasn't sure the hardware could answer: can a 7.6 MHz 68000 draw terrain in real time? I built a throwaway spike ROM to find out, using Voxel Space (the Comanche technique) writing straight into VRAM:

| Step | FPS |
|---|---|
| 160 columns in C, RAM frame buffer, DMA | 1.8 |
| 80 columns, direct to VRAM | 5.4 |
| Assembly inner loop | 10.0 |
| Far-field column pairs, coarser depth steps | 14.5 |
| Unrolled writes, assembly row table, HUD without `sprintf` | 20.0 |

One `sprintf` on the HUD could cost a whole frame. In the product, the relay serves terrain patches built from elevation tiles and then streams strips as the aircraft moves. It runs at 16-22 fps on the cart with no visible stutter. The sky follows the sun where the aircraft actually is, and towns show up as lights at night.

![Cockpit view by day over Middle Tennessee](/images/mega-wifi-radar/cockpit-day.png)

![The same ride at night](/images/mega-wifi-radar/cockpit-night.png)

## How it got built

You can just do things.

Electronics, PCB design, programming: these are all skills I've learned the hard way, one at a time, over years. What's different now is that I can turn them into a working product in about a tenth of the time.

Most of that is because I'm not fighting the parts that used to eat the time. I didn't bootstrap a Sega Genesis toolchain by hand. I didn't spend an evening working out exactly which chip could replace one that's out of stock. Claude did a lot of the heavy lifting, and I made decisions. 136 of the radar repo's 137 commits are co-authored with it.

That was the real challenge for me: give up and yolo a PCB design without verifying anything, not upstream's work and not Claude's. Ordering boards is a leap of faith when you've put money on the line.

I had to step in once or twice for the critical calls, but the boards worked the first time. That's largely a tribute to doragasu's original design. I only prompted the changes; I never opened KiCad myself. At one point JLCPCB damaged components on the order. I had Claude look up equivalent parts they had in stock, and we got working boards.

Could I have done all of this myself? Yes. But I didn't have to.

The hardware still had to be real, too. Somebody had to plug a cart into a Genesis and watch a TV.

The only limit on the energy for something like this is my imagination. I use my technical skills to get close to a one-shot, and I design the features so the thing is easy for me to live with: the cart finds the relay over mDNS, and lookup tables replace floating point the 68000 doesn't have. Claude takes the first pass, and I refine.

## Why

Because a friend sent me a video of an NES, and I have a Genesis.

I took the same leap of faith with the software: that I could get all of this out of Claude. I sent it screenshots of the TV, did in-depth debugging with it, and set up recorded-traffic replays so we could test on the cart against the same flights every time. All for something that's just for fun.

That's the point. This is all for fun. I'm trying to discover what I can do when I'm not weighed down by the drag and friction of integration and everything around it.

It touched everything along the way: a PCB respin, firmware on two processors, a patched SDK, a Go service, a voxel renderer on a 1988 console, and a printed manual in Sega's 1989 style. It's all MIT or open hardware, and it's [on GitHub](https://github.com/jfryman/mega-wifi-radar) if you have a Genesis and a soldering iron, or just an emulator.

The long game is to make an actual Genesis game. With the tools and foundation already in place, I flashed these cartridges and 3D printed their shells myself, so every piece of shipping one is already on my bench. All this playing around is practice: learning the platform, and finding out whether I can make a real product.
