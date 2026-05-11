# Final Project

## What it is

A comedic-critical art piece in Temporal Forge. For example, a person without a permanent
address tries to get help. Several avenues exist. None of them work — not
because the model says so explicitly, but because it has built a self-reinforcing
system that closes every door while appearing, at each individual step, to be
procedurally reasonable.

The main message here is not to label the system cruel, rather to show the system to be
formally correct but ultimately structurally impossible to navigate if
you start from the wrong place.

## Three buckets

- Core: people, status, document labels, location, crime records, media stories,
  public sympathy, the trespassing law, the loop between all of them.
- Related but not modeled: multiple interacting people, labels expiring over time,
  a sandwich or tangible goal object, money.
- Out of scope: real welfare policy, geography, any explicit statement that the
  system is discriminatory.

## Goals

- Foundation: the loop runs, a person accumulates trespassing records, media
  responds, sympathy does not recover, the system is stable.
- Target: show via `unsat` that a person starting from Homeless / UnverifiedAddress
  cannot reach a state where aid is granted, regardless of path taken.
- Reach: an interactive interface where the viewer attempts to find a way through
  the system themselves, directing the solver down one avenue or another, and
  watching each one close.

## Status following Design Check 2 redirection

- sigs, init, trespassing law, media transitions, sympathy dynamics, and trace
  structure are all written
- the self-reinforcing loop is structurally present
- deniedAid is in place with the paperwork framing
- the crime list (Murder, ArmedRobbery, Trespassing) is defined; only Trespassing
  is ever applied
- misleading comments have not been added yet, pending
- custom visualizer is in the works and being perfected

## Files

- `final.frg` — the original, now outdated, model
- `final2.frg` — the model
- `final_tests.frg` — tests (currently references older sandwich model sigs)
- `README.md` — this file

Running from the terminal:

    racket final2.frg
    racket final_tests.frg

## Open questions for the mentor

1. Should `Society` be the only locus of some sympathy/law state, or should individual Person records track something like a publicPerception field separately?
2. Is `Park` the right single safe location, or do you think should there be multiple designated zones that might change over time like the real world? Or too much?

-- maybe one more here, any ideas?
