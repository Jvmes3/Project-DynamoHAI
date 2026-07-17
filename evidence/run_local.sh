#!/bin/bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
task_dir="$repo_root/log-report"
pytest_bin="${PYTEST_BIN:-pytest}"
run_root="$(mktemp -d)"
trap 'rm -rf "$run_root"' EXIT

run_scenario() {
  local scenario="$1"
  local report_mode="$2"
  local scenario_root="$run_root/$scenario"
  local output_dir="$repo_root/evidence/$scenario"
  mkdir -p "$scenario_root/app" "$scenario_root/tests" "$scenario_root/logs" "$output_dir"
  cp "$task_dir/environment/access.log" "$scenario_root/app/access.log"
  sed "s|Path(\"/app/report.json\")|Path(\"$scenario_root/app/report.json\")|" \
    "$task_dir/tests/test_outputs.py" > "$scenario_root/tests/test_outputs.py"

  if [[ "$report_mode" == "oracle" ]]; then
    sed -e "s|/app/access.log|$scenario_root/app/access.log|" \
        -e "s|/app/report.json|$scenario_root/app/report.json|" \
      "$task_dir/solution/solve.py" > "$scenario_root/solve.py"
    python3 "$scenario_root/solve.py"
  elif [[ "$report_mode" == "bugged" ]]; then
    sed -e "s|/app/access.log|$scenario_root/app/access.log|" \
        -e "s|/app/report.json|$scenario_root/app/report.json|" \
        -e 's/"total_requests": total,/"total_requests": total + 1,  # deliberate off-by-one error/' \
      "$task_dir/solution/solve.py" > "$scenario_root/solve.py"
    python3 "$scenario_root/solve.py"
    grep '"total_requests"' "$scenario_root/solve.py" > "$output_dir/bugged-snippet.txt"
  fi

  set +e
  "$pytest_bin" "$scenario_root/tests/test_outputs.py" -rA \
    --ctrf "$output_dir/ctrf.json" > "$output_dir/pytest.txt" 2>&1
  local status=$?
  set -e
  sed -i.bak 's/[[:space:]]*$//' "$output_dir/pytest.txt"
  rm "$output_dir/pytest.txt.bak"

  if [[ "$status" -eq 0 ]]; then
    echo 1 > "$output_dir/reward.txt"
  else
    echo 0 > "$output_dir/reward.txt"
  fi

  if [[ -f "$scenario_root/app/report.json" ]]; then
    cp "$scenario_root/app/report.json" "$output_dir/report.json"
  fi
}

run_scenario oracle oracle
run_scenario nop nop
run_scenario bugged bugged

echo "Evidence written under $repo_root/evidence"
