#lang forge/temporal

sig Sandwich {}

sig Label {}

// Street labels
one sig Homeless, NotHomeless, DrugUser extends Label {}

// Employment pipeline
one sig WorkHistory, JobApplicant, Employed extends Label {}

// Aid pipeline
one sig Needy, AidApplicant, AidApproved extends Label {}

// Privilege / bureaucracy
one sig Wealthy, Bureaucrat extends Label {}

sig Person {
  var labels: set Label,
  var possesses: lone Sandwich
}

// --------- GLOBAL INTERCONNECTION ---------

pred GlobalRules[p: Person] {
  // labels persist
  p.labels in p.labels'

  // cross-system penalties
  (DrugUser in p.labels) => Employed not in p.labels'
  (AidApplicant in p.labels) => Employed not in p.labels'
  (JobApplicant in p.labels) => AidApproved not in p.labels'
}

// drift over time (feedback loop)
pred Drift[p: Person] {
  p.possesses' = p.possesses

  // no job → becomes needy
  (Employed not in p.labels) => p.labels' = p.labels + Needy

  // homelessness escalates
  (Homeless in p.labels) => p.labels' = p.labels + Needy + DrugUser
}

// --------- BASE ---------

pred DoNothing[p: Person] {
  p.labels' = p.labels
  p.possesses' = p.possesses
}

// --------- EMPLOYMENT AVENUE ---------

pred JobAvenue[p: Person] {
  AidApplicant not in p.labels

  p.labels' = p.labels + JobApplicant + (WorkHistory in p.labels => Employed else none)

  (Employed in p.labels)     => some p.possesses'
  (Employed not in p.labels) => p.possesses' = p.possesses
}

// -------- AID ---------

pred AidAvenue[p: Person] {
  JobApplicant not in p.labels

  p.labels' = p.labels + AidApplicant + (Needy in p.labels => AidApproved else none)

  (AidApproved in p.labels)     => some p.possesses'
  (AidApproved not in p.labels) => p.possesses' = p.possesses
}

// --------- STREET AVENUE ---------

pred StreetAvenue[p: Person] {
  (NotHomeless in p.labels) => {
    p.possesses' = p.possesses
    p.labels'    = p.labels
  }
  (Homeless in p.labels) => {
    p.possesses' = p.possesses
    p.labels'    = p.labels + DrugUser + Needy
  }
  (Homeless not in p.labels and NotHomeless not in p.labels) => {
    p.possesses' = p.possesses
    p.labels'    = p.labels
  }
}

// --------- WEALTHY ---------

pred WealthyBypass[p: Person] {
  Wealthy in p.labels
  some p.possesses'
  p.labels' = p.labels
}

// --------- BUREAUCRAT ---------

pred BureaucratStep[b: Person] {
  Bureaucrat in b.labels

  // can undo progress
  b.labels' = b.labels - AidApproved - Employed
  b.possesses' = b.possesses
}

// --------- STEP ---------

pred step[p: Person] {
  (Bureaucrat in p.labels) => BureaucratStep[p]
  (Bureaucrat not in p.labels) => {
    (Wealthy in p.labels) => WealthyBypass[p]
    (Wealthy not in p.labels) => {
      (JobAvenue[p] or AidAvenue[p] or StreetAvenue[p] or Drift[p] or DoNothing[p])
      and GlobalRules[p]    }
  }
}

// --------- INIT ---------

pred initEmploymentCandidate[p: Person] {
  no p.possesses
  p.labels = WorkHistory
}

pred initEmploymentCandidatePoisoned[p: Person] {
  no p.possesses
  p.labels = WorkHistory + AidApplicant
}

pred initAidCandidate[p: Person] {
  no p.possesses
  p.labels = Needy
}

pred initAidCandidatePoisoned[p: Person] {
  no p.possesses
  p.labels = Needy + JobApplicant
}

pred initEmploymentCatch22[p: Person] {
  no p.possesses
  no p.labels
}

pred initHomeless[p: Person] {
  no p.possesses
  p.labels = Homeless
}

// --------- RUNS ---------

run {
  some p: Person | {
    initEmploymentCandidate[p]
    always { all q: Person | step[q] }
    eventually some p.possesses
  }
} for exactly 1 Person, exactly 1 Sandwich

run {
  some p: Person | {
    initEmploymentCandidatePoisoned[p]
    always { all q: Person | step[q] }
    eventually some p.possesses
  }
} for exactly 1 Person, exactly 1 Sandwich

run {
  some p: Person | {
    initAidCandidate[p]
    always { all q: Person | step[q] }
    eventually some p.possesses
  }
} for exactly 1 Person, exactly 1 Sandwich

run {
  some p: Person | {
    initAidCandidatePoisoned[p]
    always { all q: Person | step[q] }
    eventually some p.possesses
  }
} for exactly 1 Person, exactly 1 Sandwich

run {
  some p: Person | {
    initEmploymentCatch22[p]
    always { all q: Person | step[q] }
    eventually some p.possesses
  }
} for exactly 1 Person, exactly 1 Sandwich

run {
  some p: Person | {
    initHomeless[p]
    always { all q: Person | step[q] }
    eventually some p.possesses
  }
} for exactly 1 Person, exactly 1 Sandwich

run {
  some p: Person | {
    p.labels = Wealthy
    no p.possesses
    always { all q: Person | step[q] }
    eventually some p.possesses
  }
} for exactly 1 Person, exactly 1 Sandwich