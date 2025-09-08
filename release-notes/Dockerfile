FROM node:24-slim

RUN apt-get update && apt-get install -y \
    curl \
    git \
    jq \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g @anthropic-ai/claude-code

WORKDIR /workspace

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN mkdir -m 777 -p /etc/.claude/commands

USER node

ENTRYPOINT ["/entrypoint.sh"]
CMD ["--help"]
