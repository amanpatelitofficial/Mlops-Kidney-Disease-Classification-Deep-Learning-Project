FROM python:3.10-slim-bullseye

# Install system dependencies (awscli etc.)
RUN apt-get update && \
    apt-get install -y --no-install-recommends awscli && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy only requirements first (for caching)
COPY requirements.txt .

# Install Python dependencies (ignores -e . for now)
RUN grep -v "^-e ." requirements.txt > temp-requirements.txt && \
    pip install --no-cache-dir -r temp-requirements.txt && \
    rm temp-requirements.txt

# Copy the rest of the app
COPY . .

# If -e . exists, install project in editable mode
RUN if grep -q "^-e ." requirements.txt; then pip install --no-cache-dir -e .; fi

# Default command
CMD ["python", "app.py"]
