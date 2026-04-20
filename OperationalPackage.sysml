/**
 * OperationalPackage.sysml
 *
 * Answers: who does what, and in what sequence?
 *
 * Contents:
 *   — six Actor specializations (one per Stakeholder role)
 *   — seven enrollment-status state defs (the standard vocabulary)
 *   — one composite EnrollmentLifecycle state def with transitions
 *   — six EnterpriseProcess action defs (coarse-grained workflow)
 *   — three DecisionGate specializations
 *
 * Actors and Stakeholders are distinct abstractions: Stakeholders
 * hold needs (Purpose layer); Actors perform actions (Operational
 * layer).  The same real-world role appears in both layers.
 *
 * No port definitions — those belong to the Logical layer (out of
 * scope for this example).
 */
package UniversalU_Operational {

    import CoSMA::*;
    import UniversalU_Purpose::*;

    // ─────────────────────────────────────────────────────────────
    // ACTORS
    // ─────────────────────────────────────────────────────────────

    part def StudentActor :> Actor {
        doc /* The student who submits enrollment requests, monitors
               status, and receives confirmation.  Corresponds to the
               Student Stakeholder in PurposePackage. */
    }

    part def RegistrarActor :> Actor {
        doc /* The registrar's office staff who review enrollment
               requests, authorize exceptions, maintain records, and
               produce enrollment reports.  Corresponds to the
               Registrar Stakeholder. */
    }

    part def FinancialAidActor :> Actor {
        doc /* Financial aid staff who review aid eligibility
               triggered by enrollment status changes.  Corresponds
               to the FinancialAidOffice Stakeholder. */
    }

    part def FacultyActor :> Actor {
        doc /* The course instructor who relies on accurate rosters
               and prerequisite enforcement.  Corresponds to the
               Faculty Stakeholder.  Faculty do not directly
               initiate enrollment transactions in the standard
               workflow but may authorize prerequisite overrides. */
    }

    part def FederalRegulatorActor :> Actor {
        doc /* The external federal body that consumes enrollment
               reports.  In operational terms, this actor receives
               the output of ReportEnrollmentStatus rather than
               participating in the enrollment workflow directly. */
    }

    part def AccreditorActor :> Actor {
        doc /* The external accreditation body that consumes
               enrollment data extracts.  Like FederalRegulatorActor,
               this actor receives report outputs rather than
               participating in the enrollment workflow directly. */
    }

    // ─────────────────────────────────────────────────────────────
    // ENROLLMENT STATUS STATE DEFINITIONS
    // Standard enrollment status vocabulary.  Each is a named
    // state the enrollment record can occupy.
    // ─────────────────────────────────────────────────────────────

    state def Pending :> LifecycleState {
        doc /* The enrollment request has been submitted and is
               awaiting system validation (eligibility, capacity,
               prerequisites) and registrar processing.  No seat
               has been reserved. */
    }

    state def Registered :> LifecycleState {
        doc /* The enrollment request has been validated and approved.
               A seat in the section has been reserved for the student.
               The student is registered but not yet counted as
               enrolled for reporting purposes until the term begins
               or the add deadline passes, per institutional policy. */
    }

    state def Enrolled :> LifecycleState {
        doc /* The student is actively enrolled in the section.
               The add/drop deadline has passed and the student
               remains in the course.  This is the status used for
               federal enrollment reporting (e.g., IPEDS census). */
    }

    state def Waitlisted :> LifecycleState {
        doc /* The section reached capacity before the enrollment
               request could be confirmed.  The student holds a
               numbered position on the waitlist and will be promoted
               to Registered automatically if a seat opens before
               the add deadline. */
    }

    state def Dropped :> LifecycleState {
        doc /* The student's enrollment in the section was cancelled
               before the add/drop deadline.  A dropped enrollment
               does not appear on the official transcript and does
               not affect credit-hour load for financial aid
               calculation purposes. */
    }

    state def Withdrawn :> LifecycleState {
        doc /* The student ceased participation in the section after
               the add/drop deadline.  A withdrawal appears on the
               official transcript as a W grade and may affect
               Satisfactory Academic Progress evaluation. */
    }

    state def Completed :> LifecycleState {
        doc /* The course has concluded and a final grade has been
               recorded for the student.  The enrollment record
               is closed and contributes to the student's academic
               history. */
    }

    // ─────────────────────────────────────────────────────────────
    // ENROLLMENT LIFECYCLE STATE MACHINE
    // Composes the seven enrollment status states and defines the
    // transitions that move an enrollment record between them.
    // ─────────────────────────────────────────────────────────────

    state def EnrollmentLifecycle :> LifecycleState {
        doc /* The complete state machine for a single enrollment
               record from initial request through final disposition.
               Transitions represent business events (request approved,
               deadline passed, student action) rather than
               system-internal signals. */

        // ── State usages ──
        state pending    : Pending;
        state registered : Registered;
        state enrolled   : Enrolled;
        state waitlisted : Waitlisted;
        state dropped    : Dropped;
        state withdrawn  : Withdrawn;
        state completed  : Completed;

        // ── Initial state ──
        first pending;

        // ── Transitions from Pending ──
        transition pendingToRegistered
            first pending
            then registered;
            // Fires when: request passes eligibility, capacity,
            // and prerequisite checks.

        transition pendingToWaitlisted
            first pending
            then waitlisted;
            // Fires when: request is valid but section is at capacity.

        transition pendingToDropped
            first pending
            then dropped;
            // Fires when: student withdraws request before processing
            // completes, or system rejects and student does not appeal.

        // ── Transitions from Registered ──
        transition registeredToEnrolled
            first registered
            then enrolled;
            // Fires when: the add/drop deadline passes and the student
            // remains in the section.

        transition registeredToDropped
            first registered
            then dropped;
            // Fires when: student drops the section on or before the
            // add/drop deadline.

        // ── Transitions from Enrolled ──
        transition enrolledToWithdrawn
            first enrolled
            then withdrawn;
            // Fires when: student initiates a withdrawal after the
            // add/drop deadline and before the last withdrawal date.

        transition enrolledToCompleted
            first enrolled
            then completed;
            // Fires when: the course concludes and a final grade is
            // recorded for the student.

        // ── Transitions from Waitlisted ──
        transition waitlistedToRegistered
            first waitlisted
            then registered;
            // Fires when: a seat opens and the student is next on
            // the waitlist, and the add deadline has not passed.

        transition waitlistedToDropped
            first waitlisted
            then dropped;
            // Fires when: the student removes themselves from the
            // waitlist, or the add deadline passes with no seat
            // available.
    }

    // ─────────────────────────────────────────────────────────────
    // DECISION GATES
    // ─────────────────────────────────────────────────────────────

    part def EligibilityGate :> DecisionGate {
        doc /* Evaluates whether the student meets all conditions
               required to enroll: good academic standing, no
               registration holds, and compliance with any
               institutional cross-registration limits.
               Pass → continue to CapacityGate.
               Fail → notify student; enrollment request rejected. */
    }

    part def CapacityGate :> DecisionGate {
        doc /* Evaluates whether the target section has at least one
               available seat at the time the request is processed.
               Pass → confirm enrollment (Registered).
               Fail → offer waitlist placement. */
    }

    part def PrerequisiteGate :> DecisionGate {
        doc /* Evaluates whether the student has satisfied all stated
               prerequisites for the course.  Evaluated as part of
               the eligibility check, before CapacityGate.
               Pass → continue eligibility evaluation.
               Fail → notify student; enrollment request rejected
                      unless an authorized override is supplied. */
    }

    // ─────────────────────────────────────────────────────────────
    // ENTERPRISE PROCESSES
    // Coarse-grained operational steps performed by Actors.
    // Each decomposes into SystemFunctions in FunctionalPackage.
    // ─────────────────────────────────────────────────────────────

    action def SubmitEnrollmentRequest :> EnterpriseProcess {
        doc /* The student selects a course section and submits an
               enrollment request for a given academic term.
               Primary actor: StudentActor.
               Output: an enrollment request pending system
               validation. */
    }

    action def ProcessEnrollmentRequest :> EnterpriseProcess {
        doc /* The system validates the enrollment request against
               eligibility rules, prerequisite requirements, and
               section capacity.  Applies the three decision gates
               and routes the request to the appropriate outcome.
               Primary actor: system (automated); RegistrarActor
               involved for exception handling.
               Output: a registration confirmation, waitlist
               placement, or rejection notification. */
    }

    action def ReviewEnrollmentRequest :> EnterpriseProcess {
        doc /* The registrar reviews enrollment requests that require
               human judgement: prerequisite overrides, capacity
               overrides, late additions, or policy exceptions.
               Primary actor: RegistrarActor.
               Output: an authorized exception record or a denial. */
    }

    action def RecordEnrollment :> EnterpriseProcess {
        doc /* The enrollment transaction is written to the system
               of record, the student's enrollment status is updated,
               and the section's available seat count is decremented.
               Primary actor: system (automated).
               Output: a committed enrollment record. */
    }

    action def NotifyStudent :> EnterpriseProcess {
        doc /* The student is notified of the outcome of their
               enrollment request: confirmed, waitlisted, or
               rejected.  Status change notifications are also
               sent to relevant institutional offices.
               Primary actor: system (automated).
               Output: a delivered enrollment status notification. */
    }

    action def ReportEnrollmentStatus :> EnterpriseProcess {
        doc /* Enrollment data is extracted and formatted for
               internal reporting (faculty rosters, financial aid
               triggers) and external reporting (federal census
               submissions, accreditation data requests).
               Primary actor: RegistrarActor, system (automated).
               Output: enrollment report or data extract. */
    }
}
