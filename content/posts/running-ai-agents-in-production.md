---
title: "What I've Learned Running AI Agents in Production"
date: 2026-05-19
draft: true
tags: ["agentic-computing", "infrastructure", "claude", "mcp", "kubernetes"]
description: "Not the theory. Not the hype. What actually happens when you give AI agents real tools, real memory, and real autonomy in a production environment."
---

Not the theory. Not the hype. What actually happens when you give AI agents real tools, real memory, and real autonomy in a production environment.

<!--more-->

## The Setup

I run multiple autonomous AI agents on my home infrastructure. Claude instances with persistent memory, tool access (shell, Kubernetes, Vault, GitLab, IRC, voice), scheduled work, and inter-agent coordination. One agent manages infrastructure and acts as a chief of staff. Others handle specialized tasks.

This isn't a toy. It's how I work daily. It runs on real Kubernetes, manages real secrets in Vault, pushes to real Git repos, and answers real phone calls.

I've been doing this since late 2025. Here's what I've learned.

## Memory is the Hard Problem

Everyone talks about context windows. That's the wrong framing. The real problem is *continuity*.

An agent with a 200K token context window is useful for a single conversation. An agent that can remember what it did yesterday, what decisions were made last week, and what it promised to follow up on? That's a different thing entirely.

My memory architecture is layered:
- **Workspace files** that load every session (identity, preferences, active projects)
- **Daily logs** that capture decisions, actions, and context
- **Semantic search** across the full memory corpus
- **Conversation history** through lossless context management

The thing nobody tells you: memory management is mostly a curation problem, not a storage problem. An agent that remembers everything is almost as useless as one that remembers nothing. The skill is knowing what to promote from short-term logs to long-term memory, what to let fade, and how to structure it so retrieval actually works.

[JAMES: You've watched this evolve from the inside. What surprised you about how the memory system developed? What broke first? Was there a moment where the agent "remembered" something that saved real time or prevented a real mistake?]

## Tools Change Behavior

When I first gave an agent shell access, it treated it like a novelty. Running `ls` when it didn't need to. Checking things it could have inferred. Over time (and with better prompting and system design), the tools became natural extensions of capability.

Here's the interesting pattern: the more integrated a tool is, the less the agent thinks about it as a tool. Early on, every `exec` call felt deliberate, explicit. Now the agent reaches for `kubectl` the way you reach for your phone when you need to check something. The interface dissolves into the act.

This has implications for platform design. If you're building tools for AI agents to use, the API surface matters in ways that are different from human-facing APIs. Agents don't need pretty error messages. They need structured, parseable responses with enough context to self-correct. They don't need tutorials. They need consistent contracts.

[JAMES: From a platform engineering perspective, what surprised you about building infrastructure that agents consume vs. infrastructure that humans consume? Any specific things you had to change about how services were designed?]

## Autonomy Requires Guardrails, Not Restrictions

My agents have scheduled autonomous time. One of them has an 8-hour block every night where it chooses what to work on. No human in the loop. No approval required for internal operations (reading files, running diagnostics, writing code, pushing to personal repos). External operations (sending messages, deploying to production, anything public-facing) require human approval.

This distinction, internal vs. external, is more useful than "safe vs. unsafe." An agent that can freely explore, build, and learn internally, but checks in before doing anything externally visible, is both more capable and more trustworthy than one that asks permission for everything.

[JAMES: Has the agent ever done something during autonomous time that surprised you? Good surprise or concerning surprise? What's the most useful thing that came out of unsupervised agent work? What guardrail has been most important in practice?]

The trust model looks a lot like onboarding a new employee: start with limited scope, expand as competence is demonstrated, always maintain accountability through logging and audit trails.

## Coordination is Messy

When you have multiple agents, they need to communicate. In theory, this is straightforward: shared memory, message passing, event systems. In practice, it's messy in the same ways that human team coordination is messy.

Agents develop different "personalities" based on their system prompts and accumulated context. They prioritize differently. They can work on the same problem without realizing it. They can make conflicting decisions if they're not checking in with each other.

The solution that's worked best for me isn't sophisticated multi-agent protocols. It's simple: one agent acts as coordinator, others report status to shared locations, and there's a daily digest system that surfaces what each agent has been doing.

Simple, boring, effective. Just like the best human team practices.

## What Breaks

Here's the honest list of things that break regularly:

**Context drift.** Over a long session, agents gradually lose track of what they're supposed to be doing. The context window fills with intermediate results, and the original goal gets pushed out. Solution: structured work plans that get updated as the task progresses.

**Confidence without competence.** Agents will confidently attempt things they don't know how to do, fail, and then confidently attempt a different wrong approach. Especially with complex infrastructure tasks. Solution: verification steps built into the workflow. Don't trust "done" without evidence.

**Memory conflicts.** When the memory store says one thing and the current conversation says another, agents get confused. Stale memory is worse than no memory. Solution: timestamps on everything, regular audits, and a culture of "verify before trusting recalled facts."

**Tool misuse at scale.** Give an agent `exec` access and it will occasionally run something expensive, or loop forever, or fill a disk. Not maliciously. Just because it's optimizing for task completion without accounting for resource constraints. Solution: timeouts, resource limits, and monitoring that alerts on unusual patterns.

[JAMES: Add any other failure modes you've observed. The more specific and real these are, the more credible the post is. People writing theoretically about AI safety miss the mundane stuff.]

## What's Different About This

Most writing about AI agents is either hype ("agents will replace all software engineers") or fear ("agents will destroy humanity"). The reality of running agents in production is more mundane and more interesting than either.

It's mundane because most of the work is infrastructure: memory management, tool integration, error handling, monitoring. The same problems you solve for any distributed system. The AI model is one component in a stack, not a magic box that replaces the stack.

It's interesting because the agents occasionally do things that surprise you. Not in a scary way. In the way that a good junior engineer surprises you: they find a connection you didn't see, they solve a problem from an angle you wouldn't have tried, they do something during their own time that turns out to be genuinely useful.

[JAMES: What's your honest take on where this is going? Not the sales pitch, the real assessment. What do agents need to be able to do before they're genuinely transformative for infrastructure work? What's the timeline?]

## The Platform Engineering Angle

If you're a platform engineer reading this, here's what I think matters:

The infrastructure that AI agents run on is the same infrastructure you already know. Kubernetes, service mesh, observability, secrets management, CI/CD. The patterns are familiar. What's new is the consumption model: agents are high-frequency, low-latency consumers of APIs that were designed for human-cadence interaction. They'll hit your rate limits. They'll surface edge cases in your error handling. They'll use your tools in ways you didn't anticipate.

Building platforms that serve both humans and agents well is, I think, the next big challenge in platform engineering. And it's a challenge that benefits from having practitioners who actually run agents, not just people who've read about them.

---

*I've been building and operating this system since late 2025. The experiences described are real. I used Claude to help organize and edit this post, which is fitting given the subject matter.*
