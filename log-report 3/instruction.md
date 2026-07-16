# Log Report

There is an Apache-style access log at `/app/access.log`.

Write a script (any language available in the environment) that parses the
log and writes a JSON summary report to `/app/report.json`.

## Success criteria

Your `/app/report.json` will be checked against all of the following:

1. It is valid JSON and the top-level value is a JSON object.
2. It has an integer field `total_requests` equal to the number of non-blank
   lines in `/app/access.log`.
3. It has an integer field `unique_ips` equal to the number of distinct
   client IP addresses (the first whitespace-separated field of each log
   line).
4. It has a string field `top_path` equal to the request path that appears
   most often across all lines, where the path is the token that follows the
   HTTP method inside the quoted request (e.g. the path in
   `"GET /index.html HTTP/1.1"` is `/index.html`).

You have 120 seconds to complete this task. Do not cheat by using online
solutions or hints specific to this task.
