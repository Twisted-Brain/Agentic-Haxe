# Security Guidelines

<div align="center">
  <img src="assets/logo.png" alt="Haxe Security Logo" width="100" height="100">
</div>

## Environment Variables

### ⚠️ CRITICAL: Never Commit API Keys!

- **NEVER** commit API keys to the repository
- Use Mac environment variables for secure configuration
- Store sensitive keys in your shell profile (~/.zshrc)
- Environment variables are not tracked by git

### Setup Instructions

#### Mac Environment Variables (Recommended)

1. Add to your shell profile (`~/.zshrc` or `~/.bashrc`):
   ```bash
   # Haxe Agentic AI Configuration
   export OPENROUTER_API_KEY="sk-or-v1-your-actual-key"
   export OPENROUTER_BASE_URL="https://openrouter.ai/api/v1"
   export LLM_MODEL="openai/gpt-3.5-turbo"
   ```

2. Reload your shell:
   ```bash
   source ~/.zshrc
   ```

#### Alternative: Temporary Session Variables

For testing purposes, you can set variables for the current session:
```bash
export OPENROUTER_API_KEY="sk-or-v1-your-actual-key"
export OPENROUTER_BASE_URL="https://openrouter.ai/api/v1"
export LLM_MODEL="openai/gpt-3.5-turbo"
```

Note: These will only persist for the current terminal session.

### Protected Files

These files are automatically ignored by git:
- `.env`
- `.env.local`
- `.env.*.local`
- `.env.production`
- `.env.development`
- `.env.test`

### If You Accidentally Committed API Keys

1. **Immediately revoke** the exposed API keys
2. Generate new API keys
3. Remove the keys from git history:
   ```bash
   git filter-branch --force --index-filter \
   'git rm --cached --ignore-unmatch .env*' \
   --prune-empty --tag-name-filter cat -- --all
   ```
4. Force push to update remote repository

## Repository Security

- Keep sensitive configuration in environment variables
- Use `.template` files for documentation
- Regular security audits of dependencies
- Never hardcode secrets in source code