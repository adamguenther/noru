# Diagnosis: {short-description}

**Date:** {date}
**Severity:** {total-outage | degraded | intermittent | cosmetic}
**Fault Domain:** {code | infrastructure | configuration | deployment | third-party | data | client}

## Summary

{One-sentence description of the issue and identified root cause.}

## Symptoms

- **What:** {observable behavior}
- **Who affected:** {blast radius}
- **When started:** {timestamp or trigger event}

## Hypotheses Tested

| # | Hypothesis | Domain | Result | Evidence |
|---|-----------|--------|--------|----------|
| 1 | {description} | {domain} | {confirmed/eliminated} | {what was checked, what was found} |

## Root Cause

{Detailed description of the identified root cause. If still ambiguous, list narrowed candidates with confidence levels.}

## Evidence

{Specific log entries, metrics, config values, code references, or observations that support the diagnosis.}

## Recommended Action

{Concrete next steps. If code fix needed, note track promotion. Include rollback plan where applicable.}
