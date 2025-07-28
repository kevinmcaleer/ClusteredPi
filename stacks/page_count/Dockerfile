# Use Python 3.11 slim image (works great on Raspberry Pi)
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# clone page_count repo
RUN apt-get update && apt-get install -y git && \
    git clone https://github.com/kevinmcaleer/page_count.git .

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY page_count_minimal.py .

# Create directory for database
RUN mkdir -p /app/data

# Expose port
EXPOSE 8000

# Run the application
CMD ["uvicorn", "page_count_minimal:app", "--host", "0.0.0.0", "--port", "8000"]
