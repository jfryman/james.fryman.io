---
title: "The Decade-Long Bet"
date: 2026-05-19
draft: true
tags: ["chatops", "agentic-computing", "career", "automation"]
description: "I saw something at GitHub in 2012 that changed how I think about work. I've been trying to replicate it ever since."
---

I saw something at GitHub in 2012 that changed how I think about work. I've been trying to replicate it ever since.

<!--more-->

## The Room

[JAMES: Describe what it was like walking into GitHub for the first time. What did the operations floor look like? What was the energy? What was Hubot doing when you first saw it in action? This is the hook, make it visceral.]

What I saw wasn't just a tool. It was a way of working. Engineers talking to a bot in a chat room, and the bot was deploying code, checking monitoring, running diagnostics. Not because someone had decided "we should automate things" in a quarterly planning meeting. Because it was *natural*. The chat room was where work happened, so the automation lived there too.

The computer was responding to the human in the human's space, instead of the other way around.

That's the moment that hasn't left my head in fourteen years.

## Taking It With Me

When I left GitHub in 2014, I took that idea with me like a coal from a campfire. I was convinced that if you could get this right, if you could make automation meet people where they already worked, you could fundamentally change how organizations operated.

At StackStorm, we tried to commercialize it. Built the first enterprise ChatOps product. I gave talks on stages around the world, collaborated on "ChatOps for Dummies" with Wiley Publishing, traveled to conferences evangelizing event-driven automation. The technology worked. We could demo it, ship it, deploy it on-premise.

[JAMES: What was the StackStorm experience really like? The highs of building something you believed in, and the reality of a startup that ran out of runway. What did it feel like when you knew it wasn't going to make it? This is an important beat because it shows you kept going anyway.]

Then Auth0. NationBuilder. Puppet. Ripple. Salesforce. At every company, I tried to bring some version of that philosophy. Humans and automation in the same space. Computers that respond to people instead of demanding that people learn the computer's language.

Every time, the technology worked. The cultural barriers didn't budge.

## The Wall

The problem was never technical. It was always organizational.

[JAMES: Pick two or three specific examples of cultural resistance you hit. Not naming companies negatively, just describing the pattern. Things like: "We built the automation, the demo was great, and then nobody used it because the team leads didn't trust something they couldn't review in a pull request." Or whatever the actual pattern was. Be specific enough to be credible, general enough to not burn bridges.]

Organizations wanted to talk about automation. They'd bring me in, get excited about the vision, fund the project. And then somewhere between the proof of concept and production adoption, the same thing would happen: the people who had to change how they worked didn't want to change how they worked.

I'm not bitter about this. I understand it. Changing workflows is hard. Trust is earned slowly. And for most of the 2010s, the automation wasn't smart enough to earn that trust. A bot that can deploy code is useful. A bot that can understand context, remember past incidents, and make judgment calls? That didn't exist yet.

## The Shift

Something changed around 2024-2025. Large language models went from "interesting research" to "actually useful in production." Not because of hype. Because the models got good enough that the automation could finally do what I'd always wanted it to: understand context, maintain state, and respond intelligently in human spaces.

The barriers I'd been hitting for a decade started eroding. Not because organizations got braver, but because the technology caught up to the vision.

I started building what I'd always wanted to build.

## What It Looks Like Now

Today I run multiple autonomous AI agents in my home infrastructure. They have persistent memory across sessions. They have tools: shell access, Kubernetes, Vault, GitLab, IRC, voice interfaces. They have scheduled time to work on their own projects. They coordinate with each other.

This isn't a weekend hack or a demo for a conference talk. It's how I work every day. When I need to check infrastructure, I don't SSH into a server and run commands. I tell an agent what I need, and it figures out how to get it done. When something breaks at 2 AM, an agent notices, diagnoses the problem, and either fixes it or wakes me up with context about what's wrong.

[JAMES: Add a concrete example here. Something specific that happened recently where the agentic setup saved you time or caught something you would have missed. The more specific and mundane, the better. Not "it deployed my application," but something like "it noticed my Vault token was expiring and rotated it before anything broke" or whatever actually happened.]

It's ChatOps. Just... fourteen years later, with models that can actually think.

## The Bet

Here's what I believe: the pattern I saw at GitHub in 2012 was right. Humans and automation belong in the same space. The computer should respond to the human, not the other way around.

For a decade, the technology wasn't ready. The culture wasn't ready. I kept carrying the idea from job to job, getting a little further each time, hitting the same walls.

Now the technology is ready. The capital is flowing. Companies are investing in agentic computing not because it's trendy, but because the models finally justify it.

I don't know if I was early or just stubborn. Probably both. But I've been making this bet for fourteen years, and I think it's finally about to pay off.

[JAMES: How do you want to close this? What's the forward-looking statement? Something about where you want to take this next, what you want to build, where you want to be. This is the "I'm looking for the right place to do this work" beat without being explicitly a job-search post.]

---

*This post reflects a decade of carrying an idea through multiple companies and roles. The technical details are real; the opinions are mine. I used Claude to help refine the structure, because of course I did.*
