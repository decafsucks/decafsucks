# Decaf Sucks

<!-- [![Buildkite build status](https://img.shields.io/buildkite/20f6a2f15ca22d9ff497d9419ae8192fcbdf8d74a7205a5565?logo=buildkite&logoColor=white)](https://buildkite.com/timriley/decafsucks) -->
[![ci](https://github.com/decafsucks/decafsucks/actions/workflows/ci.yml/badge.svg)](https://github.com/decafsucks/decafsucks/actions/workflows/ci.yml)

Decaf Sucks was once a thriving little cafe review app and community.

We’re going to rebuild it as an OSS Hanami 2.0 example application. Watch this space!

## Setup

Install Ruby & Node using [Mise](https://mise.jdx.dev/):

```shell
mise install
```

Run Postgres via Docker Compose:

```shell
docker compose up -d
```

Setup the app:

```
bin/setup
```

Then run the app:

```
bin/dev
```

Open [localhost:2300](http://localhost:2300) to see the app, and [localhost:8025](http://localhost:8025) to inspect emails.
