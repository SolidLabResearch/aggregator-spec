set -euo pipefail
./pre.sh
bikeshed spec dist/spec.bs dist/index.html
