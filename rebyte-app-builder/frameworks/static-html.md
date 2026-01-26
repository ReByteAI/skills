# Static HTML

**Type:** Static

For single HTML files with assets (CSS, JS, images).

## Structure

```
project/
├── index.html
├── styles.css
├── script.js
└── images/
    └── logo.png
```

## Deploy

No build step needed. Deploy the entire project directory.

```bash
node bin/rebyte.js deploy
```

## Notes

- Ensure all asset paths are relative (`./styles.css`, not `/styles.css`)
- For multiple pages, create subdirectories with `index.html` files:
  ```
  project/
  ├── index.html        # /
  ├── about/
  │   └── index.html    # /about
  └── contact/
      └── index.html    # /contact
  ```
