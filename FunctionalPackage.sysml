/**
 * FunctionalPackage.sysml
 *
 * Answers: what must the process be capable of doing?
 * Contains:
 *   — additional InformationArtifact definitions (functional level)
 *   — one SystemFunction specialization per discrete capability
 *   — the WorkdayTransferCreditConstraint (system constraint)
 *
 * Functions are deliberately actor-agnostic.  No performer is named
 * here — assigning responsibility to logical components is the job
 * of LogicalPackage.  The only question answered in this file is
 * "what must be doable?" not "who does it?"
 *
 * Functions are grouped by the phase in which they are exercised,
 * matching the six phases defined in OperationalPackage.
 */
package CrossRegistration_Functional {

    import CoSMA::*;
    import CrossRegistration_Purpose::*;
    import CrossRegistration_Operational::*;

    // ─────────────────────────────────────────────────────────────
    // ADDITIONAL INFORMATION ARTIFACTS
    // These types are needed at the functional level but were not
    // required by the coarser-grained operational view.
    // ─────────────────────────────────────────────────────────────

    item def StudentAcademicRecord :> InformationArtifact {
        doc /* The student's academic record at the home institution:
               GPA, enrollment status, active holds, and academic
               standing.  Consumed by VerifyStudentEligibility. */
    }

    item def AdmissionRecord :> InformationArtifact {
        doc /* The formal admission decision produced by the host
               registrar after reviewing capacity and prerequisites.
               Carries the outcome (approved / denied) and, if
               approved, the non-degree program of study to which
               the student is admitted. */
    }

    item def FinancialAidDecision :> InformationArtifact {
        doc /* The financial aid office's determination of whether
               the student's existing aid award applies to the cross-
               registered course and which institution is responsible
               for billing. */
    }

    item def CourseEquivalencyRecord :> InformationArtifact {
        doc /* The result of the course equivalency evaluation.
               States whether a direct catalogue equivalent exists at
               the home institution and, if so, which requirement
               it satisfies.  Drives the posting category in
               PostTransferCredit. */
    }

    // ─────────────────────────────────────────────────────────────
    // PHASE 1 FUNCTIONS — Eligibility Confirmation
    // ─────────────────────────────────────────────────────────────

    action def VerifyStudentEligibility :> SystemFunction {
        doc /* Retrieve the student's academic record and evaluate
               it against the home institution's cross-registration
               eligibility policy (good standing, no holds).
               Produces the EligibilityDetermination consumed by
               the EligibilityGate transition in the lifecycle. */
        in  academicRecord : StudentAcademicRecord;
        out determination  : EligibilityDetermination;
    }

    action def TransmitEligibilityConfirmation :> SystemFunction {
        doc /* Forward the completed EligibilityDetermination from
               the home institution to the host institution, confirming
               that the student is cleared to apply. */
        in  determination  : EligibilityDetermination;
        out sentConfirmation : EligibilityDetermination;
    }

    // ─────────────────────────────────────────────────────────────
    // PHASE 2 FUNCTIONS — Application and Admission
    // ─────────────────────────────────────────────────────────────

    action def ReceiveCrossRegistrationApplication :> SystemFunction {
        doc /* Accept and record the cross-registration application
               submitted by the student to the host institution.
               The application package includes student identity,
               home institution, and the requested course. */
        in  application    : CrossRegistrationApplication;
        out recordedApplication : CrossRegistrationApplication;
    }

    action def ReviewApplicationForAdmission :> SystemFunction {
        doc /* Evaluate the application against course capacity and
               stated prerequisite requirements.  Produces an
               AdmissionRecord whose outcome drives the
               HostApprovalGate transition in the lifecycle. */
        in  application    : CrossRegistrationApplication;
        in  confirmation   : EligibilityDetermination;
        out admissionRecord : AdmissionRecord;
    }

    // ─────────────────────────────────────────────────────────────
    // PHASE 3 FUNCTIONS — Registration and Financial Setup
    // ─────────────────────────────────────────────────────────────

    action def RegisterStudentInCourse :> SystemFunction {
        doc /* Formally enroll the admitted student in the target
               course at the host institution and produce an
               EnrollmentConfirmation sent to all parties. */
        in  admissionRecord : AdmissionRecord;
        out enrollment      : EnrollmentConfirmation;
    }

    action def ConfirmFinancialAidApplicability :> SystemFunction {
        doc /* Determine whether the student's existing financial-aid
               award applies to the cross-registered course, and
               establish which institution is responsible for billing.
               Produces a FinancialAidDecision before the course begins. */
        in  enrollment  : EnrollmentConfirmation;
        out aidDecision : FinancialAidDecision;
    }

    // ─────────────────────────────────────────────────────────────
    // PHASE 4 FUNCTIONS — Course Attendance
    // Phase 4 is primarily a human activity (student attends class).
    // No distinct system function is required beyond maintaining the
    // enrollment record, which RegisterStudentInCourse already produces.
    // ─────────────────────────────────────────────────────────────

    // ─────────────────────────────────────────────────────────────
    // PHASE 5 FUNCTIONS — Grade Submission and Transcript Transmission
    // ─────────────────────────────────────────────────────────────

    action def RecordFinalGradeAtHost :> SystemFunction {
        doc /* Capture the instructor's final grade in the host
               institution's student information system, producing a
               FinalGradeRecord that is the authoritative grade source
               for all downstream steps. */
        out grade : FinalGradeRecord;
    }

    action def TransmitOfficialTranscript :> SystemFunction {
        doc /* Send the FinalGradeRecord from the host institution to
               the home institution as an official transcript or
               grade report.  The transmission channel is left
               unspecified at this layer (secure file transfer,
               National Student Clearinghouse, etc.). */
        in  grade            : FinalGradeRecord;
        out transmittedGrade : FinalGradeRecord;
    }

    action def ReceiveInboundTranscript :> SystemFunction {
        doc /* Accept and acknowledge the inbound transcript at the
               home institution, making the FinalGradeRecord available
               to the transfer-credit evaluation workflow. */
        in  transmittedGrade : FinalGradeRecord;
        out receivedGrade    : FinalGradeRecord;
    }

    // ─────────────────────────────────────────────────────────────
    // PHASE 6 FUNCTIONS — Transfer Credit Evaluation and Posting
    // ─────────────────────────────────────────────────────────────

    action def EvaluateCourseEquivalency :> SystemFunction {
        doc /* Compare the host course against the home institution's
               course catalogue to determine whether a direct
               equivalent exists.  Implements the CourseEquivalencyGate
               logic and produces a CourseEquivalencyRecord that
               drives the posting category in PostTransferCredit. */
        in  receivedGrade     : FinalGradeRecord;
        out equivalencyRecord : CourseEquivalencyRecord;
    }

    action def PostTransferCredit :> SystemFunction {
        doc /* Post the earned credit to the student's home-institution
               transcript.  If a course equivalent exists (per the
               CourseEquivalencyRecord), post to the matched degree
               requirement; otherwise post as general elective credit.
               This function is subject to WorkdayTransferCreditConstraint:
               the implementation must use the transfer-credit workflow,
               not a native grade-posting path. */
        in  receivedGrade     : FinalGradeRecord;
        in  equivalencyRecord : CourseEquivalencyRecord;
        out transcriptEntry   : TranscriptEntry;
    }

    action def NotifyStudentOfCreditPosting :> SystemFunction {
        doc /* Inform the student that transfer credit has been posted
               to their official transcript, including course name,
               credit hours, grade received, and posting category
               (matched requirement or elective). */
        in transcriptEntry : TranscriptEntry;
    }

    // ─────────────────────────────────────────────────────────────
    // SYSTEM CONSTRAINT
    // ─────────────────────────────────────────────────────────────

    requirement def WorkdayTransferCreditConstraint :> SystemConstraint {
        doc /* In a multi-tenant Workday Student implementation, credit
               earned at the host institution cannot be posted natively
               to the home institution's academic record.  It must be
               processed through the transfer-credit workflow.
               This is a system constraint, not a policy choice.
               It applies regardless of institutional preference and
               governs how PostTransferCredit must be implemented
               at the Technical layer (out of scope for this model).
               The formal satisfy relationship is recorded in
               SpecificationsPackage. */
    }
}
