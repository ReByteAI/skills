---
name: Spreadsheet Workflow
description: Research data from the internet and build a professional online spreadsheet. Use when user wants to create a spreadsheet that requires gathering external data first — market research, competitor analysis, pricing comparisons, statistics, rankings, or any structured data from the web. Triggers include "research and build spreadsheet", "find data and make a spreadsheet", "create a spreadsheet of", "compare X in a spreadsheet", "build a tracker with real data".
---

# Spreadsheet Workflow

Build spreadsheets backed by real, researched data. This workflow connects research skills with the spreadsheet builder to go from a user's question to a finished, shareable spreadsheet.

## Sub-Skills

- `rebyteai/internet-search` — Quick web search for facts, figures, and data points
- `rebyteai/deep-research` — Comprehensive multi-source research with citations when the topic requires depth (10+ sources, trend analysis, conflicting data)
- `rebyteai/data-scraper` — Extract structured data from specific websites (tables, lists, product pages) when search results point to a rich data source
- `rebyteai/spreadsheet-builder` — Create the final online spreadsheet with formatted cells, formulas, and multiple sheets

## Workflow

### Step 1: Understand the Request

Parse what the user wants. Identify:
- **What data** — What entities, metrics, or facts need to be in the spreadsheet?
- **How many rows** — Is this 10 items or 500? This affects which search strategy to use.
- **Structure** — What columns make sense? What's the primary key (name, date, company, etc.)?
- **Calculations** — Does the user need totals, averages, percentages, or comparisons?

Do NOT start searching yet. First, confirm your understanding with the user if the request is ambiguous. If it's clear, proceed directly.

### Step 2: Gather Data

Choose your research strategy based on complexity:

**Simple data (< 20 items, factual):**
Use `internet-search`. Run 2-5 targeted searches to collect the data points. Example: "top 10 programming languages by popularity 2025", "average salary software engineer by city".

**Complex data (20+ items, multi-faceted, or requires synthesis):**
Use `deep-research`. This handles multi-source gathering, cross-referencing, and citation tracking automatically. Example: "comprehensive comparison of all major cloud providers across 15 dimensions".

**Structured web data (tables on specific sites):**
Use `data-scraper` when you've identified a specific webpage that has the data in a table or list format. Example: scraping a product catalog, a rankings page, or a government statistics table.

**Combination:**
For many real requests, you'll combine these. Example: use `internet-search` to find which websites have the data, then `data-scraper` to extract it, then `deep-research` to fill gaps or add context.

### Step 3: Process and Structure

Before building the spreadsheet, organize the collected data:

1. **Deduplicate** — Remove redundant data from multiple sources
2. **Normalize** — Ensure consistent units (all prices in USD, all dates in same format)
3. **Validate** — Cross-check numbers across sources when possible. Flag any data that seems unreliable.
4. **Structure** — Decide final column layout. Put the most important columns first. Group related columns together.
5. **Identify formulas** — Determine which cells should be calculated (totals, averages, percentages, growth rates) rather than hardcoded

### Step 4: Build the Spreadsheet

Use `spreadsheet-builder` to create the spreadsheet:

1. **Name the sheet** descriptively (e.g., "Cloud Provider Comparison", not "Sheet 1")
2. **Set column widths** first for clean layout
3. **Write headers** with `"s": "header"` styling
4. **Populate data** row by row
5. **Add formulas** for calculated fields (SUM, AVERAGE, percentages)
6. **Add a summary section** if the data warrants it (totals row, key takeaways)
7. **Create additional sheets** if the data naturally segments (e.g., "Raw Data" + "Summary" + "Charts")

### Step 5: Present Results

After building the spreadsheet:

1. Share the spreadsheet URL with the user
2. Explain what's in it:
   - How many rows/columns of data
   - What sources the data came from
   - Any formulas or calculations included
   - Any data gaps or caveats (e.g., "2024 data used where 2025 wasn't available")
3. Ask if the user wants any modifications (additional columns, different sorting, more data)

## Decision Points

- **"Should I use internet-search or deep-research?"** — If the user's request can be answered with a few Google searches and the data is factual/numerical, use `internet-search`. If it requires synthesizing information from many sources, comparing viewpoints, or building a comprehensive picture, use `deep-research`.

- **"Should I use data-scraper?"** — Only when you've identified a specific URL that contains structured data you need. Don't scrape blindly. Search first, then scrape the specific pages that have what you need.

- **"The data is incomplete"** — Tell the user. Never fill cells with made-up numbers. Use "N/A" or leave blank, and explain what's missing and why.

- **"The user wants ongoing updates"** — The spreadsheet is a snapshot. Explain that the data reflects the time of creation. If they need live data, suggest they re-run the workflow periodically.
