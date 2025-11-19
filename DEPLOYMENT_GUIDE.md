# Vercel Deployment Template Guide

## Overview

This document provides instructions for deploying web applications to Vercel using a reusable framework template. The template is designed to streamline deployment from scratch with minimal configuration.

## Template Location

**GitHub Repository:** https://github.com/muldercw/vercel_template

This repository contains a complete Flask-based starter application configured for Vercel deployment, including automated deployment scripts and environment management.

## What's Included in the Template

- **Flask Application** (`app.py`) - Minimal Python web server with a "Hello, world!" endpoint
- **Vercel Configuration** (`vercel.json`) - Routes and build settings for serverless deployment
- **Deployment Scripts**
  - `deploy.ps1` - PowerShell automation for Windows
  - `deploy.sh` - Bash script for Linux/macOS
- **GitHub Actions** (`.github/workflows/deploy.yml`) - Automated CI/CD pipeline
- **Environment Management** (`.env.deploy.example`) - Template for storing Vercel tokens securely
- **Dependencies** (`requirements.txt`) - Python packages (Flask, python-dotenv)
- **Documentation** (`README.md`, `DEPLOYMENT_GUIDE.md`) - Detailed setup and usage instructions
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

**Windows (PowerShell):**
```powershell
# Preview deployment (generates a unique test URL)
./deploy.ps1

# Production deployment (updates your main domain)
./deploy.ps1 -Prod
```

**Linux/macOS (Bash):**
```bash
# Make the script executable (first time only)
chmod +x deploy.sh

# Preview deployment
./deploy.sh

# Production deployment
./deploy.sh --prod
```

The deployment scripts automatically:
- Load your token from `.env.deploy`
- Validate the Vercel CLI is installed
- Execute the deployment with proper authentication
- Keep your token private and off GitHub

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

**Windows:**

| Command | Purpose |
|---------|---------|
| `./deploy.ps1` | Deploy to preview URL for testing |
| `./deploy.ps1 -Prod` | Deploy to production domain |

**Linux/macOS:**

| Command | Purpose |
|---------|---------|
| `./deploy.sh` | Deploy to preview URL for testing |
| `./deploy.sh --prod` | Deploy to production domain |

### Automated CI/CD with GitHub Actions

The template includes a pre-configured GitHub Actions workflow (`.github/workflows/deploy.yml`) that:

1. **Triggers on:**
   - Every push to `main` or `master` branch
   - Manual workflow dispatch from GitHub UI

2. **Workflow steps:**
   - Checks out your code
   - Sets up Node.js and Python environments
   - Installs dependencies
   - Runs basic smoke tests
   - Deploys to Vercel production

3. **Setup instructions:**
   ```bash
   # 1. Push the workflow file to your repository
   git add .github/workflows/deploy.yml
   git commit -m "Add GitHub Actions deployment workflow"
   git push
   
   # 2. Add VERCEL_TOKEN to GitHub Secrets:
   #    - Go to: https://github.com/YOUR_USERNAME/YOUR_REPO/settings/secrets/actions
   #    - Click "New repository secret"
   #    - Name: VERCEL_TOKEN
   #    - Value: [paste your Vercel token]
   #    - Click "Add secret"
   ```

4. **Verify deployment:**
   - Visit the "Actions" tab in your GitHub repository
   - Each push will show a new workflow run
   - Click any run to see logs and deployment status

### CI/CD Integration (Custom Pipeline Example)

For other CI/CD platforms, use similar patterns:

**GitLab CI** (`.gitlab-ci.yml`):

```yaml
deploy:
  stage: deploy
  image: node:20
  before_script:
    - npm install -g vercel
  script:
    - vercel deploy --prod --token $VERCEL_TOKEN
  only:
    - main
```

**CircleCI** (`.circleci/config.yml`):

```yaml
version: 2.1
jobs:
  deploy:
    docker:
      - image: cimg/node:20.0
    steps:
      - checkout
      - run: npm install -g vercel
      - run: vercel deploy --prod --token $VERCEL_TOKEN
workflows:
  deploy:
    jobs:
      - deploy:
          filters:
            branches:
              only: main
```

Store `VERCEL_TOKEN` as a secret/environment variable in your CI platform settings.

## Troubleshooting

### "vercel command not found"

**Windows:**
```powershell
npm install -g vercel
# Restart your terminal after installation
```

**Linux/macOS:**
```bash
npm install -g vercel
# May need sudo on some systems
sudo npm install -g vercel
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

**Windows:**
```powershell
# Verify Python installation
python --version

# Check installed packages
python -m pip list

# Reinstall dependencies
python -m pip install -r requirements.txt --force-reinstall
```

**Linux/macOS:**
```bash
# Verify Python installation
python3 --version

# Check installed packages
pip3 list

# Reinstall dependencies
pip3 install -r requirements.txt --force-reinstall

# If using virtual environment
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
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
