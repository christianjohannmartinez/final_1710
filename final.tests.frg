#lang forge/temporal

open "final.frg"

test expect {
  jobAvenueSat: {
    some p: Person | JobAvenue[p]
  } for exactly 1 Person, exactly 1 Sandwich is sat

  streetAvenueSat: {
    some p: Person | StreetAvenue[p]
  } for exactly 1 Person, exactly 1 Sandwich is sat

  aidAvenueSat: {
    some p: Person | AidAvenue[p]
  } for exactly 1 Person, exactly 1 Sandwich is sat

  wealthyGetsSandwich: {
    some p: Person | {
      Wealthy in p.labels
      AidAvenue[p]
      some p.possesses
    }
  } for exactly 1 Person, exactly 1 Sandwich is sat
}