/**
 * OperationalPackage.sysml
 *
 * Answers: what happens, in what order, and who decides?
 * Contains:
 *   — three DecisionGate specializations (the branching points)
 *   — six LifecyclePhase specializations (the named states)
 *   — key OperationalActivity specializations (steps within phases)
 *   — one composite state def (CrossRegistrationLifecycle) that
 *     chains phases together with guarded transitions
 *
 * Decision gates are defined here; their formal satisfy-relationships
 * to StakeholderNeeds are deferred to SpecificationsPackage.
 */
package CrossRegistration_Operational {

    import CoSMA::*;
    import CrossRegistration_Purpose::*;

    // ─────────────────────────────────────────────────────────────
    // DECISION GATES
    // Each gate is a point where a Boolean condition either allows
    // the process to advance or causes it to terminate / branch.
    // ─────────────────────────────────────────────────────────────

    part def EligibilityGate :> DecisionGate {
        doc /* Evaluated by the home registrar at the end of Phase 1.
               Condition: the student is in good academic standing
               and has no administrative holds.
               Pass  → process advances to Phase 2.
               Fail  → process terminates; student is notified. */
    }

    part def HostApprovalGate :> DecisionGate {
        doc /* Evaluated by the host registrar at the end of Phase 2.
               Condition: the course has available capacity and the
               student satisfies all stated prerequisites.
               Pass  → process advances to Phase 3.
               Fail  → process terminates; student is notified. */
    }

    part def CourseEquivalencyGate :> DecisionGate {
        doc /* Evaluated by the home registrar during Phase 6.
               Condition: a direct course equivalent exists in the
               home institution's catalogue.
               Pass  → credit posted to the matched requirement.
               Fail  → credit posted as general elective credit.
               Note: unlike the first two gates, this gate never
               terminates the process — both branches lead to a
               successful outcome. */
    }

    // ─────────────────────────────────────────────────────────────
    // LIFECYCLE PHASES
    // Each phase is a state the process occupies.  The entry
    // condition, exit condition, and responsible actor(s) are
    // documented here.  Detailed functions live in FunctionalPackage.
    // ─────────────────────────────────────────────────────────────

    state def EligibilityConfirmationPhase :> LifecyclePhase {
        doc /* Phase 1 — Course Identification and Eligibility Check.
               Entry : student wishes to cross-register.
               Actor : Student, HomeRegistrar.
               Work  : student identifies a course at the host
                       institution; home registrar verifies the
                       student is in good standing with no holds.
               Exit  : EligibilityGate is evaluated. */
    }

    state def ApplicationAndAdmissionPhase :> LifecyclePhase {
        doc /* Phase 2 — Application and Admission.
               Entry : EligibilityGate passed.
               Actor : Student, HomeRegistrar, HostRegistrar.
               Work  : student submits a cross-registration
                       application to the host institution; host
                       registrar reviews capacity and prerequisites
                       and admits the student to a non-degree
                       cross-registration program of study.
               Exit  : HostApprovalGate is evaluated. */
    }

    state def RegistrationAndFinancialSetupPhase :> LifecyclePhase {
        doc /* Phase 3 — Course Registration and Financial Setup.
               Entry : HostApprovalGate passed.
               Actor : Student, HostRegistrar, FinancialAidOffice.
               Work  : student is enrolled in the course at the
                       host institution; financial aid eligibility
                       is confirmed; tuition billing is established.
               Exit  : enrollment is confirmed and financial
                       arrangements are in place. */
    }

    state def CourseAttendancePhase :> LifecyclePhase {
        doc /* Phase 4 — Course Attendance.
               Entry : registration and financial setup complete.
               Actor : Student, Instructor.
               Work  : student attends and completes the course.
               Exit  : course concludes; final grade period opens. */
    }

    state def GradeSubmissionAndTransmissionPhase :> LifecyclePhase {
        doc /* Phase 5 — Grade Submission and Transcript Transmission.
               Entry : course attendance complete.
               Actor : Instructor, HostRegistrar.
               Work  : instructor submits the final grade; host
                       registrar transmits an official transcript
                       (or grade report) to the home institution.
               Exit  : home institution receives the grade record. */
    }

    state def TransferCreditEvaluationPhase :> LifecyclePhase {
        doc /* Phase 6 — Transfer Credit Evaluation and Posting.
               Entry : home institution receives the grade record.
               Actor : HomeRegistrar.
               Work  : home registrar evaluates whether a direct
                       course equivalent exists (CourseEquivalencyGate);
                       credit is posted to the student's official
                       transcript as either matched or elective credit.
               Exit  : process is complete; student transcript updated.
               System constraint: in a multi-tenant Workday Student
               environment, this step is executed as a transfer-credit
               workflow, not a native grade posting. */
    }

    // ─────────────────────────────────────────────────────────────
    // KEY OPERATIONAL ACTIVITIES
    // One representative action per phase.  Each names its
    // performer and its immediate output.  Detailed decomposition
    // into SystemFunctions happens in FunctionalPackage.
    // ─────────────────────────────────────────────────────────────

    action def ConfirmEligibilityActivity :> OperationalActivity {
        doc /* Home registrar checks standing and holds for the student
               and produces an eligibility determination. */
        in  performer : HomeRegistrar;
        out result    : EligibilityDetermination;
    }

    action def SubmitApplicationActivity :> OperationalActivity {
        doc /* Student submits a cross-registration application to
               the host institution, triggering the admission review. */
        in  performer    : Student;
        out application  : CrossRegistrationApplication;
    }

    action def EnrollInCourseActivity :> OperationalActivity {
        doc /* Host registrar enrolls the student in the selected
               course and confirms the enrollment to all parties. */
        in  performer   : HostRegistrar;
        out enrollment  : EnrollmentConfirmation;
    }

    action def SubmitFinalGradeActivity :> OperationalActivity {
        doc /* Instructor submits the final grade at the host
               institution at the conclusion of the course. */
        in  performer : Instructor;
        out grade     : FinalGradeRecord;
    }

    action def PostTransferCreditActivity :> OperationalActivity {
        doc /* Home registrar evaluates the received grade, applies
               the CourseEquivalencyGate decision, and posts credit
               to the student's official transcript. */
        in  performer : HomeRegistrar;
        in  grade     : FinalGradeRecord;
        out posting   : TranscriptEntry;
    }

    // ─────────────────────────────────────────────────────────────
    // INFORMATION ARTIFACTS
    // The key records that flow between activities.
    // ─────────────────────────────────────────────────────────────

    item def EligibilityDetermination :> InformationArtifact {
        doc /* A formal record stating whether the student meets the
               home institution's eligibility criteria to cross-register.
               Produced by ConfirmEligibilityActivity. */
    }

    item def CrossRegistrationApplication :> InformationArtifact {
        doc /* The application package submitted to the host institution,
               including student identity, home institution, and the
               requested course. */
    }

    item def EnrollmentConfirmation :> InformationArtifact {
        doc /* Official confirmation that the student is enrolled in
               the course at the host institution. */
    }

    item def FinalGradeRecord :> InformationArtifact {
        doc /* The official grade submitted by the instructor and
               transmitted from the host institution to the home
               institution via transcript or grade report. */
    }

    item def TranscriptEntry :> InformationArtifact {
        doc /* The credit posting on the student's home-institution
               transcript — either to a matched course requirement
               or as general elective credit. */
    }

    // ─────────────────────────────────────────────────────────────
    // THE LIFECYCLE STATE MACHINE
    // Chains the six phases together with guarded transitions.
    // Guards correspond directly to the three DecisionGates above.
    // ─────────────────────────────────────────────────────────────

    state def CrossRegistrationLifecycle {
        doc /* The complete end-to-end lifecycle of a single
               cross-registration request, from initial course
               identification through final transcript posting. */

        // ── Phase usages ──
        state phase1 : EligibilityConfirmationPhase;
        state phase2 : ApplicationAndAdmissionPhase;
        state phase3 : RegistrationAndFinancialSetupPhase;
        state phase4 : CourseAttendancePhase;
        state phase5 : GradeSubmissionAndTransmissionPhase;
        state phase6 : TransferCreditEvaluationPhase;

        // ── Terminal states ──
        state processTerminated {
            doc /* The process has ended without the student
                   enrolling in the course.  Triggered by a failed
                   EligibilityGate or HostApprovalGate. */
        }
        state processComplete {
            doc /* The process has ended successfully.  The student's
                   transcript reflects the transfer credit posting. */
        }

        // ── Initial state ──
        first phase1;

        // ── Phase 1 → Phase 2 (via EligibilityGate) ──
        transition eligibleToApply
            first phase1
            if isEligible
            then phase2;

        transition eligibilityFailed
            first phase1
            if !isEligible
            then processTerminated;

        // ── Phase 2 → Phase 3 (via HostApprovalGate) ──
        transition approvedToRegister
            first phase2
            if hostApproves
            then phase3;

        transition hostDenied
            first phase2
            if !hostApproves
            then processTerminated;

        // ── Phase 3 → 4 → 5 → 6 (unconditional) ──
        transition registeredToAttend
            first phase3
            then phase4;

        transition attendanceToGrading
            first phase4
            then phase5;

        transition gradingToEvaluation
            first phase5
            then phase6;

        // ── Phase 6 → Complete ──
        // CourseEquivalencyGate does not terminate the process;
        // both branches of that gate resolve within phase6 itself.
        transition evaluationComplete
            first phase6
            then processComplete;
    }
}
