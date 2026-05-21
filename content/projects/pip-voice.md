---
title: "pip-voice — An AI Agent on the Phone Line"
date: 2026-05-21
draft: false
weight: 2
description: "A voice agent built on Asterisk that handles real phone calls through a full speech conversation loop."
---

pip-voice is a voice agent that answers a real phone line. Call the number and an autonomous Claude agent picks up — a full speech conversation loop over real telephony, not an IVR tree.

## How it works

An inbound call hits an Asterisk PBX, which routes it through a Stasis application into the agent over the Asterisk REST Interface (ARI) WebSocket. From there the agent runs the conversation: speech in, reasoning, speech out — using the same memory and tools as the rest of the system.

The defining constraint is *immediacy*. Text chat gives an agent room to think and revise. A phone call doesn't — the caller is waiting, and the silence has weight. Designing for that changes the architecture: a call gets a scoped agent built for fast, clear responses, comfortable with imperfection, because the medium allows nothing else.

## Status

The full voice conversation loop works end to end — real DID, real trunk, real calls answered.

*Stack: Asterisk PBX · ARI / WebSocket · Stasis · Claude · Elixir*
