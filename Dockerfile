FROM alpine:latest

# Install required packages (including ttyd, Python3, pip, git)
RUN apk add --no-cache python3 py3-pip ttyd git

WORKDIR /app

# Clone the project repository
RUN git clone https://github.com/TnS-hun/kobo-book-downloader.git . && \
    apk del git  # Remove git after build to reduce image size

# Create a Python virtual environment and install dependencies
RUN python3 -m venv /venv && \
    . /venv/bin/activate && \
    pip install --no-cache-dir -r requirements.txt

# Add the virtual environment's bin directory to PATH,
# so that subsequent commands prefer the virtual environment's python
ENV PATH="/venv/bin:$PATH"

VOLUME ["/downloads"]

# Expose ttyd's web terminal port
EXPOSE 7681

# Start ttyd, providing an interactive shell environment
CMD ["ttyd", "-p", "7681", "--writable", "sh"]
