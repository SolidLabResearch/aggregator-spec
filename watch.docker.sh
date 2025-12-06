set -euo pipefail
./pre.sh
docker run --rm -v $(pwd):/data bikeshed:latest bikeshed watch /data/dist/spec.bs /data/dist/index.html
