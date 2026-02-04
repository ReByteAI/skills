## Authentication

**IMPORTANT:** All API requests require authentication. Get your auth token and API URL by running:

```bash
AUTH_TOKEN=$(/home/user/.local/bin/rebyte-auth)
API_URL=$(python3 -c "import json; print(json.load(open('/home/user/.rebyte.ai/auth.json'))['sandbox']['relay_url'])")
```

Include the token in all API requests as a Bearer token, and use `$API_URL` as the base for all API endpoints.

## Artifact Store

If this skill produces output files (PDFs, images, exports, etc.), you MUST upload them to the artifact store. Without this, **users cannot access the files** - they only exist inside the VM.

Upload whenever you generate:
- Exported documents (PDF, Word, Excel, PowerPoint)
- Images (screenshots, generated graphics, charts)
- Media files (videos, audio)
- Any file the user asked to "download" or "export"

```bash
curl -X PUT "$API_URL/api/artifacts" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -F "files=@/path/to/file.pdf"
```

Multiple files:
```bash
curl -X PUT "$API_URL/api/artifacts" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -F "files=@file1.png" \
  -F "files=@file2.png"
```

**Allowed:** `.pdf`, `.doc(x)`, `.xls(x)`, `.ppt(x)`, `.png`, `.jpg`, `.gif`, `.webp`, `.svg`, `.mp4`, `.webm`, `.mov`, `.mp3`, `.wav`, `.ogg`

**Not allowed:** Source code, config files, or development files.
