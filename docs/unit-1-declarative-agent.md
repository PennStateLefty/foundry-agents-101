# Unit 1: Creating a Declarative Agent in Foundry

## Overview

Welcome to Unit 1 of the **AI Agents with Microsoft Foundry** lab series! In this unit, you'll create your very first AI agent using Microsoft Foundry — no code required.

A **declarative agent** in Foundry is configured entirely through the portal UI. Instead of writing code, you define the agent's behavior, instructions, and capabilities through a visual interface. Think of it like filling out a form that describes *what* your agent should do, rather than programming *how* it does it.

By the end of this unit, you'll have a working agent that you can chat with in the Foundry playground. It won't be able to take actions in the real world yet — but it will serve as the foundation we build on in Units 2–4.

---

## Prerequisites

Before starting this unit, make sure you have:

- ✅ Completed the infrastructure deployment (`azd up`) as described in the [main README](../README.md)
- ✅ Access to the Microsoft Foundry portal at [ai.azure.com](https://ai.azure.com)
- ✅ Azure credentials with the appropriate permissions to your deployed resource group

> **📝 Note:** If you haven't run `azd up` yet, go back to the root of this repository and follow the setup instructions in the README before continuing.

---

## What is a Declarative Agent?

There are two broad approaches to building AI agents:

| Approach | Description |
|---|---|
| **Declarative** | You *describe* the agent's behavior through configuration — its name, instructions, model, and connected tools. The platform handles the rest. |
| **Programmatic** | You *write code* that orchestrates the agent's behavior, managing conversation flow, tool calls, and state yourself. |

Declarative agents are a great starting point because they let you focus on **what the agent should do** without worrying about the underlying implementation. Microsoft Foundry makes this especially accessible — you can go from zero to a working agent in just a few minutes.

A declarative agent in Foundry has three core building blocks:

1. **Instructions** — A system prompt that defines the agent's persona and behavior
2. **Model** — The language model that powers the agent's responses
3. **Capabilities** — Optional extensions like knowledge sources and tools (we'll add these in later units)

> **💡 Tip:** Think of the instructions as the agent's "job description." The more specific and clear you are, the better the agent will perform.

---

## Steps

### Step 1: Navigate to Microsoft Foundry

1. Open your browser and go to [ai.azure.com](https://ai.azure.com).
2. Sign in with the same Azure credentials you used during infrastructure deployment.
3. Once signed in, you should see the Foundry portal home page.

> **📝 Note:** If this is your first time signing in, you may be prompted to select a directory or accept terms of service. Follow the on-screen prompts to continue.

---

### Step 2: Create a New Agent

Now let's create your first declarative agent.

1. From the Foundry home page, find and select the project that was created during your `azd up` deployment.
2. In the left-hand navigation, click on **Agents**.
3. Click the **+ New Agent** button to start creating a new declarative agent.
4. Give your agent a name:

   ```
   LightbulbAssistant
   ```

5. In the **Instructions** field, enter the following system prompt:

   ```
   You are a helpful assistant that can control a smart lightbulb. You can turn the light on and off, and change its color. When the user asks you to perform an action on the lightbulb, confirm what you are doing. Be friendly and concise.
   ```

6. Remove the web search, we will look at that later.

7. Click **Create** to save your new agent.

> **💡 Tip:** Good instructions are specific about what the agent *can* do and *how* it should respond. Notice that we tell the agent to "confirm what you are doing" — this helps the user understand the agent's actions. In later units, we'll connect actual tools so the agent can *really* control a lightbulb.

---

### Step 3: Test Your Agent

With your agent created, let's take it for a spin in the Foundry playground.

1. After creating the agent, you should see a chat interface (the **playground**) on the right side of the screen.
2. Try sending a few messages to your agent. Here are some ideas:

   ```
   Turn on the light.
   ```

   ```
   Change the light to blue.
   ```

   ```
   What color is the light right now?
   ```

3. Observe the agent's responses. You should notice that:
   - ✅ The agent responds in a friendly, helpful tone (following your instructions)
   - ✅ The agent *talks about* controlling the lightbulb
   - ❌ The agent **cannot actually control** a real lightbulb — it's only generating text responses
   - ❌ The agent **has no memory** of previous lightbulb states between conversations

> **📝 Note:** Right now, the agent is essentially "role-playing" as a lightbulb controller. It has no connected tools or knowledge sources, so it can only respond based on its model and your instructions. This is expected! We'll fix this in the upcoming units.

4. Try asking something outside the agent's instructions:

   ```
   What's the weather today?
   ```

   Notice how the agent responds — depending on the model, it may attempt to answer or politely redirect. This is a good example of why clear instructions matter.

---

## Summary

Congratulations! 🎉 You've created your first declarative agent in Microsoft Foundry. Here's what you accomplished:

| ✅ Done | ❌ Not Yet |
|---|---|
| Created a declarative agent in Foundry | No external knowledge (e.g., web search) |
| Defined system instructions for agent behavior | No tools connected (e.g., lightbulb API) |
| Tested the agent in the Foundry playground | No persistent state or memory |

This baseline agent is the starting point for the rest of the lab series. In each subsequent unit, we'll add new capabilities to make the agent more powerful and useful.

### What's Next

In **Unit 2**, we'll add **Grounding with Bing Search** as a tool to give the agent access to real-time web information. This means it will be able to answer questions about the world — not just respond based on its training data.

---

## Key Concepts

Here's a quick reference of the key concepts covered in this unit:

- **Declarative Agent** — An agent defined through configuration (instructions, model, capabilities) rather than code. Foundry's UI lets you create these without any programming.

- **System Instructions (Agent Persona)** — The prompt that tells the agent who it is and how to behave. This is the most important part of a declarative agent's configuration.

- **Foundry Agent Playground** — The built-in chat interface in the Foundry portal where you can test and interact with your agents in real time.

- **Declarative vs. Programmatic Agents** — Declarative agents are configured through UI/config files; programmatic agents are built with code. Both have their place — declarative is great for rapid prototyping and simpler use cases, while programmatic gives you full control for complex scenarios.

> **💡 Tip:** As you continue through the lab series, keep your Foundry portal tab open. You'll be building on this same agent in every unit.
