# Post-Deployment Verification

## SSR Deployments (Next.js, Nuxt, Remix, SvelteKit)

SSR deployments need ~90 seconds for full infrastructure propagation:
- Lambda function code is uploaded and activated (~10s)
- API Gateway integration is configured (~5s)
- Lambda@Edge routing config is cached and refreshes every 60 seconds
- CloudFront cache invalidation propagates to edge locations (~30-60s)

**DO NOT immediately visit the URL and start debugging errors.** Instead:

```bash
# 1. Deploy
node $SKILL_DIR/bin/rebyte.js deploy
# Note the URL from output, e.g., https://abc123.rebyte.pro

# 2. Wait for propagation
echo "Waiting 90 seconds for deployment to propagate..."
sleep 90

# 3. Verify the site works
curl -s -o /dev/null -w '%{http_code}' https://<deploy-id>.rebyte.pro

# 4. Only if step 3 returns non-200, check logs:
node $SKILL_DIR/bin/rebyte.js logs
```

### Common False Alarms During Propagation

- **502/503 errors** → Lambda@Edge hasn't picked up new config yet (wait longer)
- **500 errors** → Lambda cold start may be slow on first request (retry after 10s)
- **403 Forbidden** → CloudFront still serving old/cached version (wait for invalidation)

**Only start debugging if errors persist after 2 minutes.** When they do, use `rebyte.js logs` to check Lambda execution logs.

## Static Deployments (Vite, Astro, Plain HTML)

Static-only deploys propagate faster (~30 seconds) because there's no Lambda/API Gateway setup — just S3 upload and CloudFront invalidation.

```bash
# 1. Deploy
node $SKILL_DIR/bin/rebyte.js deploy

# 2. Wait briefly
sleep 30

# 3. Verify
curl -s -o /dev/null -w '%{http_code}' https://<deploy-id>.rebyte.pro
```
