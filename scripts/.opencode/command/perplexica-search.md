---
description: AI search with citations
---

## Arguments
- `$ARGUMENTS` contains the full natural-language query (context + desired outcome).
- If `$ARGUMENTS` is empty or unclear, ask the user to restate the question.

**CRITICAL – follow these steps exactly**

Steps
1. Parse the user request and restate the research goal (topic + desired output).
2. Choose the best Perplexica focus mode:
   - `webSearch` – general news or mixed sources
   - `academicSearch` – research papers, reports, data
   - `writingAssistant` – drafting or outlining content
   - `redditSearch` – community sentiment or discussions
   - `youtubeSearch` – video explainers or walkthroughs
   - `wolframAlphaSearch` – factual calculations or reference data
3. Execute the query exclusively through the CLI:
   ```bash
   node Scripts/perplexica-cli.js "$QUERY" --mode $FOCUS_MODE
   ```
   - The CLI builds the payload, enforces a 300s timeout, and returns JSON with
     `message` (summary) and `sources` (title + URL).
4. Parse the CLI output:
   - Extract the primary answer from `message`.
   - Collect each source title and URL from `sources`.
   - Capture the reported runtime (printed by the CLI).
5. Produce the final response:
   - 2–3 sentence summary covering the main findings.
   - Bullet list of the top sources with titles + URLs.
   - Mention number of sources, focus mode, and elapsed time.

**Query optimization tips**
- Add “latest” or “recent” for up-to-date info.
- Use “how to” for procedural queries.
- Add “comparison”/“vs” for trade-off analysis.
- Use “analysis” or “report” for deep dives.

**Sample queries**
- “What are the latest NIST controls for AI supply-chain security audits?”
- “How do open-weight LLMs reduce compliance inference costs in 2025 enterprise workloads?”
- “Which newly approved NASA missions will monitor solar storms over the next decade?”

**Error handling**
- If a specialized mode fails, retry with `webSearch`.
- Confirm the Perplexica endpoint (default `http://localhost:3000/api/search`).
- The CLI already retries on transient failures; only rerun if it exits with an error.

Output: Summary paragraph followed by a numbered source list and search metadata.
