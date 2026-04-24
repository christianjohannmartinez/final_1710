# Final Project

## What it is

A person wants a sandwich. Three avenues can give them one: a job, asking
on the street, and government aid. Each avenue has a catch. The model is
about whether the catches combine into a trap you can't get out of.

## Three buckets

- Core: people, labels, sandwich possession, the three avenues, the catch-22 in each one.
- Related but not modeled: labels expiring over time, multiple people interacting, scarcity of sandwiches.
- Out of scope: real welfare policy, money, geography.

## Goals

- Foundation: a trace runs, a person moves through avenues, labels and possession change the way we expect.
- Target: show via `unsat` that some starting configurations can ever reach a sandwich.
- Reach: compare which single rule change (e.g., drop the experience requirement for a job) unblocks the trap.

## Status at Design Check 1

- sigs, init, three avenue predicates, step, traces — all written
- one run block produces instances
- tests file started, one sanity check passing
- haven't proven the trap yet (open TODO in tests file)

## Files

- `final.frg` — the model
- `final.tests.frg` — tests
- `README.md` — this

From the terminal:

    racket final.frg
    racket final.tests.frg

## Open questions for the mentor

1. Is `lone Sandwich` the right call, or should sandwiches be a shared
   pool that runs out?
2. `step` picks one person and one avenue at random. Is that the right
   abstraction, or should each tick be a fixed avenue?
3. What's the cleanest way to write the "trap is provable" check?

