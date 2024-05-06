# Dockerfile based on https://github.com/evilmartians/ruby-on-whales

ARG RUBY_VERSION=3.2.2
ARG DISTRO_NAME=bookworm

FROM ruby:$RUBY_VERSION-slim-$DISTRO_NAME

ARG DISTRO_NAME

# Install common dependencies
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=tmpfs,target=/var/log \
  rm -f /etc/apt/apt.conf.d/docker-clean; \
  echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache; \
  apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
  build-essential \
  gnupg2 \
  curl \
  less \
  git

# Install postgres
ARG PG_MAJOR=15
RUN curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
  gpg --dearmor -o /usr/share/keyrings/postgres-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/postgres-archive-keyring.gpg] https://apt.postgresql.org/pub/repos/apt/" \
  $DISTRO_NAME-pgdg main $PG_MAJOR | tee /etc/apt/sources.list.d/postgres.list > /dev/null
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=tmpfs,target=/var/log \
  apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
  libpq-dev \
  postgresql-client-$PG_MAJOR

# Install Node.js
ARG NODE_MAJOR=18
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=tmpfs,target=/var/log \
  apt-get update && \
  apt-get install -y curl software-properties-common && \
  curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
  echo "deb https://deb.nodesource.com/node_${NODE_MAJOR}.x $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/nodesource.list && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends nodejs

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
