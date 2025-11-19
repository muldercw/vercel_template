# Flask on Vercel Starter

Minimal, repeatable baseline for deploying a Python Flask web app to Vercel. The default page responds with `Hello, world!`, making it easy to verify deployments end-to-end before layering on additional logic.

## Project Structure

- `app.py` – Flask application entry point and Vercel serverless handler.
- `requirements.txt` – Runtime dependencies.
- `vercel.json` – Configures Vercel to build and route all traffic to `app.py` using the official Python runtime.
- `.env.deploy.example` – Template for securely storing your Vercel token (copy to `.env.deploy`).
- `deploy.ps1` – Deployment script for Windows (PowerShell).
- `deploy.sh` – Deployment script for Linux/macOS (Bash).
- `.github/workflows/deploy.yml` – GitHub Actions CI/CD automation.
- `.gitignore` – Keeps local environment artifacts out of version control.
- `DEPLOYMENT_GUIDE.md` – Comprehensive guide for agents and developers.

## Prerequisites

1. **Python** 3.11+ with `pip` available on your PATH.
2. **Node.js & npm** (needed for the `vercel` CLI).
3. A Vercel account and a [personal access token](https://vercel.com/docs/rest-api#authentication/vercel-personal-access-tokens) with deploy permission.

## Local Development

```powershell
# Install dependencies
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt

# Run the Flask dev server (http://localhost:5000)
python app.py
```

## Deployment Setup

1. Install the Vercel CLI if you have not already:
   ```powershell
   npm install -g vercel
   ```
2. Create your deployment env file:
   ```powershell
   Copy-Item .env.deploy.example .env.deploy
   # edit .env.deploy and paste your real token
   ```

## Deploying to Vercel

Use the helper script which wraps the Vercel CLI and injects the token automatically:

**Windows (PowerShell):**
```powershell
# Preview deployment (Vercel will provide a unique URL)
./deploy.ps1

# Production deployment
./deploy.ps1 -Prod
```

**Linux/macOS (Bash):**
```bash
# Make executable (first time only)
chmod +x deploy.sh

# Preview deployment
./deploy.sh

# Production deployment
./deploy.sh --prod
```

Behind the scenes the script reads `VERCEL_TOKEN` from `.env.deploy` and runs `vercel deploy --token <token>`. For additional CLI flags (e.g., `--env`, `--build-env`), update the deployment script or invoke the CLI directly.

## Customization Tips

- Add new Flask routes inside `app.py` or split them into blueprints as the app grows.
- Define additional environment variables via `vercel env add` or the project dashboard, then access them from Flask just like `VERCEL_TOKEN` is loaded locally via `python-dotenv`.
- Modify `vercel.json` if you need per-route behaviors or to bump the runtime version.

Once you're ready for CI/CD, port the commands above into your preferred pipeline runner and feed `VERCEL_TOKEN` through your secrets manager.
