---
name: browser-automation
description: Browser automation using Chrome DevTools MCP. Use when the user needs to interact with web pages, test web applications, debug frontend issues, take screenshots, fill forms, or extract data from websites. Covers two workflows - Testing (UI interaction) and Scraping (data extraction).
---

# Browser Automation with Chrome DevTools MCP

Chrome DevTools MCP is pre-installed and connected to a browser instance via CDP (port 9222). Use the `mcp__chrome-devtools__*` tools for all browser interactions.

Two primary workflows:

| Workflow | Best For | Primary Tool |
|----------|----------|--------------|
| **Testing** | UI interaction, form filling, clicking buttons | `take_snapshot` + uid |
| **Scraping** | Data extraction from complex pages | `evaluate_script` |

---

## Testing Workflow

Use for: verifying deployed apps, filling forms, clicking buttons, UI testing.

### Core Pattern (uid-based)

```
1. take_snapshot    → Get page structure with element uids
2. Identify uid     → Find target element (e.g., uid="e5")
3. Interact         → click, fill, hover using the uid
4. Re-snapshot      → After navigation or DOM changes
```

### Example: Test a Login Form

```
navigate_page url="https://app.example.com/login"
take_snapshot
# Output shows: textbox "Email" [uid=e4], textbox "Password" [uid=e5], button "Sign In" [uid=e6]

fill uid="e4" value="user@example.com"
fill uid="e5" value="password123"
click uid="e6"

wait_for text="Dashboard"
take_snapshot  # Verify login succeeded
```

### Example: Test Navigation Flow

```
navigate_page url="https://app.example.com"
take_snapshot
click uid="e3"  # Click menu item

wait_for text="Settings"
take_snapshot
# Verify correct page loaded
```

### Testing Tools

| Tool | Purpose |
|------|---------|
| `take_snapshot` | Get accessibility tree with uids |
| `click` | Click element by uid |
| `fill` | Type into input by uid |
| `hover` | Hover over element |
| `press_key` | Keyboard input (Enter, Tab, etc.) |
| `wait_for` | Wait for text/element to appear |
| `take_screenshot` | Visual verification |

### Testing Best Practices

**Always re-snapshot after navigation** - UIDs are invalidated after page changes:
```
click uid="e3"           # Triggers navigation
wait_for text="Dashboard"
take_snapshot            # Get fresh uids!
```

**Wait for dynamic content** before interacting:
```
wait_for text="Loading complete"
take_snapshot
```

---

## Scraping Workflow

Use for: extracting data from websites, bulk data collection, parsing complex pages.

### Core Pattern (JavaScript-based)

```
1. navigate_page    → Go to target URL
2. wait_for         → Ensure content loaded
3. evaluate_script  → Run JavaScript to extract data
4. (optional)       → Paginate and repeat
```

### Example: Scrape Product Listings

```
navigate_page url="https://www.amazon.com"

# Search for products
evaluate_script function="() => {
  document.querySelector('#twotabsearchtextbox').value = 'mechanical keyboard';
  document.querySelector('#nav-search-submit-button').click();
}"

wait_for text="results"

# Extract product data
evaluate_script function="() => {
  const products = [];
  document.querySelectorAll('[data-component-type=\"s-search-result\"]').forEach(item => {
    const title = item.querySelector('h2 span')?.textContent?.trim();
    const price = item.querySelector('.a-price .a-offscreen')?.textContent?.trim();
    const rating = item.querySelector('.a-icon-star-small span')?.textContent?.trim();
    if (title) products.push({ title, price, rating });
  });
  return products;
}"
```

### Example: Scrape Table Data

```
navigate_page url="https://example.com/data-table"
wait_for text="Table loaded"

evaluate_script function="() => {
  const rows = [];
  document.querySelectorAll('table tbody tr').forEach(row => {
    const cells = Array.from(row.querySelectorAll('td')).map(td => td.textContent.trim());
    rows.push(cells);
  });
  return rows;
}"
```

### Example: Scrape with Pagination

```
evaluate_script function="() => {
  const allData = [];

  // Extract current page
  document.querySelectorAll('.item').forEach(item => {
    allData.push(item.textContent);
  });

  // Check for next page
  const nextBtn = document.querySelector('.next-page');
  return { data: allData, hasNext: !!nextBtn };
}"

# If hasNext, click next and repeat
click uid="<next-button-uid>"
wait_for text="Page 2"
# Extract again...
```

### Scraping Tools

| Tool | Purpose |
|------|---------|
| `navigate_page` | Go to URL |
| `wait_for` | Wait for content to load |
| `evaluate_script` | Run JavaScript to extract/interact |
| `list_network_requests` | Monitor API calls (useful for finding data endpoints) |

### Scraping Best Practices

**Use evaluate_script for complex pages** - More precise than parsing snapshots:
```
evaluate_script function="() => document.querySelector('.price').textContent"
```

**Find API endpoints** instead of scraping HTML when possible:
```
list_network_requests resourceTypes=["xhr", "fetch"]
get_network_request reqid=<id>
# Often returns clean JSON data
```

**Handle dynamic loading**:
```
wait_for text="Results loaded"
# or
evaluate_script function="() => new Promise(resolve => setTimeout(resolve, 2000))"
```

---

## Debugging Tools

Available for both workflows:

```
list_console_messages              # Check for JS errors
list_network_requests              # Inspect API calls
get_network_request reqid=5        # Get request/response details
take_screenshot                    # Visual verification
```

## Troubleshooting

### Element Not Found (Testing)
1. Page may have changed - take fresh snapshot
2. Element in iframe - check snapshot structure
3. Element hidden - wait for it to appear

### Data Not Extracted (Scraping)
1. Content not loaded - add wait_for
2. Wrong selector - inspect page with evaluate_script
3. Data loaded via API - check network requests instead
