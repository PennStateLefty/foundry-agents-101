# Unit 3: Knowledge Grounding with Files

## Overview

Welcome to Unit 3 of the **AI Agents with Microsoft Foundry** lab series! In this unit, you'll teach your agent something entirely new by uploading a **document as a knowledge source** — giving it domain-specific expertise that doesn't exist on the public web or in its training data.

Up to this point, your agent has a persona (Unit 1) and can search the web with Bing (Unit 2). But what happens when a user asks a detailed product question — like "What's the warranty on this lightbulb?" or "Can I control the brightness?" The agent has no way to answer those questions accurately. The information isn't on the public web and it's not built into the agent's training data.

The solution is **file-based knowledge grounding** — uploading documents directly to the agent so it can retrieve and cite specific information from them. This is a form of **Retrieval-Augmented Generation (RAG)**, one of the most powerful patterns in modern AI applications. And just like everything else in this lab series, you'll do it entirely through the Foundry portal — no code required.

By the end of this unit, your agent will be able to answer detailed questions about the SmartGlow 101 lightbulb by pulling information directly from its product manual, citing the document as its source.

---

## Prerequisites

Before starting this unit, make sure you have:

- ✅ Completed [Unit 1: Creating a Declarative Agent](./unit-1-declarative-agent.md) and [Unit 2: Grounding with Bing](./unit-2-grounding-with-bing.md)
- ✅ Your **Lightbulb-Agent** agent is working in the Foundry playground with Bing Grounding enabled
- ✅ Access to the [Microsoft Foundry portal](https://ai.azure.com)
- ✅ A copy of the **SmartGlow 101 Product Manual** — the file `docs/assets/lightbulb-manual.md` from this repository

> **📝 Note:** If you don't have the lightbulb manual file handy, you can find it in this repository at `docs/assets/lightbulb-manual.md`. Download or copy it to a location you can easily browse to when uploading.

---

## What is File-Based Knowledge Grounding?

In Unit 2, you gave your agent the ability to search the web using Bing. That's one form of grounding — connecting the agent to an external data source so its answers are based on real information. But web search has limitations:

- It can only find information that's **publicly available** on the internet
- It may return **irrelevant or noisy results** for niche or domain-specific topics
- It has **no access** to internal documents, proprietary manuals, or organizational knowledge

**File-based knowledge grounding** solves these problems by letting you upload documents directly to the agent. When the agent receives a question, it can **search through those uploaded documents** to find relevant information, then incorporate that information into its response — complete with citations back to the source document.

This pattern is called **Retrieval-Augmented Generation (RAG)**:

| Step | What Happens |
|---|---|
| **Retrieval** | The agent searches through the uploaded documents to find passages relevant to the user's question |
| **Augmentation** | The retrieved passages are added to the agent's context alongside the user's question |
| **Generation** | The language model generates a response informed by both the question and the retrieved content |

RAG is one of the most widely used patterns in enterprise AI because it lets you give an agent **specialized knowledge** without retraining the underlying model. You simply upload the documents you want the agent to know about, and it handles the rest.

### File Grounding vs. Web Grounding

Both file grounding and web grounding (Bing) serve the same fundamental purpose: giving the agent access to information beyond its training data. But they're designed for different scenarios:

| | File Grounding | Web Grounding (Bing) |
|---|---|---|
| **Data source** | Documents you upload (PDFs, Word docs, Markdown, etc.) | The public internet via Bing search |
| **Best for** | Internal docs, product manuals, policies, FAQs, proprietary data | Current events, general knowledge, publicly available information |
| **Control** | You control exactly what the agent knows | Results depend on what Bing finds |
| **Privacy** | Documents stay within your Azure environment | Queries go through the Bing search service |
| **Citations** | Cites the specific uploaded document | Cites web URLs |
| **Freshness** | As current as the documents you upload | Real-time web results |

The real power comes from using **both together**. Your agent can answer product-specific questions from uploaded documents while still answering general knowledge questions from the web. Foundry handles the routing automatically — the agent decides which knowledge source to consult based on the question.

> **💡 Tip:** Think of file grounding as giving your agent a "company handbook." It can reference that handbook for internal questions, but it still has access to the internet (Bing) for everything else. In later units, you'll also connect MCP tools for even more capabilities.

### When to Use File Grounding

File grounding is ideal when your agent needs to answer questions about:

- **Product documentation** — Manuals, specifications, feature lists, compatibility information
- **Internal policies** — HR policies, IT procedures, security guidelines, compliance rules
- **FAQs and troubleshooting guides** — Known issues, step-by-step solutions, common questions
- **Organizational knowledge** — Process documents, onboarding materials, team wikis
- **Domain-specific content** — Anything that isn't publicly available or well-represented on the web

In this unit, you'll upload the **SmartGlow 101 Product Manual** — a document containing product specifications, usage instructions, troubleshooting tips, warranty information, and more. This gives your agent deep knowledge about the lightbulb product it controls.

---

## Steps

### Step 1: Review the Product Manual

Before uploading, let's take a look at the document you'll be giving to your agent.

1. Open the file `docs/assets/lightbulb-manual.md` from this repository in a text editor or viewer.
2. Skim through the contents. Notice that the manual includes:
   - Product overview and specifications
   - A getting started guide
   - Usage instructions for controlling the lightbulb
   - A list of supported colors and their limitations
   - A detailed troubleshooting FAQ with 10+ Q&A pairs
   - Safety information
   - Warranty details

3. Pay special attention to information that **only exists in this document** and isn't available through Bing or the MCP tools:
   - The product name "SmartGlow 101"
   - Warranty terms and conditions
   - Safety guidelines
   - Specific troubleshooting steps
   - The fact that brightness control and scheduling are not supported

> **📝 Note:** This manual is written specifically for the workshop. In a real-world scenario, you'd upload your organization's actual product documentation, policy documents, or knowledge base articles.

> **💡 Tip:** The quality of the agent's file-grounded responses depends directly on the quality of the documents you upload. Well-structured documents with clear headings, concise answers, and specific details produce the best results.

---

### Step 2: Navigate to the Agent's Tools Section

Now let's find where to upload the document in the Foundry portal.

1. Open the [Microsoft Foundry portal](https://ai.azure.com) and navigate to your project.
2. Select the **Build** tab on top-right. In the left-hand navigation, click on **Agents**.
3. Select the **Lightbulb-Agent** agent to open its configuration.
4. Scroll down to the **Tools** section — the same section where you previously added Bing Grounding.

> **📝 Note:** Foundry also has a dedicated **Knowledge** section where you can create knowledge bases and configure multiple grounding sources with more control — including integration with **Foundry IQ**, which provides semantic understanding, automated retrieval pipelines, and enterprise-grade knowledge management. For production agents with many document sources, Knowledge and Foundry IQ are the recommended approach. However, for this lab we'll use the simpler **Upload Files** option in the Tools section, which creates an **automated vector index** from your documents behind the scenes — giving you RAG capabilities with zero configuration.

---

### Step 3: Upload the Product Manual

Time to give your agent product expertise by uploading the lightbulb manual.

1. In the **Tools** section, click **Upload Files**.
2. Browse to the `docs/assets/lightbulb-manual.md` file from this repository and select it for upload.
3. Wait for the upload and indexing to complete. Foundry will automatically process the document, create a vector index from its contents, and make it searchable by the agent.
4. Once uploaded, you should see the file listed in the Tools section for your agent.
5. **Save** your agent configuration.

> **💡 Tip:** Foundry supports multiple file formats for upload, including Markdown, PDF, Word documents, and plain text. The SmartGlow manual is in Markdown format, which works well because it has clear structure and headings that help the vector index create meaningful chunks for retrieval.

> **📝 Note:** Behind the scenes, Foundry splits the document into chunks, generates vector embeddings for each chunk, and stores them in an automated index. When the agent receives a question, it searches this index to find the most relevant passages — all without you having to configure any of this. This is the same RAG pattern that enterprises build custom pipelines for, delivered as a single click.

---

### Step 4: Update the Agent Instructions

Now that the agent has access to the product manual, let's update its instructions to tell it about this new knowledge source.

1. In the agent configuration, scroll up to the **Instructions** field.
2. Update the system instructions to reference the product manual. Replace the existing instructions with:

   ```
   You are a helpful assistant that can control a smart lightbulb. You can turn the light on and off, and change its color. When the user asks you to perform an action on the lightbulb, confirm what you are doing. Be friendly and concise.

   You have access to the SmartGlow 101 Product Manual. When users ask questions about the lightbulb product — such as specifications, supported features, troubleshooting, warranty, or safety information — refer to the product manual to provide accurate, detailed answers. Cite the manual when your answer comes from it.

   If a question is about product knowledge (like supported colors, limitations, or warranty), refer to the product manual. If a question is about general topics or current events, use web search.
   ```

3. **Save** the updated configuration.

> **💡 Tip:** Notice how the updated instructions give the agent **guidance on when to use each knowledge source**. This helps the agent make smarter decisions about whether to consult the manual or search the web. You're essentially teaching the agent a decision-making framework.

> **📝 Note:** While the agent can often figure out which knowledge source to use on its own, explicit instructions improve consistency. Clear routing guidance in the system prompt reduces the chance of the agent searching the web for something that's already in the uploaded manual.

---

### Step 5: Test with Product Knowledge Questions

Time to see file-based knowledge grounding in action! Let's test the agent with questions that specifically require information from the uploaded manual.

1. In the Foundry portal, open the **playground** for your Lightbulb-Agent agent.
2. Start with a straightforward product question:

   ```
   What colors does the SmartGlow lightbulb support?
   ```

   Observe the response. You should notice:
   - ✅ The agent lists the five supported colors: **red, green, blue, yellow, and white**
   - ✅ The response references or cites the product manual as the source
   - ✅ The answer is specific and accurate — not a vague guess

3. Now ask a question about a feature limitation:

   ```
   Can I set a custom color like purple?
   ```

   The agent should clearly explain:
   - ✅ No, custom colors are not supported
   - ✅ Only the five preset colors are available
   - ✅ The information comes from the product manual

4. Try a troubleshooting question:

   ```
   How do I troubleshoot a light that won't turn on?
   ```

   The agent should provide the troubleshooting steps from the manual:
   - ✅ Check that the app is deployed and running
   - ✅ Verify the URL loads in a browser
   - ✅ Check the Azure App Service in the portal
   - ✅ Confirm the MCP connection is configured correctly

5. Ask about state persistence:

   ```
   Is the lightbulb state persistent across restarts?
   ```

   The agent should explain:
   - ✅ No, state is stored in memory only
   - ✅ State resets to off/white when the server restarts
   - ✅ This is by design for the workshop

6. Test a feature-availability question:

   ```
   Can I control the brightness?
   ```

   The agent should clearly state:
   - ✅ No, brightness control is not supported
   - ✅ The lightbulb is either on (full brightness) or off
   - ✅ There are no dimming capabilities

7. Ask about warranty information — something that only exists in the manual:

   ```
   What's the warranty on this lightbulb?
   ```

   The agent should provide warranty details from the manual:
   - ✅ The warranty duration and what is covered
   - ✅ What is NOT covered
   - ✅ How to make a warranty claim

> **💡 Tip:** Pay attention to the **citations** in the agent's responses. When the agent pulls information from the uploaded manual, it should indicate that the answer comes from the document. This transparency helps users trust the response and verify the information.

---

### Step 6: Compare Knowledge Sources

Now let's see how the agent intelligently selects between its different knowledge sources depending on the question. This is where the multi-source architecture really shines.

1. Ask a question that the **product manual** should answer:

   ```
   What safety precautions should I follow with the SmartGlow 101?
   ```

   **Expected:** The agent references the manual's safety section, citing the uploaded document.

2. Ask a question that **Bing** should answer:

   ```
   What's happening in the tech industry today?
   ```

   **Expected:** The agent searches the web and returns current news with web citations.

3. Now try a question that **combines knowledge sources**:

   ```
   The product manual says five colors are supported. Can you tell me more about them and also search for the latest smart home trends?
   ```

   **Expected:** The agent references the manual for the supported colors, and uses Bing for smart home trends — using both file knowledge and web search in a single response.

4. Try a deliberately tricky question:

   ```
   Can I set the light to purple?
   ```

   **Expected:** The agent should reference the product manual to explain that only five preset colors are supported. The file knowledge helps the agent answer accurately rather than guessing.

> **📝 Note:** The agent's ability to choose the right knowledge source is one of the most powerful aspects of this architecture. It's not following rigid rules — it's using the question context and the available knowledge to make intelligent decisions. Sometimes it may not choose perfectly, and that's okay. Refining your instructions and document quality improves accuracy over time.

---

### Step 7: Observe Hybrid Grounding in Action

Let's run one final experiment to see the full breadth of your agent's capabilities working together.

1. Start a new conversation in the playground and send this multi-part request:

   ```
   I'm setting up my SmartGlow 101 for the first time. Can you tell me what colors are available and what the warranty covers? Also, what are the latest trends in smart home lighting?
   ```

2. Watch how the agent handles this complex request. It should:
   - ✅ Reference the **product manual** to list the available colors and warranty details
   - ✅ Use **Bing web search** to find current smart home lighting trends
   - ✅ Synthesize everything into a coherent, helpful response

3. This single interaction demonstrates the agent using **two different knowledge sources** in one turn — file grounding and web search. This is hybrid grounding in action.

> **💡 Tip:** If the agent doesn't use all the expected sources in a single turn, try breaking the request into parts or being more explicit. Complex multi-source requests can be challenging for the agent, and iterating on your prompt is part of the learning process.

> **📝 Note:** In later units, you'll connect MCP tools that let the agent take real actions — like controlling the lightbulb and searching technical documentation. Combined with the file knowledge and web search you've set up here, this will give your agent a truly comprehensive set of capabilities.

---

## Summary

Congratulations! 🎉 You've given your agent deep product knowledge by uploading a document as a knowledge source. Here's what you've accomplished across the lab so far:

| Unit | What You Added | Capability |
|---|---|---|
| **Unit 1** | Declarative agent + system instructions | Agent has a persona and can chat |
| **Unit 2** | Grounding with Bing | Agent can search the web for real-time information |
| **Unit 3** | File-based knowledge grounding | Agent can answer questions from uploaded documents with citations |

Your Lightbulb-Agent now has:

- 🤖 **Custom persona and instructions** — defining how it behaves and routes questions
- 🌐 **Web search via Bing** — for real-time information and current events
- 📄 **Product manual knowledge** — for domain-specific questions, troubleshooting, and product details

### Key Takeaway

File-based knowledge grounding turns your agent into a **domain expert**. Instead of relying solely on its training data or web search, the agent can reference specific documents you provide — product manuals, policy guides, FAQs, or any other organizational knowledge. Combined with Bing for web knowledge, you now have an agent with a **hybrid knowledge architecture**.

And once again, you accomplished all of this through **configuration, not code**. The RAG pattern that enterprises spend months implementing with custom code — you set it up in minutes through the Foundry portal.

### What's Next

In **[Unit 4: Instructions & Conversational Flow](./unit-4-instructions-and-flow.md)**, you'll take a step back from adding new capabilities and focus on **how your agent communicates**. You'll replace the basic system prompt with a structured prompt that defines the agent's role, scope, personality, behavioral rules, and conversational patterns — giving your agent polish before connecting it to external tools.

---

## Key Concepts

Here's a quick reference of the key concepts covered in this unit:

- **Retrieval-Augmented Generation (RAG)** — A pattern where the agent retrieves relevant information from external documents, augments its context with that information, and then generates a response informed by the retrieved content. RAG lets agents answer questions using specific, authoritative sources without retraining the model.

- **File Knowledge Sources** — Documents uploaded to a Foundry agent that it can search and reference when answering questions. Supported formats include Markdown, PDF, Word documents, and plain text. The documents are indexed so the agent can efficiently find relevant passages.

- **Document Grounding** — The practice of connecting an agent to specific uploaded documents so its responses are grounded in that content. Similar to web grounding (Bing), but using your own documents instead of public web results. This ensures the agent provides answers based on authoritative, controlled content.

- **Knowledge Source Selection** — The agent's ability to intelligently decide which knowledge source to consult for a given question — the uploaded documents, Bing web search, or its own training data. In later units, MCP tools will add another dimension to this selection. Effective system instructions improve the agent's selection accuracy.

- **Citation from Uploaded Documents** — When the agent answers a question using information from an uploaded file, it can cite the source document. This transparency lets users verify the information and builds trust in the agent's responses.

- **Hybrid Grounding** — Using multiple grounding sources together — such as file uploads and web search — so the agent can draw from the best source for each question. In later units, you'll add MCP tools for an even richer hybrid architecture. Foundry handles the orchestration automatically, and the agent selects the appropriate source based on context.

- **Foundry IQ** — Microsoft Foundry's advanced knowledge management system for agents. Foundry IQ provides enterprise-grade retrieval pipelines, semantic understanding, and unified access to organizational data. For production agents with many document sources across different systems, Foundry IQ and the dedicated **Knowledge** section in the portal offer more control than the simple file upload approach used in this unit — including custom indexing strategies, data source connections, and knowledge graph integration.

> **💡 Tip:** As you build agents for real-world use cases, think carefully about which documents to upload. The most effective knowledge sources are well-structured, up-to-date, and focused on the domain your agent serves. Regularly updating your uploaded documents keeps the agent's knowledge current.
