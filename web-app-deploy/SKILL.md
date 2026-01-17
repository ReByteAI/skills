---
name: web-app-deploy
description: Build and deploy web apps to the cloud. Supports React, Vue, Astro, Next.js (static), vanilla HTML/CSS/JS, and serverless functions. Sites deploy to *.rebyte.pro with automatic SSL. Use when user asks to "deploy", "publish", "host", or make their app "live". Triggers include "deploy my app", "make it live", "publish site", "host my app", "deploy website", "put it online".
---

# Web App Builder

Build and deploy web apps to the cloud with automatic SSL and custom subdomains.

{{include:auth.md}}

---

## Supported Frameworks

| Framework | Build Command | Output Dir | Notes |
|-----------|---------------|------------|-------|
| **React (Vite)** | `npm run build` | `dist/` | SPA, needs `_redirects` |
| **React (CRA)** | `npm run build` | `build/` | SPA, needs `_redirects` |
| **Vue (Vite)** | `npm run build` | `dist/` | SPA, needs `_redirects` |
| **Astro** | `npm run build` | `dist/` | Static by default |
| **Next.js (static)** | `npm run build` | `out/` | Requires `output: 'export'` |
| **Vanilla HTML** | None | `.` | Just HTML/CSS/JS files |
| **Svelte** | `npm run build` | `build/` | SPA, needs `_redirects` |

### Serverless Backend Support

| Type | Location | Access URL |
|------|----------|------------|
| Netlify Functions | `netlify/functions/` | `/.netlify/functions/{name}` |
| Edge Functions | `netlify/edge-functions/` | Configured in `netlify.toml` |

---

## What You SHOULD Do

1. **Always build before deploying** - Run the framework's build command first
2. **Include `index.html` at root** - This is the entry point, required
3. **Add `_redirects` for SPAs** - React/Vue apps need this for client-side routing
4. **Use relative paths** - All asset paths should be relative (`./assets/` not `/assets/`)
5. **Test locally first** - Preview your build before deploying
6. **Keep builds small** - Optimize images, minify code

## What You Should NOT Do

1. **Don't deploy `node_modules/`** - Only deploy the build output
2. **Don't deploy source files** - Deploy `dist/`, not `src/`
3. **Don't hardcode localhost URLs** - Use relative paths or environment variables
4. **Don't include `.env` files** - Use Netlify environment variables for secrets
5. **Don't skip the build step** - Raw source won't work
6. **Don't use server-side rendering** - Only static exports are supported (no SSR)
7. **Don't guess icon names** - Only use verified icons from the list below

---

## Valid Tabler Icons (IMPORTANT)

When using `tabler:*` icons in Astro templates, **ONLY use these verified icons**. Using invalid icons will cause build failures.

### Safe Icons to Use

**Navigation & UI:**
- `tabler:home`, `tabler:menu`, `tabler:menu-2`, `tabler:arrow-left`, `tabler:arrow-right`, `tabler:arrow-down`
- `tabler:chevron-down`, `tabler:chevron-right`, `tabler:chevron-left`, `tabler:chevron-up`
- `tabler:x`, `tabler:check`, `tabler:plus`, `tabler:minus`, `tabler:dots`

**Actions:**
- `tabler:download`, `tabler:upload`, `tabler:refresh`, `tabler:search`, `tabler:settings`
- `tabler:edit`, `tabler:trash`, `tabler:copy`, `tabler:share`, `tabler:link`

**Communication:**
- `tabler:mail`, `tabler:phone`, `tabler:message`, `tabler:send`, `tabler:at`

**Social & Brands:**
- `tabler:brand-github`, `tabler:brand-twitter`, `tabler:brand-x`, `tabler:brand-facebook`
- `tabler:brand-instagram`, `tabler:brand-linkedin`, `tabler:brand-youtube`, `tabler:brand-discord`
- `tabler:brand-tailwind`, `tabler:rss`

**Content & Files:**
- `tabler:file`, `tabler:folder`, `tabler:image`, `tabler:video`, `tabler:music`
- `tabler:document`, `tabler:book`, `tabler:notebook`, `tabler:clipboard`

**Status & Alerts:**
- `tabler:alert-circle`, `tabler:info-circle`, `tabler:help-circle`, `tabler:check-circle`
- `tabler:alert-triangle`, `tabler:ban`, `tabler:lock`, `tabler:shield`, `tabler:shield-check`

**Objects:**
- `tabler:sun`, `tabler:moon`, `tabler:star`, `tabler:heart`, `tabler:bulb`
- `tabler:clock`, `tabler:calendar`, `tabler:calendar-event`, `tabler:map-pin`, `tabler:location`
- `tabler:user`, `tabler:users`, `tabler:building`, `tabler:briefcase`
- `tabler:rocket`, `tabler:package`, `tabler:paint`, `tabler:palette`
- `tabler:code`, `tabler:terminal`, `tabler:database`, `tabler:server`
- `tabler:wifi`, `tabler:bluetooth`, `tabler:battery`, `tabler:plug`
- `tabler:tool`, `tabler:hammer`, `tabler:wrench`, `tabler:bolt`

**Layout:**
- `tabler:layout`, `tabler:layout-grid`, `tabler:layout-list`, `tabler:template`
- `tabler:components`, `tabler:squares`, `tabler:box`, `tabler:cube`

**Lists & Checks:**
- `tabler:list`, `tabler:list-check`, `tabler:checkbox`, `tabler:circle-check`
- `tabler:letter-case`, `tabler:text-size`

### Icons to AVOID (will cause build errors)

❌ `tabler:layers` - Use `tabler:layout-grid` instead
❌ `tabler:vacuum-cleaner` - Not in the icon set
❌ `tabler:tools` - Use `tabler:tool` instead
❌ Any made-up or guessed icon names

### How to Verify Icons

Before using an icon, run `npm run build` to check for errors. If you see:
```
Unable to locate "tabler:icon-name" icon!
```
Replace it with a verified icon from the list above.

---

## How to Build

### React (Vite)

```bash
# Install dependencies
npm install

# Build for production
npm run build

# Output: dist/
```

Add `_redirects` for SPA routing:
```bash
echo "/*    /index.html   200" > dist/_redirects
```

### React (Create React App)

```bash
npm install
npm run build

# Output: build/
```

Add `_redirects`:
```bash
echo "/*    /index.html   200" > build/_redirects
```

### Vue (Vite)

```bash
npm install
npm run build

# Output: dist/
```

Add `_redirects`:
```bash
echo "/*    /index.html   200" > dist/_redirects
```

### Astro

```bash
npm install
npm run build

# Output: dist/
```

No `_redirects` needed - Astro generates static HTML pages.

### Next.js (Static Export)

First, configure `next.config.js`:
```javascript
/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'export',  // Required for static export
  images: {
    unoptimized: true  // Required for static export
  }
}

module.exports = nextConfig
```

Then build:
```bash
npm install
npm run build

# Output: out/
```

### Vanilla HTML/CSS/JS

No build needed. Just ensure you have:
```
project/
├── index.html    # Required
├── style.css
└── script.js
```

### Svelte (SvelteKit)

Configure `svelte.config.js` for static:
```javascript
import adapter from '@sveltejs/adapter-static';

export default {
  kit: {
    adapter: adapter({
      pages: 'build',
      assets: 'build',
      fallback: 'index.html'  // For SPA mode
    })
  }
};
```

Then build:
```bash
npm install
npm run build

# Output: build/
```

---

## How to Deploy

### Step 1: Get Upload URL

```bash
AUTH_TOKEN=$(rebyte-auth)
curl -X POST $API_URL/api/data/netlify/get-upload-url \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{}'
```

**Response:**
```json
{
  "deployId": "app-x7k2",
  "uploadUrl": "https://storage.googleapis.com/...",
  "expiresIn": 3600
}
```

Optionally pass `{"id": "my-app"}` to customize the deploy ID prefix.

Save `deployId` and `uploadUrl` for next steps.

### Step 2: Create ZIP from Build Output

```bash
# For Vite (React/Vue)
cd dist && zip -r ../site.zip . && cd ..

# For Create React App
cd build && zip -r ../site.zip . && cd ..

# For Next.js static
cd out && zip -r ../site.zip . && cd ..

# For Astro
cd dist && zip -r ../site.zip . && cd ..
```

### Step 3: Upload ZIP

```bash
curl -X PUT "${uploadUrl}" \
  -H "Content-Type: application/zip" \
  --data-binary @site.zip
```

### Step 4: Deploy

```bash
curl -X POST $API_URL/api/data/netlify/deploy \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"deployId": "my-app-x7k2"}'
```

**Response:**
```json
{
  "deployId": "my-app-x7k2",
  "url": "https://my-app-x7k2.rebyte.pro",
  "status": "deployed"
}
```

**Your site is now live!** SSL activates in 1-2 minutes.

---

## Complete Build & Deploy Script

```bash
#!/bin/bash
set -e

# Configuration
PROJECT_DIR="."
BUILD_CMD="npm run build"
BUILD_OUTPUT="dist"
API_URL="$API_URL/api/data/netlify"

# Get auth token
AUTH_TOKEN=$(rebyte-auth)

# Step 1: Build
echo "Building project..."
cd "$PROJECT_DIR"
npm install
$BUILD_CMD

# Add SPA redirects if needed (for React/Vue)
echo "/*    /index.html   200" > "$BUILD_OUTPUT/_redirects"

# Step 2: Get upload URL
echo "Getting upload URL..."
RESPONSE=$(curl -s -X POST "$API_URL/get-upload-url" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{}")

DEPLOY_ID=$(echo $RESPONSE | jq -r '.deployId')
UPLOAD_URL=$(echo $RESPONSE | jq -r '.uploadUrl')

# Step 3: Create ZIP
echo "Creating ZIP..."
cd "$BUILD_OUTPUT"
zip -r /tmp/site.zip .
cd ..

# Step 4: Upload
echo "Uploading..."
curl -s -X PUT "$UPLOAD_URL" \
  -H "Content-Type: application/zip" \
  --data-binary @/tmp/site.zip

# Step 5: Deploy
echo "Deploying..."
RESULT=$(curl -s -X POST "$API_URL/deploy" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"deployId\": \"$DEPLOY_ID\"}")

SITE_URL=$(echo $RESULT | jq -r '.url')

echo ""
echo "========================================="
echo "Deployed successfully!"
echo "URL: $SITE_URL"
echo "========================================="
```

---

## Complete Python Example

```python
import subprocess
import requests
import zipfile
import os
import json

# Get auth token and API URL
AUTH_TOKEN = subprocess.check_output(["rebyte-auth"]).decode().strip()
with open('/home/user/.rebyte.ai/auth.json') as f:
    API_URL = json.load(f)['sandbox']['relay_url'] + "/api/data/netlify"

HEADERS = {"Authorization": f"Bearer {AUTH_TOKEN}"}

def build_and_deploy(
    project_dir: str,
    build_cmd: str = "npm run build",
    build_output: str = "dist",
    is_spa: bool = True
) -> str:
    """
    Build and deploy a web app.

    Args:
        project_dir: Path to project root
        build_cmd: Build command (e.g., "npm run build")
        build_output: Build output directory (e.g., "dist", "build", "out")
        is_spa: Whether to add SPA redirects (for React/Vue)

    Returns:
        Deployed site URL
    """

    # Step 1: Install dependencies
    print("Installing dependencies...")
    subprocess.run(["npm", "install"], cwd=project_dir, check=True)

    # Step 2: Build
    print(f"Building with: {build_cmd}")
    subprocess.run(build_cmd.split(), cwd=project_dir, check=True)

    build_path = os.path.join(project_dir, build_output)

    # Step 3: Add SPA redirects if needed
    if is_spa:
        redirects_path = os.path.join(build_path, "_redirects")
        with open(redirects_path, "w") as f:
            f.write("/*    /index.html   200\n")
        print("Added _redirects for SPA routing")

    # Step 4: Get upload URL
    print("Getting upload URL...")
    response = requests.post(
        f"{API_URL}/get-upload-url",
        headers=HEADERS,
        json={}
    )
    response.raise_for_status()
    data = response.json()
    deploy_id = data["deployId"]
    upload_url = data["uploadUrl"]

    # Step 5: Create ZIP
    print("Creating ZIP...")
    zip_path = "/tmp/site.zip"
    with zipfile.ZipFile(zip_path, 'w', zipfile.ZIP_DEFLATED) as zipf:
        for root, dirs, files in os.walk(build_path):
            for file in files:
                file_path = os.path.join(root, file)
                arcname = os.path.relpath(file_path, build_path)
                zipf.write(file_path, arcname)

    print(f"ZIP size: {os.path.getsize(zip_path)} bytes")

    # Step 6: Upload
    print("Uploading...")
    with open(zip_path, 'rb') as f:
        response = requests.put(
            upload_url,
            data=f,
            headers={"Content-Type": "application/zip"}
        )
    response.raise_for_status()

    # Step 7: Deploy
    print("Deploying...")
    response = requests.post(
        f"{API_URL}/deploy",
        headers=HEADERS,
        json={"deployId": deploy_id}
    )
    response.raise_for_status()
    result = response.json()

    site_url = result["url"]
    print(f"\nDeployed! URL: {site_url}")

    return site_url


# Example usage for different frameworks
if __name__ == "__main__":
    # React (Vite)
    url = build_and_deploy(
        project_dir="./my-react-app",
        build_cmd="npm run build",
        build_output="dist",
        is_spa=True
    )

    # # Astro (not a SPA)
    # url = build_and_deploy(
    #     project_dir="./my-astro-site",
    #     build_cmd="npm run build",
    #     build_output="dist",
    #     is_spa=False
    # )

    # # Next.js static export
    # url = build_and_deploy(
    #     project_dir="./my-next-app",
    #     build_cmd="npm run build",
    #     build_output="out",
    #     is_spa=False
    # )
```

---

## Adding Serverless Functions

Create backend API endpoints with Netlify Functions.

### Directory Structure

```
project/
├── dist/                    # Frontend build output
├── netlify/
│   └── functions/
│       └── api.js           # Serverless function
└── netlify.toml             # Configuration
```

### Example Function

**netlify/functions/api.js:**
```javascript
export default async (request, context) => {
  const url = new URL(request.url);
  const path = url.pathname.replace('/.netlify/functions/api', '');

  // GET /api/hello
  if (request.method === 'GET' && path === '/hello') {
    return Response.json({ message: 'Hello World!' });
  }

  // POST /api/data
  if (request.method === 'POST' && path === '/data') {
    const body = await request.json();
    return Response.json({ received: body });
  }

  return new Response('Not Found', { status: 404 });
};

export const config = {
  path: "/api/*"
};
```

### Configuration

**netlify.toml:**
```toml
[build]
  publish = "dist"
  functions = "netlify/functions"

[[redirects]]
  from = "/api/*"
  to = "/.netlify/functions/api/:splat"
  status = 200
```

### Deploy with Functions

Include the `netlify/` folder in your ZIP:

```bash
# Build frontend
npm run build

# Create ZIP with both frontend and functions
zip -r site.zip dist/ netlify/ netlify.toml
```

Access your API at: `https://your-site.rebyte.pro/api/hello`

---

## SPA Routing Configuration

Single-page applications (React, Vue, Svelte) need special handling for client-side routing.

### Option 1: `_redirects` file

Create `_redirects` in your build output:
```
/*    /index.html   200
```

### Option 2: `netlify.toml`

Create `netlify.toml` in project root:
```toml
[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200
```

---

## API Reference

### Get Upload URL

```
POST $API_URL/api/data/netlify/get-upload-url
```

No parameters needed. Returns a stable `deployId` that is unique per workspace (1 workspace = 1 deployment).

**Response includes:**
- `deployId`: Stable ID for your deployment (derived from workspace)
- `uploadUrl`: Signed URL to upload your ZIP file
- `isExisting`: Whether this workspace already has a deployment
- `currentUrl`: If existing, the current live URL

### Deploy

```
POST $API_URL/api/data/netlify/deploy
```

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `deployId` | string | Yes | Deploy ID from get-upload-url |

**Auto-detects create vs update:** If the site doesn't exist yet, creates a new one. If it already exists, updates it automatically. No need to use a separate `update` endpoint.

### Check Status

```
POST $API_URL/api/data/netlify/status
```

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `deployId` | string | Yes | Deploy ID |

### Delete Site

```
POST $API_URL/api/data/netlify/delete
```

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `deployId` | string | Yes | Deploy ID |

---

## Troubleshooting

### "Page Not Found" after deploy
- Ensure `index.html` is at the ZIP root
- For SPAs, add `_redirects` file

### Routes not working (404 on refresh)
- Add `_redirects` file: `/*    /index.html   200`

### Assets not loading
- Use relative paths (`./assets/` not `/assets/`)
- Check browser console for 404 errors

### Build fails
- Run `npm install` first
- Check `package.json` for correct build script
- Ensure Node.js version is compatible

### Functions not working
- Functions must be in `netlify/functions/`
- Include `netlify.toml` in ZIP
- Check function logs at admin URL

### Icon build errors ("Unable to locate icon")
You used an invalid icon name. Check the "Valid Tabler Icons" section above and replace with a verified icon.

---

## Limits

| Resource | Limit |
|----------|-------|
| ZIP size | 100MB |
| Upload URL expiry | 1 hour |
| Function execution | 10 seconds |
| Function memory | 1024 MB |
