# Vercel Deployment Template Guide

## Overview

This document provides instructions for deploying web applications to Vercel using a reusable framework template. The template is designed to streamline deployment from scratch with minimal configuration.

## Template Location

**GitHub Repository:** https://github.com/muldercw/vercel_template

This repository contains a complete Flask-based starter application configured for Vercel deployment, including automated deployment scripts and environment management.

## What's Included in the Template

- **Flask Application** (`app.py`) - Minimal Python web server with a "Hello, world!" endpoint
- **Vercel Configuration** (`vercel.json`) - Routes and build settings for serverless deployment
- **Deployment Script** (`deploy.ps1`) - PowerShell automation for secure deployments
- **Environment Management** (`.env.deploy.example`) - Template for storing Vercel tokens securely
- **Dependencies** (`requirements.txt`) - Python packages (Flask, python-dotenv)
- **Documentation** (`README.md`) - Detailed setup and usage instructions
- **Git Configuration** (`.gitignore`) - Prevents secrets from being committed

## Quick Start for New Projects

### Prerequisites

1. **Python 3.11+** installed and available on PATH
2. **Node.js & npm** (required for Vercel CLI)
3. **Git** for version control
4. **Vercel Account** with a [personal access token](https://vercel.com/account/tokens)

### Step 1: Clone the Template

```powershell
# Clone the template repository
git clone https://github.com/muldercw/vercel_template.git my-new-project
cd my-new-project

# Remove the template's git history and start fresh
Remove-Item -Recurse -Force .git
git init
```

### Step 2: Configure Your Vercel Token

```powershell
# Copy the example environment file
Copy-Item .env.deploy.example .env.deploy

# Edit and add your Vercel token
notepad .env.deploy
```

Inside `.env.deploy`, replace the placeholder:
```
VERCEL_TOKEN=your-actual-vercel-token-here
```

**Important:** Never commit `.env.deploy` to version control. It's already in `.gitignore`.

### Step 3: Install Dependencies

```powershell
# Install Python dependencies
python -m pip install -r requirements.txt

# Install Vercel CLI globally
npm install -g vercel
```

### Step 4: Test Locally

```powershell
# Run the Flask development server
python app.py

# Visit http://localhost:5000 to verify it works
```

### Step 5: Deploy to Vercel

```powershell
# Preview deployment (generates a unique test URL)
./deploy.ps1

# Production deployment (updates your main domain)
./deploy.ps1 -Prod
```

The deployment script automatically:
- Loads your token from `.env.deploy`
- Validates the Vercel CLI is installed
- Executes the deployment with proper authentication
- Keeps your token private and off GitHub

## Customizing the Template for Your Application

### Modifying the Application

1. **Update `app.py`** with your routes, logic, and endpoints
2. **Add dependencies** to `requirements.txt` as needed
3. **Adjust `vercel.json`** if you need custom routing or build settings

### Example: Adding a New Route

Edit `app.py`:
```python
@app.get("/api/status")
def status():
    return {"status": "healthy", "version": "1.0.0"}
```

### Setting Environment Variables in Vercel

For production secrets (API keys, database URLs, etc.):

```powershell
# Add via CLI
vercel env add DATABASE_URL production

# Or use the Vercel dashboard:
# https://vercel.com/your-project/settings/environment-variables
```

Access them in Flask:
```python
import os
db_url = os.environ.get("DATABASE_URL")
```

## Version Control & GitHub Integration

### Push to Your Own Repository

```powershell
# Create a new repo on GitHub, then:
git remote add origin https://github.com/your-username/your-project.git
git add .
git commit -m "Initial commit from Vercel template"
git push -u origin main
```

### Optional: Enable Automatic Deployments

1. Go to your project in the [Vercel dashboard](https://vercel.com/dashboard)
2. Navigate to **Settings → Git**
3. Connect your GitHub repository
4. Every push to `main` will trigger a production deployment automatically

## Deployment Workflow Reference

### Manual Deployments

| Command | Purpose |
|---------|---------|
| `./deploy.ps1` | Deploy to preview URL for testing |
| `./deploy.ps1 -Prod` | Deploy to production domain |

### CI/CD Integration (GitHub Actions Example)

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to Vercel

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      
      - name: Install Vercel CLI
        run: npm install -g vercel
      
      - name: Deploy to Production
        run: vercel deploy --prod --token ${{ secrets.VERCEL_TOKEN }}
        env:
          VERCEL_TOKEN: ${{ secrets.VERCEL_TOKEN }}
```

Store `VERCEL_TOKEN` in your GitHub repository secrets (Settings → Secrets and variables → Actions).

## Troubleshooting

### "vercel command not found"

```powershell
npm install -g vercel
# Restart your terminal after installation
```

### "VERCEL_TOKEN is not set"

Ensure `.env.deploy` exists and contains:
```
VERCEL_TOKEN=your-token-here
```

### Build Failures

Check the Vercel deployment logs:
```powershell
vercel logs your-deployment-url
```

Common issues:
- Missing dependencies in `requirements.txt`
- Python version incompatibility (update `vercel.json` runtime)
- Syntax errors in `app.py`

### Local Development Issues

```powershell
# Verify Python installation
python --version

# Check installed packages
python -m pip list

# Reinstall dependencies
python -m pip install -r requirements.txt --force-reinstall
```

## Best Practices

1. **Keep secrets out of code** - Use environment variables for all sensitive data
2. **Test locally first** - Run `python app.py` before deploying
3. **Use preview deployments** - Test changes with `./deploy.ps1` before `--Prod`
4. **Version control** - Commit working code regularly
5. **Monitor deployments** - Check the Vercel dashboard for errors and performance

## Framework Expansion

This template can be adapted for other frameworks:

### Next.js
Replace Flask files with Next.js, update `vercel.json` to remove custom builds (Vercel auto-detects Next.js).

### Express.js
Swap `app.py` for `index.js`, update `vercel.json` to use `@vercel/node`.

### Static Sites
Remove `app.py`, add HTML/CSS/JS files, simplify `vercel.json` to serve static assets.

The deployment workflow (`deploy.ps1`, `.env.deploy`, `.gitignore`) remains the same across all frameworks.

## Additional Resources

- [Vercel Documentation](https://vercel.com/docs)
- [Vercel CLI Reference](https://vercel.com/docs/cli)
- [Flask Documentation](https://flask.palletsprojects.com/)
- [Template Repository](https://github.com/muldercw/vercel_template)

## Support

For issues with the template itself, open an issue on the [GitHub repository](https://github.com/muldercw/vercel_template/issues).

For Vercel platform issues, consult the [official support channels](https://vercel.com/support).

---

**Template Version:** 1.0  
**Last Updated:** November 19, 2025  
**Maintained By:** Chris Mulder
