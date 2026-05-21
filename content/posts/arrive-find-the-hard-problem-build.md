---
title: "Arrive, Find the Hard Problem, Build"
date: 2026-05-19
draft: true
tags: ["platform-engineering", "career", "leadership", "teams"]
description: "The same pattern, across eight companies and twenty years. What I've learned about building platform teams and shipping infrastructure."
---

I've been a platform engineer for twenty years across eight companies. The pattern is always the same: arrive, find the hard problem, build the thing, scale it.

<!--more-->

## The Pattern

It starts the same way every time.

You walk into a new company. The infrastructure is in some state between "it works, don't touch it" and "we know this is bad but nobody has time to fix it." There's a backlog of technical debt that everyone acknowledges and nobody prioritizes. The on-call rotation is either nonexistent or traumatic. The deployment pipeline is held together with scripts that one person wrote and nobody else understands.

Your job is to figure out which of the twenty problems you could work on is the one that actually matters. Not the most interesting problem. Not the problem your boss thinks is the problem. The one that, if you solve it, unlocks everything else.

[JAMES: What's your process for finding the real problem? Do you have a framework, or is it more intuitive? What does the first month at a new company look like for you? Specific examples from Ripple, Salesforce, or GitHub would be powerful here.]

## Ripple: Writing the Business Case

At Ripple, there was no Platform Engineering team. There was a three-person ops group doing their best with growing infrastructure across multiple countries. Kubernetes adoption was ad hoc. Services were deployed differently depending on who built them and when.

The hard problem wasn't "we need Kubernetes." Everyone knew that. The hard problem was that nobody had made the case for investing in a platform team. The three-person ops group was keeping the lights on, and the organization was comfortable enough with that to not change anything.

So I wrote the business case. Not a technical document about Kubernetes migration. A business document about cost reduction, developer velocity, and operational risk.

[JAMES: What was in that business case? What numbers did you use? How did you frame it to non-technical leadership? This is a really valuable thing to share because most engineers don't know how to write a business case for infrastructure investment.]

It got funded. I hired six engineers. We built Platform v2: a comprehensive Kubernetes migration across US, Iceland, India, and UK infrastructure. Custom operators using operator-sdk. A training program delivered in four countries.

The technical work was hard. But the hardest part was the thirty-page document that made it possible.

## Salesforce: When the Product Outgrows You

Code Builder started as a runtime provisioning problem. Salesforce needed a way to run VS Code instances for developers. I was the IC who figured out how to make the compute layer work.

[JAMES: What was Code Builder like in the very early days? What was the first prototype like? What did it feel like to go from "here's how we could do this" to actually getting it funded and staffed?]

Then the team grew. Through a combination of delivery and attrition (the people who should have led weren't delivering, and they left), I ended up leading twelve engineers across three teams. The product went from internal tool to GA to becoming the runtime for Salesforce's AI product, Vibes.

The Kubernetes Operator I built in Go manages the compute session lifecycle: 1,200 to 1,400 concurrent sessions daily, peaking at 10,000 to 20,000 during Dreamforce. That's a real number serving real Salesforce customers.

[JAMES: What was the Dreamforce scaling experience like? Any war stories from peak load? What about the Elixir adoption, how did that happen and what resistance did you face?]

The pattern held: arrive, find the hard problem (runtime provisioning), build the thing (custom K8s operator), scale it (GA + Vibes runtime). But this time the pattern included something I hadn't done before at this scale: evolving from IC to team lead through execution rather than promotion.

## Auth0: Building SRE from Nothing

When I joined Auth0, the operations team was two people. Two people keeping a growing identity platform running. No on-call rotation. No SRE practice. No structured incident response.

The hard problem wasn't any single infrastructure issue. It was that there was no *organization* around infrastructure. Everything was reactive. The two ops engineers were heroes, and hero culture is a scaling failure waiting to happen.

I built the SRE function. Four workstreams: Support/Growth, Stability/Maintenance, Common Tools, CI/CD. Implemented an on-call program with rotation, escalation, and postmortem culture. Turned reactive firefighting into proactive engineering.

[JAMES: What was the most resistant part of this? Who pushed back and why? How did you convince engineers to do on-call who'd never done it before?]

## GitHub: Where It Started

[JAMES: This is where the ChatOps story begins. What was it like doing 24/7 ops for github.com? What was the culture like? What did it feel like to grow from 100 cloud nodes to datacenter-scale? This section could be shorter since the ChatOps story gets its own post, but the operational experience is worth capturing.]

## What I've Learned

After doing this across eight companies, some patterns emerge:

**The hard problem is usually organizational, not technical.** The technology exists. The challenge is getting humans to change how they work, getting budgets allocated to things that don't directly generate revenue, and building trust in new systems.

**Business cases beat technical arguments.** Nobody got platform investment by saying "Kubernetes is better." You get it by saying "this will reduce deployment time from two weeks to two hours and save $250K annually in integration costs." Talk money, talk velocity, talk risk.

**IC-to-lead transitions happen through delivery.** Nobody promoted me to tech lead. I delivered, the people who should have led didn't, and the role was mine. This is how it works at most companies, even if the org chart pretends otherwise.

**Platform engineering is product engineering.** Your users are other engineers. Your product is the infrastructure they build on. If they don't like using it, they'll route around you. Build things people love to use, not things that are technically impressive but painful to operate.

**The best infrastructure is invisible.** You succeed when nobody talks about the platform because it just works. The highest compliment is silence.

[JAMES: Anything else you'd add from twenty years of doing this? Any contrarian takes? Things you used to believe that turned out to be wrong?]

## What's Next

I've been at Salesforce for five years. The work is done. The platform is built, GA, and serving customers. What got me here won't take me further here, because the organization has decided infrastructure is a cost center, not a differentiator.

I'm looking for the next version of this pattern. A place where platform engineering is foundational. Where the hard problems are genuinely hard. Where the people around me are better than me at things I want to learn.

Twenty years of arriving, finding the hard problem, and building. The pattern hasn't changed. The problems have gotten more interesting.

---

*Twenty years of career compressed into one post. Details are from memory and may be slightly imprecise on dates and numbers. I used Claude to help structure and edit this.*
