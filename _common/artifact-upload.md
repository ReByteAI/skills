## Artifact Store

**CRITICAL:** If this skill produces output files (PDFs, images, exports, etc.), you MUST upload them to the artifact store. Without this, **users cannot access the files** - they only exist inside the VM which the user cannot reach.

### When to Use

Upload to artifacts whenever you generate:
- Exported documents (PDF, Word, Excel, PowerPoint)
- Images (screenshots, generated graphics, charts)
- Media files (videos, audio)
- Any file the user asked to "download" or "export"

### Upload Command

```bash
curl -X PUT "$API_URL/api/artifacts" \
  -H "Authorization: Bearer $SANDBOX_TOKEN" \
  -F "files=@/path/to/file.pdf"
```

**Multiple files:**
```bash
curl -X PUT "$API_URL/api/artifacts" \
  -H "Authorization: Bearer $SANDBOX_TOKEN" \
  -F "files=@slide-001.png" \
  -F "files=@slide-002.png" \
  -F "files=@slide-003.png"
```

### Allowed File Types

| Category | Extensions |
|----------|------------|
| Documents | `.pdf`, `.doc`, `.docx`, `.xls`, `.xlsx`, `.ppt`, `.pptx` |
| Images | `.png`, `.jpg`, `.jpeg`, `.gif`, `.webp`, `.svg` |
| Videos | `.mp4`, `.webm`, `.mov` |
| Audio | `.mp3`, `.wav`, `.ogg` |

**Not allowed:** Source code, config files, or development files.

### After Upload

Tell the user the file is ready. The frontend will display download links automatically.
