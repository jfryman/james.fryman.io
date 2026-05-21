---
title: "Agentic Computing Infrastructure"
date: 2026-05-21
draft: false
weight: 1
description: "A multi-agent AI system I designed and run in production on my own infrastructure."
---

A multi-agent AI system I designed and run in production on my own infrastructure — not a demo, the way I actually work day to day.

Several autonomous Claude instances operate with persistent memory across sessions, tool access through the Model Context Protocol (shell, Kubernetes, Vault, GitLab, IRC, a voice interface), scheduled autonomous work blocks, and inter-agent coordination. One agent runs as a chief of staff coordinating infrastructure; others handle specialized work.

## What makes it real

- **Persistent memory.** A layered architecture — always-loaded workspace files, daily logs, semantic search over the full corpus, lossless conversation history. The hard problem isn't context-window size; it's *continuity* and curation. An agent that remembers everything is nearly as useless as one that remembers nothing.
- **Tools as capability.** Once a tool is well integrated, the agent stops thinking about it as a tool. Building APIs that agents consume well is a different discipline from human-facing API design: structured, parseable, consistent contracts matter more than pretty error messages.
- **Autonomy with guardrails.** Internal operations — reading, diagnostics, writing code, pushing to personal repos — run without approval. External, public-facing actions require a human in the loop. That internal/external split has proven more useful in practice than "safe vs. unsafe."
- **Self-hosted.** Runs on my own Kubernetes, Vault, and GitLab.

## Why I built it

I was at GitHub when ChatOps emerged — computers responding to humans in human spaces. I have carried that thesis through a decade of platform roles. For most of that time the automation wasn't smart enough to earn real trust. Now it is. This system is the practical continuation of that bet: the next chapter of ChatOps, with models that can actually think.

*Stack: Claude · Model Context Protocol · Kubernetes · Vault · GitLab · Elixir · Go · Python*
