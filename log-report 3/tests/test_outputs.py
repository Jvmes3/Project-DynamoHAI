import json
from pathlib import Path

REPORT = Path("/app/report.json")

# Ground truth for the fixed environment/access.log shipped with this task:
#   6 non-blank lines, 3 distinct client IPs, "/index.html" requested 3
#   times (vs. 2 for /about.html and 1 for /api/login) -> unique top path.
EXPECTED_TOTAL_REQUESTS = 6
EXPECTED_UNIQUE_IPS = 3
EXPECTED_TOP_PATH = "/index.html"


def _load_report():
    assert REPORT.exists(), "no /app/report.json found"
    data = json.loads(REPORT.read_text())
    assert isinstance(data, dict), "report.json must contain a JSON object"
    return data


def test_criterion_1_report_is_json_object():
    """Criterion 1: report.json is valid JSON with an object at the top level."""
    _load_report()


def test_criterion_2_total_requests():
    """Criterion 2: total_requests is an integer equal to non-blank log lines."""
    data = _load_report()
    assert type(data.get("total_requests")) is int, "total_requests must be an integer"
    assert data.get("total_requests") == EXPECTED_TOTAL_REQUESTS, (
        f"total_requests: expected {EXPECTED_TOTAL_REQUESTS}, "
        f"got {data.get('total_requests')!r}"
    )


def test_criterion_3_unique_ips():
    """Criterion 3: unique_ips is an integer equal to the distinct client IPs."""
    data = _load_report()
    assert type(data.get("unique_ips")) is int, "unique_ips must be an integer"
    assert data.get("unique_ips") == EXPECTED_UNIQUE_IPS, (
        f"unique_ips: expected {EXPECTED_UNIQUE_IPS}, got {data.get('unique_ips')!r}"
    )


def test_criterion_4_top_path():
    """Criterion 4: top_path is a string equal to the most requested path."""
    data = _load_report()
    assert isinstance(data.get("top_path"), str), "top_path must be a string"
    assert data.get("top_path") == EXPECTED_TOP_PATH, (
        f"top_path: expected {EXPECTED_TOP_PATH!r}, got {data.get('top_path')!r}"
    )
