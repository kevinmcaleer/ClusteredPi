# Build and serve a project's Storybook static build.
# Builds entirely from this directory by cloning the project's repo at build
# time, so it can run from a central place instead of a local project checkout.
#
# Public repo (HTTPS):
#   docker build --build-arg REPO_URL=https://github.com/you/your-project.git \
#                 --build-arg REPO_BRANCH=main \
#                 -t 192.168.2.1:5000/storybook:latest .
#
# Private repo (SSH, key never baked into the image, requires an ssh-agent
# with the key loaded and BuildKit, which is the Docker default):
#   docker build --ssh default \
#                 --build-arg REPO_URL=git@github.com:you/your-project.git \
#                 --build-arg REPO_BRANCH=main \
#                 -t 192.168.2.1:5000/storybook:latest .
FROM node:20-bookworm-slim AS build
ARG REPO_URL
ARG REPO_BRANCH=main
RUN apt-get update && apt-get install -y --no-install-recommends git openssh-client && rm -rf /var/lib/apt/lists/*
WORKDIR /app
RUN mkdir -p -m 700 ~/.ssh && ssh-keyscan github.com gitlab.com >> ~/.ssh/known_hosts
RUN --mount=type=ssh git clone --depth 1 --branch "${REPO_BRANCH}" "${REPO_URL}" .
RUN npm ci
RUN npm run build-storybook -- -o /app/storybook-static

FROM node:20-bookworm-slim
WORKDIR /app
RUN npm install -g http-server
COPY --from=build /app/storybook-static ./storybook-static
EXPOSE 6006
CMD ["http-server", "storybook-static", "-p", "6006"]
