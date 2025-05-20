# Cabrera Evil Docker Images - `pgloader`

This repository provides a curated Docker image of [`pgloader`](https://github.com/dimitri/pgloader) compiled from [Pull Request #1531](https://github.com/dimitri/pgloader/pull/1531), built and maintained by [Douglas Cabrera](https://cabrera-dev.com). It is optimized for ARM64 (e.g., Raspberry Pi) and designed for robust, one-off SQLite → PostgreSQL migrations in modern infrastructure.

## 📦 Table of Contents

- [Cabrera Evil Docker Images - `pgloader`](#cabrera-evil-docker-images---pgloader)
  - [📦 Table of Contents](#-table-of-contents)
  - [🚀 Getting Started](#-getting-started)
    - [Pull from local build or registry:](#pull-from-local-build-or-registry)
    - [Run via Docker CLI:](#run-via-docker-cli)
  - [📦 Usage Examples](#-usage-examples)
    - [With `docker-compose`:](#with-docker-compose)
    - [`.env` example:](#env-example)
  - [🛠️ Local Development](#️-local-development)
    - [Build the image manually (with BuildKit enabled):](#build-the-image-manually-with-buildkit-enabled)
  - [📄 License](#-license)

## 🚀 Getting Started

You can use this image for one-time migrations or integrate it into your CI/CD pipelines.

### Pull from local build or registry:

```bash
docker pull cabreraevil/pgloader
```

### Run via Docker CLI:

```bash
docker run --rm \
  -v $(pwd)/db.sqlite3:/db.sqlite3:ro \
  pgloader:pr-1531-arm64 \
  --with "quote identifiers" --with "data only" \
  /db.sqlite3 postgresql://user:pass@host:5432/dbname
```

## 📦 Usage Examples

### With `docker-compose`:

```yaml
services:
  pgloader:
    build:
      context: .
      dockerfile: Dockerfile
    image: pgloader:pr-1531-arm64
    volumes:
      - ./db/db.sqlite3:/db.sqlite3:ro
    command: >
      --with "quote identifiers" --with "data only" /db.sqlite3
      postgresql://${DB_USER}:${DB_PASS}@${DB_HOST}:${DB_PORT}/${DB_NAME}
    env_file:
      - .env
```

### `.env` example:

```env
DB_USER=postgres
DB_PASS=secret
DB_HOST=postgres
DB_PORT=5432
DB_NAME=mydb
```

## 🛠️ Local Development

### Build the image manually (with BuildKit enabled):

```bash
docker buildx build \
  --platform linux/arm64 \
  -t pgloader:pr-1531-arm64 \
  .
```

## 📄 License

This image is based on [pgloader](https://github.com/dimitri/pgloader), released under the PostgreSQL License. Custom Docker packaging by [Douglas Cabrera](https://cabrera-dev.com), licensed under [MIT](LICENSE).

---

© 2025 Douglas Cabrera · [cabrera-dev.com](https://cabrera-dev.com)
