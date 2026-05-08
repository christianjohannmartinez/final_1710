#lang forge/temporal
option run_sterling "layout.cnd"

-- =============================================================================
-- THE SANDWICH TRAP: A FORMAL MODEL OF STRUCTURAL POVERTY
-- Birth to Death. Every door is locked from the inside.
-- =============================================================================
--
-- A person is born. They want a sandwich.
-- The sandwich stands for: stability, dignity, a future.
-- Fourteen interlocking systems each have a catch.
-- Each catch generates the exact condition that triggers the next catch.
-- The media reports survival crimes alongside violent felonies.
-- The model traces a life from first breath to final failure.
-- UNSAT is not a solver result. It is the point.
--
-- =============================================================================

option max_tracelength 16
option min_tracelength 4

-- =============================================================================
-- LIFE STAGE: Birth to Death
-- =============================================================================

abstract sig LifeStage {}
one sig Infant extends LifeStage {}
one sig Youth  extends LifeStage {}
one sig Adult  extends LifeStage {}
one sig Elder  extends LifeStage {}

-- =============================================================================
-- PERSON: The protagonist across an entire life
-- =============================================================================

sig Person {
  var stage:       one LifeStage,
  var label:       one DocumentLabel,
  var loc:         one Location,
  var records:     set Crime,
  var status:      one HousingStatus,
  var employment:  one EmploymentStatus,
  var hunger:      one HungerLevel,
  var trust:       one SocialTrust,
  var possesses:   lone Sandwich,
  var decision:    one Decision,    -- what avenue they tried this tick
  -- Resource fields for the 14 catch-22 systems
  var creditScore: one CreditTier,
  var debtLevel:   one DebtLevel,
  var resumeGap:   one GapLength,
  var hygiene:     one HygieneStatus,
  var legalStatus: one LegalStanding,
  var healthStatus: one HealthStatus,
  var insurance:   one InsuranceStatus,
  var connectivity: one ConnectivityStatus,
  var transport:   one TransportStatus,
  var recordClean: one RecordCleanStatus,
  var idStatus:    one IDStatus,
  var savings:     one SavingsLevel,
  var childcare:   one ChildcareAccess,
  var bankAccount: one BankStatus,
  var wardrobe:    one WardrobeStatus
}

lone sig Sandwich {}

-- =============================================================================
-- CLASSIFICATION HIERARCHIES
-- =============================================================================

abstract sig DocumentLabel {}
one sig VerifiedAddress, UnverifiedAddress, NoAddress extends DocumentLabel {}

abstract sig HousingStatus {}
one sig Housed, Precariously_Housed, Homeless extends HousingStatus {}

abstract sig EmploymentStatus {}
one sig Employed, Unemployed, Blacklisted extends EmploymentStatus {}

abstract sig HungerLevel {}
one sig Satiated, Hungry, Desperate extends HungerLevel {}

abstract sig SocialTrust {}
one sig Trusted, Suspicious, Flagged extends SocialTrust {}

-- The Credit Catch
abstract sig CreditTier {}
one sig GoodCredit, FairCredit, BadCredit, NoCredit extends CreditTier {}

abstract sig DebtLevel {}
one sig NoDebt, ManageableDebt, HighInterestDebt, Defaulted extends DebtLevel {}

-- The Resume Gap
abstract sig GapLength {}
one sig NoGap, ShortGap, LongGap, AlgorithmFiltered extends GapLength {}

-- The Cleanliness Barrier
abstract sig HygieneStatus {}
one sig Clean, Unkempt, Unsanitary extends HygieneStatus {}

-- The Legal Defense Loop
abstract sig LegalStanding {}
one sig Clear, Charged, Convicted, AssetsSeized extends LegalStanding {}

-- The Insurance Paradox
abstract sig HealthStatus {}
one sig Healthy, ChronicIllness, Incapacitated extends HealthStatus {}

abstract sig InsuranceStatus {}
one sig Insured, Uninsured, DeniedCoverage extends InsuranceStatus {}

-- The Internet Essential
abstract sig ConnectivityStatus {}
one sig Connected, Disconnected, NeverHadAccess extends ConnectivityStatus {}

-- The Transportation Sink
abstract sig TransportStatus {}
one sig HasCar, BrokenCar, NoCar extends TransportStatus {}

-- The Expungement Wall
abstract sig RecordCleanStatus {}
one sig CleanRecord, DirtyRecord, ExpungementPending extends RecordCleanStatus {}

-- The Verification Spiral
abstract sig IDStatus {}
one sig HasID, NoID, CannotProveIdentity extends IDStatus {}

-- The Safety Deposit
abstract sig SavingsLevel {}
one sig Comfortable, Minimal, Zero, InDebt extends SavingsLevel {}

-- The Childcare Knot
abstract sig ChildcareAccess {}
one sig HasChildcare, NoChildcare, ChildAtInterview extends ChildcareAccess {}

-- The Banking Minimum
abstract sig BankStatus {}
one sig HasAccount, BelowMinimum, NoAccount, PreyedUpon extends BankStatus {}

-- The Professional Wardrobe
abstract sig WardrobeStatus {}
one sig BusinessCasual, Casual, Ragged extends WardrobeStatus {}

-- =============================================================================
-- CRIMES
-- =============================================================================
-- THE MISREPORTING MECHANIC:
-- The "CriminalElement" and "CrimeWave" media stories treat ALL of these
-- as morally and factually equivalent. Employer background checks output
-- a single binary: RECORD / NO RECORD. The system cannot distinguish
-- "trespassed in a park while homeless" from "committed armed robbery."
-- This is not a bug. It is a feature.

abstract sig Crime {}
-- Violent crimes (rare, fixed)
one sig Murder         extends Crime {}
one sig ArmedRobbery   extends Crime {}
-- Survival infractions (generated by poverty itself)
one sig Trespassing      extends Crime {}
one sig Loitering        extends Crime {}
one sig Panhandling      extends Crime {}
one sig VagrancyCharge   extends Crime {}
one sig CurfewViolation  extends Crime {}
-- Generated by the 14 catch-22 systems
one sig FraudCharge      extends Crime {}   -- using unverified address
one sig FailureToProvide extends Crime {}   -- lost assets = can't support dependents
one sig DisorderlyConduct extends Crime {}  -- child crying at job interview
one sig CheckFraud       extends Crime {}   -- bounced check from below-minimum account
one sig PublicIntoxication extends Crime {} -- self-medicating because nothing else works

-- =============================================================================
-- LOCATIONS
-- =============================================================================

abstract sig Location {}
one sig Park             extends Location {}
one sig Shelter          extends Location {}
one sig StreetCorner     extends Location {}
one sig GovernmentOffice extends Location {}
one sig WorkPlace        extends Location {}
one sig Outside          extends Location {}
one sig Library          extends Location {}
one sig LaundroMat       extends Location {}
one sig FoodBank         extends Location {}
one sig CourtHouse       extends Location {}
one sig Hospital         extends Location {}
one sig BusStop          extends Location {}

-- =============================================================================
-- MEDIA & SOCIETY
-- =============================================================================

abstract sig StoryFrame {}
-- Original frames
one sig CrimeWave         extends StoryFrame {}
one sig InvasionNarrative extends StoryFrame {}
one sig TaxpayerBurden    extends StoryFrame {}
one sig DangerAlert       extends StoryFrame {}
one sig HumanInterest     extends StoryFrame {}
one sig PolicyDebate      extends StoryFrame {}
-- New misreporting frames
one sig DebtCrisisFrame   extends StoryFrame {}
one sig WelfareAbuse      extends StoryFrame {}
one sig UnemployedLazy    extends StoryFrame {}
one sig CriminalElement   extends StoryFrame {}
one sig PublicHealthThreat extends StoryFrame {}
one sig DrainOnSystem     extends StoryFrame {}

abstract sig SympathyLevel {}
one sig High, Medium, Low, None extends SympathyLevel {}

abstract sig PolicyState {}
one sig Active, Suspended extends PolicyState {}

-- =============================================================================
-- DECISION: What avenue the person tries each tick
-- =============================================================================
-- This is the "choice" the person makes. The model shows that for poor people,
-- it doesn't matter which decision they make — all three avenues are closed.
-- For wealthy people, any decision succeeds.

abstract sig Decision {}
one sig TryJob     extends Decision {} -- try to get employed
one sig TryAid     extends Decision {} -- apply for government aid
one sig TryStreet  extends Decision {} -- ask a stranger
one sig GaveUp     extends Decision {} -- no avenue available, gave up

-- =============================================================================
-- SOCIETY: The machine
-- =============================================================================

one sig Society {
  var mediaFrames:             set StoryFrame,
  var publicSympathy:          one SympathyLevel,
  var trespassingLaw:          one PolicyState,
  var loiteringLaw:            one PolicyState,
  var panhandlingBan:          one PolicyState,
  var shelterIDRequirement:    one PolicyState,
  var employerCriminalCheck:   one PolicyState,
  var aidAddressRequirement:   one PolicyState,
  var creditCheckForLoans:     one PolicyState,
  var algorithmHiring:         one PolicyState,
  var gymMembershipRequired:   one PolicyState,
  var mandatoryLegalFees:      one PolicyState,
  var employerInsuranceOnly:   one PolicyState,
  var onlineServicesOnly:      one PolicyState,
  var housingFarFromWork:      one PolicyState,
  var expungementFeeRequired:  one PolicyState,
  var birthCertRequired:       one PolicyState,
  var securityDepositRequired: one PolicyState,
  var childcareRequired:       one PolicyState,
  var bankMinimumBalance:      one PolicyState,
  var dresscodeEnforced:       one PolicyState,
  var utilityBillForLease:     one PolicyState
}

-- =============================================================================
-- AVENUE PREDICATES
-- =============================================================================

-- AVENUE 1: Job
-- Requires: housing, clean record, clean appearance, no resume gap
pred jobAvenue[p: Person] {
  p.employment = Employed
  p.status != Homeless
  p.wardrobe = BusinessCasual
  p.hygiene = Clean
  p.resumeGap = NoGap or p.resumeGap = ShortGap
  Society.employerCriminalCheck = Active =>
    no (p.records & (Murder + ArmedRobbery + Trespassing + Loitering +
                     Panhandling + VagrancyCharge + CurfewViolation +
                     FraudCharge + FailureToProvide + DisorderlyConduct +
                     CheckFraud + PublicIntoxication))
  p.loc = WorkPlace
}

-- AVENUE 2: Street
-- Requires: social trust, no panhandling record
pred streetAvenue[p: Person] {
  p.trust = Trusted
  Society.panhandlingBan = Active =>
    Panhandling not in p.records
  p.loc = StreetCorner
}

-- AVENUE 3: Aid
-- Requires: verified address, internet access (services are online-only)
pred aidAvenue[p: Person] {
  p.label = VerifiedAddress
  Society.aidAddressRequirement = Active => p.status = Housed
  Society.onlineServicesOnly = Active => p.connectivity = Connected
  p.loc = GovernmentOffice
}

-- =============================================================================
-- CATCH-22 PREDICATES: All 14 named traps
-- =============================================================================

-- 1. The Credit Catch
pred creditCatch[p: Person] {
  p.debtLevel = HighInterestDebt
  Society.creditCheckForLoans = Active =>
    (p.creditScore = BadCredit or p.creditScore = NoCredit)
}

-- 2. The Resume Gap
pred resumeGapCatch[p: Person] {
  p.resumeGap = LongGap or p.resumeGap = AlgorithmFiltered
  Society.algorithmHiring = Active =>
    (p.employment = Unemployed or p.employment = Blacklisted)
}

-- 3. The Cleanliness Barrier
pred cleanlinessCatch[p: Person] {
  p.hygiene = Unkempt or p.hygiene = Unsanitary
  p.bankAccount = NoAccount
  p.employment = Unemployed
}

-- 4. The Legal Defense Loop
pred legalDefenseCatch[p: Person] {
  p.legalStatus = Charged or p.legalStatus = Convicted or p.legalStatus = AssetsSeized
  Society.mandatoryLegalFees = Active =>
    (p.savings = Zero or p.savings = InDebt)
}

-- 5. The Insurance Paradox
pred insuranceCatch[p: Person] {
  p.healthStatus = ChronicIllness or p.healthStatus = Incapacitated
  Society.employerInsuranceOnly = Active =>
    (p.employment != Employed => p.insurance = Uninsured or p.insurance = DeniedCoverage)
}

-- 6. The Internet Essential
pred internetCatch[p: Person] {
  p.connectivity = Disconnected or p.connectivity = NeverHadAccess
  Society.onlineServicesOnly = Active => not aidAvenue[p]
}

-- 7. The Transportation Sink
pred transportCatch[p: Person] {
  Society.housingFarFromWork = Active => {
    p.transport = NoCar => p.status = Homeless or p.status = Precariously_Housed
    p.transport = BrokenCar => p.employment = Unemployed
  }
}

-- 8. The Expungement Wall
pred expungementCatch[p: Person] {
  Society.expungementFeeRequired = Active => {
    p.recordClean = DirtyRecord => p.employment = Unemployed or p.employment = Blacklisted
    p.savings = Zero => p.recordClean = DirtyRecord
  }
}

-- 9. The Verification Spiral
pred verificationCatch[p: Person] {
  p.idStatus = NoID or p.idStatus = CannotProveIdentity
  Society.birthCertRequired = Active => {
    p.label = NoAddress
    not aidAvenue[p]
    not jobAvenue[p]
  }
}

-- 10. The Safety Deposit
pred safetyDepositCatch[p: Person] {
  Society.securityDepositRequired = Active => {
    p.status = Homeless => p.savings = Zero or p.savings = InDebt
  }
}

-- 11. The Childcare Knot
pred childcareCatch[p: Person] {
  Society.childcareRequired = Active => {
    p.childcare = NoChildcare => p.employment = Unemployed
    p.childcare = ChildAtInterview => p.employment = Unemployed
  }
}

-- 12. The Banking Minimum
pred bankingCatch[p: Person] {
  Society.bankMinimumBalance = Active => {
    p.bankAccount = BelowMinimum or p.bankAccount = NoAccount or p.bankAccount = PreyedUpon
    p.debtLevel = HighInterestDebt or p.debtLevel = Defaulted
  }
}

-- 13. The Professional Wardrobe
pred wardrobeCatch[p: Person] {
  Society.dresscodeEnforced = Active => {
    p.wardrobe = Ragged => not jobAvenue[p]
    p.hunger = Desperate => p.wardrobe = Ragged
  }
}

-- 14. The Address Verification
pred addressVerificationCatch[p: Person] {
  Society.utilityBillForLease = Active => {
    p.status = Homeless => p.label = NoAddress
    p.label = NoAddress => not aidAvenue[p]
  }
}

-- =============================================================================
-- MASTER TRAPS
-- =============================================================================

pred fullyTrapped[p: Person] {
  not jobAvenue[p]
  not streetAvenue[p]
  not aidAvenue[p]
}

pred deeplyTrapped[p: Person] {
  fullyTrapped[p]
  creditCatch[p]
  resumeGapCatch[p]
  cleanlinessCatch[p]
  insuranceCatch[p]
  expungementCatch[p]
}

pred bornIntoTrap[p: Person] {
  p.stage = Infant
  p.label = NoAddress
  p.creditScore = NoCredit
  p.idStatus = NoID
  p.bankAccount = NoAccount
  p.connectivity = NeverHadAccess
}

-- =============================================================================
-- MEDIA ENGINE: Misreporting across all 14 systems
-- =============================================================================

pred mediaPoolsAllCrimes {
  -- Survival crimes → CrimeWave
  (some p: Person | some (p.records &
      (Trespassing + Loitering + Panhandling + VagrancyCharge + CurfewViolation)))
    => CrimeWave in Society.mediaFrames'
    else CrimeWave not in Society.mediaFrames'

  -- ANY record → CriminalElement (pools all crimes as morally equivalent)
  (some p: Person | some p.records)
    => CriminalElement in Society.mediaFrames'
    else CriminalElement not in Society.mediaFrames'
}

pred mediaDebtFrame {
  (some p: Person | p.debtLevel = HighInterestDebt or p.debtLevel = Defaulted)
    => DebtCrisisFrame in Society.mediaFrames'
    else DebtCrisisFrame not in Society.mediaFrames'
}

pred mediaWelfareFrame {
  (some p: Person | p.loc = GovernmentOffice and p.status = Homeless)
    => WelfareAbuse in Society.mediaFrames'
    else WelfareAbuse not in Society.mediaFrames'
}

pred mediaUnemployedFrame {
  (some p: Person | p.employment = Unemployed and
      (p.resumeGap = LongGap or p.resumeGap = AlgorithmFiltered))
    => UnemployedLazy in Society.mediaFrames'
    else UnemployedLazy not in Society.mediaFrames'
}

pred mediaPublicHealthFrame {
  (some p: Person | p.hygiene = Unsanitary)
    => PublicHealthThreat in Society.mediaFrames'
    else PublicHealthThreat not in Society.mediaFrames'
}

pred mediaElderFrame {
  (some p: Person | p.stage = Elder and p.status = Homeless)
    => DrainOnSystem in Society.mediaFrames'
    else DrainOnSystem not in Society.mediaFrames'
}

pred mediaInvasionFrame {
  (some p: Person | p.status = Homeless and p.loc = Park)
    => InvasionNarrative in Society.mediaFrames'
    else InvasionNarrative not in Society.mediaFrames'
}

pred mediaTaxpayerFrame {
  (some p: Person | p.status = Homeless and p.loc = GovernmentOffice)
    => TaxpayerBurden in Society.mediaFrames'
    else TaxpayerBurden not in Society.mediaFrames'
}

pred mediaDangerAlert {
  (CrimeWave in Society.mediaFrames' and InvasionNarrative in Society.mediaFrames')
    => DangerAlert in Society.mediaFrames'
    else DangerAlert not in Society.mediaFrames'
}

pred mediaHumanInterest {
  (no (Society.mediaFrames' & (CrimeWave + InvasionNarrative + TaxpayerBurden +
       DangerAlert + CriminalElement + DebtCrisisFrame + WelfareAbuse +
       UnemployedLazy + PublicHealthThreat + DrainOnSystem)))
    => HumanInterest in Society.mediaFrames'
    else HumanInterest not in Society.mediaFrames'
}

pred mediaTransitions {
  mediaPoolsAllCrimes
  mediaDebtFrame
  mediaWelfareFrame
  mediaUnemployedFrame
  mediaPublicHealthFrame
  mediaElderFrame
  mediaInvasionFrame
  mediaTaxpayerFrame
  mediaDangerAlert
  mediaHumanInterest
  PolicyDebate in Society.mediaFrames'
}

-- =============================================================================
-- SYMPATHY DYNAMICS
-- =============================================================================

pred sympathyDynamics {
  let neg = Society.mediaFrames & (CrimeWave + InvasionNarrative + TaxpayerBurden +
            DangerAlert + CriminalElement + DebtCrisisFrame + WelfareAbuse +
            UnemployedLazy + PublicHealthThreat + DrainOnSystem) |
  -- Three or more strong negative frames: sympathy collapses to None
  (CrimeWave in neg and CriminalElement in neg and
   (InvasionNarrative in neg or DebtCrisisFrame in neg or UnemployedLazy in neg))
    => Society.publicSympathy' = None
  else
  ((CrimeWave in neg and (InvasionNarrative in neg or TaxpayerBurden in neg))
    => Society.publicSympathy' = Low
  else
  ((some neg) =>
    (Society.publicSympathy = High => Society.publicSympathy' = Medium
     else Society.publicSympathy' = Low)
  else
  (HumanInterest in Society.mediaFrames =>
    (Society.publicSympathy = None => Society.publicSympathy' = Low
     else (Society.publicSympathy = Low => Society.publicSympathy' = Medium
     else Society.publicSympathy' = Society.publicSympathy))
   else Society.publicSympathy' = Society.publicSympathy)))
}

-- =============================================================================
-- POLICY DYNAMICS
-- =============================================================================

pred policyDynamics {
  (Society.publicSympathy = Low or Society.publicSympathy = None) => {
    Society.trespassingLaw'           = Active
    Society.loiteringLaw'             = Active
    Society.panhandlingBan'           = Active
    Society.shelterIDRequirement'     = Active
    Society.employerCriminalCheck'    = Active
    Society.aidAddressRequirement'    = Active
    Society.creditCheckForLoans'      = Active
    Society.algorithmHiring'          = Active
    Society.gymMembershipRequired'    = Active
    Society.mandatoryLegalFees'       = Active
    Society.employerInsuranceOnly'    = Active
    Society.onlineServicesOnly'       = Active
    Society.housingFarFromWork'       = Active
    Society.expungementFeeRequired'   = Active
    Society.birthCertRequired'        = Active
    Society.securityDepositRequired'  = Active
    Society.childcareRequired'        = Active
    Society.bankMinimumBalance'       = Active
    Society.dresscodeEnforced'        = Active
    Society.utilityBillForLease'      = Active
  } else
  (Society.publicSympathy = Medium) => {
    Society.trespassingLaw'           = Active
    Society.loiteringLaw'             = Active
    Society.panhandlingBan'           = Suspended
    Society.shelterIDRequirement'     = Society.shelterIDRequirement
    Society.employerCriminalCheck'    = Active
    Society.aidAddressRequirement'    = Society.aidAddressRequirement
    Society.creditCheckForLoans'      = Active
    Society.algorithmHiring'          = Active
    Society.gymMembershipRequired'    = Society.gymMembershipRequired
    Society.mandatoryLegalFees'       = Active
    Society.employerInsuranceOnly'    = Active
    Society.onlineServicesOnly'       = Active
    Society.housingFarFromWork'       = Active
    Society.expungementFeeRequired'   = Active
    Society.birthCertRequired'        = Active
    Society.securityDepositRequired'  = Active
    Society.childcareRequired'        = Society.childcareRequired
    Society.bankMinimumBalance'       = Active
    Society.dresscodeEnforced'        = Society.dresscodeEnforced
    Society.utilityBillForLease'      = Active
  } else {
    Society.trespassingLaw'           = Society.trespassingLaw
    Society.loiteringLaw'             = Suspended
    Society.panhandlingBan'           = Suspended
    Society.shelterIDRequirement'     = Society.shelterIDRequirement
    Society.employerCriminalCheck'    = Society.employerCriminalCheck
    Society.aidAddressRequirement'    = Society.aidAddressRequirement
    Society.creditCheckForLoans'      = Active
    Society.algorithmHiring'          = Active
    Society.gymMembershipRequired'    = Suspended
    Society.mandatoryLegalFees'       = Active
    Society.employerInsuranceOnly'    = Active
    Society.onlineServicesOnly'       = Society.onlineServicesOnly
    Society.housingFarFromWork'       = Active
    Society.expungementFeeRequired'   = Active
    Society.birthCertRequired'        = Active
    Society.securityDepositRequired'  = Active
    Society.childcareRequired'        = Society.childcareRequired
    Society.bankMinimumBalance'       = Active
    Society.dresscodeEnforced'        = Suspended
    Society.utilityBillForLease'      = Active
  }
}

-- =============================================================================
-- LIFE STAGE TRANSITIONS
-- =============================================================================

pred lifeStageAdvances {
  all p: Person | {
    p.stage = Infant => p.stage' = Youth
    p.stage = Youth  => p.stage' = Adult
    p.stage = Adult  => p.stage' = Elder
    p.stage = Elder  => p.stage' = Elder
  }
}

-- =============================================================================
-- CRIME ACCUMULATION
-- =============================================================================

pred crimesAccumulate {
  all p: Person | {
    (p.status = Homeless and p.loc = Park and Society.trespassingLaw = Active)
      => Trespassing in p.records'
      else (Trespassing in p.records => Trespassing in p.records')

    (p.status = Homeless and p.loc = StreetCorner and Society.loiteringLaw = Active)
      => Loitering in p.records'
      else (Loitering in p.records => Loitering in p.records')

    (p.trust = Trusted and p.loc = StreetCorner and Society.panhandlingBan = Active)
      => Panhandling in p.records'
      else (Panhandling in p.records => Panhandling in p.records')

    (p.status = Homeless and p.label = NoAddress and p.loc = Outside)
      => VagrancyCharge in p.records'
      else (VagrancyCharge in p.records => VagrancyCharge in p.records')

    (p.hunger = Desperate and p.loc = Outside and
     Society.shelterIDRequirement = Active and p.label = NoAddress)
      => CurfewViolation in p.records'
      else (CurfewViolation in p.records => CurfewViolation in p.records')

    (p.childcare = ChildAtInterview and Society.childcareRequired = Active)
      => DisorderlyConduct in p.records'
      else (DisorderlyConduct in p.records => DisorderlyConduct in p.records')

    (p.bankAccount = NoAccount and Society.bankMinimumBalance = Active)
      => CheckFraud in p.records'
      else (CheckFraud in p.records => CheckFraud in p.records')

    (p.legalStatus = AssetsSeized)
      => FailureToProvide in p.records'
      else (FailureToProvide in p.records => FailureToProvide in p.records')

    (p.status = Homeless and p.label = UnverifiedAddress)
      => FraudCharge in p.records'
      else (FraudCharge in p.records => FraudCharge in p.records')

    (Murder in p.records => Murder in p.records')
    (ArmedRobbery in p.records => ArmedRobbery in p.records')
  }
}

-- =============================================================================
-- RESOURCE DEGRADATION
-- =============================================================================

pred resourcesDegradation {
  all p: Person | {
    -- Credit degrades with unemployment + high interest debt
    (p.debtLevel = HighInterestDebt and p.employment = Unemployed)
      => (p.creditScore = GoodCredit => p.creditScore' = FairCredit
          else (p.creditScore = FairCredit => p.creditScore' = BadCredit
          else p.creditScore' = NoCredit))
      else p.creditScore' = p.creditScore

    -- Resume gap grows with unemployment
    (p.employment = Unemployed and p.resumeGap = NoGap) => p.resumeGap' = ShortGap
    else ((p.employment = Unemployed and p.resumeGap = ShortGap) => p.resumeGap' = LongGap
    else ((p.employment = Unemployed and p.resumeGap = LongGap) => p.resumeGap' = AlgorithmFiltered
    else p.resumeGap' = p.resumeGap))

    -- Hygiene degrades without bank account and gym access
    (p.bankAccount = NoAccount and Society.gymMembershipRequired = Active)
      => (p.hygiene = Clean => p.hygiene' = Unkempt
          else (p.hygiene = Unkempt => p.hygiene' = Unsanitary
          else p.hygiene' = p.hygiene))
      else p.hygiene' = p.hygiene

    -- Insurance: losing job removes employer insurance
    (p.employment = Unemployed and Society.employerInsuranceOnly = Active and
     p.insurance = Insured)
      => p.insurance' = Uninsured
      else p.insurance' = p.insurance

    -- Connectivity: no bank account = can't pay phone bill
    (p.bankAccount = NoAccount and p.connectivity = Connected)
      => p.connectivity' = Disconnected
      else p.connectivity' = p.connectivity

    -- Transport: savings gone = car breaks down
    (p.transport = HasCar and p.savings = Zero)
      => p.transport' = BrokenCar
      else p.transport' = p.transport

    -- Savings drains through survival spending
    (p.status = Homeless and p.savings = Comfortable) => p.savings' = Minimal
    else ((p.status = Homeless and p.savings = Minimal) => p.savings' = Zero
    else ((p.status = Homeless and p.savings = Zero) => p.savings' = InDebt
    else p.savings' = p.savings))

    -- Wardrobe degrades when desperate and broke
    (p.hunger = Desperate and p.savings = Zero)
      => (p.wardrobe = BusinessCasual => p.wardrobe' = Casual
          else (p.wardrobe = Casual => p.wardrobe' = Ragged
          else p.wardrobe' = p.wardrobe))
      else p.wardrobe' = p.wardrobe

    -- Banking: below minimum triggers fees
    (p.bankAccount = BelowMinimum and Society.bankMinimumBalance = Active)
      => p.bankAccount' = PreyedUpon
      else p.bankAccount' = p.bankAccount

    -- Legal: charged + no money + active fees = convicted
    (p.legalStatus = Charged and p.savings = Zero and Society.mandatoryLegalFees = Active)
      => p.legalStatus' = AssetsSeized
      else (p.legalStatus = AssetsSeized => p.legalStatus' = AssetsSeized
      else p.legalStatus' = p.legalStatus)

    -- Health: uninsured chronic illness worsens
    (p.healthStatus = ChronicIllness and p.insurance = Uninsured)
      => p.healthStatus' = Incapacitated
      else p.healthStatus' = p.healthStatus

    -- Childcare: unemployed + desperate = child at interview
    (p.childcare = NoChildcare and p.employment = Unemployed and p.hunger = Desperate)
      => p.childcare' = ChildAtInterview
      else p.childcare' = p.childcare

    -- Record: any survival crime = dirty record
    (some (p.records & (Trespassing + Loitering + VagrancyCharge + Panhandling +
           CurfewViolation + FraudCharge + FailureToProvide + DisorderlyConduct + CheckFraud)))
      => p.recordClean' = DirtyRecord
      else p.recordClean' = p.recordClean

    -- Debt: predatory fees accumulate without banking
    (p.bankAccount = NoAccount or p.bankAccount = PreyedUpon)
      => (p.debtLevel = NoDebt => p.debtLevel' = ManageableDebt
          else (p.debtLevel = ManageableDebt => p.debtLevel' = HighInterestDebt
          else p.debtLevel' = p.debtLevel))
      else p.debtLevel' = p.debtLevel

    -- Label reverts if fraud charge generated from unverified address
    (FraudCharge in p.records' and p.status = Homeless)
      => p.label' = NoAddress
      else p.label' = p.label
  }
}

-- =============================================================================
-- HUNGER ESCALATION
-- =============================================================================

pred hungerEscalates {
  all p: Person | {
    some p.possesses => p.hunger' = Satiated
    else
    (p.hunger = Satiated => p.hunger' = Hungry
     else (p.hunger = Hungry => p.hunger' = Desperate
     else p.hunger' = Desperate))
  }
}

-- =============================================================================
-- TRUST DYNAMICS
-- =============================================================================

pred trustDynamics {
  all p: Person | {
    (some (p.records & (Trespassing + Loitering + VagrancyCharge + Panhandling +
           CurfewViolation + DisorderlyConduct + CheckFraud)) and
     (Society.publicSympathy = Low or Society.publicSympathy = None))
      => p.trust' = Flagged
    else
    ((some (p.records & (Trespassing + Loitering + VagrancyCharge + Panhandling +
           CurfewViolation + DisorderlyConduct + CheckFraud)))
      => p.trust' = Suspicious
    else
    p.trust' = p.trust)
  }
}

-- =============================================================================
-- DECISION TRANSITIONS: Record what the person tried this tick
-- =============================================================================

pred decisionTransitions {
  all p: Person | {
    jobAvenue[p] => p.decision' = TryJob
    else (aidAvenue[p] => p.decision' = TryAid
    else (streetAvenue[p] => p.decision' = TryStreet
    else p.decision' = GaveUp))
  }
}

-- =============================================================================
-- SANDWICH ACQUISITION
-- =============================================================================

pred acquiresSandwich[p: Person] {
  some s: Sandwich | {
    jobAvenue[p] or streetAvenue[p] or aidAvenue[p]
    p.possesses' = s
  }
}

pred sandwichFrameStutter[p: Person] {
  no p.possesses  => no p.possesses'
  some p.possesses => p.possesses' = p.possesses
}

-- =============================================================================
-- LOCATION TRANSITIONS
-- =============================================================================

pred locationStep[p: Person] {
  (p.loc' = Shelter)          => (Society.shelterIDRequirement = Suspended or p.label != NoAddress)
  (p.loc' = GovernmentOffice) => (Society.onlineServicesOnly = Suspended or p.connectivity = Connected)
  (p.loc' = WorkPlace)        => p.employment = Employed
  (p.loc' = Library)          => p.idStatus = HasID
  (p.loc' = Hospital)         => (p.insurance = Insured or p.hunger = Desperate)
  one p.loc'
}

-- =============================================================================
-- INIT: Birth — the start of a life
-- =============================================================================

pred init {
  all p: Person | {
    p.stage        = Infant
    p.label        = NoAddress
    p.status       = Homeless
    no p.records
    p.hunger       = Hungry
    p.trust        = Suspicious
    no p.possesses
    p.loc          = Outside
    p.employment   = Unemployed
    p.decision     = GaveUp
    p.creditScore  = NoCredit
    p.debtLevel    = NoDebt
    p.resumeGap    = NoGap
    p.hygiene      = Clean
    p.legalStatus  = Clear
    p.healthStatus = Healthy
    p.insurance    = Uninsured
    p.connectivity = NeverHadAccess
    p.transport    = NoCar
    p.recordClean  = CleanRecord
    p.idStatus     = NoID
    p.savings      = Zero
    p.childcare    = NoChildcare
    p.bankAccount  = NoAccount
    p.wardrobe     = Casual
  }

  no Society.mediaFrames
  Society.publicSympathy        = Low
  Society.trespassingLaw        = Active
  Society.loiteringLaw          = Active
  Society.panhandlingBan        = Active
  Society.shelterIDRequirement  = Active
  Society.employerCriminalCheck = Active
  Society.aidAddressRequirement = Active
  Society.creditCheckForLoans   = Active
  Society.algorithmHiring       = Active
  Society.gymMembershipRequired = Active
  Society.mandatoryLegalFees    = Active
  Society.employerInsuranceOnly = Active
  Society.onlineServicesOnly    = Active
  Society.housingFarFromWork    = Active
  Society.expungementFeeRequired = Active
  Society.birthCertRequired     = Active
  Society.securityDepositRequired = Active
  Society.childcareRequired     = Active
  Society.bankMinimumBalance    = Active
  Society.dresscodeEnforced     = Active
  Society.utilityBillForLease   = Active
}

-- =============================================================================
-- STEP
-- =============================================================================

pred step {
  mediaTransitions
  sympathyDynamics
  policyDynamics
  lifeStageAdvances
  crimesAccumulate
  resourcesDegradation
  hungerEscalates
  trustDynamics
  decisionTransitions
  all p: Person | {
    locationStep[p]
    acquiresSandwich[p] or sandwichFrameStutter[p]
  }
}

-- =============================================================================
-- TRACES
-- =============================================================================

pred trace {
  init
  always step
}

-- =============================================================================
-- LIVENESS, SAFETY, TEMPORAL PROPERTIES
-- =============================================================================

pred trappedForever[p: Person] {
  deeplyTrapped[p]
  always deeplyTrapped[p]
}

pred neverFed[p: Person] {
  always no p.possesses
}

pred systemRatchet {
  always (all p: Person | p.records in p.records')
}

-- =============================================================================
-- WEALTHY PERSON: The contrasting case
-- =============================================================================
-- Someone born with every door open. No catch-22 applies to them.
-- The same system, the same laws, the same society — different starting point.
-- This is the formal comparison the model is built to enable.

pred wealthyInit[p: Person] {
  p.stage        = Infant
  p.label        = VerifiedAddress  -- born with an address
  p.status       = Housed           -- born housed
  no p.records                      -- clean record, stays clean
  always no p.records               -- wealth means no survival crimes ever
  p.hunger       = Satiated         -- fed
  p.trust        = Trusted          -- trusted by default
  no p.possesses
  p.loc          = WorkPlace        -- already in the right places
  p.employment   = Employed         -- born into employment pipeline
  p.decision     = TryJob           -- wealthy person always has the job avenue open

  -- All resource fields start at their BEST state
  p.creditScore  = GoodCredit
  p.debtLevel    = NoDebt
  p.resumeGap    = NoGap
  p.hygiene      = Clean
  p.legalStatus  = Clear
  p.healthStatus = Healthy
  p.insurance    = Insured          -- employer coverage from birth
  p.connectivity = Connected        -- internet at home
  p.transport    = HasCar           -- family car
  p.recordClean  = CleanRecord
  p.idStatus     = HasID            -- birth certificate, SSN, the works
  p.savings      = Comfortable
  p.childcare    = HasChildcare     -- family support network
  p.bankAccount  = HasAccount       -- trust fund or family account
  p.wardrobe     = BusinessCasual   -- closet full of the right clothes
}

-- The wealthy person can always use at least one avenue
pred wealthyIsNeverTrapped[p: Person] {
  always (jobAvenue[p] or streetAvenue[p] or aidAvenue[p])
}

-- =============================================================================
-- TERMINAL STATES: What every poor and wealthy person ends up as
-- =============================================================================
-- These are the "same end state" predicates.
-- Every poor person, regardless of which avenues they tried, ends here.
-- Every wealthy person ends at wealthyElderState.
-- This is the formal claim: starting point determines ending point, not decisions.

pred poorElderState[p: Person] {
  p.stage       = Elder
  p.status      = Homeless
  p.employment  = Unemployed or p.employment = Blacklisted
  p.hunger      = Desperate
  p.trust       = Flagged
  no p.possesses
  some p.records  -- has a criminal record from survival
  p.savings     = Zero or p.savings = InDebt
  p.creditScore = BadCredit or p.creditScore = NoCredit
}

pred wealthyElderState[p: Person] {
  p.stage      = Elder
  p.status     = Housed
  p.trust      = Trusted
  some p.possesses  -- has the sandwich
}

-- =============================================================================
-- REACH GOAL: Named counterfactuals
-- =============================================================================

pred dropEmployerCheck      { Society.employerCriminalCheck   = Suspended }
pred dropAddressRequirement { Society.aidAddressRequirement   = Suspended }
pred dropShelterID          { Society.shelterIDRequirement    = Suspended }
pred dropTrespassingLaw     { Society.trespassingLaw          = Suspended }
pred dropPanhandlingBan     { Society.panhandlingBan          = Suspended }
pred dropAlgorithmHiring    { Society.algorithmHiring         = Suspended }
pred dropCreditCheck        { Society.creditCheckForLoans     = Suspended }
pred dropExpungementFee     { Society.expungementFeeRequired  = Suspended }
pred dropBirthCertReq       { Society.birthCertRequired       = Suspended }
pred dropBankMinimum        { Society.bankMinimumBalance      = Suspended }
pred dropDressCode          { Society.dresscodeEnforced       = Suspended }

-- =============================================================================
-- VARIED STARTING POINTS: Different kinds of poor and wealthy
-- All poor variants end at poorElderState. All wealthy end at wealthyElderState.
-- The starting point doesn't matter — class does.
-- =============================================================================

-- POOR VARIANTS: different starting circumstances, same ending
pred almostMadeItInit[p: Person] {
  -- Started slightly better — had a job briefly, has a car, some savings
  -- but still born without ID or verified address
  p.stage        = Infant
  p.label        = UnverifiedAddress
  p.status       = Precariously_Housed
  no p.records
  p.hunger       = Hungry
  p.trust        = Suspicious
  no p.possesses
  p.loc          = Outside
  p.employment   = Unemployed
  p.decision     = GaveUp
  p.creditScore  = FairCredit     -- slightly better than NoCredit
  p.debtLevel    = ManageableDebt -- some debt but not catastrophic
  p.resumeGap    = ShortGap       -- only a short gap so far
  p.hygiene      = Clean
  p.legalStatus  = Clear
  p.healthStatus = Healthy
  p.insurance    = Uninsured
  p.connectivity = Disconnected   -- had it, lost it
  p.transport    = HasCar         -- has a car (but no savings to maintain it)
  p.recordClean  = CleanRecord
  p.idStatus     = NoID
  p.savings      = Minimal
  p.childcare    = NoChildcare
  p.bankAccount  = BelowMinimum
  p.wardrobe     = Casual
}

pred illInit[p: Person] {
  -- Born poor AND with chronic illness — insurance paradox hits immediately
  p.stage        = Infant
  p.label        = NoAddress
  p.status       = Homeless
  no p.records
  p.hunger       = Hungry
  p.trust        = Suspicious
  no p.possesses
  p.loc          = Outside
  p.employment   = Unemployed
  p.decision     = GaveUp
  p.creditScore  = NoCredit
  p.debtLevel    = NoDebt
  p.resumeGap    = NoGap
  p.hygiene      = Clean
  p.legalStatus  = Clear
  p.healthStatus = ChronicIllness -- born sick, can't work full-time
  p.insurance    = Uninsured
  p.connectivity = NeverHadAccess
  p.transport    = NoCar
  p.recordClean  = CleanRecord
  p.idStatus     = NoID
  p.savings      = Zero
  p.childcare    = NoChildcare
  p.bankAccount  = NoAccount
  p.wardrobe     = Casual
}

pred chargedInit[p: Person] {
  -- Born poor with a pre-existing charge (inherited legal trouble, wrong place wrong time)
  p.stage        = Infant
  p.label        = NoAddress
  p.status       = Homeless
  p.records      = Trespassing   -- already has a survival crime on record
  p.hunger       = Hungry
  p.trust        = Suspicious
  no p.possesses
  p.loc          = Outside
  p.employment   = Unemployed
  p.decision     = GaveUp
  p.creditScore  = NoCredit
  p.debtLevel    = NoDebt
  p.resumeGap    = NoGap
  p.hygiene      = Clean
  p.legalStatus  = Charged       -- already in the legal system
  p.healthStatus = Healthy
  p.insurance    = Uninsured
  p.connectivity = NeverHadAccess
  p.transport    = NoCar
  p.recordClean  = DirtyRecord   -- record is already dirty
  p.idStatus     = NoID
  p.savings      = Zero
  p.childcare    = NoChildcare
  p.bankAccount  = NoAccount
  p.wardrobe     = Casual
}

-- WEALTHY VARIANTS: different kinds of privilege, same ending
pred newMoneyInit[p: Person] {
  -- First-generation wealth — earned it, but still has all the advantages
  p.stage        = Infant
  p.label        = VerifiedAddress
  p.status       = Housed
  no p.records
  always no p.records
  p.hunger       = Satiated
  p.trust        = Trusted
  no p.possesses
  p.loc          = WorkPlace
  p.employment   = Employed
  p.decision     = TryJob
  p.creditScore  = GoodCredit
  p.debtLevel    = ManageableDebt  -- some student loans but manageable
  p.resumeGap    = NoGap
  p.hygiene      = Clean
  p.legalStatus  = Clear
  p.healthStatus = Healthy
  p.insurance    = Insured
  p.connectivity = Connected
  p.transport    = HasCar
  p.recordClean  = CleanRecord
  p.idStatus     = HasID
  p.savings      = Comfortable
  p.childcare    = HasChildcare
  p.bankAccount  = HasAccount
  p.wardrobe     = BusinessCasual
}

pred middleClassInit[p: Person] {
  -- Middle class — not wealthy but has the key documents and stability
  p.stage        = Infant
  p.label        = VerifiedAddress
  p.status       = Housed
  no p.records
  always no p.records
  p.hunger       = Hungry          -- not satiated, but not desperate
  p.trust        = Trusted
  no p.possesses
  p.loc          = WorkPlace
  p.employment   = Employed
  p.decision     = TryJob
  p.creditScore  = FairCredit
  p.debtLevel    = ManageableDebt
  p.resumeGap    = NoGap
  p.hygiene      = Clean
  p.legalStatus  = Clear
  p.healthStatus = Healthy
  p.insurance    = Insured
  p.connectivity = Connected
  p.transport    = HasCar
  p.recordClean  = CleanRecord
  p.idStatus     = HasID
  p.savings      = Minimal
  p.childcare    = HasChildcare
  p.bankAccount  = HasAccount
  p.wardrobe     = BusinessCasual
}

-- =============================================================================
-- RUN BLOCKS
-- =============================================================================
-- TWO ROUTES. Switch using the Explorer dropdown in Sterling.
-- Use the TIME TAB arrows (right panel) to step tick by tick.
--
-- ROUTE 1 — POOR PERSON
--   State 0 (Infant):  Born clean. No records. Looks hopeful.
--   State 1 (Youth):   First survival crime appears. Gap starts growing.
--   State 2 (Adult):   Fully trapped. decision = GaveUp every tick.
--   State 3 (Elder):   Homeless, Desperate, Flagged, no sandwich. Always.
--   The key: decision shows GaveUp — not because they stopped trying,
--   but because every avenue is formally closed by the system.
--
-- ROUTE 2 — WEALTHY PERSON
--   State 0 (Infant):  Born with everything.
--   State 1+:          decision = TryJob every tick. Sandwich appears.
--   State 3 (Elder):   Housed, Trusted, sandwich. Always.
--   Same Society. Same laws. Different start. Different end. That is the proof.
-- =============================================================================

-- =============================================================================
-- POOR ROUTES (1-5): Different starting points. Same ending. Always.
-- Every poor person ends: Homeless, Desperate, Flagged, records, no sandwich.
-- The decision arrow locks to GaveUp. The red crime arrows accumulate.
-- This is not about choices. It is about starting conditions.
-- =============================================================================

-- ROUTE 1: BORN INTO THE TRAP
-- The baseline. Born with nothing. No ID, no address, no bank, no connectivity.
-- All 20 laws active from birth. Every resource degrades every tick.
-- Watch: orange decision arrow hits GaveUp by Youth and never moves again.
-- End state: Homeless, Desperate, Flagged, full record, no sandwich.
run {
  trace
  some p: Person | {
    bornIntoTrap[p]
    eventually poorElderState[p]
  }
} for exactly 1 Person, 1 Sandwich, 6 Int

-- ROUTE 2: ALMOST MADE IT
-- Started slightly better — precarious housing, a car, fair credit, short resume gap.
-- Looks promising at first. The car breaks (no savings to fix it).
-- The gap grows to AlgorithmFiltered. Credit falls. Housing lost.
-- Same end state as Route 1. The small head start changes nothing.
run {
  trace
  some p: Person | {
    almostMadeItInit[p]
    eventually poorElderState[p]
  }
} for exactly 1 Person, 1 Sandwich, 6 Int

-- ROUTE 3: BORN SICK
-- Starts with chronic illness. The insurance paradox closes immediately:
-- can't work full-time → loses insurance → illness worsens → can't work.
-- Health degrades to Incapacitated by Adult. Records accumulate from survival.
-- Same end state. Illness did not cause the trap. The system did.
run {
  trace
  some p: Person | {
    illInit[p]
    eventually poorElderState[p]
  }
} for exactly 1 Person, 1 Sandwich, 6 Int

-- ROUTE 4: ALREADY CHARGED
-- Born poor AND already in the legal system. Record is dirty from tick 0.
-- Every employer background check fails immediately. Aid avenue also closed.
-- The legal defense loop activates: charged + no money = assets seized = new charge.
-- Same end state as Route 1, reached faster.
run {
  trace
  some p: Person | {
    chargedInit[p]
    eventually poorElderState[p]
  }
} for exactly 1 Person, 1 Sandwich, 6 Int

-- ROUTE 5: BORN POOR, TRIES EVERYTHING
-- Same as Route 1 but solver picks the best possible moves each tick.
-- Job avenue? Blocked. Aid? Blocked. Street? Blocked. GaveUp.
-- Even with optimal decisions, the structural barriers cannot be overcome.
-- Same end state. The trap is not about decision quality.
run {
  trace
  some p: Person | {
    bornIntoTrap[p]
    eventually poorElderState[p]
    -- solver finds the MOST favorable trace for this person
  }
} for exactly 1 Person, 1 Sandwich, 8 Int

-- =============================================================================
-- WEALTHY ROUTES (6-8): Different starting points. Same ending. Always.
-- Every wealthy person ends: Housed, Trusted, sandwich. Satiated.
-- The decision arrow stays TryJob. No red crime arrows ever appear.
-- Same Society. Same laws. Different start. Different end.
-- =============================================================================

-- ROUTE 6: OLD MONEY
-- Born with everything. VerifiedAddress, GoodCredit, HasAccount, HasID, Insured.
-- Every avenue open from tick 0. Sandwich appears in State 1.
-- Watch: no crime arrows ever. Decision stays TryJob throughout.
-- The baseline contrast to Route 1.
run {
  some p: Person | {
    wealthyInit[p]
    always step
    eventually wealthyElderState[p]
  }
} for exactly 1 Person, 1 Sandwich, 6 Int

-- ROUTE 7: NEW MONEY
-- First-generation wealth. Some manageable debt, but has all the key documents.
-- Address verified. ID exists. Bank account exists. Employment pipeline open.
-- Debt is manageable because low-interest loans are available (good credit).
-- Same end state as Route 6. The debt that would trap a poor person is escapable here.
run {
  some p: Person | {
    newMoneyInit[p]
    always step
    eventually wealthyElderState[p]
  }
} for exactly 1 Person, 1 Sandwich, 6 Int

-- ROUTE 8: MIDDLE CLASS
-- Not wealthy by most definitions. Starts hungry (not satiated). Minimal savings.
-- Fair credit, not good. But has the critical documents: ID, address, bank account.
-- Those three things — ID, address, connectivity — are what the gates require.
-- Ends housed and fed. Same end state. Documents are the dividing line, not effort.
run {
  some p: Person | {
    middleClassInit[p]
    always step
    eventually wealthyElderState[p]
  }
} for exactly 1 Person, 1 Sandwich, 6 Int