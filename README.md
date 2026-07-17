# ProjectDynamoHAI

Corrected Harbor onboarding assessment task for generating a JSON summary from
an Apache-style access log.

## Task contents

- `log-report 3/task.toml`: Harbor task configuration
- `log-report 3/instruction.md`: agent instructions and four success criteria
- `log-report 3/environment/`: reproducible task environment and input log
- `log-report 3/solution/`: oracle solution
- `log-report 3/tests/`: verifier with one test per success criterion
- `evidence/`: oracle, nop-agent, and deliberately bugged-solution results

## What was fixed

- **Format:** `artifacts` is a top-level array naming `/app/report.json`, and
  the task metadata and environment fields match the supplied template.
- **Environment:** the Python base image is pinned by digest, verifier
  dependencies are installed at build time, internet access is disabled, and
  no solution hint is copied into the agent environment.
- **Verifier:** four criterion-labelled tests validate JSON shape, typed request
  count, typed unique-IP count, and typed most-common path. Invalid, empty, or
  fabricated reports fail.
- **Instruction:** the output path, schema, parsing rules, and four success
  criteria are explicit and map one-to-one to the verifier tests.

## Validation

The evidence demonstrates that the oracle receives reward `1`, while both a
nop agent and a deliberately wrong request count receive reward `0`. See
[`evidence/README.md`](evidence/README.md) for commands and summaries.
