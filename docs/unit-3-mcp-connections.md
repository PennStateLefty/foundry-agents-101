# Unit 3: MCP Connections

## Overview

Welcome to Unit 3 of the **AI Agents with Microsoft Foundry** lab series! In this unit, you'll connect your agent to an external **MCP (Model Context Protocol) server** — giving it the ability to discover and use tools hosted outside of Foundry.

Up to this point, your agent has its own personality (Unit 1) and can search the web for real-time information (Unit 2). But what if your agent needs to interact with a specific service — like searching technical documentation, querying a database, or calling an API? That's where MCP comes in.

You'll connect your agent to the **Microsoft Learn MCP endpoint**, a remote MCP server that exposes tools for searching and retrieving Microsoft documentation. After this unit, your agent will be able to answer technical questions by pulling directly from Microsoft's official docs.

Once again, you won't write a single line of code. MCP connections in Foundry are configured through the portal — just like everything else you've done so far.

---

## Prerequisites

Before starting this unit, make sure you have:

- ✅ Completed [Unit 2: Grounding with Bing](./unit-2-grounding-with-bing.md)
- ✅ Your **Lightbulb Assistant** agent is working in the Foundry playground with Bing Grounding enabled
- ✅ Access to the [Microsoft Foundry portal](https://foundry.microsoft.com)

---

## What is MCP?

**Model Context Protocol (MCP)** is an open standard that defines how AI agents communicate with external tools and data sources. Think of it as a universal adapter — a standardized way for agents to discover, understand, and call tools hosted anywhere on the internet.

### The "USB-C for AI" Analogy

Before USB-C, every device had its own charger and cable. You needed a different connector for your phone, tablet, laptop, and headphones. USB-C solved that by providing **one standard port** that works with everything.

MCP does the same thing for AI agents. Without MCP, every tool integration requires custom code — a unique connector for each service. With MCP, there's **one protocol** that any agent can use to connect to **any tool**. The agent doesn't need to know the details of how a tool works internally — it just needs to speak MCP.

### How It Works

An **MCP server** is a service that exposes one or more **tools** over the MCP protocol. Each tool has:

- A **name** (e.g., `search_documentation`)
- A **description** of what it does (so the agent knows when to use it)
- A **schema** defining the inputs it expects and the outputs it returns

When you connect an MCP server to your agent, the agent **automatically discovers** all the tools that server offers. Then, when a user asks a question that one of those tools could help with, the agent calls the appropriate tool, processes the result, and responds naturally.

> **💡 Tip:** You don't need to tell the agent *when* to use an MCP tool. The agent reads the tool descriptions and decides on its own — just like it decides when to search the web with Bing.

### Streamable HTTP Transport

MCP servers can communicate using different transport methods. The one you'll use in this lab is **Streamable HTTP** — the most common approach for remote MCP servers. With Streamable HTTP, the agent sends requests to the MCP server over HTTPS and receives responses back. It's simple, secure, and works well for cloud-hosted tools.

> **📝 Note:** You may also encounter the term "SSE" (Server-Sent Events) in MCP documentation. Streamable HTTP is the current recommended transport for remote servers and is what Foundry uses for MCP connections.

---

## Steps

### Step 1: Understanding MCP in Foundry

Before we configure anything, let's understand how MCP fits into Foundry's architecture.

In the previous units, you added **knowledge** to your agent (Grounding with Bing). Knowledge sources give the agent access to information — the agent can look things up and include what it finds in its responses.

**MCP tools are different.** Tools give the agent the ability to **take actions** — to call a function, run a query, or interact with an external system. The Microsoft Learn MCP server, for example, exposes tools that can search Microsoft's documentation library and return specific articles, code samples, and technical guidance.

Here's how it fits together:

| Capability | Source | What It Does |
|---|---|---|
| Personality & instructions | System prompt (Unit 1) | Defines how the agent behaves |
| Real-time web knowledge | Grounding with Bing (Unit 2) | Searches the web for current information |
| External tools | MCP connections (Unit 3) | Calls tools on remote servers |

Foundry handles the MCP communication for you. When you add an MCP connection, Foundry will:

1. **Connect** to the remote MCP server
2. **Discover** the tools the server exposes
3. **Register** those tools with your agent so it can call them
4. **Manage** the request/response flow when the agent invokes a tool

> **📝 Note:** MCP connections in Foundry are configured per-agent. Each agent can have its own set of MCP connections, and different agents can connect to different servers.

---

### Step 2: Add the Microsoft Learn MCP Connection

Now let's connect the Microsoft Learn MCP server to your agent.

1. Open the [Microsoft Foundry portal](https://foundry.microsoft.com) and navigate to your project.
2. In the left-hand navigation, click on **Agents**.
3. Select the **Lightbulb Assistant** agent to open its configuration.
4. Scroll down to the **Tools** section of the agent configuration (this is separate from the Knowledge section where you added Bing).
5. Click **+ Add Tool** (or the equivalent button to add a new tool).
6. From the list of tool types, select **MCP**.
7. You'll be prompted to configure the MCP connection:
   - **Server URL:** Enter the Microsoft Learn MCP endpoint URL:
     ```
     https://learn.microsoft.com/api/mcp
     ```
   - **Transport:** This should default to **Streamable HTTP** — leave it as-is.
   - **Name:** Give it a recognizable name like `Microsoft Learn Docs`.
8. Click **Connect** (or **Add**) to establish the connection.
9. Foundry will reach out to the MCP server and discover its available tools. After a moment, you should see the tools listed under your new MCP connection.
10. **Save** your agent configuration.

> **💡 Tip:** After connecting, take a moment to review the tools that were discovered. You'll see the tool names, descriptions, and input schemas. This is exactly what the agent sees when deciding which tool to call — clear descriptions lead to better tool selection.

> **📝 Note:** The Microsoft Learn MCP endpoint is a public, read-only MCP server. It doesn't require authentication. Other MCP servers you connect to in the future may require API keys or OAuth — Foundry supports those authentication methods too.

---

### Step 3: Test the MCP-Connected Agent

Time to see MCP in action! Let's test the agent with questions that will trigger it to use the Microsoft Learn tools.

1. In the Foundry portal, open the **playground** for your Lightbulb Assistant agent.
2. Start with a technical documentation question:

   ```
   How do I create a Bicep template for deploying an Azure App Service?
   ```

3. Observe the response carefully. You should notice:
   - ✅ The agent calls one of the MCP tools (you may see the tool call in the response trace)
   - ✅ The response includes **specific, accurate technical guidance** pulled from Microsoft Learn
   - ✅ The information is detailed and relevant — not a vague, general answer

4. Try a few more questions that target Microsoft documentation:

   ```
   What are Azure Functions and how do I create one?
   ```

   ```
   Explain how to use managed identities in Azure.
   ```

   ```
   What's the difference between Azure Blob Storage and Azure Files?
   ```

5. Now try a question that the agent should answer using **Bing** rather than the MCP tools:

   ```
   What's in the tech news today?
   ```

   Notice how the agent intelligently chooses the right tool for the job — Bing for general web queries, and the Microsoft Learn MCP tools for documentation lookups.

6. And try a question that uses the agent's **core personality** from Unit 1:

   ```
   Turn on the light.
   ```

   The agent still responds as your Lightbulb Assistant. MCP tools extend the agent — they don't replace its existing behavior.

> **💡 Tip:** Pay attention to the **tool calls** shown in the agent's response. Foundry's playground often displays which tools were invoked and what data was returned. This transparency is invaluable for understanding how your agent makes decisions.

> **📝 Note:** The agent decides which tool to use based on the user's question and the tool descriptions provided by the MCP server. If you're not seeing MCP tool calls for documentation questions, try being more explicit — for example, "Search Microsoft Learn for information about Azure Functions."

---

## Summary

Congratulations! 🎉 You've connected your agent to an external MCP server, giving it the ability to search and retrieve Microsoft documentation on demand. Here's what you've accomplished across the lab so far:

| ✅ Done | ❌ Not Yet |
|---|---|
| Created a declarative agent in Foundry (Unit 1) | No custom tools that change application state |
| Added Grounding with Bing for real-time web knowledge (Unit 2) | No persistent state or memory |
| Connected to a remote MCP server for documentation search (Unit 3) | No custom MCP server |
| Agent intelligently chooses between knowledge sources and tools | |

### Key Takeaway

MCP provides a **standardized way to extend agent capabilities** with external tools. Instead of building custom integrations for every service, you connect to an MCP server and the agent automatically discovers and uses the tools it offers. This is the same pattern whether you're connecting to Microsoft Learn, a database, a CRM, or any other MCP-enabled service.

Notice the progression across the units: your agent started as a simple chatbot, gained web knowledge, and now has access to specialized tools — all through configuration.

### What's Next

In **Unit 4**, we'll take the final step: connecting the agent to a **custom MCP server** that can actually **change application state** — like controlling that lightbulb for real. You'll see how MCP goes beyond read-only documentation search to enable agents that take real actions in the world.

---

## Key Concepts

Here's a quick reference of the key concepts covered in this unit:

- **Model Context Protocol (MCP)** — An open standard that defines how AI agents communicate with external tools and data sources. MCP provides a universal, consistent interface for tool integration — the same way an agent connects to one MCP server is how it connects to any MCP server.

- **MCP Server** — A service that exposes one or more tools over the MCP protocol. Each tool has a name, description, and schema. The Microsoft Learn MCP endpoint is one example of a remote MCP server.

- **Streamable HTTP** — The recommended transport method for remote MCP servers. The agent communicates with the MCP server over HTTPS, sending tool requests and receiving responses. Secure, simple, and works well for cloud-hosted tools.

- **Tool Discovery** — The process by which an agent automatically learns what tools an MCP server offers. When you connect an MCP server in Foundry, the agent reads the tool names, descriptions, and schemas — no manual configuration of individual tools is needed.

- **Knowledge vs. Tools** — Knowledge sources (like Bing) provide information that the agent incorporates into its responses. Tools (like MCP endpoints) allow the agent to take actions — calling functions, running queries, or interacting with external systems. Your agent now has both.

> **💡 Tip:** As you think about building your own agents, consider what tools they might need. Any service with an MCP server can be connected to your agent using the same pattern you followed in this unit. The MCP ecosystem is growing rapidly — check out the [MCP specification](https://modelcontextprotocol.io) to learn more.
