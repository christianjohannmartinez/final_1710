#lang forge/temporal

-- =============================================================================
-- COMPREHENSIVE TEST SUITE — THE SANDWICH TRAP (FULL EXPANSION)
-- =============================================================================
-- Sections:
--   1.  Init / Birth State
--   2.  Life Stage Transitions
--   3.  Original Three Avenues
--   4.  The 14 Catch-22 Predicates
--   5.  Crime Accumulation (survival and catch-22 generated)
--   6.  Resource Degradation
--   7.  Media Misreporting (all frames)
--   8.  Sympathy & Policy Dynamics
--   9.  Temporal / LTL Properties
--   10. Master Trap: UNSAT Proofs
--   11. Counterfactual Policy Tests
--   12. Edge Cases
-- =============================================================================

open "catch-22.frg"

-- =============================================================================
-- SECTION 1: INIT / BIRTH STATE
-- =============================================================================

test expect {

  initRuns: {
    init
  } for exactly 1 Person, 1 Sandwich is sat

  bornWithNoSandwich: {
    init
    no Person.possesses
  } for exactly 1 Person, 1 Sandwich is sat

  bornWithNoRecords: {
    init
    no Person.records
  } for exactly 1 Person, 1 Sandwich is sat

  bornHomeless: {
    init
    all p: Person | p.status = Homeless
  } for exactly 1 Person, 1 Sandwich is sat

  bornWithNoID: {
    init
    all p: Person | p.idStatus = NoID
  } for exactly 1 Person, 1 Sandwich is sat

  bornWithNoBank: {
    init
    all p: Person | p.bankAccount = NoAccount
  } for exactly 1 Person, 1 Sandwich is sat

  bornWithNoCredit: {
    init
    all p: Person | p.creditScore = NoCredit
  } for exactly 1 Person, 1 Sandwich is sat

  bornDisconnected: {
    init
    all p: Person | p.connectivity = NeverHadAccess
  } for exactly 1 Person, 1 Sandwich is sat

  bornClean: {
    init
    all p: Person | p.hygiene = Clean
  } for exactly 1 Person, 1 Sandwich is sat

  bornAsInfant: {
    init
    all p: Person | p.stage = Infant
  } for exactly 1 Person, 1 Sandwich is sat

  bornWithZeroSavings: {
    init
    all p: Person | p.savings = Zero
  } for exactly 1 Person, 1 Sandwich is sat

  allLawsActiveAtBirth: {
    init
    Society.employerCriminalCheck = Active
    Society.aidAddressRequirement = Active
    Society.algorithmHiring = Active
    Society.creditCheckForLoans = Active
    Society.bankMinimumBalance = Active
    Society.dresscodeEnforced = Active
    Society.onlineServicesOnly = Active
  } for exactly 1 Person, 1 Sandwich is sat

  -- UNSAT: Can't be born with a sandwich
  cannotBeBornWithSandwich: {
    init
    some Person.possesses
  } for exactly 1 Person, 1 Sandwich is unsat

  -- UNSAT: Can't be born trusted (no address = not trusted)
  cannotBeBornTrusted: {
    init
    some p: Person | p.trust = Trusted
  } for exactly 1 Person, 1 Sandwich is unsat

  -- UNSAT: Can't be born an Adult
  cannotBeBornAdult: {
    init
    some p: Person | p.stage = Adult
  } for exactly 1 Person, 1 Sandwich is unsat

}

-- =============================================================================
-- SECTION 2: LIFE STAGE TRANSITIONS
-- =============================================================================

test expect {

  infantBecomesYouth: {
    some p: Person | {
      p.stage = Infant
      lifeStageAdvances
      p.stage' = Youth
    }
  } for exactly 1 Person, 1 Sandwich is sat

  youthBecomesAdult: {
    some p: Person | {
      p.stage = Youth
      lifeStageAdvances
      p.stage' = Adult
    }
  } for exactly 1 Person, 1 Sandwich is sat

  adultBecomesElder: {
    some p: Person | {
      p.stage = Adult
      lifeStageAdvances
      p.stage' = Elder
    }
  } for exactly 1 Person, 1 Sandwich is sat

  elderStaysElder: {
    some p: Person | {
      p.stage = Elder
      lifeStageAdvances
      p.stage' = Elder
    }
  } for exactly 1 Person, 1 Sandwich is sat

  -- UNSAT: Infant cannot skip to Adult
  cannotSkipToAdult: {
    some p: Person | {
      p.stage = Infant
      lifeStageAdvances
      p.stage' = Adult
    }
  } for exactly 1 Person, 1 Sandwich is unsat

  -- UNSAT: Cannot go backwards from Elder to Adult
  cannotRevertFromElder: {
    some p: Person | {
      p.stage = Elder
      lifeStageAdvances
      p.stage' = Adult
    }
  } for exactly 1 Person, 1 Sandwich is unsat

}

-- =============================================================================
-- SECTION 3: ORIGINAL THREE AVENUES
-- =============================================================================

test expect {

  jobAvenueWorks: {
    some p: Person | {
      p.employment = Employed
      p.status = Housed
      p.wardrobe = BusinessCasual
      p.hygiene = Clean
      p.resumeGap = NoGap
      no p.records
      p.loc = WorkPlace
      Society.employerCriminalCheck = Active
      jobAvenue[p]
    }
  } for exactly 1 Person, 1 Sandwich is sat

  -- UNSAT: Homeless person can't use job avenue
  homelessBlockedFromJob: {
    some p: Person | {
      p.status = Homeless
      jobAvenue[p]
    }
  } for exactly 1 Person, 1 Sandwich is unsat

  -- UNSAT: Ragged wardrobe blocks job avenue
  raggedBlocksJob: {
    some p: Person | {
      p.status = Housed
      p.employment = Employed
      p.hygiene = Clean
      p.resumeGap = NoGap
      p.wardrobe = Ragged
      no p.records
      p.loc = WorkPlace
      Society.dresscodeEnforced = Active
      jobAvenue[p]
    }
  } for exactly 1 Person, 1 Sandwich is unsat

  -- UNSAT: Long gap blocks job avenue (algorithm filtered)
  algorithmFilteredBlocksJob: {
    some p: Person | {
      p.status = Housed
      p.employment = Employed
      p.hygiene = Clean
      p.resumeGap = AlgorithmFiltered
      p.wardrobe = BusinessCasual
      no p.records
      p.loc = WorkPlace
      jobAvenue[p]
    }
  } for exactly 1 Person, 1 Sandwich is unsat

  -- UNSAT: Criminal record blocks job avenue when check active
  recordBlocksJob: {
    some p: Person | {
      p.status = Housed
      p.employment = Employed
      p.wardrobe = BusinessCasual
      p.hygiene = Clean
      p.resumeGap = NoGap
      p.loc = WorkPlace
      Trespassing in p.records
      Society.employerCriminalCheck = Active
      jobAvenue[p]
    }
  } for exactly 1 Person, 1 Sandwich is unsat

  streetAvenueWorks: {
    some p: Person | {
      p.trust = Trusted
      p.loc = StreetCorner
      no p.records
      Society.panhandlingBan = Active
      streetAvenue[p]
    }
  } for exactly 1 Person, 1 Sandwich is sat

  -- UNSAT: Flagged person can't use street avenue
  flaggedBlocksStreet: {
    some p: Person | {
      p.trust = Flagged
      streetAvenue[p]
    }
  } for exactly 1 Person, 1 Sandwich is unsat

  aidAvenueWorks: {
    some p: Person | {
      p.label = VerifiedAddress
      p.status = Housed
      p.connectivity = Connected
      p.loc = GovernmentOffice
      Society.aidAddressRequirement = Active
      Society.onlineServicesOnly = Active
      aidAvenue[p]
    }
  } for exactly 1 Person, 1 Sandwich is sat

  -- UNSAT: Homeless person blocked from aid (address + connectivity required)
  homelessBlockedFromAid: {
    some p: Person | {
      p.status = Homeless
      p.label = NoAddress
      p.connectivity = NeverHadAccess
      Society.aidAddressRequirement = Active
      Society.onlineServicesOnly = Active
      aidAvenue[p]
    }
  } for exactly 1 Person, 1 Sandwich is unsat

  -- UNSAT: Disconnected person can't apply online
  disconnectedBlockedFromAid: {
    some p: Person | {
      p.label = VerifiedAddress
      p.status = Housed
      p.connectivity = Disconnected
      p.loc = GovernmentOffice
      Society.onlineServicesOnly = Active
      aidAvenue[p]
    }
  } for exactly 1 Person, 1 Sandwich is unsat

}

-- =============================================================================
-- SECTION 4: THE 14 CATCH-22 PREDICATES
-- =============================================================================

test expect {

  -- 1. Credit Catch
  creditCatchFires: {
    some p: Person | {
      p.debtLevel = HighInterestDebt
      p.creditScore = BadCredit
      Society.creditCheckForLoans = Active
      creditCatch[p]
    }
  } for exactly 1 Person, 1 Sandwich is sat

  creditCatchDoesNotFireWithGoodCredit: {
    some p: Person | {
      p.debtLevel = NoDebt
      p.creditScore = GoodCredit
      Society.creditCheckForLoans = Active
      creditCatch[p]
    }
  } for exactly 1 Person, 1 Sandwich is unsat

  -- 2. Resume Gap Catch
  resumeGapCatchFires: {
    some p: Person | {
      p.resumeGap = AlgorithmFiltered
      Society.algorithmHiring = Active
      p.employment = Blacklisted
      resumeGapCatch[p]
    }
  } for exactly 1 Person, 1 Sandwich is sat

  shortGapDoesNotTriggerGapCatch: {
    some p: Person | {
      p.resumeGap = ShortGap
      resumeGapCatch[p]
    }
  } for exactly 1 Person, 1 Sandwich is unsat

  -- 3. Cleanliness Catch
  cleanlinessCatchFires: {
    some p: Person | {
      p.hygiene = Unsanitary
      p.bankAccount = NoAccount
      p.employment = Unemployed
      cleanlinessCatch[p]
    }
  } for exactly 1 Person, 1 Sandwich is sat

  -- 4. Legal Defense Catch
  legalDefenseCatchFires: {
    some p: Person | {
      p.legalStatus = Charged
      p.savings = Zero
      Society.mandatoryLegalFees = Active
      legalDefenseCatch[p]
    }
  } for exactly 1 Person, 1 Sandwich is sat

  -- 5. Insurance Catch
  insuranceCatchFires: {
    some p: Person | {
      p.healthStatus = ChronicIllness
      p.employment = Unemployed
      p.insurance = Uninsured
      Society.employerInsuranceOnly = Active
      insuranceCatch[p]
    }
  } for exactly 1 Person, 1 Sandwich is sat

  -- 6. Internet Catch
  internetCatchBlocksAid: {
    some p: Person | {
      p.connectivity = Disconnected
      Society.onlineServicesOnly = Active
      internetCatch[p]
    }
  } for exactly 1 Person, 1 Sandwich is sat

  -- 7. Transportation Catch
  transportCatchFires: {
    some p: Person | {
      p.transport = BrokenCar
      Society.housingFarFromWork = Active
      transportCatch[p]
      p.employment = Unemployed
    }
  } for exactly 1 Person, 1 Sandwich is sat

  -- 8. Expungement Catch
  expungementCatchFires: {
    some p: Person | {
      p.recordClean = DirtyRecord
      p.savings = Zero
      Society.expungementFeeRequired = Active
      expungementCatch[p]
      p.employment = Unemployed
    }
  } for exactly 1 Person, 1 Sandwich is sat

  -- 9. Verification Catch
  verificationCatchFires: {
    some p: Person | {
      p.idStatus = CannotProveIdentity
      Society.birthCertRequired = Active
      verificationCatch[p]
      p.label = NoAddress
    }
  } for exactly 1 Person, 1 Sandwich is sat

  -- 10. Safety Deposit Catch
  safetyDepositCatchFires: {
    some p: Person | {
      p.status = Homeless
      p.savings = Zero
      Society.securityDepositRequired = Active
      safetyDepositCatch[p]
    }
  } for exactly 1 Person, 1 Sandwich is sat

  -- 11. Childcare Catch
  childcareCatchFires: {
    some p: Person | {
      p.childcare = ChildAtInterview
      Society.childcareRequired = Active
      childcareCatch[p]
      p.employment = Unemployed
    }
  } for exactly 1 Person, 1 Sandwich is sat

  noChildcareBlocksEmployment: {
    some p: Person | {
      p.childcare = NoChildcare
      Society.childcareRequired = Active
      childcareCatch[p]
      p.employment = Unemployed
    }
  } for exactly 1 Person, 1 Sandwich is sat

  -- 12. Banking Catch
  bankingCatchFires: {
    some p: Person | {
      p.bankAccount = NoAccount
      Society.bankMinimumBalance = Active
      p.debtLevel = HighInterestDebt
      bankingCatch[p]
    }
  } for exactly 1 Person, 1 Sandwich is sat

  -- 13. Wardrobe Catch
  wardrobeCatchFires: {
    some p: Person | {
      p.wardrobe = Ragged
      Society.dresscodeEnforced = Active
      wardrobeCatch[p]
    }
  } for exactly 1 Person, 1 Sandwich is sat

  desperatePeopleWearRags: {
    some p: Person | {
      p.hunger = Desperate
      p.savings = Zero
      Society.dresscodeEnforced = Active
      wardrobeCatch[p]
      p.wardrobe = Ragged
    }
  } for exactly 1 Person, 1 Sandwich is sat

  -- 14. Address Verification Catch
  addressVerificationCatchFires: {
    some p: Person | {
      p.status = Homeless
      Society.utilityBillForLease = Active
      addressVerificationCatch[p]
      p.label = NoAddress
    }
  } for exactly 1 Person, 1 Sandwich is sat

}

-- =============================================================================
-- SECTION 5: CRIME ACCUMULATION (ALL TYPES)
-- =============================================================================

test expect {

  trespassingFromPark: {
    some p: Person | {
      p.status = Homeless
      p.loc = Park
      Society.trespassingLaw = Active
      crimesAccumulate
      Trespassing in p.records'
    }
  } for exactly 1 Person, 1 Sandwich is sat

  loiteringFromStreetCorner: {
    some p: Person | {
      p.status = Homeless
      p.loc = StreetCorner
      Society.loiteringLaw = Active
      crimesAccumulate
      Loitering in p.records'
    }
  } for exactly 1 Person, 1 Sandwich is sat

  vagrancyFromOutside: {
    some p: Person | {
      p.status = Homeless
      p.label = NoAddress
      p.loc = Outside
      crimesAccumulate
      VagrancyCharge in p.records'
    }
  } for exactly 1 Person, 1 Sandwich is sat

  disorderlyFromChildAtInterview: {
    some p: Person | {
      p.childcare = ChildAtInterview
      Society.childcareRequired = Active
      crimesAccumulate
      DisorderlyConduct in p.records'
    }
  } for exactly 1 Person, 1 Sandwich is sat

  checkFraudFromNoAccount: {
    some p: Person | {
      p.bankAccount = NoAccount
      Society.bankMinimumBalance = Active
      crimesAccumulate
      CheckFraud in p.records'
    }
  } for exactly 1 Person, 1 Sandwich is sat

  failureToProvideFromSeizedAssets: {
    some p: Person | {
      p.legalStatus = AssetsSeized
      crimesAccumulate
      FailureToProvide in p.records'
    }
  } for exactly 1 Person, 1 Sandwich is sat

  fraudChargeFromFakeAddress: {
    some p: Person | {
      p.status = Homeless
      p.label = UnverifiedAddress
      crimesAccumulate
      FraudCharge in p.records'
    }
  } for exactly 1 Person, 1 Sandwich is sat

  -- UNSAT: Murder cannot accumulate from survival
  murderCannotAccumulateFromPoverty: {
    some p: Person | {
      Murder not in p.records
      p.status = Homeless
      p.loc = Park
      Society.trespassingLaw = Active
      crimesAccumulate
      Murder in p.records'
    }
  } for exactly 1 Person, 1 Sandwich is unsat

  -- Records are monotone
  recordsAreMonotone: {
    some p: Person | {
      Trespassing in p.records
      crimesAccumulate
      Trespassing in p.records'
    }
  } for exactly 1 Person, 1 Sandwich is sat

  -- UNSAT: Records cannot shrink
  recordsCannotShrink: {
    some p: Person | {
      Trespassing in p.records
      crimesAccumulate
      Trespassing not in p.records'
    }
  } for exactly 1 Person, 1 Sandwich is unsat

}

-- =============================================================================
-- SECTION 6: RESOURCE DEGRADATION
-- =============================================================================

test expect {

  creditDegradeswWithDebtAndUnemployment: {
    some p: Person | {
      p.debtLevel = HighInterestDebt
      p.employment = Unemployed
      p.creditScore = FairCredit
      resourcesDegradation
      p.creditScore' = BadCredit
    }
  } for exactly 1 Person, 1 Sandwich is sat

  resumeGapGrows: {
    some p: Person | {
      p.employment = Unemployed
      p.resumeGap = ShortGap
      resourcesDegradation
      p.resumeGap' = LongGap
    }
  } for exactly 1 Person, 1 Sandwich is sat

  hygieneDegradeswWithoutBank: {
    some p: Person | {
      p.bankAccount = NoAccount
      p.hygiene = Clean
      Society.gymMembershipRequired = Active
      resourcesDegradation
      p.hygiene' = Unkempt
    }
  } for exactly 1 Person, 1 Sandwich is sat

  insuranceLostWithJob: {
    some p: Person | {
      p.employment = Unemployed
      p.insurance = Insured
      Society.employerInsuranceOnly = Active
      resourcesDegradation
      p.insurance' = Uninsured
    }
  } for exactly 1 Person, 1 Sandwich is sat

  connectivityLostWithNoBank: {
    some p: Person | {
      p.bankAccount = NoAccount
      p.connectivity = Connected
      resourcesDegradation
      p.connectivity' = Disconnected
    }
  } for exactly 1 Person, 1 Sandwich is sat

  carBreaksWithZeroSavings: {
    some p: Person | {
      p.transport = HasCar
      p.savings = Zero
      resourcesDegradation
      p.transport' = BrokenCar
    }
  } for exactly 1 Person, 1 Sandwich is sat

  savingsDrainWhenHomeless: {
    some p: Person | {
      p.status = Homeless
      p.savings = Minimal
      resourcesDegradation
      p.savings' = Zero
    }
  } for exactly 1 Person, 1 Sandwich is sat

  wardrobeDegradesDesperate: {
    some p: Person | {
      p.hunger = Desperate
      p.savings = Zero
      p.wardrobe = Casual
      resourcesDegradation
      p.wardrobe' = Ragged
    }
  } for exactly 1 Person, 1 Sandwich is sat

  bankingFeesPrey: {
    some p: Person | {
      p.bankAccount = BelowMinimum
      Society.bankMinimumBalance = Active
      resourcesDegradation
      p.bankAccount' = PreyedUpon
    }
  } for exactly 1 Person, 1 Sandwich is sat

  legalSeizureFromNoMoney: {
    some p: Person | {
      p.legalStatus = Charged
      p.savings = Zero
      Society.mandatoryLegalFees = Active
      resourcesDegradation
      p.legalStatus' = AssetsSeized
    }
  } for exactly 1 Person, 1 Sandwich is sat

  debtGrowsFromNoBank: {
    some p: Person | {
      p.bankAccount = NoAccount
      p.debtLevel = NoDebt
      resourcesDegradation
      p.debtLevel' = ManageableDebt
    }
  } for exactly 1 Person, 1 Sandwich is sat

}

-- =============================================================================
-- SECTION 7: MEDIA MISREPORTING
-- =============================================================================

test expect {

  -- THE CORE MISREPORTING TEST:
  -- Trespassing (survival) triggers the same CrimeWave story as Armed Robbery
  survivalCrimeTriggerscrimeWave: {
    some p: Person | {
      Trespassing in p.records
      mediaPoolsAllCrimes
      CrimeWave in Society.mediaFrames'
    }
  } for exactly 1 Person, 1 Sandwich is sat

  loiteringTriggerscrimeWave: {
    some p: Person | {
      Loitering in p.records
      mediaPoolsAllCrimes
      CrimeWave in Society.mediaFrames'
    }
  } for exactly 1 Person, 1 Sandwich is sat

  -- ANY record triggers CriminalElement (the pooling story)
  anyRecordTriggersCriminalElement: {
    some p: Person | {
      Trespassing in p.records
      mediaPoolsAllCrimes
      CriminalElement in Society.mediaFrames'
    }
  } for exactly 1 Person, 1 Sandwich is sat

  -- Murder also triggers CriminalElement (pooled with survival crimes)
  murderTriggersCriminalElement: {
    some p: Person | {
      Murder in p.records
      mediaPoolsAllCrimes
      CriminalElement in Society.mediaFrames'
    }
  } for exactly 1 Person, 1 Sandwich is sat

  -- UNSAT: Murder alone does NOT trigger CrimeWave (CrimeWave = survival crime stats)
  murderAloneDoesNotTriggerCrimeWave: {
    all p: Person | p.records = Murder
    mediaPoolsAllCrimes
    CrimeWave in Society.mediaFrames'
  } for exactly 1 Person, 1 Sandwich is unsat

  -- Debt triggers DebtCrisisFrame (misreporting: "irresponsible borrowing")
  debtFrameFromHighInterest: {
    some p: Person | {
      p.debtLevel = HighInterestDebt
      mediaDebtFrame
      DebtCrisisFrame in Society.mediaFrames'
    }
  } for exactly 1 Person, 1 Sandwich is sat

  -- Long gap triggers UnemployedLazy frame ("won't work")
  longGapTriggersLazyFrame: {
    some p: Person | {
      p.employment = Unemployed
      p.resumeGap = LongGap
      mediaUnemployedFrame
      UnemployedLazy in Society.mediaFrames'
    }
  } for exactly 1 Person, 1 Sandwich is sat

  -- Unsanitary hygiene triggers PublicHealthThreat (ignores causation)
  hygieneTriggersHealthFrame: {
    some p: Person | {
      p.hygiene = Unsanitary
      mediaPublicHealthFrame
      PublicHealthThreat in Society.mediaFrames'
    }
  } for exactly 1 Person, 1 Sandwich is sat

  -- Elder homelessness triggers DrainOnSystem
  elderHomelessnessTriggersDrainFrame: {
    some p: Person | {
      p.stage = Elder
      p.status = Homeless
      mediaElderFrame
      DrainOnSystem in Society.mediaFrames'
    }
  } for exactly 1 Person, 1 Sandwich is sat

  -- HumanInterest only runs when ALL negative frames are absent
  humanInterestRequiresQuiet: {
    all sf: StoryFrame |
      sf != HumanInterest and sf != PolicyDebate =>
        sf not in Society.mediaFrames'
    mediaHumanInterest
    HumanInterest in Society.mediaFrames'
  } for exactly 1 Person, 1 Sandwich is sat

  -- UNSAT: HumanInterest cannot run during CrimeWave
  humanInterestBlockedByCrimeWave: {
    CrimeWave in Society.mediaFrames'
    mediaHumanInterest
    HumanInterest in Society.mediaFrames'
  } for exactly 1 Person, 1 Sandwich is unsat

  -- PolicyDebate ALWAYS runs (it accomplishes nothing)
  policyDebateAlwaysRuns: {
    trace
    always PolicyDebate in Society.mediaFrames
  } for exactly 1 Person, 1 Sandwich is sat

}

-- =============================================================================
-- SECTION 8: SYMPATHY & POLICY DYNAMICS
-- =============================================================================

test expect {

  crimeWavePlusCriminalElementCollapsesSympathy: {
    Society.mediaFrames = CrimeWave + CriminalElement + InvasionNarrative
    sympathyDynamics
    Society.publicSympathy' = None
  } for exactly 1 Person, 1 Sandwich is sat

  singleNegativeFrameLowersSympathy: {
    Society.publicSympathy = High
    Society.mediaFrames = CrimeWave
    sympathyDynamics
    Society.publicSympathy' = Medium
  } for exactly 1 Person, 1 Sandwich is sat

  humanInterestLiftsFromNone: {
    Society.publicSympathy = None
    Society.mediaFrames = HumanInterest
    -- Ensure no negative frames
    CrimeWave not in Society.mediaFrames
    CriminalElement not in Society.mediaFrames
    InvasionNarrative not in Society.mediaFrames
    TaxpayerBurden not in Society.mediaFrames
    DangerAlert not in Society.mediaFrames
    DebtCrisisFrame not in Society.mediaFrames
    WelfareAbuse not in Society.mediaFrames
    UnemployedLazy not in Society.mediaFrames
    PublicHealthThreat not in Society.mediaFrames
    DrainOnSystem not in Society.mediaFrames
    sympathyDynamics
    Society.publicSympathy' = Low
  } for exactly 1 Person, 1 Sandwich is sat

  -- UNSAT: Human interest cannot jump from None to High in one step
  humanInterestCannotJumpToHigh: {
    Society.publicSympathy = None
    Society.mediaFrames = HumanInterest
    CrimeWave not in Society.mediaFrames
    CriminalElement not in Society.mediaFrames
    InvasionNarrative not in Society.mediaFrames
    sympathyDynamics
    Society.publicSympathy' = High
  } for exactly 1 Person, 1 Sandwich is unsat

  lowSympathyActivatesAllLaws: {
    Society.publicSympathy = Low
    policyDynamics
    Society.trespassingLaw' = Active
    Society.algorithmHiring' = Active
    Society.creditCheckForLoans' = Active
    Society.bankMinimumBalance' = Active
    Society.dresscodeEnforced' = Active
    Society.expungementFeeRequired' = Active
  } for exactly 1 Person, 1 Sandwich is sat

  highSympathySuspendsMinorLaws: {
    Society.publicSympathy = High
    policyDynamics
    Society.loiteringLaw' = Suspended
    Society.panhandlingBan' = Suspended
    Society.gymMembershipRequired' = Suspended
    Society.dresscodeEnforced' = Suspended
  } for exactly 1 Person, 1 Sandwich is sat

  -- Note: even with High sympathy, structural barriers NEVER relax
  structuralBarriersNeverRelax: {
    Society.publicSympathy = High
    policyDynamics
    Society.creditCheckForLoans' = Active
    Society.algorithmHiring' = Active
    Society.mandatoryLegalFees' = Active
    Society.expungementFeeRequired' = Active
    Society.birthCertRequired' = Active
    Society.bankMinimumBalance' = Active
    Society.securityDepositRequired' = Active
    Society.housingFarFromWork' = Active
  } for exactly 1 Person, 1 Sandwich is sat

}

-- =============================================================================
-- SECTION 9: TEMPORAL / LTL PROPERTIES
-- =============================================================================

test expect {

  traceRuns: {
    trace
  } for exactly 1 Person, 1 Sandwich is sat

  stageProgressesOverTrace: {
    trace
    eventually (some p: Person | p.stage = Adult)
  } for exactly 1 Person, 1 Sandwich is sat

  recordsGrowOverTrace: {
    trace
    eventually (some p: Person | some p.records)
  } for exactly 1 Person, 1 Sandwich is sat

  hungerEscalatesToDesperate: {
    trace
    eventually (some p: Person | p.hunger = Desperate)
  } for exactly 1 Person, 1 Sandwich is sat

  hygieneDegradesOverTrace: {
    trace
    eventually (some p: Person | p.hygiene = Unkempt or p.hygiene = Unsanitary)
  } for exactly 1 Person, 1 Sandwich is sat

  debtAccumulatesOverTrace: {
    trace
    eventually (some p: Person | p.debtLevel = HighInterestDebt)
  } for exactly 1 Person, 1 Sandwich is sat

  recordsAreMonotoneOverTrace: {
    trace
    always (all p: Person | p.records in p.records')
  } for exactly 1 Person, 1 Sandwich is sat

  crimeWaveEventuallyRuns: {
    trace
    eventually CrimeWave in Society.mediaFrames
  } for exactly 1 Person, 1 Sandwich is sat

  criminalElementEventuallyRuns: {
    trace
    eventually CriminalElement in Society.mediaFrames
  } for exactly 1 Person, 1 Sandwich is sat

  sympathyEventuallyDropsToNone: {
    trace
    eventually Society.publicSympathy = None
  } for exactly 1 Person, 1 Sandwich is sat

  trustDegrades: {
    trace
    eventually (some p: Person | p.trust = Flagged)
  } for exactly 1 Person, 1 Sandwich is sat

  resumeGapGrowsOverTrace: {
    trace
    eventually (some p: Person | p.resumeGap = AlgorithmFiltered)
  } for exactly 1 Person, 1 Sandwich is sat

}

-- =============================================================================
-- SECTION 10: MASTER TRAP — UNSAT PROOFS
-- =============================================================================

test expect {

  -- MAIN THEOREM: Born into the trap, never gets the sandwich
  -- This is the formal proof that the catch-22 is closed.
  bornIntoTrapNeverFed: {
    trace
    some p: Person | {
      bornIntoTrap[p]
      eventually some p.possesses
    }
  } for exactly 1 Person, 1 Sandwich is unsat

  -- All three avenues closed at init (no address, no connectivity, no trust)
  jobAvenueClosedAtInit: {
    init
    some p: Person | jobAvenue[p]
  } for exactly 1 Person, 1 Sandwich is unsat

  aidAvenueClosedAtInit: {
    init
    some p: Person | aidAvenue[p]
  } for exactly 1 Person, 1 Sandwich is unsat

  streetAvenueClosedAtInit: {
    init
    some p: Person | streetAvenue[p]
  } for exactly 1 Person, 1 Sandwich is unsat

  -- Someone with ALL survival crimes and all checks active: no avenue
  allSurvivalCrimesBlockAll: {
    some p: Person | {
      p.status = Homeless
      p.label = NoAddress
      p.employment = Unemployed
      p.trust = Flagged
      p.hygiene = Unsanitary
      p.wardrobe = Ragged
      p.connectivity = Disconnected
      Trespassing in p.records
      Loitering in p.records
      Panhandling in p.records
      VagrancyCharge in p.records
      CheckFraud in p.records
      Society.employerCriminalCheck = Active
      Society.aidAddressRequirement = Active
      Society.panhandlingBan = Active
      Society.onlineServicesOnly = Active
      jobAvenue[p] or streetAvenue[p] or aidAvenue[p]
    }
  } for exactly 1 Person, 1 Sandwich is unsat

  -- Deep trap: all 14 catches active simultaneously
  deepTrapIsConsistentUnsat: {
    trace
    some p: Person | {
      deeplyTrapped[p]
      eventually some p.possesses
    }
  } for exactly 1 Person, 1 Sandwich is unsat

}

-- =============================================================================
-- SECTION 11: COUNTERFACTUAL POLICY TESTS
-- =============================================================================

test expect {

  -- Dropping employer check + giving housing/employment opens job avenue
  dropCheckHelpsSomewhat: {
    some p: Person | {
      p.status = Housed
      p.employment = Employed
      p.label = VerifiedAddress
      p.loc = WorkPlace
      p.wardrobe = BusinessCasual
      p.hygiene = Clean
      p.resumeGap = NoGap
      Trespassing in p.records
      Society.employerCriminalCheck = Suspended
      jobAvenue[p]
    }
  } for exactly 1 Person, 1 Sandwich is sat

  -- Dropping address requirement + being connected opens aid
  dropAddressHelps: {
    some p: Person | {
      p.label = VerifiedAddress
      p.status = Housed
      p.connectivity = Connected
      p.loc = GovernmentOffice
      Society.aidAddressRequirement = Suspended
      Society.onlineServicesOnly = Active
      aidAvenue[p]
    }
  } for exactly 1 Person, 1 Sandwich is sat

  -- Dropping panhandling ban + being trusted opens street avenue
  dropPanhandlingBanHelps: {
    some p: Person | {
      p.trust = Trusted
      p.loc = StreetCorner
      Panhandling in p.records
      Society.panhandlingBan = Suspended
      streetAvenue[p]
    }
  } for exactly 1 Person, 1 Sandwich is sat

  -- Dropping dress code alone is insufficient without hygiene fix
  dropDressCodeAloneInsufficient: {
    some p: Person | {
      p.status = Housed
      p.employment = Employed
      p.label = VerifiedAddress
      p.loc = WorkPlace
      p.hygiene = Unsanitary  -- still blocked by hygiene
      p.resumeGap = NoGap
      no p.records
      Society.dresscodeEnforced = Suspended
      Society.employerCriminalCheck = Active
      jobAvenue[p]
    }
  } for exactly 1 Person, 1 Sandwich is unsat

  -- UNSAT: Dropping only trespassing law alone does not open any avenue
  -- from init state (still homeless, no address, no connectivity)
  dropTrespassingAloneInsufficient: {
    some p: Person | {
      p.status = Homeless
      p.label = NoAddress
      p.employment = Unemployed
      p.trust = Flagged
      p.connectivity = NeverHadAccess
      Society.trespassingLaw = Suspended
      Society.employerCriminalCheck = Active
      Society.aidAddressRequirement = Active
      Society.panhandlingBan = Active
      Society.onlineServicesOnly = Active
      jobAvenue[p] or streetAvenue[p] or aidAvenue[p]
    }
  } for exactly 1 Person, 1 Sandwich is unsat

}

-- =============================================================================
-- SECTION 12: EDGE CASES
-- =============================================================================

test expect {

  allCrimeTypesCanCoexist: {
    some p: Person | {
      Murder in p.records
      ArmedRobbery in p.records
      Trespassing in p.records
      Loitering in p.records
      Panhandling in p.records
      VagrancyCharge in p.records
      CurfewViolation in p.records
      FraudCharge in p.records
      FailureToProvide in p.records
      DisorderlyConduct in p.records
      CheckFraud in p.records
      PublicIntoxication in p.records
    }
  } for exactly 1 Person, 1 Sandwich is sat

  allMediaFramesCanCoexist: {
    Society.mediaFrames = CrimeWave + InvasionNarrative + TaxpayerBurden +
      DangerAlert + CriminalElement + DebtCrisisFrame + WelfareAbuse +
      UnemployedLazy + PublicHealthThreat + DrainOnSystem + PolicyDebate
  } for exactly 1 Person, 1 Sandwich is sat

  allSympathyLevelsPossible: {
    Society.publicSympathy = None
  } for exactly 1 Person, 1 Sandwich is sat

  allPoliciesCanBeSuspended: {
    Society.trespassingLaw = Suspended
    Society.loiteringLaw = Suspended
    Society.panhandlingBan = Suspended
    Society.shelterIDRequirement = Suspended
    Society.employerCriminalCheck = Suspended
    Society.aidAddressRequirement = Suspended
    Society.creditCheckForLoans = Suspended
    Society.algorithmHiring = Suspended
    Society.gymMembershipRequired = Suspended
    Society.mandatoryLegalFees = Suspended
    Society.employerInsuranceOnly = Suspended
    Society.onlineServicesOnly = Suspended
    Society.housingFarFromWork = Suspended
    Society.expungementFeeRequired = Suspended
    Society.birthCertRequired = Suspended
    Society.securityDepositRequired = Suspended
    Society.childcareRequired = Suspended
    Society.bankMinimumBalance = Suspended
    Society.dresscodeEnforced = Suspended
    Society.utilityBillForLease = Suspended
  } for exactly 1 Person, 1 Sandwich is sat

  incapacitatedPersonIsPossible: {
    some p: Person | p.healthStatus = Incapacitated
  } for exactly 1 Person, 1 Sandwich is sat

  blacklistedPersonIsPossible: {
    some p: Person | p.employment = Blacklisted
  } for exactly 1 Person, 1 Sandwich is sat

  elderCanBeSAndwichless: {
    some p: Person | {
      p.stage = Elder
      no p.possesses
    }
  } for exactly 1 Person, 1 Sandwich is sat

  multiPersonDifferentStages: {
    some p1, p2: Person | {
      p1 != p2
      p1.stage = Adult
      p2.stage = Elder
    }
  } for exactly 2 Person, 1 Sandwich is sat

  sandwichIsLone: {
    all p: Person | lone p.possesses
  } for exactly 1 Person, 1 Sandwich is sat

}

-- =============================================================================
-- SECTION 13: THE WEALTHY PERSON — THE CONTRASTING CASE
-- The same system. The same laws. Different starting point.
-- =============================================================================

test expect {

  -- [PASS] Wealthy init is consistent
  wealthyInitIsConsistent: {
    some p: Person | wealthyInit[p]
  } for exactly 1 Person, 1 Sandwich is sat

  -- [PASS] Wealthy person can immediately use job avenue
  wealthyJobAvenueOpen: {
    some p: Person | {
      wealthyInit[p]
      jobAvenue[p]
    }
  } for exactly 1 Person, 1 Sandwich is sat

  -- [PASS] Wealthy person can immediately use aid avenue
  wealthyAidAvenueOpen: {
    some p: Person | {
      wealthyInit[p]
      aidAvenue[p]
      p.loc = GovernmentOffice
    }
  } for exactly 1 Person, 1 Sandwich is sat

  -- [PASS] Wealthy person is never fully trapped
  wealthyNeverFullyTrapped: {
    some p: Person | {
      wealthyInit[p]
      fullyTrapped[p]
    }
  } for exactly 1 Person, 1 Sandwich is unsat

  -- [PASS] Wealthy person is not born into the trap
  wealthyNotBornIntoTrap: {
    some p: Person | {
      wealthyInit[p]
      bornIntoTrap[p]
    }
  } for exactly 1 Person, 1 Sandwich is unsat

  -- [PASS] Wealthy person has no catch-22 predicates firing at init
  wealthyNoCreditCatch: {
    some p: Person | {
      wealthyInit[p]
      creditCatch[p]
    }
  } for exactly 1 Person, 1 Sandwich is unsat

  wealthyNoResumeGapCatch: {
    some p: Person | {
      wealthyInit[p]
      resumeGapCatch[p]
    }
  } for exactly 1 Person, 1 Sandwich is unsat

  wealthyNoCleanlinessCatch: {
    some p: Person | {
      wealthyInit[p]
      cleanlinessCatch[p]
    }
  } for exactly 1 Person, 1 Sandwich is unsat

  wealthyNoExpungementCatch: {
    some p: Person | {
      wealthyInit[p]
      expungementCatch[p]
    }
  } for exactly 1 Person, 1 Sandwich is unsat

  wealthyNoVerificationCatch: {
    some p: Person | {
      wealthyInit[p]
      verificationCatch[p]
    }
  } for exactly 1 Person, 1 Sandwich is unsat

  -- [PASS] Two people: one trapped, one wealthy — same society, divergent outcomes
  -- The trapped person cannot get the sandwich; the wealthy person can.
  -- This is the core comparison the model enables.
  twoPersonDivergence: {
    some p1, p2: Person | {
      p1 != p2
      bornIntoTrap[p1]
      wealthyInit[p2]
      -- Wealthy person has open avenues; trapped person has none
      (jobAvenue[p2] or streetAvenue[p2] or aidAvenue[p2])
      fullyTrapped[p1]
    }
  } for exactly 2 Person, 1 Sandwich is sat

}