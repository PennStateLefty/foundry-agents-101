# Unit 4: MCP Tools and State Changes

## Overview

Welcome to Unit 4 — the **grand finale** of the **AI Agents with Microsoft Foundry** lab series! 🎉

This is where everything comes together. In the previous units, you created a declarative agent, gave it web knowledge, and connected it to a read-only MCP server. Now you'll take the final step: connecting your agent to a **custom MCP server** that can **change real application state**.

You're going to connect your Foundry agent to the **lightbulb application** — the Python FastAPI app that was deployed during setup. This app exposes an MCP server with tools that can turn a lightbulb on and off, change its color, and read its current state. Your agent will call these tools, and you'll **watch the lightbulb change in real time** in the browser.

This is the moment it stops being a demo and starts feeling real. Your agent isn't just generating text anymore — it's **taking actions that change the world**.

---

## Prerequisites

Before starting this unit, make sure you have:

- ✅ Completed [Unit 3: MCP Connections](./unit-3-mcp-connections.md)
- ✅ Your **Lightbulb Assistant** agent is working in the Foundry playground with Bing Grounding and the Microsoft Learn MCP connection
- ✅ The lightbulb application is deployed (this happened automatically during `azd up`)
- ✅ Your **AZURE_WEBAPP_URL** — the URL of the deployed lightbulb app (from the `azd up` output or the Azure portal)

> **📝 Note:** If you don't have the app URL handy, you can find it by running `azd env get-values` in your terminal and looking for `AZURE_WEBAPP_URL`. You can also find it in the Azure portal under your App Service resource.

---

## Understanding the Lightbulb MCP Server

The lightbulb application isn't just a pretty UI — it's also an **MCP server**. The FastAPI backend mounts an MCP endpoint at `/mcp` using the **Streamable HTTP** transport (the same transport type you used in Unit 3 with Microsoft Learn).

### The MCP Endpoint

The MCP server URL for your lightbulb app is:

```
{AZURE_WEBAPP_URL}/mcp
```

For example, if your app URL is `https://my-lightbulb-app.azurewebsites.net`, the MCP endpoint would be:

```
https://my-lightbulb-app.azurewebsites.net/mcp
```

### Available Tools

The lightbulb MCP server exposes **three tools**:

| Tool | Type | Description |
|---|---|---|
| `get_light_state` | **Read** | Returns the current state of the lightbulb — whether it's on or off, and what color it is |
| `toggle_light` | **Write** | Turns the lightbulb on if it's off, or off if it's on |
| `set_color` | **Write** | Changes the lightbulb's color to one of: `red`, `green`, `blue`, `yellow`, or `white` |

Notice the distinction between **read** and **write** operations. In Unit 3, the Microsoft Learn MCP server only exposed read tools — it could search and retrieve documentation, but it couldn't change anything. The lightbulb MCP server introduces **write tools** that modify application state. This is a big deal.

### The Real-Time Frontend

The lightbulb application includes a **React frontend** that displays a visual lightbulb. The frontend **polls the API** at regular intervals to check the lightbulb's current state. This means that when the agent calls a tool like `toggle_light` or `set_color`, the frontend will automatically pick up the change and update the display — no page refresh needed.

This creates a satisfying **feedback loop**: you tell the agent what to do → the agent calls the MCP tool → the app state changes → the UI updates → you see the result. All in real time.

> **💡 Tip:** For the best experience, arrange your browser so you can see both the lightbulb app and the Foundry playground at the same time — side by side or on separate monitors. That way you can watch the lightbulb change the instant the agent acts.

---

## Steps

### Step 1: Open the Lightbulb App

Let's start by seeing the lightbulb application in its default state.

1. Open your browser and navigate to your **AZURE_WEBAPP_URL**.
2. You should see the lightbulb application with a visual lightbulb displayed on the page.
3. Observe the lightbulb's default state:
   - 💡 The light should be **off**
   - 🎨 The color should be **white** (the default)

4. Take a moment to appreciate what's running here: a Python FastAPI backend serving both a React frontend and an MCP server, deployed to Azure App Service — all set up automatically by `azd up`.

> **📝 Note:** If the lightbulb app isn't loading, verify that your App Service is running in the Azure portal. You can also check the deployment status by running `azd show` in your terminal.

---

### Step 2: Connect the MCP Server to Your Agent

Now let's give your agent the ability to control the lightbulb by connecting the MCP server.

1. Open the [Microsoft Foundry portal](https://ai.azure.com) and navigate to your project.
2. In the left-hand navigation, click on **Agents**.
3. Select the **Lightbulb Assistant** agent to open its configuration.
4. Scroll down to the **Tools** section (where you previously added the Microsoft Learn MCP connection).
5. Click **+ Add Tool** to add a new tool.
6. Select **MCP** from the list of tool types.
7. Configure the new MCP connection:
   - **Server URL:** Enter your lightbulb MCP endpoint:
     ```
     {AZURE_WEBAPP_URL}/mcp
     ```
     Replace `{AZURE_WEBAPP_URL}` with your actual app URL (e.g., `https://my-lightbulb-app.azurewebsites.net/mcp`).
   - **Transport:** This should default to **Streamable HTTP** — leave it as-is.
   - **Name:** Give it a recognizable name like `Lightbulb Controller`.
8. Click **Connect** (or **Add**) to establish the connection.
9. Foundry will connect to your MCP server and **automatically discover** the three tools. You should see them listed:
   - `get_light_state`
   - `toggle_light`
   - `set_color`
10. **Save** your agent configuration.

> **💡 Tip:** Review the discovered tool descriptions. These are what the agent uses to decide *when* to call each tool. The better the descriptions, the smarter the agent's tool selection will be. Your lightbulb MCP server includes clear descriptions for each tool.

> **📝 Note:** Your agent now has **two MCP connections** — Microsoft Learn (from Unit 3) and the Lightbulb Controller. The agent will intelligently choose which tools to use based on the user's request. Documentation questions go to Microsoft Learn; lightbulb commands go to the Lightbulb Controller.

---

### Step 3: Test Agent-Controlled State Changes

This is the moment you've been building toward. Time to watch your agent control a real application! 🚀

1. Open **two browser tabs** (or windows) side by side:
   - **Tab 1:** The lightbulb application (your AZURE_WEBAPP_URL)
   - **Tab 2:** The Foundry playground for your Lightbulb Assistant agent

2. In the Foundry playground, start with a simple command:

   ```
   Turn on the light.
   ```

   **Watch the lightbulb app!** You should see:
   - ✅ The agent confirms it's turning on the light
   - ✅ The agent calls the `toggle_light` MCP tool
   - ✅ The lightbulb in the app **turns on** in real time

3. Now check the state:

   ```
   What's the current state of the light?
   ```

   The agent will call `get_light_state` and report back that the light is on and what color it is.

4. Change the color:

   ```
   Change the light to blue.
   ```

   **Watch the app again!** The lightbulb should change to blue. 🔵

5. Now try a multi-step request:

   ```
   Turn off the light and then turn it back on with a red color.
   ```

   This is where it gets exciting. The agent needs to **chain multiple tool calls** together — first calling `toggle_light` to turn it off, then `toggle_light` again to turn it back on, and `set_color` to change it to red. Watch the lightbulb app as each step happens!

> **💡 Tip:** If you don't see the lightbulb updating immediately, give the frontend a moment to poll for the new state. The React app polls at regular intervals, so there may be a brief delay between the agent's action and the visual update.

---

### Step 4: Experiment

Now that you've seen the basics, let's push the boundaries and see how smart the agent really is.

1. **Try conditional logic:**

   ```
   Make the light green if it's currently off, or yellow if it's currently on.
   ```

   Watch how the agent **reasons** through this: it first calls `get_light_state` to check the current state, then decides which action to take based on the result. This is agent reasoning in action — the agent is reading state, making decisions, and then acting.

2. **Try a sequence of changes:**

   ```
   Cycle through all the available colors, pausing between each one.
   ```

   The agent may call `set_color` multiple times, changing the lightbulb through red, green, blue, yellow, and white.

3. **Ask the agent to explain itself:**

   ```
   Turn the light on and make it green, then explain exactly what tools you used and why.
   ```

   This is a great way to see the agent's reasoning process. It will describe the tool calls it made and its decision-making process.

4. **Combine all the agent's capabilities:**

   ```
   Search Microsoft Learn for information about Azure App Service, then celebrate by turning the light to blue.
   ```

   This request uses the Microsoft Learn MCP connection (Unit 3) *and* the Lightbulb Controller MCP connection (Unit 4) in a single conversation. Your agent seamlessly switches between tools!

> **📝 Note:** The agent may handle complex requests differently than you expect — that's part of the fun. If it doesn't get something right on the first try, rephrase your request or break it into smaller steps. This is how you learn to "prompt engineer" for tool-using agents.

---

## Summary

**You did it!** 🎉 You've completed the full journey from a blank slate to a fully functional AI agent that can observe and change the real world through tools.

Let's look at everything you've accomplished across all four units:

| Unit | What You Added | Capability |
|---|---|---|
| **Unit 1** | Declarative agent + system instructions | Agent has a persona and can chat |
| **Unit 2** | Grounding with Bing | Agent can search the web for real-time information |
| **Unit 3** | Microsoft Learn MCP connection | Agent can search and retrieve technical documentation |
| **Unit 4** | Lightbulb MCP connection | Agent can **read and change real application state** |

The progression tells the story of what makes AI agents powerful:

1. **Start with a personality** — define what the agent is and how it should behave
2. **Give it tools for information** — connect it to sources like Bing so it can answer questions
3. **Give it read tools** — let it discover and retrieve data from external systems
4. **Give it write tools** — let it take actions that change the world

And the remarkable part? **You didn't write a single line of agent code.** Everything was configured through the Foundry portal. The declarative agent pattern made it possible to go from zero to a fully capable, tool-using agent through configuration alone.

---

## Key Concepts

Here's a quick reference of the key concepts covered in this unit:

- **MCP Tools for State Changes** — MCP tools aren't limited to reading data. Write tools like `toggle_light` and `set_color` allow agents to **modify application state**. This is what transforms an agent from a chatbot into an actor that can do real work.

- **Agent Tool Chaining** — When given a complex request, the agent can call multiple tools in sequence to accomplish a goal. For example, checking state with `get_light_state`, then deciding whether to call `toggle_light` or `set_color`. The agent orchestrates these calls autonomously.

- **Real-Time Feedback Loops** — The pattern of **agent acts → app state changes → user sees result** creates a powerful feedback loop. The React frontend polling the API means the user gets visual confirmation that the agent's actions had real effects.

- **Read vs. Write Operations** — A critical distinction in tool design. Read operations (`get_light_state`) are safe and idempotent — they can be called any number of times without side effects. Write operations (`toggle_light`, `set_color`) change state and have real consequences. Understanding this distinction is important when designing your own MCP servers.

- **The Declarative Agent Pattern + MCP** — The combination of Foundry's declarative agents with MCP connections is incredibly powerful. You can build agents that integrate with any MCP-enabled service — without writing orchestration code. The agent handles tool discovery, selection, and chaining automatically.

---

## 🎉 Congratulations!

**You've completed the AI Agents with Microsoft Foundry lab series!**

Take a moment to appreciate what you built. Starting from nothing, you now have:

- 🤖 A **declarative agent** with a custom persona and clear instructions
- 🌐 **Web search** via Grounding with Bing for real-time information
- 📚 **Documentation access** via the Microsoft Learn MCP connection
- 💡 **Real application control** via your custom lightbulb MCP server
- 🔄 An agent that **reasons, chains tools, and takes real actions** — all without a single line of agent code

This is the declarative agent pattern at its best: **powerful agents built through configuration, not code**.

### What's Next?

The lab may be over, but your journey with AI agents is just beginning. Here are some ideas for where to go next:

- **Build your own MCP server** — The lightbulb app is a great starting point. Study how it implements the MCP protocol in Python with FastAPI, then build your own server that exposes tools for your own application or API.

- **Add more tools** — Extend the lightbulb MCP server with new capabilities. What about a `set_brightness` tool? Or a `schedule_change` tool that changes the color after a delay?

- **Explore programmatic agents** — Declarative agents are powerful, but sometimes you need more control. Explore Foundry's programmatic agent capabilities for complex workflows, custom logic, and advanced orchestration.

- **Connect to real services** — The same pattern you used for the lightbulb works for any MCP-enabled service. Connect your agent to databases, CRMs, monitoring tools, or any API that speaks MCP.

- **Dive into the MCP ecosystem** — Visit [modelcontextprotocol.io](https://modelcontextprotocol.io) to learn more about the MCP specification and discover the growing ecosystem of MCP servers and tools.

Thank you for completing this lab! Now go build something amazing. 🚀
