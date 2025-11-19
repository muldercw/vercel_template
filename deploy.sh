#!/bin/bash
# Vercel deployment script for Linux/macOS
# Usage: ./deploy.sh [--prod]

set -e

ENV_FILE="${ENV_FILE:-.env.deploy}"
PROD_FLAG=""

echo "Starting Vercel deployment script..."

# Check for production flag
if [[ "$1" == "--prod" ]]; then
    PROD_FLAG="--prod"
    echo "Production deployment mode enabled"
fi

# Verify environment file exists
if [[ ! -f "$ENV_FILE" ]]; then
    echo "Error: Environment file '$ENV_FILE' was not found."
    echo "Create it from .env.deploy.example and add your VERCEL_TOKEN."
    exit 1
fi

# Load environment variables from file
set -a
source "$ENV_FILE"
set +a

# Verify token is set
if [[ -z "$VERCEL_TOKEN" ]]; then
    echo "Error: VERCEL_TOKEN is not set. Ensure it exists inside $ENV_FILE."
    exit 1
fi

# Verify Vercel CLI is installed
if ! command -v vercel &> /dev/null; then
    echo "Error: The 'vercel' CLI is not installed or not on PATH."
    echo "Install via: npm install -g vercel"
    exit 1
fi

# Execute deployment
echo "Running: vercel deploy --yes --token \$VERCEL_TOKEN $PROD_FLAG"
vercel deploy --yes --token "$VERCEL_TOKEN" $PROD_FLAG
