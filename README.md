# aggregator-spec
Source files for the Aggregator Protocol specification, written in Bikeshed. This repo includes the modular `.bs` sections and generated outputs under `dist/`.

## Build
Requires Docker only.
```bash
make build
```

## Dev mode (watch + live reload)
```bash
make dev
```
Default dev server: http://localhost:59754/

## Git hook (optional)
Enable the pre-commit hook that builds the spec before every commit to make sure the live website gets properly updated:
```bash
git config core.hooksPath .githooks
```
