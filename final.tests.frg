#lang forge/temporal

open "final.frg"

-- sanity checks on the three avenue predicates.
-- note: `example` is not supported in temporal forge, so these use `test expect`.

test expect {
  -- each avenue is satisfiable on its own
  jobAvenueSat: {
    some p: Person | JobAvenue[p]
  } for exactly 1 Person, exactly 1 Sandwich is sat

  streetAvenueSat: {
    some p: Person | StreetAvenue[p]
  } for exactly 1 Person, exactly 1 Sandwich is sat

  governmentAvenueSat: {
    some p: Person | GovernmentAvenue[p]
  } for exactly 1 Person, exactly 1 Sandwich is sat

  -- a wealthy person taking the government avenue should be able to possess a sandwich
  wealthyGetsSandwich: {
    some p: Person | {
      Wealthy in p.labels
      GovernmentAvenue[p]
      some p.possesses
    }
  } for exactly 1 Person, exactly 1 Sandwich is sat
}