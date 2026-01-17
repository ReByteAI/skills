---
name: market-data
description: Access US stock market data including price bars, news with sentiment, and company details via rebyte data API. Use when user asks for stock prices, OHLCV data, price history, stock news, or company information. Triggers include "stock price", "price history", "OHLCV", "stock news", "company info", "market data", "ticker data". Do NOT use for SEC filings (use sec-edgar-skill instead).
---

# Market Data API

Access US stock market data through rebyte's data proxy service.

{{include:auth.md}}

## Data Coverage

- **All US stock tickers**
- **5 years of historical data**
- **100% market coverage**
- **15-minute delayed quotes**

---

## Available Endpoints

| Endpoint | Purpose |
|----------|---------|
| `POST $API_URL/api/data/stocks/bars` | OHLCV price bars (1min to 1week intervals) |
| `POST $API_URL/api/data/stocks/news` | News articles with sentiment analysis |
| `POST $API_URL/api/data/stocks/details` | Company information and market cap |

---

## Get Price Bars

Retrieve OHLCV (Open, High, Low, Close, Volume) bars for a stock.

```bash
curl -X POST "$API_URL/api/data/stocks/bars" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "ticker": "AAPL",
    "interval": "1day",
    "from": "2024-12-01",
    "to": "2024-12-31"
  }'
```

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `ticker` | string | Yes | Stock symbol (e.g., `AAPL`, `MSFT`) |
| `interval` | string | Yes | `1min`, `5min`, `15min`, `30min`, `1hour`, `4hour`, `1day`, `1week` |
| `from` | date | Yes | Start date (`YYYY-MM-DD`) |
| `to` | date | Yes | End date (`YYYY-MM-DD`) |

**Response:**
```json
{
  "ticker": "AAPL",
  "count": 21,
  "bars": [
    {
      "t": "2024-12-02T05:00:00.000Z",
      "o": 237.27,
      "h": 240.79,
      "l": 237.16,
      "c": 239.59,
      "v": 48137103,
      "vw": 239.4992,
      "n": 469685
    }
  ]
}
```

**Response Fields:**

| Field | Description |
|-------|-------------|
| `t` | Timestamp (ISO 8601 UTC) |
| `o` | Open price |
| `h` | High price |
| `l` | Low price |
| `c` | Close price |
| `v` | Volume |
| `vw` | Volume-weighted average price |
| `n` | Number of transactions |

---

## Get News

Retrieve financial news articles with sentiment analysis.

```bash
curl -X POST "$API_URL/api/data/stocks/news" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "ticker": "TSLA",
    "limit": 5
  }'
```

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `ticker` | string | Yes | Stock symbol |
| `limit` | number | No | Max articles (default: 10, max: 100) |

**Response:**
```json
{
  "count": 5,
  "articles": [
    {
      "title": "Tesla Stock Rises on Strong Delivery Numbers",
      "description": "Tesla reported better-than-expected Q4 deliveries...",
      "author": "John Smith",
      "publisher": "Reuters",
      "publishedAt": "2025-01-06T14:30:00Z",
      "url": "https://...",
      "tickers": ["TSLA"],
      "keywords": ["electric vehicles", "deliveries"],
      "sentiment": "positive",
      "sentimentReasoning": "Article discusses strong delivery numbers and positive market reaction."
    }
  ]
}
```

**Sentiment Values:** `positive`, `negative`, `neutral`

---

## Get Company Details

Retrieve company information for a stock ticker.

```bash
curl -X POST "$API_URL/api/data/stocks/details" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"ticker": "AAPL"}'
```

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `ticker` | string | Yes | Stock symbol |

**Response:**
```json
{
  "ticker": "AAPL",
  "name": "Apple Inc.",
  "description": "Apple Inc. designs, manufactures, and markets smartphones...",
  "market": "stocks",
  "primaryExchange": "XNAS",
  "type": "CS",
  "currencyName": "usd",
  "marketCap": 3949128102780,
  "listDate": "1980-12-12",
  "sicDescription": "ELECTRONIC COMPUTERS",
  "homepage": "https://www.apple.com",
  "totalEmployees": 164000
}
```

---

## Using with Python

```python
import subprocess
import requests
import json

# Get auth token and API URL
AUTH_TOKEN = subprocess.check_output(["rebyte-auth"]).decode().strip()
with open('/home/user/.rebyte.ai/auth.json') as f:
    API_URL = json.load(f)['sandbox']['relay_url']

HEADERS = {"Authorization": f"Bearer {AUTH_TOKEN}"}

def get_price_bars(ticker: str, interval: str, from_date: str, to_date: str):
    """Get OHLCV price bars for a stock."""
    response = requests.post(
        f"{API_URL}/api/data/stocks/bars",
        headers=HEADERS,
        json={
            "ticker": ticker,
            "interval": interval,
            "from": from_date,
            "to": to_date
        }
    )
    return response.json()

def get_news(ticker: str, limit: int = 10):
    """Get news articles with sentiment for a stock."""
    response = requests.post(
        f"{API_URL}/api/data/stocks/news",
        headers=HEADERS,
        json={"ticker": ticker, "limit": limit}
    )
    return response.json()

def get_company_details(ticker: str):
    """Get company information."""
    response = requests.post(
        f"{API_URL}/api/data/stocks/details",
        headers=HEADERS,
        json={"ticker": ticker}
    )
    return response.json()

# Examples
bars = get_price_bars("AAPL", "1day", "2024-12-01", "2024-12-31")
print(f"Got {bars['count']} bars for {bars['ticker']}")

news = get_news("TSLA", limit=5)
for article in news['articles']:
    print(f"[{article['sentiment']}] {article['title']}")

details = get_company_details("NVDA")
print(f"{details['name']}: Market Cap ${details['marketCap']:,}")
```

---

## Error Handling

**Missing or Invalid Auth Token:**
```json
{
  "error": "Missing sandbox token"
}
```
Solution: Run `rebyte-auth` and include the token in your request.

**Invalid Parameters:**
```json
{
  "error": "Invalid parameters",
  "message": "Missing required parameter: ticker"
}
```

---

## Important Notes

- **Tickers must be UPPERCASE** (e.g., `AAPL`, not `aapl`)
- **All timestamps are UTC** (ISO 8601 format)
- **Price data is 15-minute delayed**
- **Historical data available for 5 years**
- **No rate limits** (use responsibly)

---

## Combining with Other Skills

This skill provides **market data**. Combine with:

- **sec-edgar-skill** (EdgarTools) - SEC filings, financial statements
- **financial-deep-research** - Full research workflow and reports

**Example combined workflow:**
1. Get company details and recent price bars (this skill)
2. Get SEC filings and financial statements (sec-edgar-skill)
3. Generate comprehensive research report (financial-deep-research)
