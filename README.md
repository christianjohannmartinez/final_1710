# Final Project

## What it is

A comedic-critical art piece in Temporal Forge. For example, a person without a permanent address tries to get help through three avenues: the job market, the housing market, and the aid office. Several paths exist. None of them work for this person. The key distinction is that it is not because the model explicitly bids it, rather that we have built a system that closes every "door" while still appearing, at all the individual steps, to be reasonable. The basic point is not to label the system cruel. The point is to make a system that is formally correct but remains structurally impossible to navigate if you start from the wrong place.

## Three buckets

- Core: people, housing status, document labels and deficiencies, address verification, mailing address, employment, experience, crime records, aid status, friendship and social network dynamics, media stories, public sympathy, the loitering law, the loop between all of them.
- Related but not modeled: labels expiring over time, money, geography, scarcity of aid resources.
- Out of scope: real welfare policy, any explicit statement that the system is discriminatory.

## Goals

- Foundation: the loop runs, a person accumulates loitering records, media responds, sympathy does not recover, the system is stable. The three avenues (job, housing, aid office) each function as written
- Target: show via `unsat` or other visualizer methods that a person starting from Homeless/UnverifiedAddress cannot reach AidGranted, regardless of path taken
- Reach: an interactive interface where the viewer attempts to find a way through the system themselves, directing the solver down one avenue or another, and watching each one close

## How the model works

Each step applies all predicates simultaneously. A homeless person has no mailing address, so UnverifiedAddress is added as a label. Any Deficiency label causes the aid office to deny aid. Being outside accumulates Loitering records. More loitering triggers a CrimeIncrease media story. A media story keeps sympathy Low. Low sympathy keeps the loitering law active. The law adds more records. The crime list defines Murder, Manslaughter, ArmedRobbery, and Loitering. Oly Loitering is ever applied, despite the framing in media as Crime in general

## Modeling choices and tradeoffs

Aid denial reads as a paperwork problem rather than a direct check on housing status, because the aid predicate checks for the absence of any Deficiency label, never mentioning homelessness, even though the two might actually be structurally equivalent. Also, the friendship predicate closes off the mutualAid path: a wealthy contact who could lend an address drops the person once they are visibly homeless and asking. The job market ties back to the same paperwork gate; we see that employment requires a non-NoAddress mailing address. Sympathy cannot recover while any media story is active. No stories requires no new loitering, which requires the law to be inactive, which requires High sympathy. This is the trap we are trying to outline as a whole. Tradeoffs were minimal, mostly around limiting the sceop and complexity due to the underlying difficulty of this topic. We left out dozens of others systems we could have looped in to give time to properly display the ones we settled on.

## What we got out of the modeling exercise

The main finding is that the individual predicates, each of which is reasonable on its own in the system, combine into a larger system with no exit for the person who needs one. The job avenue requires an address. The address requires housing or wealth. The aid avenue requires clean documentation. Clean documentation requires an address. The social network that could provide an address drops you once you are visibly in need. Forge makes this structure verifiable rather than just arguable.

## Status

- sigs, init, all avenue predicates, address dynamics, friendship and social network dynamics, media and sympathy dynamics, and trace structure are all written
- the self-reinforcing loop is structurally present
- Deficiency-based aid denial is in place
- the crime list (Murder, Manslaughter, ArmedRobbery, Loitering) is defined; only Loitering is ever applied, to provide commentary on the nature of media and public interaction
- misleading comments have not been added yet, pending timing on deadline
- custom visualizer is in the works
