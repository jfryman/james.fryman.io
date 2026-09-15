---
title: "Spirit in the Sky"
date: 2026-09-15
draft: false
tags: ["making", "ai", "family", "laser", "3d-printing", "grief"]
description: "My father-in-law's funeral is Saturday. His wife asked me to engrave a bullet casing for every guest. Here's how I'm making 150 of them."
---

My father-in-law Allen passed away last week after a cardiac event. His funeral is this Saturday.

After he died, my mother-in-law asked if I could engrave something for the service. I said yes before I fully understood what I was agreeing to. I was picturing a wooden urn, maybe some text on a keepsake box. Something I could knock out on the CNC in an evening.

What she actually wanted was an engraved .30-06 bullet casing for every guest at the funeral. Allen loved guns, and she wanted everyone who showed up to take home a piece of brass with his name on it.

The other side was my wife's idea: "Spirit in the Sky." It's the song being played at the end of his funeral, and the way he wanted to be remembered if he left before everyone else did.

So now I had a manufacturing problem with a hard deadline and no room to slip it.

## The First Attempt

I have a Carvera Makera CNC with a 4th axis that should, in theory, handle round stock like a bullet casing. In practice, I couldn't get Makera Studio to do a simple engraving. The software really wants to carve; it's in the name. I probably could have generated a proper toolpath in Fusion 360, but "probably" and "Saturday" don't go well together. Too many unknowns, not enough days. I pivoted.

## The Laser Problem

My other machine is an xTool P2, a 55W CO2 laser. Faster, more predictable for text work. One problem: brass is reflective. I set a bare casing in a bed of rice to hold it steady and fired the laser. Nothing. The beam bounced right off. Brass just laughs at a CO2 wavelength.

I ordered laser marking spray. It arrived Monday and I immediately tested it on a casing. It worked. I could put marks on brass. Now I needed to do it 150 times, consistently, on a deadline.

## The Handwriting

My wife spent time going through Allen's old books and journals, looking for samples of his handwriting. She found his signature and was able to extract a clean copy of his name in his own hand. For "Spirit in the Sky," she worked from fragments to approximate what it would have looked like if he'd written it himself.

## The Jig

Engraving one bullet at a time in a rice bed might work for five or ten. Not for 150 with a Saturday deadline. I needed a fixture: something that holds multiple casings at a known height, at the right angle, so I could load, engrave, flip, engrave, and swap batches without re-registering the laser every time.

Here's where things got interesting. I sat down with Claude and described what I needed: a jig for .30-06 casings, parametric so I could adjust fit, something that corrects for the tapered case body so the marking surface stays level under the laser. I described the conditions I expected, the machines I had, how I wanted to validate success. I pointed it at a 3D model of the cartridge and let it work.

It one-shotted the design.

Not "it got close and I iterated." It produced a parametric OpenSCAD fixture with a two-part design (base plate and swappable carriers), a tilt correction that cancels the .30-06 body taper to six microns of flatness, keyed pockets so carriers can only seat one way, and a verification script that intersects the real cartridge mesh against the cradle to prove fit. It wrote acceptance checks, setup procedures, batch workflow documentation. It even engraved "IN MEMORY OF ALLEN AKIN" and "SPIRIT IN THE SKY" into the base plate flanges.

The [repo is public](https://github.com/jfryman/30-06-bullet-jig) if you want to see the whole thing, including the lode (the structured context I gave the agent to work autonomously). The lode is the interesting part from an AI perspective: it's how you give an agent enough domain knowledge to make real engineering decisions without hand-holding every parameter.

## Happy Accidents

The carrier cradles have a deliberate bit of clearance (0.35mm radial) so the casings drop in and lift out easily. A side effect: under the force of the laser, each casing walks slightly in its cradle during engraving. Every marking comes out just a little different. Tiny shifts in position, small variations in how the text lands on the curve.

Bob Ross would call these happy accidents. I think Allen would have liked them. No two are identical. They're all his name, in his handwriting, but each one is its own thing.

## The Math

At 28 casings per load (four carriers in the large base), I can process about 40 casings per hour. Two sides per casing, with a carrier swap in between. The casings arrive Wednesday or Thursday. The funeral is Saturday. The math works, but just barely. There's no buffer for a printer failure or a bad batch of spray.

## What I'm Thinking About

I'm sad to have lost Allen. I'm glad the skills I've accumulated (CNC, laser, 3D printing, and yes, working with AI agents) are being put to use for something that matters to the people I love. This isn't a product. It's not a business. It's a guy in his garage with a laser and a deadline, trying to honor a request from his mother-in-law for her husband's funeral.

The AI didn't grieve with me. It didn't know Allen. But it turned what would have been days of manual CAD work and trial-and-error fixturing into a single focused session. Without the jig, I'd be doing the rice method at scale, one casing at a time, hoping each one came out close enough. I'm not sure I could have finished in time. With the jig, I'm running batches. I have consistency. I have a margin, even if it's thin.

RIP Allen.
