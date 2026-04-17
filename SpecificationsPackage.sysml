/**
 * SpecificationsPackage.sysml
 *
 * Answers: which elements of the design satisfy which needs and
 * constraints?
 *
 * This package imports every preceding package and asserts
 * satisfy relationships that close the traceability loop:
 *
 *   StakeholderNeed (Purpose)
 *       ← satisfied by LogicalComponent (Logical)
 *           ← which performs SystemFunction (Functional)
 *               ← which executes during LifecyclePhase (Operational)
 *
 * Three kinds of satisfy relationship appear here:
 *   1. Mission     → whole system
 *   2. Need        → responsible component(s)
 *   3. Constraint  → the specific function it governs
 *
 * Decision gates are not requirements, so they cannot be the
 * target of a satisfy statement.  Instead, gate-coverage
 * requirements are defined here to assert that each gate
 * condition is evaluable by a named component.
 */
package CrossRegistration_Specifications {

    import CoSMA::*;
    import CrossRegistration_Purpose::*;
    import CrossRegistration_Operational::*;
    import CrossRegistration_Functional::*;
    import CrossRegistration_Logical::*;

    // ─────────────────────────────────────────────────────────────
    // THE SUBJECT
    // A single top-level usage of the complete logical system.
    // All satisfy relationships below trace to parts of this usage.
    // ─────────────────────────────────────────────────────────────

    part theSystem : CrossRegistrationSystem;

    // ─────────────────────────────────────────────────────────────
    // 1. MISSION SATISFACTION
    // The system as a whole satisfies the top-level mission.
    // ─────────────────────────────────────────────────────────────

    requirement missionCoverage : CrossRegistrationMission {
        doc /* Asserts that the CrossRegistrationSystem, taken as a
               whole, fulfils the mission stated in PurposePackage:
               enabling a student to earn transferable credit at a
               host institution within the same university system. */
        subject sys : CrossRegistrationSystem;
    }

    satisfy missionCoverage by theSystem;

    // ─────────────────────────────────────────────────────────────
    // 2. STAKEHOLDER NEED SATISFACTIONS
    // Each need from PurposePackage is traced to the component(s)
    // that deliver it.  Where multiple components are required,
    // one satisfy statement is issued per component.
    // ─────────────────────────────────────────────────────────────

    requirement studentEnrollmentCoverage : StudentEnrollmentNeed {
        doc /* The student's end-to-end enrollment journey spans
               four subsystems.  All four must be present for
               this need to be fully satisfied. */
        subject sys : CrossRegistrationSystem;
    }

    satisfy studentEnrollmentCoverage by theSystem.eligibility;
    satisfy studentEnrollmentCoverage by theSystem.applicationProcessing;
    satisfy studentEnrollmentCoverage by theSystem.enrollment;
    satisfy studentEnrollmentCoverage by theSystem.transferCredit;

    // ──

    requirement homeRegistrarCoverage : HomeRegistrarProcessingNeed {
        doc /* The home registrar's responsibilities span the opening
               and closing phases of the process: eligibility
               verification at the start and transfer-credit posting
               at the end. */
        subject sys : CrossRegistrationSystem;
    }

    satisfy homeRegistrarCoverage by theSystem.eligibility;
    satisfy homeRegistrarCoverage by theSystem.transferCredit;

    // ──

    requirement hostRegistrarCoverage : HostRegistrarAdmissionNeed {
        doc /* The host registrar's responsibilities are confined to
               the middle phases: admission review and course
               enrollment. */
        subject sys : CrossRegistrationSystem;
    }

    satisfy hostRegistrarCoverage by theSystem.applicationProcessing;
    satisfy hostRegistrarCoverage by theSystem.enrollment;

    // ──

    requirement financialAidCoverage : FinancialAidNeed {
        doc /* Financial aid applicability and billing are handled
               by a single dedicated subsystem at the home
               institution. */
        subject sys : CrossRegistrationSystem;
    }

    satisfy financialAidCoverage by theSystem.financialAid;

    // ──

    requirement instructorGradeCoverage : InstructorGradeSubmissionNeed {
        doc /* Grade recording and transcript transmission are handled
               by a single dedicated subsystem at the host
               institution. */
        subject sys : CrossRegistrationSystem;
    }

    satisfy instructorGradeCoverage by theSystem.gradeManagement;

    // ─────────────────────────────────────────────────────────────
    // 3. SYSTEM CONSTRAINT SATISFACTION
    // The Workday transfer-credit constraint governs a specific
    // function.  The satisfy relationship is between the constraint
    // and the perform action usage inside TransferCreditSubsystem.
    // ─────────────────────────────────────────────────────────────

    requirement workdayConstraintCoverage : WorkdayTransferCreditConstraint {
        doc /* Asserts that the PostTransferCredit function, as
               performed by TransferCreditSubsystem, uses the
               transfer-credit workflow rather than a native
               grade-posting path.  This is a system constraint,
               not a policy choice: it applies in any multi-tenant
               Workday Student environment regardless of institutional
               preference.  Enforcement belongs to the Technical layer
               (out of scope), but the constraint is formally
               acknowledged here. */
        subject postFn : PostTransferCredit;
    }

    satisfy workdayConstraintCoverage by theSystem.transferCredit.post;

    // ─────────────────────────────────────────────────────────────
    // 4. DECISION GATE COVERAGE
    // Gates are part defs, not requirements, so they cannot be
    // the direct target of satisfy.  A gate-coverage requirement
    // is defined for each gate to assert that a named component
    // is responsible for evaluating its condition.
    // ─────────────────────────────────────────────────────────────

    requirement eligibilityGateCoverage {
        doc /* The EligibilityGate condition — student in good
               academic standing with no administrative holds —
               must be evaluable.  The condition is resolved by
               VerifyStudentEligibility as performed by
               StudentEligibilitySubsystem.
               Source gate: EligibilityGate (OperationalPackage).
               Lifecycle position: end of Phase 1. */
        subject sys : CrossRegistrationSystem;
    }

    satisfy eligibilityGateCoverage by theSystem.eligibility;

    // ──

    requirement hostApprovalGateCoverage {
        doc /* The HostApprovalGate condition — course has available
               capacity and student satisfies prerequisites — must
               be evaluable.  The condition is resolved by
               ReviewApplicationForAdmission as performed by
               ApplicationProcessingSubsystem.
               Source gate: HostApprovalGate (OperationalPackage).
               Lifecycle position: end of Phase 2. */
        subject sys : CrossRegistrationSystem;
    }

    satisfy hostApprovalGateCoverage by theSystem.applicationProcessing;

    // ──

    requirement courseEquivalencyGateCoverage {
        doc /* The CourseEquivalencyGate condition — a direct
               catalogue equivalent exists at the home institution —
               must be evaluable.  The condition is resolved by
               EvaluateCourseEquivalency as performed by
               TransferCreditSubsystem.
               Source gate: CourseEquivalencyGate (OperationalPackage).
               Lifecycle position: within Phase 6.
               Note: this gate never terminates the process; both
               branches (matched credit, elective credit) lead to
               a successful outcome. */
        subject sys : CrossRegistrationSystem;
    }

    satisfy courseEquivalencyGateCoverage by theSystem.transferCredit;

    // ─────────────────────────────────────────────────────────────
    // TRACEABILITY SUMMARY
    // Read this as a quick cross-reference across all five layers.
    //
    //  Need / Constraint              Component                Function(s)
    //  ─────────────────────────────────────────────────────────────────
    //  StudentEnrollmentNeed       ← eligibility            VerifyStudentEligibility
    //                              ← applicationProcessing  ReceiveCrossRegistrationApplication
    //                                                        ReviewApplicationForAdmission
    //                              ← enrollment             RegisterStudentInCourse
    //                              ← transferCredit         ReceiveInboundTranscript
    //                                                        EvaluateCourseEquivalency
    //                                                        PostTransferCredit
    //                                                        NotifyStudentOfCreditPosting
    //
    //  HomeRegistrarProcessingNeed ← eligibility            VerifyStudentEligibility
    //                                                        TransmitEligibilityConfirmation
    //                              ← transferCredit         (see above)
    //
    //  HostRegistrarAdmissionNeed  ← applicationProcessing  (see above)
    //                              ← enrollment             RegisterStudentInCourse
    //
    //  FinancialAidNeed            ← financialAid           ConfirmFinancialAidApplicability
    //
    //  InstructorGradeSubmissionNeed ← gradeManagement      RecordFinalGradeAtHost
    //                                                        TransmitOfficialTranscript
    //
    //  WorkdayTransferCredit-      ← transferCredit.post    PostTransferCredit
    //  Constraint
    // ─────────────────────────────────────────────────────────────
}
