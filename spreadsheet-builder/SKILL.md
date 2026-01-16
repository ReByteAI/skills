---
name: Spreadsheet Builder
description: Build online spreadsheets, create shareable spreadsheets with data, financial models, reports. Share instantly via link - no Office installation required
---

# Spreadsheet Builder

Build professional online spreadsheets using Univer. Better than Excel for sharing - recipients can view instantly via link without installing Office.

## API Endpoint

```bash
curl -X POST "https://api.rebyte.ai/api/data/spreadsheet/create" \
  -H "Authorization: Bearer $(rebyte-auth)" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "My Spreadsheet",
    "commands": [...]
  }'
```

**Response:**
```json
{
  "success": true,
  "docId": "ss-Kj2mN8xQ1pRt3Y5z",
  "title": "My Spreadsheet",
  "commandCount": 15,
  "url": "https://app.rebyte.ai/drive/spreadsheets/ss-Kj2mN8xQ1pRt3Y5z"
}
```

## Command Format

Each command has this structure:

```json
{
  "id": "sheet.mutation.set-range-values",
  "params": {
    "unitId": "workbook-1",
    "subUnitId": "sheet-1",
    "range": { "startRow": 0, "endRow": 0, "startColumn": 0, "endColumn": 2 },
    "value": [[{ "v": "Cell A1" }, { "v": "Cell B1" }, { "v": "Cell C1" }]]
  }
}
```

**Notes:**
- `ts` is optional (auto-generated if missing)
- `unitId` should be `"workbook-1"`
- `subUnitId` should be `"sheet-1"` (or `"sheet-2"` for additional sheets)

## Command Types

### 1. Set Cell Values (`sheet.mutation.set-range-values`)

The main command for setting cell data.

**Single cell:**
```json
{
  "id": "sheet.mutation.set-range-values",
  "params": {
    "unitId": "workbook-1",
    "subUnitId": "sheet-1",
    "range": { "startRow": 0, "endRow": 0, "startColumn": 0, "endColumn": 0 },
    "value": [[{ "v": "Hello World" }]]
  }
}
```

**Row of data:**
```json
{
  "id": "sheet.mutation.set-range-values",
  "params": {
    "unitId": "workbook-1",
    "subUnitId": "sheet-1",
    "range": { "startRow": 0, "endRow": 0, "startColumn": 0, "endColumn": 3 },
    "value": [[
      { "v": "Name", "s": "header" },
      { "v": "Age", "s": "header" },
      { "v": "City", "s": "header" },
      { "v": "Salary", "s": "header" }
    ]]
  }
}
```

**Multiple rows:**
```json
{
  "id": "sheet.mutation.set-range-values",
  "params": {
    "unitId": "workbook-1",
    "subUnitId": "sheet-1",
    "range": { "startRow": 1, "endRow": 3, "startColumn": 0, "endColumn": 3 },
    "value": [
      [{ "v": "Alice" }, { "v": 28 }, { "v": "NYC" }, { "v": 85000 }],
      [{ "v": "Bob" }, { "v": 34 }, { "v": "LA" }, { "v": 92000 }],
      [{ "v": "Carol" }, { "v": 31 }, { "v": "Chicago" }, { "v": 78000 }]
    ]
  }
}
```

### 2. Cell Value Types

**Text:**
```json
{ "v": "Hello" }
```

**Number:**
```json
{ "v": 1234.56 }
```

**Formula:**
```json
{ "v": "", "f": "=SUM(B2:B10)" }
```

**With style reference:**
```json
{ "v": "Total", "s": "header" }
```

### 3. Set Column Width (`sheet.mutation.set-worksheet-col-width`)

```json
{
  "id": "sheet.mutation.set-worksheet-col-width",
  "params": {
    "unitId": "workbook-1",
    "subUnitId": "sheet-1",
    "colIndex": 0,
    "width": 150
  }
}
```

### 4. Set Row Height (`sheet.mutation.set-worksheet-row-height`)

```json
{
  "id": "sheet.mutation.set-worksheet-row-height",
  "params": {
    "unitId": "workbook-1",
    "subUnitId": "sheet-1",
    "rowIndex": 0,
    "height": 30
  }
}
```

### 5. Set Sheet Name (`sheet.mutation.set-worksheet-name`)

```json
{
  "id": "sheet.mutation.set-worksheet-name",
  "params": {
    "unitId": "workbook-1",
    "subUnitId": "sheet-1",
    "name": "Sales Data"
  }
}
```

### 6. Add New Sheet (`sheet.mutation.insert-sheet`)

Create additional sheets in the workbook:

```json
{
  "id": "sheet.mutation.insert-sheet",
  "params": {
    "unitId": "workbook-1",
    "sheet": {
      "id": "sheet-2",
      "name": "Summary"
    },
    "index": 1
  }
}
```

**Notes:**
- `id` is the subUnitId you'll use when adding data to this sheet
- `index` determines the tab position (0 = first, 1 = second, etc.)
- After creating a sheet, use `subUnitId: "sheet-2"` in your data commands

## Formula Reference

### Basic Formulas

| Formula | Description | Example |
|---------|-------------|---------|
| `=SUM(range)` | Sum of values | `=SUM(B2:B10)` |
| `=AVERAGE(range)` | Average of values | `=AVERAGE(C2:C20)` |
| `=COUNT(range)` | Count of numbers | `=COUNT(A1:A100)` |
| `=MAX(range)` | Maximum value | `=MAX(D2:D50)` |
| `=MIN(range)` | Minimum value | `=MIN(D2:D50)` |
| `=IF(condition, true, false)` | Conditional | `=IF(A1>100,"High","Low")` |

### Financial Formulas

| Formula | Description | Example |
|---------|-------------|---------|
| `=PMT(rate, nper, pv)` | Loan payment | `=PMT(0.05/12, 360, -200000)` |
| `=NPV(rate, values)` | Net present value | `=NPV(0.1, B2:B10)` |
| `=IRR(values)` | Internal rate of return | `=IRR(A1:A5)` |
| `=FV(rate, nper, pmt)` | Future value | `=FV(0.08, 10, -1000)` |

### Text Formulas

| Formula | Description | Example |
|---------|-------------|---------|
| `=CONCATENATE(a, b)` | Join text | `=CONCATENATE(A1, " ", B1)` |
| `=LEFT(text, n)` | Left characters | `=LEFT(A1, 3)` |
| `=RIGHT(text, n)` | Right characters | `=RIGHT(A1, 4)` |
| `=LEN(text)` | Text length | `=LEN(A1)` |
| `=UPPER(text)` | Uppercase | `=UPPER(A1)` |

### Lookup Formulas

| Formula | Description | Example |
|---------|-------------|---------|
| `=VLOOKUP(value, range, col, exact)` | Vertical lookup | `=VLOOKUP(A1, D1:F10, 2, FALSE)` |
| `=HLOOKUP(value, range, row, exact)` | Horizontal lookup | `=HLOOKUP("Q1", A1:D5, 3, FALSE)` |
| `=INDEX(range, row, col)` | Get cell by position | `=INDEX(A1:C10, 5, 2)` |
| `=MATCH(value, range, type)` | Find position | `=MATCH("Apple", A1:A10, 0)` |

### Date Formulas

| Formula | Description | Example |
|---------|-------------|---------|
| `=TODAY()` | Current date | `=TODAY()` |
| `=NOW()` | Current date/time | `=NOW()` |
| `=YEAR(date)` | Extract year | `=YEAR(A1)` |
| `=MONTH(date)` | Extract month | `=MONTH(A1)` |
| `=DATEDIF(start, end, unit)` | Date difference | `=DATEDIF(A1, B1, "D")` |

## Complete Examples

### Example 1: Simple Data Table

```json
{
  "title": "Employee Directory",
  "commands": [
    {
      "id": "sheet.mutation.set-worksheet-name",
      "params": {
        "unitId": "workbook-1",
        "subUnitId": "sheet-1",
        "name": "Employees"
      }
    },
    {
      "id": "sheet.mutation.set-worksheet-col-width",
      "params": { "unitId": "workbook-1", "subUnitId": "sheet-1", "colIndex": 0, "width": 120 }
    },
    {
      "id": "sheet.mutation.set-worksheet-col-width",
      "params": { "unitId": "workbook-1", "subUnitId": "sheet-1", "colIndex": 1, "width": 80 }
    },
    {
      "id": "sheet.mutation.set-worksheet-col-width",
      "params": { "unitId": "workbook-1", "subUnitId": "sheet-1", "colIndex": 2, "width": 150 }
    },
    {
      "id": "sheet.mutation.set-range-values",
      "params": {
        "unitId": "workbook-1",
        "subUnitId": "sheet-1",
        "range": { "startRow": 0, "endRow": 0, "startColumn": 0, "endColumn": 2 },
        "value": [[
          { "v": "Name", "s": "header" },
          { "v": "Age", "s": "header" },
          { "v": "Email", "s": "header" }
        ]]
      }
    },
    {
      "id": "sheet.mutation.set-range-values",
      "params": {
        "unitId": "workbook-1",
        "subUnitId": "sheet-1",
        "range": { "startRow": 1, "endRow": 3, "startColumn": 0, "endColumn": 2 },
        "value": [
          [{ "v": "Alice Smith" }, { "v": 28 }, { "v": "alice@company.com" }],
          [{ "v": "Bob Johnson" }, { "v": 34 }, { "v": "bob@company.com" }],
          [{ "v": "Carol White" }, { "v": 31 }, { "v": "carol@company.com" }]
        ]
      }
    }
  ]
}
```

### Example 2: Financial Model with Formulas

```json
{
  "title": "Q4 Revenue Analysis",
  "commands": [
    {
      "id": "sheet.mutation.set-worksheet-name",
      "params": { "unitId": "workbook-1", "subUnitId": "sheet-1", "name": "Revenue" }
    },
    {
      "id": "sheet.mutation.set-range-values",
      "params": {
        "unitId": "workbook-1",
        "subUnitId": "sheet-1",
        "range": { "startRow": 0, "endRow": 0, "startColumn": 0, "endColumn": 4 },
        "value": [[
          { "v": "Month", "s": "header" },
          { "v": "Revenue", "s": "header" },
          { "v": "Costs", "s": "header" },
          { "v": "Profit", "s": "header" },
          { "v": "Margin %", "s": "header" }
        ]]
      }
    },
    {
      "id": "sheet.mutation.set-range-values",
      "params": {
        "unitId": "workbook-1",
        "subUnitId": "sheet-1",
        "range": { "startRow": 1, "endRow": 3, "startColumn": 0, "endColumn": 4 },
        "value": [
          [{ "v": "October" }, { "v": 150000 }, { "v": 95000 }, { "f": "=B2-C2" }, { "f": "=D2/B2*100" }],
          [{ "v": "November" }, { "v": 180000 }, { "v": 110000 }, { "f": "=B3-C3" }, { "f": "=D3/B3*100" }],
          [{ "v": "December" }, { "v": 220000 }, { "v": 125000 }, { "f": "=B4-C4" }, { "f": "=D4/B4*100" }]
        ]
      }
    },
    {
      "id": "sheet.mutation.set-range-values",
      "params": {
        "unitId": "workbook-1",
        "subUnitId": "sheet-1",
        "range": { "startRow": 5, "endRow": 5, "startColumn": 0, "endColumn": 4 },
        "value": [[
          { "v": "Total", "s": "header" },
          { "f": "=SUM(B2:B4)" },
          { "f": "=SUM(C2:C4)" },
          { "f": "=SUM(D2:D4)" },
          { "f": "=D6/B6*100" }
        ]]
      }
    }
  ]
}
```

### Example 3: DCF Model Structure (from real Excel conversion)

```json
{
  "title": "DCF Valuation Model",
  "commands": [
    {
      "id": "sheet.mutation.set-worksheet-name",
      "params": { "unitId": "workbook-1", "subUnitId": "sheet-1", "name": "Assumptions" }
    },
    {
      "id": "sheet.mutation.set-worksheet-col-width",
      "params": { "unitId": "workbook-1", "subUnitId": "sheet-1", "colIndex": 0, "width": 200 }
    },
    {
      "id": "sheet.mutation.set-worksheet-col-width",
      "params": { "unitId": "workbook-1", "subUnitId": "sheet-1", "colIndex": 1, "width": 100 }
    },
    {
      "id": "sheet.mutation.set-range-values",
      "params": {
        "unitId": "workbook-1",
        "subUnitId": "sheet-1",
        "range": { "startRow": 0, "endRow": 0, "startColumn": 0, "endColumn": 1 },
        "value": [[{ "v": "DCF Model Assumptions", "s": "title" }, {}]]
      }
    },
    {
      "id": "sheet.mutation.set-range-values",
      "params": {
        "unitId": "workbook-1",
        "subUnitId": "sheet-1",
        "range": { "startRow": 2, "endRow": 8, "startColumn": 0, "endColumn": 1 },
        "value": [
          [{ "v": "Revenue Growth Rate" }, { "v": 0.05 }],
          [{ "v": "Operating Margin" }, { "v": 0.22 }],
          [{ "v": "Tax Rate" }, { "v": 0.21 }],
          [{ "v": "Discount Rate (WACC)" }, { "v": 0.08 }],
          [{ "v": "Terminal Growth Rate" }, { "v": 0.025 }],
          [{ "v": "Shares Outstanding (M)" }, { "v": 4300 }],
          [{ "v": "Current Stock Price" }, { "v": 62.50 }]
        ]
      }
    },
    {
      "id": "sheet.mutation.set-range-values",
      "params": {
        "unitId": "workbook-1",
        "subUnitId": "sheet-1",
        "range": { "startRow": 11, "endRow": 11, "startColumn": 0, "endColumn": 1 },
        "value": [[{ "v": "Implied Share Price", "s": "header" }, { "f": "=B15/B8" }]]
      }
    }
  ]
}
```

### Example 4: Multi-Sheet Workbook

A workbook with multiple sheets that reference each other:

```json
{
  "title": "Sales Report Q4 2024",
  "commands": [
    {
      "id": "sheet.mutation.set-worksheet-name",
      "params": { "unitId": "workbook-1", "subUnitId": "sheet-1", "name": "Raw Data" }
    },
    {
      "id": "sheet.mutation.insert-sheet",
      "params": {
        "unitId": "workbook-1",
        "sheet": { "id": "sheet-2", "name": "Summary" },
        "index": 1
      }
    },
    {
      "id": "sheet.mutation.insert-sheet",
      "params": {
        "unitId": "workbook-1",
        "sheet": { "id": "sheet-3", "name": "Charts Data" },
        "index": 2
      }
    },
    {
      "id": "sheet.mutation.set-range-values",
      "params": {
        "unitId": "workbook-1",
        "subUnitId": "sheet-1",
        "range": { "startRow": 0, "endRow": 0, "startColumn": 0, "endColumn": 3 },
        "value": [[
          { "v": "Date", "s": "header" },
          { "v": "Product", "s": "header" },
          { "v": "Units", "s": "header" },
          { "v": "Revenue", "s": "header" }
        ]]
      }
    },
    {
      "id": "sheet.mutation.set-range-values",
      "params": {
        "unitId": "workbook-1",
        "subUnitId": "sheet-1",
        "range": { "startRow": 1, "endRow": 4, "startColumn": 0, "endColumn": 3 },
        "value": [
          [{ "v": "2024-10-01" }, { "v": "Widget A" }, { "v": 150 }, { "v": 4500 }],
          [{ "v": "2024-10-15" }, { "v": "Widget B" }, { "v": 200 }, { "v": 8000 }],
          [{ "v": "2024-11-01" }, { "v": "Widget A" }, { "v": 180 }, { "v": 5400 }],
          [{ "v": "2024-11-15" }, { "v": "Widget B" }, { "v": 250 }, { "v": 10000 }]
        ]
      }
    },
    {
      "id": "sheet.mutation.set-range-values",
      "params": {
        "unitId": "workbook-1",
        "subUnitId": "sheet-2",
        "range": { "startRow": 0, "endRow": 0, "startColumn": 0, "endColumn": 1 },
        "value": [[{ "v": "Q4 Summary", "s": "title" }, {}]]
      }
    },
    {
      "id": "sheet.mutation.set-range-values",
      "params": {
        "unitId": "workbook-1",
        "subUnitId": "sheet-2",
        "range": { "startRow": 2, "endRow": 5, "startColumn": 0, "endColumn": 1 },
        "value": [
          [{ "v": "Total Units", "s": "header" }, { "f": "=SUM('Raw Data'!C2:C5)" }],
          [{ "v": "Total Revenue", "s": "header" }, { "f": "=SUM('Raw Data'!D2:D5)" }],
          [{ "v": "Average Order", "s": "header" }, { "f": "=AVERAGE('Raw Data'!D2:D5)" }],
          [{ "v": "Max Sale", "s": "header" }, { "f": "=MAX('Raw Data'!D2:D5)" }]
        ]
      }
    }
  ]
}
```

**Cross-sheet formula syntax:** Use `'Sheet Name'!CellRange` to reference other sheets.

## Workflow

1. **Gather data** - Collect the information needed for the spreadsheet
2. **Structure commands** - Build the commands array with headers, data rows, and formulas
3. **Call API** - Send to `/api/data/spreadsheet/create`
4. **Return URL** - Give user the link to view the spreadsheet

## Tips

- Set column widths first for better layout
- Use `"s": "header"` for header cells (bold styling)
- Use `"s": "title"` for title cells (larger font)
- Formulas use Excel-style syntax: `=SUM(A1:A10)`, `=B2*C2`, etc.
- Row/column indices are 0-based (row 0 = Excel row 1)
- Build data row by row for cleaner code
- For multi-sheet references, use `'Sheet Name'!A1:B10` syntax
- Create sheets first with `insert-sheet`, then populate them with data
