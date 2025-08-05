FROM node:18-bullseye

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    vim \
    postgresql-client \
    python3 \
    python3-pip \
    build-essential \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Create arheanja user
RUN groupadd --gid 1001 arheanja || true && \
    useradd --uid 1001 --gid 1001 -m -s /bin/bash arheanja && \
    echo "arheanja ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install global npm packages as root
RUN npm install -g @backstage/create-app --force

# Create workspace directory and change ownership
RUN mkdir -p /workspace && chown arheanja:arheanja /workspace

# Switch to arheanja user
USER arheanja
WORKDIR /workspace

# Set environment variables
ENV NODE_ENV=development
ENV BACKSTAGE_APP_CONFIG_backend_database_client=pg

EXPOSE 3000 7007

CMD ["sleep", "infinity"]