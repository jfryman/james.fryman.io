---
title: "Arrive, Find the Hard Problem, Build"
date: 2026-05-19
draft: false
tags: ["platform-engineering", "career", "leadership", "teams"]
description: "The same pattern, across eight companies and twenty years. What I've learned about building platform teams and shipping infrastructure."
---

I've been a platform engineer for twenty years across eight companies. The pattern is always the same: arrive, find the hard problem, build the thing, scale it.

<!--more-->

## The First Month

It starts the same way every time, and it's a human problem.

Clearly, I was hired for a reason, so I know what my scope is. But I don't know the history of how we got to where we are. That history is just as important as understanding what changes need to be made. It doesn't matter whether the process is slow, whether extra bodies are being added, or whatever the presenting symptom is. *Why I'm there* matters to understanding what to do going forward, and you never get a sense of honesty about that in the interview process. They have a job opening and a set of skills. Maybe you pick up a few signals during the interview and decide whether you want to do it. But the real stories come out once you're hired, once you're around the people who lived through whatever created your job.

So that's what I spend the first month doing. I talk with my teammates. I talk with my boss. I ask about people I should connect with, and I go talk with them. I talk with my boss's boss and ask the same questions, and I go talk with those people too. At the very least, I've built relationships across the organization, learned what people do and how they do it.

High-level introductions inevitably lead to someone spilling something, and you just kind of go from there. It's a good measure to understand who's complaining the loudest, but that's not always the marker. It just shows where your headwinds and tailwinds are coming from.

Most of the work I'm hired for has to do with growth, scaling, or bottlenecks, so I've come to understand the questions to ask and what to explore when I get there. But it's always important to keep an open mind and just be human. Ask what people do and how they do it. Learn about them. You'll be working with them.

## Finding the Hard Problem

The hard problem is almost never the one on the job description.

At Ripple, I was hired to focus on operations: scaling the product as new banks came online. There was plenty of that work to do. But as I talked with people, I realized there was significant potential being lost somewhere else entirely. I found myself asking: how do we get these clients on board? And then working backward through the funnel.

I ended up in client services and their pre-sales department, where I met a wonderful guy named Sachin. He was trying to solve his own bottleneck: it took two weeks to set up a test environment for a prospective client. When you're trying to make a sale, two weeks is just too long.

We were both eager to solve a problem. My goal was to understand why it took multiple weeks to spin up even test instances. His team faced the same issue from the sales side. We clearly shared the same problem, just with different incentives for resolving it.

We built a proof of concept. It resolved and deployed test instances an order of magnitude faster than the existing process, still following all the banking regulations. We could be a bit more relaxed because it was staging, but the POC showed this could work for production and dramatically speed up the time it takes to onboard new banks.

That was the real problem. Not "we need better ops." Ripple was bottlenecked by the speed at which it could spin up any environment, whether for evaluating the solution or onboarding to it. The job description said operations. The hard problem was onboarding velocity.

I never would have found it by reading runbooks.

## The Build That Almost Didn't Ship

At Salesforce, the product I worked on (CodeBuilder, essentially hosted VS Code for Salesforce developers) went through three complete rewrites before it reached general availability. I was around for two of them. It had headwinds from the start in terms of technical feasibility.

Right before it went to production, there were concerns about cost to serve. The part of the company that had created the product didn't have or manage operational resources, so the operational cost became something they were afraid of. They pulled the plug. The result was a diminished user experience: we didn't pay for the resources to give users a fast experience, and we made it difficult for them to onboard. It sat in that state for almost 18 months.

What saved it was the AgentForce 4 developer team. They were building an extension and ran into the exact business problem CodeBuilder was designed to solve: 70% of Salesforce developers and administrators don't have admin access on their own computers, so they can't install the tools necessary to do their work. The need was undeniable. It just took someone else hitting the same wall to restart the conversation.

We re-evaluated where our bottlenecks were, did testing and analysis to understand the actual cost-to-serve, and secured the funding to hit the desired performance characteristics. The company got a clear view of what it takes to pay for success: here's how much money we need to spend to get the max performance within our expected load.

It was a combination of fixing the technical debt from the previous iterations and ensuring the product stayed performant once loaded. The initial load time had always been purely a funding issue. Once we had the data and the dollars, we managed sustained 10,000+ customer sessions in bursts throughout Dreamforce. It was a resounding success.

But it took three rewrites, an 18-month pause, and another team hitting the same problem before the organization let it ship. That's pretty typical.

## What I'm Tired Of

The pattern I'm most tired of is the friction around making changes.

Every company creates a fear around change, usually for valid reasons. Failures cause outages, outages cost money, so the organizational immune system kicks in. Operations practitioners advocate small, frequent changes. The business demands large changes infrequently. It's fundamentally risk-driven, and I've been grappling with this push-pull for years.

We're now in an era where speed is almost required. Agents can generate code, and people are quickly realizing the bottlenecks are still the same: CI, change control, validation, and QA. The code was never the slow part. The process around the code was always the slow part, and it still is.

I'm curious to see how agents affect this conversation, because it won't be about risk appetites anymore. Everyone's risk appetite has changed. It will be about practical technical solutions we can apply, whether agentic or not, to accelerate software delivery.

For years I've been telling people that automation creates jobs, not removes them. I'm frustrated by the "everyone's going to lose their jobs" rhetoric. It's a dramatic lack of imagination for capitalists to not figure out how to use resources to generate more capital, quite frankly. New tools create new work. They always have.

## The One That Almost Worked

The closest I've come to "we did it right" was StackStorm and Netflix.

We had the right technology for resilient, auto-healing infrastructure. Netflix was the right kind of company to adopt it. The pattern proved itself. The tech proved itself. It just required a certain kind of organization that was willing to work the way we proposed, and that made it hard to sell. We could demo it all day. Getting another company to commit to operating that way was a different problem.

That's the irony. The place where everything came together was also the place that showed me why it wouldn't scale as a business. The technology was ahead of the organizational readiness. If that sounds familiar, it's because it's the same story I told in [The Decade-Long Bet](/posts/the-decade-long-bet/).

Now companies will need to decide whether they want to move as fast as possible while staying safe. There's always a bar. I'm sure we'll redefine what those bars look like in terms of what it means to go fast and what it means to be safe. Those are new conversations, and I think they're conversations worth having.

## What I'd Build

If someone gave me a blank check and a platform team with full support? Two things.

The pipe dream is manufacturing replicators. "I need a new set of forks" and they get created. I've been doing adjacent work with 3D printing, I'm learning CNC. It's a pipe dream, but it's my pipe dream.

The practical answer is Agent-In-A-Box. A truly integrated, compliant agent that can operate in a zero-trust environment. Not another generic harness (those come out every day). Something that gets secrets properly, works within real access controls, and earns trust the same way an employee does.

The power of what I saw at GitHub, when the chat agent could be customized for each team's workflow, is something I want to see with AI agents. If I don't trust my employees with root access, I shouldn't trust my agent with root access, so the agent should have the same tools and the same constraints. Then you just let them work. The economics become a matter of cost and LLM viability. You can min-max on which models work best for which tasks.

I've been building a version of this at home, and it works well enough to prove the concept. What I don't have is the scale, the compliance requirements, or the adversarial pressure that would make it production-grade for a real enterprise. That's the interesting work. I think seeing what happens when you create agent swarms that operate within real organizational constraints is genuinely new territory, and I want to be building in it.

---

*Twenty years, eight companies, same pattern. The job description never describes the actual problem. The actual problem is always human. The technology usually works. Getting organizations to let it work is the real engineering challenge.*
