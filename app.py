import os
from flask import Flask
from dotenv import load_dotenv

# Load environment variables for local development (noop in Vercel where env vars are managed)
load_dotenv()

app = Flask(__name__)


@app.get("/")
def hello_world():
    """Minimal endpoint returning a greeting."""
    return "Hello, world!"


def run() -> None:
    """Start the development server."""
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)


if __name__ == "__main__":
    run()
