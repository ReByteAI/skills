---
name: form-builder
description: Build stylish, Typeform-like multi-step forms and surveys using the Rebyte Forms library (Composer API). Outputs standalone HTML files. Triggers include "create a form", "build a survey", "make a questionnaire", "feedback form", "contact form", "signup form", "onboarding flow", "multi-step form", "typeform-style", "data collection form". Do NOT use for simple single-field inputs or backend form processing.
---

# Rebyte Forms Builder

Build production-ready, Typeform-style forms using the Composer API.

## Authentication

**IMPORTANT:** All API requests require authentication. Get your auth token by running:

```bash
AUTH_TOKEN=$(rebyte-auth)
```

Include this token in all API requests as a Bearer token.

## Boilerplate Template

```html
<!DOCTYPE html>
<html lang="en" spellcheck="false" class="fmd-root" data-fmd-color-scheme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{TITLE}}</title>
    <link rel="stylesheet" type="text/css" href="https://unpkg.com/rebyte-forms/dist/css/formsmd.min.css">
</head>
<body class="fmd-body">
    <noscript>Please turn on JavaScript to see this page.</noscript>
    <div class="fmd-main">
        <div class="fmd-main-container">
            <div class="fmd-loader-container">
                <div class="fmd-loader-spinner" role="status" aria-label="Loading"></div>
            </div>
        </div>
    </div>

    <script src="https://unpkg.com/rebyte-forms/dist/js/composer.bundle.min.js"></script>
    <script src="https://unpkg.com/rebyte-forms/dist/js/formsmd.bundle.min.js"></script>
    <script>
        const composer = new Composer({
            title: "{{TITLE}}",
            colorScheme: "light",
            accent: "#6366f1",
            accentForeground: "#ffffff",
            backgroundColor: "#fafafa",
            color: "#18181b",
            fontFamily: "Inter, sans-serif",
            pageProgress: "show",
        });

        // Start slide
        composer.startSlide({ buttonText: "Get Started" });
        composer.h1("Welcome");
        composer.p("Introduction text here.");

        // Form slides go here...

        // End slide
        composer.endSlide();
        composer.h1("Thank you!");
        composer.p("Your response has been recorded.");

        // Initialize
        const formsmd = new Formsmd(composer.template, document, { isFullPage: true });
        formsmd.init();
    </script>
</body>
</html>
```

## Composer Settings

| Setting | Type | Description |
|---------|------|-------------|
| `title` | string | Page title |
| `colorScheme` | `"light"` \| `"dark"` | Default color scheme |
| `accent` | string | Primary color (hex) for buttons, fields |
| `accentForeground` | string | Text color on accent background |
| `backgroundColor` | string | Page background color |
| `color` | string | Text color |
| `backgroundImage` | string | CSS background-image (gradient or url) |
| `backdropOpacity` | string | Overlay opacity on background image (e.g., "0.4") |
| `fontFamily` | string | Font family |
| `fontSize` | `"sm"` \| `"lg"` | Font size |
| `rounded` | `"none"` \| `"pill"` | Button/UI rounding |
| `pageProgress` | `"hide"` \| `"show"` \| `"decorative"` | Progress bar style |
| `formStyle` | `"classic"` | Classic form field appearance |
| `postUrl` | string | URL to POST form responses |

## Field Types

### Text Input
```javascript
composer.textInput("fieldName", {
    question: "What's your name?",
    placeholder: "John Doe",
    required: true,
    description: "Optional helper text",
    multiline: true,  // for textarea
    maxlength: 500,
    autofocus: true,
    subfield: true,   // smaller label (for grouping)
});
```

### Email Input
```javascript
composer.emailInput("email", {
    question: "Your email address?",
    placeholder: "you@example.com",
    required: true,
});
```

### Phone Input
```javascript
composer.telInput("phone", {
    question: "Phone Number",
    country: "US",  // default country code
    required: true,
});
```

### URL Input
```javascript
composer.urlInput("website", {
    question: "Your website",
    placeholder: "https://example.com",
});
```

### Number Input
```javascript
composer.numberInput("salary", {
    question: "Expected salary (USD)",
    placeholder: "100000",
    unit: "$",
    min: 50000,
    max: 500000,
});
```

### Choice Input (Radio/Checkbox)
```javascript
// Simple choices
composer.choiceInput("role", {
    question: "What's your role?",
    choices: ["Developer", "Designer", "Manager", "Other"],
    required: true,
});

// With custom values
composer.choiceInput("ticket", {
    question: "Select ticket type",
    choices: [
        { label: "General - $99", value: "general" },
        { label: "VIP - $299", value: "vip" },
    ],
    required: true,
});

// Multiple selection
composer.choiceInput("skills", {
    question: "Select your skills",
    description: "Choose all that apply",
    choices: ["JavaScript", "Python", "Go", "Rust"],
    multiple: true,
});

// Horizontal layout
composer.choiceInput("size", {
    question: "T-Shirt Size",
    choices: ["S", "M", "L", "XL"],
    horizontal: true,
});
```

### Select Box (Dropdown)
```javascript
composer.selectBox("country", {
    question: "Select your country",
    placeholder: "Choose one",
    options: ["USA", "Canada", "UK", "Germany", "Other"],
});
```

### Rating Input
```javascript
composer.ratingInput("satisfaction", {
    question: "How satisfied are you?",
    outOf: 5,
    icon: "star",
    required: true,
});
```

### Opinion Scale (NPS)
```javascript
composer.opinionScale("nps", {
    question: "How likely are you to recommend us?",
    startAt: 0,
    outOf: 10,
    labelStart: "Not likely",
    labelEnd: "Very likely",
    required: true,
});
```

### File Upload
```javascript
composer.fileInput("resume", {
    question: "Upload your resume",
    description: "PDF format, max 10MB",
    sizeLimit: 10,
    required: true,
});
```

### Date/Time Inputs
```javascript
composer.dateInput("startDate", { question: "Start date" });
composer.timeInput("preferredTime", { question: "Preferred time" });
composer.datetimeInput("appointment", { question: "Select date and time" });
```

## Slide Structure

```javascript
// Start slide (intro)
composer.startSlide({ buttonText: "Begin" });
composer.h1("Title");
composer.p("Description");

// Regular slide
composer.slide();
composer.textInput("name", { question: "Your name?", required: true });

// Another slide with multiple fields
composer.slide();
composer.h2("Contact Details");
composer.emailInput("email", { question: "Email", required: true });
composer.telInput("phone", { question: "Phone", subfield: true });

// End slide
composer.endSlide();
composer.h1("Thanks!");
```

## Conditional Display

Show a field only when a condition is met:

```javascript
composer.choiceInput("wantFollowUp", {
    question: "Can we follow up?",
    choices: [
        { label: "Yes", value: "yes" },
        { label: "No", value: "no" },
    ],
});

composer.emailInput("followUpEmail", {
    question: "Your email for follow-up",
    displayCondition: {
        dependencies: ["wantFollowUp"],
        condition: "wantFollowUp == 'yes'",
    },
});
```

## Theme Presets

### Light Professional
```javascript
const composer = new Composer({
    colorScheme: "light",
    accent: "#18181b",
    accentForeground: "#fafafa",
    backgroundColor: "#fafafa",
    color: "#18181b",
    fontFamily: "DM Sans, sans-serif",
    formStyle: "classic",
    pageProgress: "show",
});
```

### Dark Modern
```javascript
const composer = new Composer({
    colorScheme: "dark",
    accent: "#a855f7",
    accentForeground: "#ffffff",
    backgroundColor: "#0f0a1e",
    color: "#e2e8f0",
    backgroundImage: "linear-gradient(135deg, #1a0a2e 0%, #16213e 50%, #0f0a1e 100%)",
    fontFamily: "Space Grotesk, sans-serif",
    rounded: "pill",
    pageProgress: "show",
});
```

### Warm Feedback
```javascript
const composer = new Composer({
    colorScheme: "light",
    accent: "#f97316",
    accentForeground: "#ffffff",
    backgroundColor: "#fffbeb",
    color: "#451a03",
    backgroundImage: "linear-gradient(180deg, #fef3c7 0%, #fffbeb 50%, #fff7ed 100%)",
    fontFamily: "Outfit, sans-serif",
    fontSize: "lg",
    pageProgress: "show",
});
```

### With Background Image
```javascript
const composer = new Composer({
    colorScheme: "dark",
    accent: "#f472b6",
    accentForeground: "#ffffff",
    backgroundColor: "#1e1b4b",
    color: "#f8fafc",
    backgroundImage: "url('https://images.unsplash.com/photo-xxx?w=1920&q=80')",
    backdropOpacity: "0.4",
    fontFamily: "Plus Jakarta Sans, sans-serif",
    rounded: "pill",
});
```

## Collecting Form Submissions

To collect responses, you need to:
1. Create a form backend (stores submissions)
2. Add `postUrl` to your HTML form
3. Deploy the HTML form (using web-app-deploy skill)

### Complete Workflow

#### Step 1: Create Form Backend

Call the Forms API to create a backend that stores submissions:

```bash
AUTH_TOKEN=$(rebyte-auth)
curl -X POST https://api.rebyte.ai/api/forms/create \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "My Survey",
    "fields": ["name", "email", "rating", "feedback"]
  }'
```

**IMPORTANT:** The `fields` array must contain the exact field names you use in your form (e.g., `composer.textInput("name", ...)` means `"name"` goes in fields).

Response:
```json
{
  "formId": "abc123def456",
  "submitUrl": "https://api.rebyte.ai/api/forms/submit/abc123def456",
  "adminUrl": "https://app.rebyte.ai/forms/abc123def456",
  "fields": ["name", "email", "rating", "feedback"]
}
```

**Save these URLs:**
- **`submitUrl`**: Where form data is POSTed (use as `postUrl` in Composer)
- **`adminUrl`**: Spreadsheet UI to view all submissions (share with form creator)

#### Step 2: Configure Form HTML

Add the `submitUrl` as `postUrl` in your Composer settings:

```javascript
const composer = new Composer({
    title: "My Survey",
    postUrl: "https://api.rebyte.ai/api/forms/submit/abc123def456",
    // ... other settings
});
```

#### Step 3: Deploy Form

After creating the HTML file, deploy it:

```bash
# 1. Save form as index.html
cat > index.html << 'HTMLEOF'
<!DOCTYPE html>
... your form HTML ...
HTMLEOF

# 2. Get upload URL (reuse AUTH_TOKEN from Step 1)
RESPONSE=$(curl -s -X POST https://api.rebyte.ai/api/data/netlify/get-upload-url \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"id": "form"}')
DEPLOY_ID=$(echo $RESPONSE | jq -r '.deployId')
UPLOAD_URL=$(echo $RESPONSE | jq -r '.uploadUrl')

# 3. Create ZIP with index.html AT THE ROOT (CRITICAL!)
zip site.zip index.html

# 4. Upload ZIP
curl -X PUT "$UPLOAD_URL" -H "Content-Type: application/zip" --data-binary @site.zip

# 5. Deploy
curl -s -X POST https://api.rebyte.ai/api/data/netlify/deploy \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"deployId\": \"$DEPLOY_ID\"}"
```

**CRITICAL:** The ZIP must have `index.html` at the root, NOT inside a subdirectory.
- ✅ Correct: `zip site.zip index.html`
- ❌ Wrong: `zip site.zip code/` (creates `code/index.html` inside ZIP)

#### Step 4: Validate Deployment

**You MUST run these validation checks before telling the user the form is ready:**

```bash
# 1. Verify ZIP structure (BEFORE uploading)
unzip -l site.zip | grep -E "^\s+\d+.*index\.html$"
# ✅ Should show: "index.html" (at root)
# ❌ If shows: "code/index.html" or "dist/index.html" - WRONG! Recreate ZIP

# 2. After deploy, verify site returns HTML (not 404)
FORM_URL="https://${DEPLOY_ID}.rebyte.pro"
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$FORM_URL")
if [ "$HTTP_STATUS" != "200" ]; then
  echo "ERROR: Site returned $HTTP_STATUS, expected 200"
fi

# 3. Verify Content-Type is HTML (not text/plain)
CONTENT_TYPE=$(curl -sI "$FORM_URL" | grep -i "content-type" | head -1)
echo "Content-Type: $CONTENT_TYPE"
# ✅ Should contain: text/html
# ❌ If text/plain - deployment issue

# 4. Verify admin URL works
ADMIN_URL="<the adminUrl from form creation API>"
ADMIN_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$ADMIN_URL")
if [ "$ADMIN_STATUS" != "200" ]; then
  echo "ERROR: Admin URL returned $ADMIN_STATUS"
fi
```

**If any validation fails, debug and fix before returning URLs to user.**

### Final URLs to Share

After deployment, you'll have:
- **Form URL**: `https://your-form-xyz.rebyte.pro` - Share with respondents
- **Admin URL**: `https://app.rebyte.ai/forms/abc123def456` - View responses in spreadsheet

### Viewing Results

**Admin UI (Recommended)**: Open `adminUrl` in a browser to view responses in a spreadsheet interface with CSV/JSON export.

**API Endpoints** (for programmatic access):
- **JSON**: `GET https://api.rebyte.ai/api/forms/results/{formId}`
- **CSV**: `GET https://api.rebyte.ai/api/forms/results/{formId}/csv`

## IMPORTANT: Always Return Both URLs

When you finish building and deploying a form, you **MUST** tell the user both URLs:

1. **Form URL** (for respondents): The deployed site URL from Netlify (e.g., `https://app-xyz123.rebyte.pro`)
2. **Admin URL** (for viewing results): Copy the EXACT `adminUrl` from the form creation API response

**CRITICAL:**
- The Admin URL comes from the **form creation API** (Step 1), NOT from the deploy step
- You MUST use the EXACT `adminUrl` returned by the API - do NOT construct it manually
- The form ID and deploy ID are DIFFERENT - don't mix them up

Example workflow:
```
Step 1: Create form backend
→ API returns: {"formId": "form-abc123", "adminUrl": "https://app.rebyte.ai/forms/form-abc123", ...}
→ SAVE this adminUrl!

Step 2: Build HTML with postUrl

Step 3: Deploy to Netlify
→ Returns: {"url": "https://app-xyz789.rebyte.pro", ...}
→ This is the Form URL (different ID!)

Step 4: Return to user:
📝 Form URL: https://app-xyz789.rebyte.pro (from deploy)
📊 Admin URL: https://app.rebyte.ai/forms/form-abc123 (from form creation API - EXACT!)
```

**Never forget the Admin URL** - without it, the user cannot see their form submissions!
