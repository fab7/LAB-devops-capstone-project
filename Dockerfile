FROM python:3.9-slim

# Create working folder 'app' and install dependencies
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application contents (i.e. the service package)
# into the working directory of the same name in the image
COPY service/ ./service/

# Create a non-root user called 'theia', change the ownership
# of the '/app' folder recursively to 'theia', and switch to
# that non-root user
RUN useradd --uid 1000 theia && chown -R theia /app
USER theia

# Expose port 8080 and create a CMD statement that runs 'gunicorn'
EXPOSE 8080
CMD ["gunicorn", "--bind=0.0.0.0:8080", "--log-level=info", "service:app"]
