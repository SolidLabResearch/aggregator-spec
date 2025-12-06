set -euo pipefail
./pre.sh
bikeshed watch dist/spec.bs dist/index.html
