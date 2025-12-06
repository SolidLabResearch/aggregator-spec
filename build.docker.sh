set -euo pipefail
./pre.sh
docker run --rm -v $(pwd):/data bikeshed:latest bikeshed spec /data/dist/spec.bs /data/dist/index.html
