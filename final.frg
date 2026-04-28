#lang forge/temporal

sig Sandwich {}

sig Label {}
one sig Homeless, NotHomeless, DrugUser, Wealthy, Bureaucrat extends Label {}

sig Person {
  var labels: set Label,
  var possesses: lone Sandwich
}

pred DoNothing[p: Person] {
    p.labels' = p.labels
    p.possesses' = p.possesses
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
    (NotHomeless in p.labels) => no p.possesses

    // If you are homeless and ask, you are assigned "DrugUser" and denied
    (Homeless in p.labels) => {
      DrugUser in p.labels'
      no p.possesses
    }
  }
}

pred GovernmentAvenue[p: Person] {
  // If wealthy, the web of nonsense disappears
  (Wealthy in p.labels) => { some s: Sandwich | p.possesses = s }

  // If not wealthy, they enter a state with no valid transitions to "possesses"
  (Wealthy not in p.labels) => {
    // Government bureaucracy nonsense here
    no p.possesses
  }
}

pred BureaucratRemoval[b: Person] {
  
  Bureaucrat in b.labels

  all p: Person | p != b implies {
    (Wealthy in p.labels) => {
      b.labels' = (b.labels - Bureaucrat) + Homeless
      p.labels' = p.labels
    } 

    else {
      some nextLabels: set Label | {
        Wealthy not in nextLabels
        // Homeless in p.labels => 
        p.labels' = nextLabels
      }
      b.labels' = b.labels
    }
  }
}

// run {
//   some p: Person | JobAvenue[p] or StreetAvenue[p] or GovernmentAvenue[p]
// } for exactly 1 Person, exactly 1 Sandwich