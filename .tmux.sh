# Exit the script if any statement returns a non-true return value.
set -e

export LC_NUMERIC=C

__newline='
'

_apply() {
  echo "Embedded bash applied."
}

_ip_address() {
  ip -brief -4 a show | awk -F'[\t\n/ ]+' '$2 == "UP" { print $3; exit}'
}

_used_cpu_percent() {
  top -bn1 | sed -n '/Cpu/p' | awk '{printf("%.1f", 100.0 - $8) }'
}

_used_memory_percent() {
  free | grep Mem | awk '{ printf("%.2f", $3/$2 * 100.0) }'
}

"$@"
