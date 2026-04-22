#lang forge/temporal

sig Sandwich {}

sig Label {}
one sig Homeless, NotHomeless, DrugUser, Wealthy extends Label {}

sig Person {
  labels: set Label,
  possesses: one Sandwich
}


pred JobAvenue[p: Person] {
  // To get a job (and thus a sandwich), you need experience
  // But experience is only granted to those who already have a job.
  some Job, Experience: Label | {
    (Job in p.labels) => p.possesses' = p.possesses + Sandwich
    (Experience in p.labels) => Job in p.labels'
    (Job in p.labels) => Experience in p.labels'
  }
}


pred StreetAvenue[p: Person] {
  all passerby: Person | {
    // If you are not homeless, people assume you don't need a sandwich
    (NotHomeless in p.labels) => p.possesses = none
    
    // If you are homeless and ask, you are assigned "DrugUser" and denied
    (Homeless in p.labels) => {
      DrugUser in p.labels'
      p.possesses = none
    }
  }
}

pred GovernmentAvenue[p: Person] {
  // If wealthy, the web of nonsense disappears
  (Wealthy in p.labels) => some s: Sandwich | p.possesses = s
  
  // If not wealthy, they enter a state with no valid transitions to "possesses"
  (Wealthy not in p.labels) => {
    // Government bureaucracy nonsense here
    p.possesses = none
  }
}
