# Verifier evidence

The verifier was exercised against three isolated `/app` states. The recorded
outputs are kept in the adjacent scenario directories.

| Scenario | Report | Tests | Reward |
| --- | --- | --- | --- |
| Oracle | `{"total_requests": 6, "unique_ips": 3, "top_path": "/index.html"}` | 4 passed | 1 |
| Nop agent | No report produced | 4 failed | 0 |
| Bugged oracle | `total_requests` deliberately changed to `total + 1` | 3 passed, 1 failed | 0 |

The deliberately introduced bug was:

```python
"total_requests": total + 1,  # deliberate off-by-one error
```

Only criterion 2 failed in that run, showing that the verifier pinpoints the
incorrect field. The committed oracle in `solution/solve.py` is not bugged.
