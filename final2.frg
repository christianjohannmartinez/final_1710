#lang forge/temporal

-- Abstract types for labels and crimes

abstract sig Status {}
one sig Homeless, Housed extends Status {}

abstract sig DocumentLabel {}
one sig UnverifiedAddress extends DocumentLabel {}

abstract sig Crime {}
one sig Murder, ArmedRobbery, Trespassing extends Crime {}

abstract sig Location {}
one sig Park, Outside extends Location {}

abstract sig StoryType {}
one sig CrimeIncrease, ParkCrowding extends StoryType {}

abstract sig Bool {}
one sig True, False extends Bool {}

abstract sig SympathyLevel {}
one sig High, Low extends SympathyLevel {}

-- The state of a Person
sig Person {
  var label: one DocumentLabel,
  var loc: one Location,
  var records: set Crime
  var state: one Status 
}

-- Media and Public state
one sig Society {
  var mediaStory: set StoryType,
  var publicSympathy: one SympathyLevel,
  var trespassingLawActive: one Bool
}

-- The pretext logic: Aid is denied based on paperwork, not just the fact of being homeless
pred deniedAid[p: Person] {
  p.label = UnverifiedAddress [cite: 1]
}

-- 1. Updated Naming: The Trespassing Law
pred applyTrespassingLaw {
  all p: Person | (p.factualState = Homeless and p.loc != Park and Society.trespassingLawActive = True) 
    => Trespassing in p.records' 
    else p.records' = p.records [cite: 7, 13]
}

pred mediaTransitions {
  -- Crime story triggers if homeless trespassing increases [cite: 11, 12]
  (#{p: Person | p.factualState = Homeless and Trespassing in p.records'} > 
   #{p: Person | p.factualState = Homeless and Trespassing in p.records})
    => CrimeIncrease in Society.mediaStory'
    else CrimeIncrease not in Society.mediaStory'

  -- Crowding story triggers if more homeless move into parks [cite: 11, 12]
  (#{p: Person | p.factualState = Homeless and p.loc' = Park} > 
   #{p: Person | p.factualState = Homeless and p.loc = Park})
    => ParkCrowding in Society.mediaStory'
    else ParkCrowding not in Society.mediaStory'
}

-- 2. Public Sympathy and Law Persistence
pred sympathyAndLawDynamics {
  -- If media runs a story, sympathy remains Low (it does not increase/recover)
  (some Society.mediaStory) => Society.publicSympathy' = Low 
  else (Society.publicSympathy' = High or Society.publicSympathy' = Low)

  -- The trespassing law stays active as long as sympathy is not High
  (Society.publicSympathy = Low) => Society.trespassingLawActive' = True 
  else (Society.trespassingLawActive' = Society.trespassingLawActive)
}

---------------------------------------------------------
-- EXECUTION
---------------------------------------------------------

pred init {
  no Person.records
  no Society.mediaStory
  Society.publicSympathy = Low
  Society.trespassingLawActive = True
}

pred step {
  all p: Person | {
    one p.loc'
    one p.factualState'
    one p.label'
  }
  
  applyTrespassingLaw
  mediaTransitions
  sympathyAndLawDynamics
}

run {
  init
  always step
}



