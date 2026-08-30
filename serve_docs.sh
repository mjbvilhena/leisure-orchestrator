#!/bin/bash
# Script to start the local MkDocs server

echo "Starting the documentation server..."
echo "You can view the docs by opening http://127.0.0.1:8000 in your browser."
echo "Press Ctrl+C to stop the server."
echo ""

cd "$(dirname "$0")"
source .venv/bin/activate
mkdocs serve
