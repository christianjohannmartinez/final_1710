# Final Project

## What it is

A comedic-critical art piece in Temporal Forge. For example, a person without a permanent
address tries to get help. Several avenues exist. None of them work — not
because the model says so explicitly, but because it has built a self-reinforcing
system that closes every door while appearing, at each individual step, to be
procedurally reasonable.

What is really the point? The identity of the code. It seems to be deliberate in constructing a system that does not work holistically. The code wants to pretend like it is a well-meaning system, when it really denies help. It does this in many ways, and I will provide detaited descriptions of the instances it does this. 
(1) In practice, the only crime committed by a person in our system is loitering, the lamest of all crimes, but the code seeks to mislead by listing various violent crimes first in the sig extensions. 
(2) The lack of an address is reframed as a paperwork issue instead of the lack of a home: this person hasn't filled out their address on the form. 
(3) Similarly, the job search frames the the need for an address as a place to send the check
(4) This allows us also to make choices about when not to make things veiled, as is the case with the fact that if a person is wealthy they are constantly afforded any privilege they need
(5) There are many more, but the a major part of our interactive component is for the viewer to be confused and start to slowly see these things!

How to run? The major run statements confirm that a person cannot be born homeless and then die housed, and other such predicaments. 

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

- `catch-22.frg` — the model
- `catch-22_test.frg` — tests 
- `layout.cnd` - layout file
- `README.md` — this file

Running from the terminal:

    racket catch-22.frg
    racket catch-22_test.frg


## AI Usage 
Used to come up with use cases for the scenarios that people in the system could experience.

## Open questions for the mentor

1. Should `Society` be the only locus of some sympathy/law state, or should individual Person records track something like a publicPerception field separately?
2. Is `Park` the right single safe location, or do you think should there be multiple designated zones that might change over time like the real world? Or too much?