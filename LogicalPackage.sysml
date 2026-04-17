/**
 * LogicalPackage.sysml
 *
 * Answers: which abstract components are responsible for each function?
 * Contains:
 *   — six LogicalInterface specializations (the exchange contracts)
 *   — six LogicalComponent specializations, three per institution
 *   — perform action assignments linking each component to the
 *     SystemFunctions it is responsible for delivering
 *   — one top-level CrossRegistrationSystem that composes all
 *     components and shows item flows between them
 *
 * All component names describe responsibility, not product or vendor.
 * No Workday-specific content appears here.  The Technical layer
 * (out of scope) would map these logical components to real platforms.
 */
package CrossRegistration_Logical {

    import CoSMA::*;
    import CrossRegistration_Purpose::*;
    import CrossRegistration_Operational::*;
    import CrossRegistration_Functional::*;

    // ─────────────────────────────────────────────────────────────
    // LOGICAL INTERFACES
    // Each interface names the contract between two components:
    // what information crosses the boundary and in which direction.
    // ─────────────────────────────────────────────────────────────

    part def EligibilityConfirmationInterface :> LogicalInterface {
        doc /* Carries an EligibilityDetermination from the home
               institution's StudentEligibilitySubsystem to the host
               institution's ApplicationProcessingSubsystem.
               Direction: home → host. */
    }

    part def ApplicationSubmissionInterface :> LogicalInterface {
        doc /* Carries a CrossRegistrationApplication from the student
               (external actor) to the host institution's
               ApplicationProcessingSubsystem.
               Direction: external → host. */
    }

    part def EnrollmentNotificationInterface :> LogicalInterface {
        doc /* Carries an EnrollmentConfirmation from the host
               institution's EnrollmentManagementSubsystem to the
               home institution's FinancialAidSubsystem.
               Direction: host → home. */
    }

    part def TranscriptTransmissionInterface :> LogicalInterface {
        doc /* Carries a FinalGradeRecord (official transcript or
               grade report) from the host institution's
               GradeManagementSubsystem to the home institution's
               TransferCreditSubsystem.
               Direction: host → home. */
    }

    part def AidConfirmationInterface :> LogicalInterface {
        doc /* Carries a FinancialAidDecision from the home
               institution's FinancialAidSubsystem back to the
               EnrollmentManagementSubsystem, confirming that billing
               is in place before the course begins.
               Direction: home → host. */
    }

    part def StudentNotificationInterface :> LogicalInterface {
        doc /* Carries outcome notifications (eligibility, admission,
               credit posting) from the TransferCreditSubsystem
               to the student.
               Direction: home → external. */
    }

    // ─────────────────────────────────────────────────────────────
    // HOME INSTITUTION COMPONENTS
    // ─────────────────────────────────────────────────────────────

    part def StudentEligibilitySubsystem :> LogicalComponent {
        doc /* Responsible for retrieving the student's academic record
               and evaluating it against the home institution's cross-
               registration eligibility policy.  Also responsible for
               transmitting the eligibility determination to the host
               institution over the EligibilityConfirmationInterface.
               Drives the EligibilityGate outcome. */

        perform action verify   : VerifyStudentEligibility;
        perform action transmit : TransmitEligibilityConfirmation;
    }

    part def FinancialAidSubsystem :> LogicalComponent {
        doc /* Responsible for confirming whether the student's
               existing financial-aid award applies to the cross-
               registered course and establishing which institution
               is responsible for tuition billing.  Receives the
               EnrollmentConfirmation and produces a FinancialAidDecision
               before the course begins. */

        perform action confirmAid : ConfirmFinancialAidApplicability;
    }

    part def TransferCreditSubsystem :> LogicalComponent {
        doc /* Responsible for the complete Phase 5–6 workflow at the
               home institution: receiving the inbound transcript,
               evaluating course equivalency against the home catalogue,
               posting transfer credit to the student's official
               transcript, and notifying the student of the outcome.
               Subject to WorkdayTransferCreditConstraint: the posting
               step must use the transfer-credit workflow. */

        perform action receive  : ReceiveInboundTranscript;
        perform action evaluate : EvaluateCourseEquivalency;
        perform action post     : PostTransferCredit;
        perform action notify   : NotifyStudentOfCreditPosting;
    }

    // ─────────────────────────────────────────────────────────────
    // HOST INSTITUTION COMPONENTS
    // ─────────────────────────────────────────────────────────────

    part def ApplicationProcessingSubsystem :> LogicalComponent {
        doc /* Responsible for receiving cross-registration applications
               from students, verifying the accompanying eligibility
               confirmation from the home institution, and producing
               an AdmissionRecord for the host registrar's review.
               Drives the HostApprovalGate outcome. */

        perform action receive : ReceiveCrossRegistrationApplication;
        perform action review  : ReviewApplicationForAdmission;
    }

    part def EnrollmentManagementSubsystem :> LogicalComponent {
        doc /* Responsible for formally enrolling the admitted student
               in the target course at the host institution and
               transmitting the EnrollmentConfirmation to the home
               institution's FinancialAidSubsystem. */

        perform action enroll : RegisterStudentInCourse;
    }

    part def GradeManagementSubsystem :> LogicalComponent {
        doc /* Responsible for recording the instructor's final grade
               in the host institution's student information system
               and transmitting the official transcript (or grade
               report) to the home institution via the
               TranscriptTransmissionInterface. */

        perform action record   : RecordFinalGradeAtHost;
        perform action transmit : TransmitOfficialTranscript;
    }

    // ─────────────────────────────────────────────────────────────
    // TOP-LEVEL SYSTEM COMPOSITION
    // Assembles all components and shows which information artifacts
    // flow between them through which interfaces.
    // ─────────────────────────────────────────────────────────────

    part def CrossRegistrationSystem :> LogicalComponent {
        doc /* The complete logical system for cross-registration,
               composed of three home-institution subsystems and three
               host-institution subsystems.  Item flows between
               subsystems are declared below and correspond directly
               to the InformationArtifacts defined in
               OperationalPackage and FunctionalPackage. */

        // ── Home institution subsystems ──
        part eligibility   : StudentEligibilitySubsystem;
        part financialAid  : FinancialAidSubsystem;
        part transferCredit : TransferCreditSubsystem;

        // ── Host institution subsystems ──
        part applicationProcessing : ApplicationProcessingSubsystem;
        part enrollment            : EnrollmentManagementSubsystem;
        part gradeManagement       : GradeManagementSubsystem;

        // ── Item flows between subsystems ──
        // Each flow names the artifact type, its source component,
        // and its target component.  The interface definition above
        // documents the contract; the flow here binds it to the
        // concrete parts in this composition.

        flow of EligibilityDetermination
            from eligibility
            to   applicationProcessing;

        flow of CrossRegistrationApplication
            from applicationProcessing   // receives from external student
            to   applicationProcessing;  // internal: triggers review

        flow of EnrollmentConfirmation
            from enrollment
            to   financialAid;

        flow of FinancialAidDecision
            from financialAid
            to   enrollment;

        flow of FinalGradeRecord
            from gradeManagement
            to   transferCredit;

        flow of TranscriptEntry
            from transferCredit
            to   transferCredit;  // internal: notify step consumes posting
    }
}
