# Unit 2: Grounding with Bing

## Overview

Welcome to Unit 2 of the **AI Agents with Microsoft Foundry** lab series! In this unit, you'll supercharge the declarative agent you built in Unit 1 by adding **Grounding with Bing** — giving your agent the ability to search the web for real-time information.

Right now, your agent can only respond using the knowledge baked into its underlying language model. That means it can't tell you today's weather, the latest news, or anything that happened after its training cutoff. By adding Bing as a tool, your agent will be able to pull in current, relevant information from the web — and cite its sources.

The best part? You won't write a single line of code. This is the power of declarative agents in Foundry: extending capabilities is a matter of **configuration, not code**.

By the end of this unit, your agent will be able to answer questions about the real world with up-to-date, grounded responses.

---

## Prerequisites

Before starting this unit, make sure you have:

- ✅ Completed [Unit 1: Creating a Declarative Agent in Foundry](./unit-1-declarative-agent.md)
- ✅ Your **Lightbulb Assistant** agent is working in the Foundry playground
- ✅ Infrastructure deployed via `azd up` (this provisions the Bing Grounding resource automatically)
- ✅ Access to the [Azure Portal](https://portal.azure.com) and the [Microsoft Foundry portal](https://ai.azure.com)

> **📝 Note:** The `azd up` deployment from the main README provisions a Grounding with Bing resource in your Azure resource group. If you skipped that step or the resource wasn't created, go back to the [main README](../README.md) and redeploy before continuing.

---

## What is Grounding with Bing?

When you chat with a language model, it generates responses based on patterns learned during training. But that training data has a cutoff date — the model doesn't *know* what happened yesterday, and it can't look things up on the internet. This is where **grounding** comes in.

**Grounding** means connecting a language model to external, authoritative data sources so its responses are based on real, up-to-date information rather than just its training data. Without grounding, a model might:

- Guess at current events and get them wrong
- Provide outdated information confidently
- "Hallucinate" plausible-sounding but incorrect answers

**Grounding with Bing** is an Azure service that gives your agent the ability to search the web via Bing and incorporate the results into its responses. When your agent receives a question that requires current information, it will:

1. **Search** the web using Bing to find relevant, up-to-date content
2. **Synthesize** the search results into a natural, conversational response
3. **Cite** the sources so the user knows where the information came from

> **💡 Tip:** Think of Grounding with Bing as giving your agent a web browser. Instead of guessing, it can look things up — just like you would.

This is a game-changer for agents that need to provide accurate, real-time information. And in Foundry, adding it is as simple as adding a tool.

---

## Steps

### Step 1: Locate Your Bing Grounding Resource

Before configuring the agent, let's verify that the Bing Grounding resource exists in your Azure environment.

1. Open the [Azure Portal](https://portal.azure.com) and sign in with your Azure credentials.
2. Navigate to your **resource group** — this is the one created during the `azd up` deployment.
3. In the resource list, look for a resource with the type **Grounding with Bing Search**. It should have been provisioned automatically by the infrastructure-as-code templates.
4. Click on the resource to view its details. Take note of:
   - The **resource name**
   - The **location/region**
   - The **pricing tier**

> **📝 Note:** You don't need to copy any keys or connection strings — Foundry will handle the connection for you. This step is just to confirm the resource exists and is healthy.

> **💡 Tip:** If you don't see the Bing Grounding resource in your resource group, double-check that `azd up` completed successfully. You can re-run it from the repository root if needed.

---

### Step 2: Add Bing Grounding to Your Agent

Now let's connect the Bing Grounding resource to the agent you created in Unit 1.

1. Open the [Microsoft Foundry portal](https://ai.azure.com) and navigate to your project.
2. In the left-hand navigation, click on **Agents**.
3. Select the **Lightbulb Assistant** agent you created in Unit 1 to open its configuration.
4. Scroll down to the **Tools** section of the agent configuration.
5. Click **+ Add Tool** (or the equivalent button to add a new tool).
6. From the list of available tool types, select **Grounding with Bing Search**.
7. Foundry will prompt you to connect the resource:
   - Select the **Bing Grounding resource** from your Azure subscription.
   - Confirm the connection.
8. Once added, you should see **Grounding with Bing Search** listed under the Tools section.
9. **Save** your agent configuration.

> **💡 Tip:** You don't need to change your agent's instructions to use Bing Grounding. The agent will automatically decide when to search the web based on the user's question. If the question can be answered from the model's training data alone, it may not trigger a web search — and that's fine.

> **📝 Note:** It may take a moment for the tool to become active after saving. If your first test doesn't show web results, wait a few seconds and try again.

---

### Step 3: Test the Enhanced Agent

Time to see the difference Bing Grounding makes! Let's test the agent with questions that require current information.

1. In the Foundry portal, open the **playground** for your Lightbulb Assistant agent.
2. Start by asking a question that requires up-to-date information:

   ```
   What's in the news today?
   ```

3. Observe the response. You should notice:
   - ✅ The agent provides **current, relevant information** — not a generic response
   - ✅ The response includes **citations or source references** indicating where the information came from
   - ✅ The tone is still friendly and helpful, following your original instructions

4. Try a few more questions that benefit from web grounding:

   ```
   What is the current weather in Seattle?
   ```

   ```
   What are the latest developments in AI agents?
   ```

   ```
   Who won the most recent Super Bowl?
   ```

5. Now, compare this to Unit 1. Remember when you asked "What's the weather today?" and the agent couldn't help? Try it again — the difference should be immediately clear.

6. Also try a question that *doesn't* need web search to see that the agent still behaves normally:

   ```
   Turn on the light.
   ```

   The agent should still respond as your Lightbulb Assistant — Bing Grounding doesn't replace the agent's core behavior, it **extends** it.

> **💡 Tip:** Pay attention to the citations in the agent's responses. Grounded answers will often include links or references to the web sources used. This transparency is a key benefit — users can verify the information for themselves.

> **📝 Note:** The agent is intelligent about when to use Bing. If you ask a lightbulb-related question, it will rely on its instructions. If you ask about current events, it will search the web. This blending of knowledge sources happens automatically.

---

## Summary

Congratulations! 🎉 You've added real-time web knowledge to your declarative agent. Here's what you accomplished:

| ✅ Done | ❌ Not Yet |
|---|---|
| Created a declarative agent in Foundry (Unit 1) | No tools connected (e.g., lightbulb API) |
| Added Grounding with Bing for real-time web knowledge | No persistent state or memory |
| Agent can now answer questions about current events | No custom data sources or APIs |
| Agent cites its sources for transparency | |

### Key Takeaway

Adding Bing Grounding to a declarative agent is **configuration, not code**. You didn't write any code, deploy any services, or modify any prompts. You simply connected a tool through the Foundry UI, and your agent immediately became more capable.

This pattern — extending agents through configuration — is a core principle of Foundry's declarative approach. As you'll see in the next units, the same pattern applies to tools and other capabilities.

### What's Next

In **Unit 3**, we'll take things further by connecting the agent to an **MCP (Model Context Protocol) endpoint**. This will allow the agent to interact with external services and take real actions — like actually controlling that lightbulb.

---

## Key Concepts

Here's a quick reference of the key concepts covered in this unit:

- **Grounding** — The practice of connecting a language model to external data sources so its responses are based on real, verifiable information rather than just training data. Grounding reduces hallucination and improves accuracy.

- **Grounding with Bing** — An Azure service that enables AI agents to search the web via Bing and incorporate up-to-date search results into their responses. It provides real-time knowledge and source citations.

- **Hallucination** — When a language model generates information that sounds plausible but is factually incorrect. Grounding helps mitigate hallucination by giving the model access to authoritative sources.

- **Tools in Foundry** — Pluggable capabilities that can be added to a declarative agent through the Foundry UI. Grounding with Bing is one example; others include MCP connections, file uploads, Azure AI Search indexes, and more.

- **Declarative Configuration** — The pattern of extending agent capabilities through UI-based configuration rather than writing code. This makes it fast to iterate and accessible to non-developers.

> **💡 Tip:** As you continue through the lab series, notice how each unit adds a new capability to the same agent — without rewriting what came before. This composability is what makes declarative agents so powerful.
