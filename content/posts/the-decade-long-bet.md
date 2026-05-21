---
title: "The Decade-Long Bet"
date: 2026-05-19
draft: false
tags: ["chatops", "agentic-computing", "career", "automation"]
description: "I saw something at GitHub in 2012 that changed how I think about work. I've been trying to replicate it ever since."
---

I saw something at GitHub in 2012 that changed how I think about work. I've been trying to replicate it ever since.

<!--more-->

## The Room

I walked onto the operations floor at GitHub and it hit me like lightning.

What I was looking at was a shared console. A shared command line. Engineers were handling an outage asynchronously in a chat room, and everyone was accelerated because they could query the same data, see the same data, and talk about the same data. Someone checked the state of a service. The output appeared in the channel. Someone else saw it and started debugging. A third person deployed a fix. The whole thing took maybe fifteen minutes, and nobody had to get on a phone call.

That sounds unremarkable now. In 2012 it was a revelation.

Up to that point, coordination during incidents meant phone bridges. Someone would open a line, twenty people would join, and the next hour was a mess: VPs interjecting to ask for status, engineers trying to debug while someone talked over them, disagreements about naming standards and how to call things out, plus all the noise associated with sitting on voice calls for long periods of time. Most of the effort wasn't even debugging. It was getting to the data. What's broken? Where do I look? What am I seeing?

The chat room inverted that. Hubot sat in the channel and responded to commands. Anyone could query the same systems and see the same output. The value prop for the human was in *debugging*, not in figuring out what the data was, how to get to it, or what it was saying. The computer was responding to the human in the human's space, instead of the other way around.

That's the moment that hasn't left my head in fourteen years.

## Taking It With Me

When I left GitHub in 2014, I took that idea with me like a coal from a campfire. I was convinced that if you could get this right, if you could make automation meet people where they already worked, you could fundamentally change how organizations operated.

The folks at StackStorm had approached me before I left. They had an event-driven automation engine, and they thought my ChatOps talks were the missing piece: bringing the humans into the conversation and into the loop. I was beyond ecstatic. Here was a team, which I thought had money, ready to go build the thing I most believed in.

I'm still very proud of what we shipped. StackStorm became the engine behind what Netflix called the Chaos Army. It's apparently still in production at Salesforce today under the name Warden AI. It's part of the Linux Foundation. The technology worked. The technology was never the problem.

The problem was that it was 2014, and nobody cared yet.

I knew it probably wasn't going to make it after our big moment. We announced that Netflix was a partner, and the response was silence. Not hostility. Indifference. The CEO kept going to investor meetings, kept coming back without the money, and eventually just couldn't pay us. It was upsetting, to say the least. Not because we'd failed to build something good, but because we'd built something good and it didn't matter enough.

Then Auth0. NationBuilder. Puppet. Ripple. Salesforce. At every company, I tried to bring some version of that philosophy. Humans and automation in the same space. Computers that respond to people instead of demanding that people learn the computer's language.

Every time, the technology worked. The cultural barriers didn't budge.

## The Wall

The problem with ChatOps was never a single thing. It was three things, layered on top of each other.

**The language problem.** ChatOps captures the language of a business and models it into things that can be called. At GitHub, this happened organically. Engineers built regular expressions for the shared command interface, and a custom chat client helped people discover what was available. Then Slack replaced that client, and the discovery layer vanished. At StackStorm and every other place I worked, trying to capture what that vocabulary looked like was possible but difficult, even for one organization, let alone as a generic product. Every company talks about its infrastructure differently, and the mapping from intent to executable action was always handcrafted.

**The batteries problem.** People wanted to automate. They just didn't know where to start. The guidance was always "start small, build tools that help you gain visibility, then grow into things that take action." But even building visibility tools was hard, because vendors fifteen years ago rarely had APIs you could query. You ended up building something homegrown, in-house, writing shims to query data you already had. That's extra development time, and as an ops organization, getting business approval for that kind of work was almost impossible. Half the places I worked had some internal tooling. The other half had nothing.

**The security problem.** How do you authorize a task that a bot executes? How do you ensure four eyes on a destructive action? The principle of least privilege still matters. We ran into this at StackStorm. Others in the space tried a more security-first approach and still struggled with it. This was always the objection that killed adoption after the demo. It looked great, until someone asked about access control.

I'm not bitter about any of this. I understand it. Changing workflows is hard. Trust is earned slowly. And for most of the 2010s, the automation wasn't smart enough to earn that trust.

## The Shift

Every one of those walls was a symptom of the same underlying gap: the automation wasn't intelligent enough.

It couldn't infer intent, so you had to hand-craft the language mapping. It couldn't bootstrap itself, so you needed batteries included from day one. It couldn't reason about risk, so you needed rigid permission models that nobody wanted to maintain.

Large language models close that gap. Not perfectly, not yet, but enough that the math has changed.

The language problem dissolves when a model can infer intent from natural conversation instead of matching a regex. The batteries problem shrinks when an agent can read documentation, inspect an API, and write its own integration. The security problem is still real, but it becomes a tractable engineering challenge: guardrails, approval flows, blast-radius constraints, audit trails. Things we know how to build.

## What It Looks Like Now

Today I run multiple autonomous AI agents in my home infrastructure. They have persistent memory across sessions. They have tools: shell access, Kubernetes, Vault, GitLab, IRC, voice interfaces. They have scheduled time to work on their own projects. They coordinate with each other.

This isn't a weekend hack or a demo for a conference talk. It's how I work every day. When I need to check infrastructure, I don't SSH into a server and run commands. I tell an agent what I need, and it figures out how to get it done. When something breaks at 2 AM, an agent notices, diagnoses the problem, and either fixes it or wakes me up with context about what's wrong.

One of them answers a real phone line. Another monitors my Kubernetes cluster, watches for expiring credentials, and rotates them before anything breaks. They file issues in my backlog, search for job postings that match my profile, and draft content for my blog. Right now, as I write this, one of them is tightening up a resume for me while another researches open roles at defense companies.

It's ChatOps. Just fourteen years later, with models that can actually think.

## The Bet

Here's what I believe: we're close to self-improving loops, if we're not already there.

The models are remarkably good at inferring intent from conversation and then performing tool calls. That's half the battle: formalizing how to capture a task to be done. The other half is the set of capabilities you can include, and that's not finished. MCP is a step in the right direction, but blast radius and security are still open questions.

What's changed is the appetite. More people want to try this than ever before, right, wrong, or indifferent. It's being pushed. If I can get an AI agent to understand what I'm trying to do and iterate on scripts to get there, that's essentially what happened at GitHub in 2012, but in tighter circles with guardrails and feedback loops. Agents can self-improve, and that's what I'm interested in.

I'm curious where this breaks. Token economics at scale. Security models that hold up under adversarial pressure. Safety constraints that don't make the system useless. I've been running my own harnesses long enough to know they work. I've also been running them long enough to feel where I'm outgrowing the generic approach, and to start thinking about what purpose-built harnesses look like.

The pattern I saw at GitHub in 2012 was right. Humans and automation belong in the same space. The computer should respond to the human, not the other way around. For a decade, the technology wasn't ready. I kept carrying the idea from job to job, getting a little further each time, hitting the same walls. Now the technology is ready, and I want to be in the room where the next version gets built.

I don't know if I was early or just stubborn. Probably both.

---

*This post reflects a decade of carrying an idea through multiple companies and roles. The technical details are real; the opinions are mine. I used Claude to help refine the structure, because of course I did.*
