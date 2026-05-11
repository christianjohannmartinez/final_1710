#lang forge/temporal

abstract sig Status {}
one sig Homeless, Housed extends Status {}

sig Address {}
one sig NoAddress extends Address {}

abstract sig AidStatus {}
one sig AidGranted, NoAid extends AidStatus {}

abstract sig DocumentLabel {}
abstract sig Deficiency extends DocumentLabel {} 
one sig UnverifiedAddress, UnverifiedSSN, MissingDocumentation extends Deficiency {}
one sig ValidDocumentation, Wealthy extends DocumentLabel {}

abstract sig Crime {}
one sig Murder, Manslaughter, ArmedRobbery, Loitering extends Crime {}

abstract sig Experience {}
one sig None, Some extends Experience {}

abstract sig Location {}
one sig Park, Outside, Home extends Location {}

abstract sig StoryType {}
one sig CrimeIncrease, ParkCrowding extends StoryType {}

abstract sig Bool {}
one sig True, False extends Bool {}

abstract sig SympathyLevel {}
one sig High, Low extends SympathyLevel {}

sig Person {
  var labels: set DocumentLabel,
  var loc: one Location,
  var records: set Crime,
  var factualState: one Status,
  var experience: one Experience,
  var employed: one Bool,
  var mailingAddress: one Address,
  var aid: one AidStatus,
  var friends: set Person,
  var askingForAid: one Bool
}

one sig Society {
  var mediaStory: set StoryType,
  var publicSympathy: one SympathyLevel,
  var loiteringLawActive: one Bool
}

pred wealthyDynamics[p: Person] {
  Wealthy in p.labels => {
    p.mailingAddress != NoAddress 
    no (p.labels & Deficiency)
    p.records' = p.records 
    p.experience = Some
  }
}

pred friendship {
  all p: Person | {
    all f: p.friends | {
      (Wealthy in f.labels) => (p not in f.friends)
      (f.askingForAid = True and f.factualState = Homeless) => {
         p.friends' = p.friends - f
      } else {
         p.friends' = p.friends
      }
    }
  }
}

pred mutualAid[p: Person] {
  (some f: p.friends | Wealthy in f.labels) => {
     p.labels' = p.labels - Deficiency
     some f: p.friends | Wealthy in f.labels and p.mailingAddress' = f.mailingAddress
  } else {
     p.labels' = p.labels
     p.mailingAddress' = p.mailingAddress
  }
}

pred addressDynamics {
  all p: Person {
    wealthyDynamics[p]
    (p.factualState = Homeless and Wealthy not in p.labels) => p.mailingAddress = NoAddress
    (p.factualState = Housed or Wealthy in p.labels) => p.mailingAddress != NoAddress
    (p.mailingAddress = NoAddress) => UnverifiedAddress in p.labels
    else UnverifiedAddress not in p.labels
  }
}

pred housingMarket {
  all p: Person {
    wealthyDynamics[p]
    (p.factualState = Homeless and p.factualState' = Housed) => {
      Wealthy in p.labels or (no p.records and p.employed = True)
    }
    (p.factualState = Homeless) => p.loc != Home
  }
}

pred jobMarket {
  all p: Person | {
    (p.employed = False and p.employed' = True) => (Wealthy in p.labels or p.experience = Some)
    (p.experience = None and p.experience' = Some) => p.employed = True
    p.mailingAddress != NoAddress
  }
}

pred aidOfficeProcess[p: Person] {
  (no (p.labels & Deficiency)) => p.aid' = AidGranted
  else p.aid' = NoAid
}

pred applyTrespassingLaw {
  all p: Person | {
    wealthyDynamics[p]
    (Society.loiteringLawActive = True and p.loc = Outside) 
      => Loitering in p.records' 
      else p.records' = p.records 
  }
}

pred mediaAndSympathyDynamics {
  (#{p: Person | p.factualState = Homeless and Loitering in p.records'} > 
   #{p: Person | p.factualState = Homeless and Loitering in p.records})
    => CrimeIncrease in Society.mediaStory'
    else CrimeIncrease not in Society.mediaStory'

  (#{p: Person | p.factualState = Homeless and p.loc' = Park} > 
   #{p: Person | p.factualState = Homeless and p.loc = Park})
    => ParkCrowding in Society.mediaStory'
    else ParkCrowding not in Society.mediaStory'

  (some Society.mediaStory) => Society.publicSympathy' = Low 
  else (Society.publicSympathy' = High or Society.publicSympathy' = Low)

  (Society.publicSympathy = Low) => Society.loiteringLawActive' = True 
  else Society.loiteringLawActive' = Society.loiteringLawActive
}

pred init {
  no Person.records
  no Society.mediaStory
  Society.publicSympathy = Low
  Society.loiteringLawActive = True
  some p: Person | Wealthy in p.labels
  all p: Person, h: Person | h.factualState = Homeless => h in p.friends
  all p, f: Person | (f in p.friends and Wealthy in f.labels) => p not in f.friends
}

pred step {
  all p: Person {
    one p.loc'
    one p.factualState'
    one p.experience'
    one p.employed'
    one p.mailingAddress'
    aidOfficeProcess[p]
    mutualAid[p]
  }
  friendship
  addressDynamics
  housingMarket
  jobMarket
  applyTrespassingLaw
  mediaAndSympathyDynamics
}

run { init always step }



