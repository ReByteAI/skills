---
name: Stock Analysis Workflow
description: Analyze stocks with real market data, SEC filings, and interactive charts. Use when user wants stock analysis, company financials, investment research, portfolio comparison, or earnings analysis. Triggers include "analyze stock", "stock analysis", "compare stocks", "SEC filing", "company financials", "investment research", "earnings analysis", "portfolio analysis", "stock chart".
---

# Stock Analysis Workflow

Perform comprehensive stock analysis combining real-time market data, SEC filings, web research, and interactive visualizations. Delivers results as charts, spreadsheets, or deployed web apps.

## Sub-Skills

- `rebyteai/market-data` — US stock prices, OHLCV bars (1min to 1week), news with sentiment, company details. Covers all US tickers with 5 years of history.
- `rebyteai/sec-edgar-skill` — SEC EDGAR filings: 10-K, 10-Q, 8-K, proxy statements, 13F holdings, Form 4 insider trading. Uses EdgarTools Python library.
- `rebyteai/internet-search` — General web search for analyst opinions, news, industry context, and background knowledge not available in structured data sources.
- `rebyteai/echarts` — Interactive charts via pyecharts: candlestick, line, bar, pie, heatmap. Output as self-contained HTML.
- `rebyteai/spreadsheet-builder` — Create structured spreadsheets for raw data, comparison tables, and financial models.
- `rebyteai/rebyte-app-builder` — Deploy interactive dashboards and analysis results as web apps on rebyte.pro.

## Workflow

### Step 1: Understand the Analysis

Parse what the user wants. Identify:
- **Tickers** — Which stocks or companies? (e.g., AAPL, TSLA, NVDA)
- **Analysis type** — Price analysis, fundamental analysis, comparison, sector analysis, earnings review?
- **Time horizon** — Last week, 6 months, 5-year trend?
- **Output format** — Charts, spreadsheet, deployed dashboard, or just a summary?
- **Specific metrics** — P/E ratio, revenue growth, margins, debt, insider activity?

If the request is clear, proceed directly. If ambiguous, ask for the tickers and what they want to learn.

### Step 2: Gather Market Data

Use `market-data` to pull structured stock data:

- **Price history** — OHLCV bars at appropriate intervals (daily for months/years, hourly for weeks, minute for intraday)
- **Company details** — Market cap, sector, description, key stats
- **News** — Recent articles with sentiment scores for context

For multi-stock comparisons, pull data for all tickers in parallel.

### Step 3: Pull SEC Filings (if needed)

Use `sec-edgar-skill` when the analysis requires fundamentals:

- **10-K annual reports** — Revenue, earnings, segments, risk factors, R&D spending
- **10-Q quarterly reports** — Recent quarter performance, trends
- **8-K current reports** — Material events, acquisitions, leadership changes
- **13F filings** — Institutional holdings (e.g., Berkshire Hathaway's portfolio)
- **Form 4** — Insider buying/selling patterns
- **Proxy statements** — Executive compensation

Extract the specific numbers and metrics needed. Don't dump entire filings — pull targeted data points.

### Step 4: Research Context

Use `internet-search` to fill gaps that structured data doesn't cover:

- Analyst ratings and price targets
- Industry trends and competitive landscape
- Recent news not yet in market-data (mergers, lawsuits, product launches)
- Macro factors affecting the stock (interest rates, regulation, geopolitics)

This step provides the narrative that connects the numbers. Skip if the user only wants raw data/charts.

### Step 5: Visualize

Use `echarts` to create interactive charts. Match chart type to data:

| Analysis | Chart Type |
|----------|------------|
| Price history | Candlestick or line chart with volume bars |
| Stock comparison | Multi-line chart (normalized to % change) |
| Revenue/earnings trend | Bar chart with YoY growth line overlay |
| Segment breakdown | Pie or stacked bar chart |
| Sector comparison | Horizontal bar chart ranked by metric |
| Correlation | Scatter plot or heatmap |
| Portfolio allocation | Treemap or pie chart |

Always include:
- Clear title and axis labels
- Tooltips showing exact values
- Legend for multi-series charts
- Appropriate time formatting on x-axis

### Step 6: Deliver Results

Choose delivery based on complexity:

**Simple analysis (1-2 charts, summary):**
- Generate charts as HTML files
- Write a text summary with key findings
- Upload charts to Artifact Store

**Comprehensive analysis (multiple charts, data tables):**
- Build an interactive dashboard with `rebyte-app-builder`
- Deploy to rebyte.pro with all charts, tables, and narrative on one page
- Share the live URL with the user

**Data-heavy output (raw numbers, comparisons):**
- Use `spreadsheet-builder` to create a structured spreadsheet
- Include raw data sheet + summary sheet with formulas

After delivering:
1. Explain key findings and what the data shows
2. Note any data limitations (e.g., "market data is 15-min delayed", "latest 10-K is from March 2025")
3. Ask if they want deeper analysis on any specific aspect

## Decision Points

- **"market-data or sec-edgar?"** — Use `market-data` for prices, OHLCV, and stock news. Use `sec-edgar-skill` for financial statements, filings, and regulatory data. Most analyses need both.

- **"Do I need internet-search?"** — Yes, if the analysis involves qualitative context (analyst opinions, industry trends, competitive positioning). No, if the user just wants charts of raw price/financial data.

- **"Chart or dashboard?"** — Single stock, single metric → one chart. Multi-stock comparison or multi-metric analysis → deploy a dashboard with `rebyte-app-builder`.

- **"How far back should data go?"** — Match the user's question. Default to 1 year for price analysis, 3-5 years for fundamental trends. Market-data supports up to 5 years.
