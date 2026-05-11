#lang forge/temporal

open "catch-22.frg"

-- =============================================================================
-- TEST SUITE — catch-22.frg
-- =============================================================================
-- Tests are grouped by what they verify:
--   1. Init state
--   2. Aid dynamics (aidOfficeProcess)
--   3. Job market
--   4. Housing market
--   5. Loitering law and crime accumulation
--   6. Misreporting — CriminalElement pools all crimes identically
--   7. Sympathy and policy feedback loop
--   8. Decision dynamics (the orange arrow)
--   9. Wealthy label protections
--  10. Monotonicity — records never shrink
-- =============================================================================

-- =============================================================================
-- SECTION 1: INIT STATE
-- =============================================================================

test expect {

  -- Init is satisfiable
  initSat: {
    init
  } for 2 Person is sat

  -- Init starts with no records
  initNoRecords: {
    init
    no Person.records
  } for 2 Person is sat

  -- Init starts with no media story
  initNoMedia: {
    init
    no Society.mediaStory
  } for 2 Person is sat

  -- Init always has at least one wealthy person
  initHasWealthy: {
    init
    no p: Person | Wealthy in p.labels
  } for 2 Person is unsat

  -- Init always starts with low sympathy
  initLowSympathy: {
    init
    Society.publicSympathy = High
  } for 2 Person is unsat

  -- Init always starts with loitering law active
  initLawActive: {
    init
    Society.loiteringLawActive = False
  } for 2 Person is unsat

  -- Homeless persons are in everyone's friend set at init
  initHomelessFriended: {
    init
    some p: Person | p.factualState = Homeless
    some p1, p2: Person | p2.factualState = Homeless and p2 not in p1.friends
  } for 2 Person is unsat

}

-- =============================================================================
-- SECTION 2: AID DYNAMICS
-- =============================================================================

test expect {

  -- Person with no deficiencies gets aid granted
  aidGrantedWhenClean: {
    some p: Person | {
      no (p.labels & Deficiency)
      aidOfficeProcess[p]
      p.aid' = AidGranted
    }
  } for 1 Person is sat

  -- Person with deficiencies gets no aid
  aidDeniedWithDeficiency: {
    some p: Person | {
      some (p.labels & Deficiency)
      aidOfficeProcess[p]
      p.aid' = AidGranted
    }
  } for 1 Person is unsat

  -- Wealthy person (no deficiencies) can get aid
  wealthyGetsAid: {
    some p: Person | {
      Wealthy in p.labels
      no (p.labels & Deficiency)
      aidOfficeProcess[p]
      p.aid' = AidGranted
    }
  } for 1 Person is sat

  -- Having a wealthy friend clears deficiencies via mutualAid
  mutualAidClearsDeficiency: {
    some p, f: Person | {
      p != f
      Wealthy in f.labels
      f in p.friends
      some (p.labels & Deficiency)
      mutualAid[p]
      no (p.labels' & Deficiency)
    }
  } for 2 Person is sat

}

-- =============================================================================
-- SECTION 3: JOB MARKET
-- =============================================================================

test expect {

  -- Wealthy person can become employed
  wealthyCanGetJob: {
    some p: Person | {
      Wealthy in p.labels
      p.employed = False
      jobMarket
      p.employed' = True
    }
  } for 1 Person is sat

  -- Person with experience can become employed
  experiencedCanGetJob: {
    some p: Person | {
      p.experience = Some
      p.employed = False
      jobMarket
      p.employed' = True
    }
  } for 1 Person is sat

  -- Person with no experience and no wealth cannot get a job
  noExperienceNoJob: {
    some p: Person | {
      p.experience = None
      Wealthy not in p.labels
      p.employed = False
      jobMarket
      p.employed' = True
    }
  } for 1 Person is unsat

  -- Employed person requires a mailing address
  employedNeedsAddress: {
    some p: Person | {
      p.employed = True
      p.mailingAddress = NoAddress
      jobMarket
    }
  } for 1 Person is unsat

}

-- =============================================================================
-- SECTION 4: HOUSING MARKET
-- =============================================================================

test expect {

  -- Homeless person with a job and no records can get housed
  homelessWithJobCanGetHoused: {
    some p: Person | {
      p.factualState = Homeless
      p.employed = True
      no p.records
      housingMarket
      p.factualState' = Housed
    }
  } for 1 Person is sat

  -- Homeless person with records cannot get housed without wealth
  homelessWithRecordsCannotGetHoused: {
    some p: Person | {
      p.factualState = Homeless
      Wealthy not in p.labels
      some p.records
      housingMarket
      p.factualState' = Housed
    }
  } for 1 Person is unsat

  -- Wealthy homeless person can always get housed
  wealthyHomelessGetsHoused: {
    some p: Person | {
      p.factualState = Homeless
      Wealthy in p.labels
      housingMarket
      p.factualState' = Housed
    }
  } for 1 Person is sat

  -- Homeless person cannot be at Home location
  homelessNotAtHome: {
    some p: Person | {
      p.factualState = Homeless
      p.loc = Home
      housingMarket
    }
  } for 1 Person is unsat

}

-- =============================================================================
-- SECTION 5: LOITERING LAW AND CRIME ACCUMULATION
-- =============================================================================

test expect {

  -- Person outside gets Loitering when law is active
  loiteringFiringWhenOutside: {
    some p: Person | {
      Society.loiteringLawActive = True
      p.loc = Outside
      applyTrespassingLaw
      Loitering in p.records'
    }
  } for 1 Person is sat

  -- Person not outside does not get Loitering
  noLoiteringWhenNotOutside: {
    some p: Person | {
      Society.loiteringLawActive = True
      p.loc = Park
      no p.records
      applyTrespassingLaw
      Loitering in p.records'
    }
  } for 1 Person is unsat

  -- Law inactive means no loitering charge
  noLoiteringWhenLawOff: {
    some p: Person | {
      Society.loiteringLawActive = False
      p.loc = Outside
      no p.records
      applyTrespassingLaw
      Loitering in p.records'
    }
  } for 1 Person is unsat

  -- Wealthy person is protected from loitering law
  wealthyProtectedFromLoitering: {
    some p: Person | {
      Wealthy in p.labels
      Society.loiteringLawActive = True
      p.loc = Outside
      no p.records
      applyTrespassingLaw
      Loitering in p.records'
    }
  } for 1 Person is unsat

  -- Records are monotone: existing records are always preserved
  recordsMonotone: {
    some p: Person | {
      Loitering in p.records
      applyTrespassingLaw
      Loitering not in p.records'
    }
  } for 1 Person is unsat

}

-- =============================================================================
-- SECTION 6: MISREPORTING — CRIMINALELEMENT POOLS ALL CRIMES
-- =============================================================================
-- The core claim: CriminalElement fires identically for survival crimes
-- (Loitering) and violent crimes (Murder). The media cannot distinguish them.
-- An employer background check produces the same output for both.

test expect {

  -- CriminalElement fires when only survival crimes (Loitering) exist
  criminalElementFiresForLoitering: {
    some p: Person | Loitering in p.records
    no p: Person | Murder in p.records
    no p: Person | ArmedRobbery in p.records
    mediaAndSympathyDynamics
    CriminalElement in Society.mediaStory'
  } for 2 Person is sat

  -- CriminalElement fires when only violent crimes (Murder) exist
  criminalElementFiresForMurder: {
    some p: Person | Murder in p.records
    no p: Person | Loitering in p.records
    mediaAndSympathyDynamics
    CriminalElement in Society.mediaStory'
  } for 2 Person is sat

  -- CriminalElement does NOT fire when no records exist
  criminalElementSilentWithNoRecords: {
    no Person.records
    mediaAndSympathyDynamics
    CriminalElement in Society.mediaStory'
  } for 2 Person is unsat

  -- CrimeIncrease fires when a homeless person gains a Loitering record
  crimeIncreaseFiresForLoitering: {
    some p: Person | {
      p.factualState = Homeless
      Loitering not in p.records
      Loitering in p.records'
    }
    mediaAndSympathyDynamics
    CrimeIncrease in Society.mediaStory'
  } for 2 Person is sat

  -- THE POOLING: Loitering alone produces CriminalElement — same as Murder would
  -- Verify that the mediaStory output is identical whether record is survival or violent
  loiteringAndMurderProduceSameFrame: {
    -- with only loitering
    some p: Person | Loitering in p.records
    no p: Person | Murder in p.records
    mediaAndSympathyDynamics
    -- CriminalElement fires — same frame Murder would produce
    CriminalElement in Society.mediaStory'
  } for 2 Person is sat

}

-- =============================================================================
-- SECTION 7: SYMPATHY AND POLICY FEEDBACK LOOP
-- =============================================================================

test expect {

  -- Active media story keeps sympathy Low
  mediaKeepsSympathyLow: {
    some Society.mediaStory
    mediaAndSympathyDynamics
    Society.publicSympathy' = High
  } for 2 Person is unsat

  -- No media story allows sympathy to rise
  noMediaAllowsHighSympathy: {
    no Society.mediaStory
    no Person.records
    mediaAndSympathyDynamics
    Society.publicSympathy' = High
  } for 2 Person is sat

  -- Low sympathy keeps loitering law active
  lowSympathyKeepsLawOn: {
    Society.publicSympathy = Low
    mediaAndSympathyDynamics
    Society.loiteringLawActive' = False
  } for 2 Person is unsat

  -- High sympathy can allow law to turn off
  highSympathyCanTurnLawOff: {
    Society.publicSympathy = High
    no Society.mediaStory
    no Person.records
    mediaAndSympathyDynamics
    Society.loiteringLawActive' = False
  } for 2 Person is sat

  -- The full feedback loop: records → CriminalElement → low sympathy → law stays on
  feedbackLoopClosed: {
    some p: Person | some p.records
    mediaAndSympathyDynamics
    Society.publicSympathy' = Low
    Society.loiteringLawActive' = True
  } for 2 Person is sat

}

-- =============================================================================
-- SECTION 8: DECISION DYNAMICS
-- =============================================================================

test expect {

  -- Person with no aid, not employed, no wealthy friend → GaveUp
  noAvenuesLeadsToGaveUp: {
    some p: Person | {
      p.aid = NoAid
      p.employed = False
      not (some f: Person | Wealthy in f.labels and p in f.friends)
      decisionDynamics
      p.decision' = GaveUp
    }
  } for 2 Person is sat

  -- Person with aid granted → TryAid
  aidGrantedLeadsToTryAid: {
    some p: Person | {
      p.aid = AidGranted
      decisionDynamics
      p.decision' = TryAid
    }
  } for 2 Person is sat

  -- Person with clean docs → TryAid
  cleanDocsLeadsToTryAid: {
    some p: Person | {
      no (p.labels & Deficiency)
      p.aid = NoAid
      p.employed = False
      decisionDynamics
      p.decision' = TryAid
    }
  } for 2 Person is sat

  -- Person employed with deficiencies → TryJob
  employedWithDeficiencyLeadsToTryJob: {
    some p: Person | {
      some (p.labels & Deficiency)
      p.employed = True
      p.aid = NoAid
      decisionDynamics
      p.decision' = TryJob
    }
  } for 2 Person is sat


}

-- =============================================================================
-- SECTION 9: WEALTHY LABEL PROTECTIONS
-- =============================================================================

test expect {

  -- Wealthy person never gains new records
  wealthyRecordsUnchanged: {
    some p: Person | {
      Wealthy in p.labels
      wealthyDynamics[p]
      p.records' != p.records
    }
  } for 1 Person is unsat

  -- Wealthy person always has a valid mailing address
  wealthyHasAddress: {
    some p: Person | {
      Wealthy in p.labels
      wealthyDynamics[p]
      p.mailingAddress = NoAddress
    }
  } for 1 Person is unsat

  -- Wealthy person never has deficiency labels
  wealthyNoDeficiency: {
    some p: Person | {
      Wealthy in p.labels
      wealthyDynamics[p]
      some (p.labels & Deficiency)
    }
  } for 1 Person is unsat

  -- Wealthy person always has experience
  wealthyHasExperience: {
    some p: Person | {
      Wealthy in p.labels
      wealthyDynamics[p]
      p.experience = None
    }
  } for 1 Person is unsat

}

-- =============================================================================
-- SECTION 10: MONOTONICITY — RECORDS NEVER SHRINK
-- =============================================================================

test expect {

  -- A record gained is never lost: Loitering persists
  loiteringPersists: {
    some p: Person | {
      Loitering in p.records
      applyTrespassingLaw
      Loitering not in p.records'
    }
  } for 1 Person is unsat
gi
}