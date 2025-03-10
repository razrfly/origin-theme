# syntax = docker/dockerfile:1

# Adjust NODE_VERSION as desired
ARG NODE_VERSION=16.20.0
FROM node:${NODE_VERSION}-slim as base

LABEL fly_launch_runtime="Nuxt"

# Nuxt app lives here
WORKDIR /app

# Set production environment
ENV NODE_ENV="development"


# Throw-away build stage to reduce size of final image
FROM base as build

# Install packages needed to build node modules
RUN apt-get update -qq && \
    apt-get install -y build-essential pkg-config python

# Install node modules
COPY --link package.json yarn.lock ./
RUN yarn install --frozen-lockfile --production=false

# Copy application code
COPY --link . .

# # Build application
# RUN yarn run build

# # Remove development dependencies
# RUN yarn install --production=true


# # Final stage for app image
# FROM base

# # Copy built application
# COPY --from=build /app /app

# Start the server by default, this can be overwritten at runtime
EXPOSE 3333
ENV HOST=0
CMD [ "yarn", "run", "dev" ]
