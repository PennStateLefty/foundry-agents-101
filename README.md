# Foundry Agents 101

A hands-on lab for learning AI Agents with Microsoft Foundry. Build a declarative agent, add knowledge sources, connect MCP endpoints, and control a real application through agent tool use.

## What You'll Build

A **lightbulb web application** (Python + React) with an MCP server that a Foundry agent can use to toggle the light on/off and change its color — demonstrating how AI agents can take real actions in the world.

## Lab Units

| Unit | Topic | Description |
|------|-------|-------------|
| [Unit 1](docs/unit-1-declarative-agent.md) | Declarative Agent | Create your first agent in Microsoft Foundry |
| [Unit 2](docs/unit-2-grounding-with-bing.md) | Grounding with Bing | Add web knowledge to your agent |
| [Unit 3](docs/unit-3-mcp-connections.md) | MCP Connections | Connect to the Microsoft Learn MCP endpoint |
| [Unit 4](docs/unit-4-mcp-tools-state.md) | MCP Tools & State | Control the lightbulb app via agent tool calls |

## Prerequisites

- Azure subscription
- [Azure Developer CLI (`azd`)](https://learn.microsoft.com/azure/developer/azure-developer-cli/install-azd)
- [Python 3.11+](https://www.python.org/downloads/)
- [uv](https://docs.astral.sh/uv/getting-started/installation/) (Python package manager)
- [Node.js 18+](https://nodejs.org/)
- Access to [Microsoft Foundry](https://foundry.microsoft.com)

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/your-org/foundry-agents-101.git
cd foundry-agents-101
```

### 2. Deploy to Azure

```bash
azd auth login
azd up
```

This provisions all Azure resources (App Service, Foundry, Grounding with Bing) and deploys the lightbulb application.

### 3. Start the lab

Open [Unit 1](docs/unit-1-declarative-agent.md) and follow along!

## Architecture

```
┌─────────────────────────────────────────────┐
│                  Foundry Agent               │
│         (created by student in portal)       │
└──────────┬──────────────┬───────────────────┘
           │              │
     Grounding       MCP (Streamable HTTP)
     with Bing            │
                          ▼
              ┌───────────────────────┐
              │   Python Backend      │
              │   (Azure App Service) │
              │                       │
              │  ┌─────────────────┐  │
              │  │  MCP Server     │  │
              │  │  /mcp           │  │
              │  └─────────────────┘  │
              │  ┌─────────────────┐  │
              │  │  REST API       │  │
              │  │  /api/lightbulb │  │
              │  └─────────────────┘  │
              │  ┌─────────────────┐  │
              │  │  React Frontend │  │
              │  │  (static files) │  │
              │  └─────────────────┘  │
              └───────────────────────┘
```

## Project Structure

```
foundry-agents-101/
├── azure.yaml              # Azure Developer CLI project config
├── infra/                  # Bicep infrastructure-as-code
├── src/app/
│   ├── backend/            # Python FastAPI + MCP server
│   └── frontend/           # React lightbulb UI
└── docs/                   # Lab unit guides
```

## Local Development

Run the backend and frontend in **separate terminals**. The Vite dev server proxies `/api` and `/mcp` requests to the backend automatically.

### Backend

This project uses [uv](https://docs.astral.sh/uv/) to manage Python dependencies in a virtual environment.

```bash
cd src/app/backend
uv venv
source .venv/bin/activate   # On Windows: .venv\Scripts\activate
uv pip install -r requirements.txt
uvicorn main:app --reload
```

### Frontend

```bash
cd src/app/frontend
npm install
npm run dev
```

> Open the Vite URL (default `http://localhost:5173`). API calls are proxied to the backend at `http://localhost:8000`.

## MCP Tools Reference

The lightbulb MCP server (at `/mcp`) exposes these tools:

| Tool | Description |
|------|-------------|
| `get_light_state` | Get the current on/off state and color |
| `toggle_light` | Toggle the lightbulb on or off |
| `set_color` | Set the color (red, green, blue, yellow, white) |

## Redeployment

After making code changes, redeploy with:

```bash
azd deploy
```
