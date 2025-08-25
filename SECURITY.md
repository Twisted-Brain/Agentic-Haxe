# Security Guidelines

<div align="center">
  <img src="assets/logo.png" alt="Haxe Security Logo" width="100" height="100">
</div>

## Environment Variables

### ⚠️ CRITICAL: Never Commit API Keys!

- **NEVER** commit `.env` files containing real API keys
- Use `.env.template` as a reference for required variables
- Copy `.env.template` to `.env` and fill in your actual values
- The `.env` file is automatically ignored by git

### Setup Instructions

#### Option 1: Global Environment Variables (Recommended)

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

#### Option 2: Global .env File

1. Create a global environment file:
   ```bash
   cp .env.template ~/.env
   ```

2. Edit `~/.env` with your actual API keys

3. Source it in your shell profile:
   ```bash
   echo 'source ~/.env' >> ~/.zshrc
   ```

#### Option 3: Project-specific .env (Less Secure)

1. Copy the template:
   ```bash
   cp .env.template .env
   ```

2. Edit `.env` with your actual API keys

3. Verify `.env` is ignored:
   ```bash
   git status  # .env should NOT appear in untracked files
   ```

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
   'git rm --cached --ignore-unmatch .env' \
   --prune-empty --tag-name-filter cat -- --all
   ```
4. Force push to update remote repository

## Repository Security

- Keep sensitive configuration in environment variables
- Use `.template` files for documentation
- Regular security audits of dependencies
- Never hardcode secrets in source code