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

pred DoNothing[p: Person] {
    p.labels' = p.labels
    p.possesses' = p.possesses
}

// --------- EMPLOYMENT AVENUE ---------
// WorkHistory -> Employed -> sandwich (two steps)

pred JobAvenue[p: Person] {
  // gates
  AidApplicant not in p.labels

  // effect: add JobApplicant; if WorkHistory present, add Employed
  p.labels' = p.labels + JobApplicant + (WorkHistory in p.labels => Employed else none)

  // payoff: Employed in CURRENT state earns a sandwich next state
  (Employed in p.labels)     => some p.possesses'
  (Employed not in p.labels) => p.possesses' = p.possesses
}

// -------- AID ---------
// Needy -> AidApproved -> sandwich (two steps)

pred AidAvenue[p: Person] {
  // gates
  JobApplicant not in p.labels

  // effect: add AidApplicant; if Needy present, add AidApproved
  p.labels' = p.labels + AidApplicant + (Needy in p.labels => AidApproved else none)

  // payoff: AidApproved in CURRENT state earns a sandwich next state
  (AidApproved in p.labels)     => some p.possesses'
  (AidApproved not in p.labels) => p.possesses' = p.possesses
}

// --------- STREET AVENUE ---------
// NotHomeless -> assumed fine, no sandwich
// Homeless -> labeled DrugUser, still no sandwich

pred StreetAvenue[p: Person] {
  (NotHomeless in p.labels) => {
    p.possesses' = p.possesses
    p.labels'    = p.labels
  }
  (Homeless in p.labels) => {
    p.possesses' = p.possesses
    p.labels'    = p.labels + DrugUser
  }
  (Homeless not in p.labels and NotHomeless not in p.labels) => {
    p.possesses' = p.possesses
    p.labels'    = p.labels
  }
}

// --------- WEALTHY BYPASS ---------
// No questions asked

pred WealthyBypass[p: Person] {
  Wealthy in p.labels
  some p.possesses'
  p.labels' = p.labels
}

// --------- BUREAUCRAT ---------

pred BureaucratStep[b: Person] {
  Bureaucrat in b.labels
  b.labels'    = b.labels
  b.possesses' = b.possesses
}

// --------- STEP ---------

pred step[p: Person] {
  (Bureaucrat in p.labels) => BureaucratStep[p]
  (Bureaucrat not in p.labels) => {
    (Wealthy in p.labels) => WealthyBypass[p]
    (Wealthy not in p.labels) => {
      JobAvenue[p] or AidAvenue[p] or StreetAvenue[p] or DoNothing[p]
    }
  }
}

// --------- INIT PREDICATES ---------

// has WorkHistory only
pred initEmploymentCandidate[p: Person] {
  no p.possesses
  p.labels = WorkHistory
}

// WorkHistory, but also Aid
pred initEmploymentCandidatePoisoned[p: Person] {
  no p.possesses
  p.labels = WorkHistory + AidApplicant //locks employment
}

// has Needy only
pred initAidCandidate[p: Person] {
  no p.possesses
  p.labels = Needy
}

// has Needy, but also JobApplicant
pred initAidCandidatePoisoned[p: Person] {
  no p.possesses
  p.labels = Needy + JobApplicant //locks aid
}

// employment loop catch, nothing to enter any system
pred initEmploymentCatch22[p: Person] {
  no p.possesses
  no p.labels
}

// Homeless trap
pred initHomeless[p: Person] {
  no p.possesses
  p.labels = Homeless
}

// --------- RUNS ---------

// Should be sat: WorkHistory alone -> Employed (step 1) -> sandwich (step 2)
run {
  some p: Person | {
    initEmploymentCandidate[p]
    always { all q: Person | step[q] }
    eventually some p.possesses
  }
} for exactly 1 Person, exactly 1 Sandwich

// Should be unsat: WorkHistory present but Aid first -> blocks employment
run {
  some p: Person | {
    initEmploymentCandidatePoisoned[p]
    always { all q: Person | step[q] }
    eventually some p.possesses
  }
} for exactly 1 Person, exactly 1 Sandwich

// Should be sat: Needy alone -> AidApproved (step 1) -> sandwich (step 2)
run {
  some p: Person | {
    initAidCandidate[p]
    always { all q: Person | step[q] }
    eventually some p.possesses
  }
} for exactly 1 Person, exactly 1 Sandwich

// Should be unsat: Needy but also Employment requested -> blocks aid
run {
  some p: Person | {
    initAidCandidatePoisoned[p]
    always { all q: Person | step[q] }
    eventually some p.possesses
  }
} for exactly 1 Person, exactly 1 Sandwich

// Should be unsat: employment loop
run {
  some p: Person | {
    initEmploymentCatch22[p]
    always { all q: Person | step[q] }
    eventually some p.possesses
  }
} for exactly 1 Person, exactly 1 Sandwich

// Should be unsat: Homeless trap
run {
  some p: Person | {
    initHomeless[p]
    always { all q: Person | step[q] }
    eventually some p.possesses
  }
} for exactly 1 Person, exactly 1 Sandwich

// Should be sat: Wealthy label -> bypasses all systems instantly
run {
  some p: Person | {
    p.labels = Wealthy
    no p.possesses
    always { all q: Person | step[q] }
    eventually some p.possesses
  }
} for exactly 1 Person, exactly 1 Sandwich