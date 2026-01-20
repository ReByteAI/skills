---
name: skill-publisher
description: Publish skills to your organization's private skill store. Use this after creating and packaging a skill with skill-creator. Handles uploading .skill packages to GCS and registering them in the organization database.
---

# Skill Publisher

Publish packaged skills to your organization's private skill store.

## Publish a Skill

```bash
scripts/publish.sh <slug> <path-to-skill-file>
```

Example:
```bash
scripts/publish.sh my-skill ./my-skill.skill
```

## List Organization Skills

```bash
scripts/list.sh
```

## Delete a Skill

```bash
scripts/delete.sh <skill-id>
```
