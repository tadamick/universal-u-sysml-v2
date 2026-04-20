/**
 * FunctionalPackage.sysml
 *
 * Answers: what discrete capabilities must the enrollment process
 * be able to perform?
 *
 * Contents:
 *   — eight InformationArtifact specializations (the data types
 *     that flow between functions)
 *   — nine SystemFunction specializations (one per required
 *     capability)
 *   — one complete action sequence (ProcessEnrollmentSequence)
 *     showing the enrollment workflow with a decide/merge branch
 *     for the eligibility failure path
 *
 * Functions are actor-agnostic: no performer is named.
 * No port definitions: those belong to the Logical layer (out of
 * scope for this example).
 * No satisfy links: those will be added once source citations are
 * established in the formal version of this model.
 */
package UniversalU_Functional {

    private import ScalarValues::*;

    import CoSMA::*;
    import UniversalU_Purpose::*;
    import UniversalU_Operational::*;

    // ─────────────────────────────────────────────────────────────
    // INFORMATION ARTIFACTS
    // The typed data payloads that flow between system functions.
    // ─────────────────────────────────────────────────────────────

    item def EnrollmentRequest :> InformationArtifact {
        doc /* The input to the enrollment process.  Contains at
               minimum: student identifier, section identifier,
               academic term, and submission timestamp. */
    }

    item def EligibilityResult :> InformationArtifact {
        doc /* The outcome of the ValidateStudentEligibility function.
               Carries a Boolean determination and, on failure, the
               reason code (hold type, standing violation, etc.) that
               prevented enrollment. */
    }

    item def CapacityCheckResult :> InformationArtifact {
        doc /* The outcome of the CheckSectionCapacity function.
               Carries a Boolean determination and, if capacity is
               available, the count of remaining seats. */
    }

    item def EnrollmentRecord :> InformationArtifact {
        doc /* The committed enrollment transaction.  Serves as the
               authoritative record in the system of record.
               Contains: student identifier, section identifier,
               term, enrollment status, transaction timestamp, and
               initiating actor reference. */
    }

    item def StatusUpdateRecord :> InformationArtifact {
        doc /* A record of an enrollment status change.  Extends
               EnrollmentRecord with: prior status, new status,
               and the business reason for the transition. */
    }

    item def FinancialAidTrigger :> InformationArtifact {
        doc /* A signal sent to the financial aid system when a
               credit-hour-affecting enrollment status change occurs.
               Contains: student identifier, term, new credit-hour
               load, and the triggering transaction reference. */
    }

    item def EnrollmentConfirmation :> InformationArtifact {
        doc /* The outbound notification delivered to the student
               upon successful enrollment.  Contains: section
               details, enrollment status, credit hours, and
               any applicable deadlines (add/drop, withdrawal). */
    }

    item def StatusNotification :> InformationArtifact {
        doc /* A general-purpose status notification sent to one
               or more parties (student, registrar, faculty) when
               enrollment status changes.  Parameterised by
               recipient, prior status, and new status. */
    }

    // ─────────────────────────────────────────────────────────────
    // SYSTEM FUNCTIONS
    // One action def per discrete required capability.
    // ─────────────────────────────────────────────────────────────

    action def ValidateStudentEligibility :> SystemFunction {
        doc /* Determine whether the student is eligible to enroll.
               Calls VerifyPrerequisites and CheckRegistrationHolds
               as subordinate checks.  Produces an EligibilityResult
               that drives the eligibility branch in
               ProcessEnrollmentSequence. */
        in  request       : EnrollmentRequest;
        out result        : EligibilityResult;
        out isEligible    : Boolean;
    }

    action def VerifyPrerequisites :> SystemFunction {
        doc /* Check that the student has satisfied all prerequisites
               stated for the requested course.  Consults the
               academic history record and the course catalogue.
               A subordinate function called by
               ValidateStudentEligibility. */
        in  request           : EnrollmentRequest;
        out prerequisitesMet  : Boolean;
    }

    action def CheckRegistrationHolds :> SystemFunction {
        doc /* Check whether any administrative holds are active on
               the student's account that would prevent enrollment
               (financial, academic, judicial, etc.).  A subordinate
               function called by ValidateStudentEligibility. */
        in  request    : EnrollmentRequest;
        out holdsExist : Boolean;
    }

    action def CheckSectionCapacity :> SystemFunction {
        doc /* Determine whether the requested section has at least
               one available seat.  Consults the live seat count in
               the system of record.  Produces a CapacityCheckResult
               that drives the capacity branch in
               ProcessEnrollmentSequence. */
        in  request : EnrollmentRequest;
        out result  : CapacityCheckResult;
        out hasCapacity : Boolean;
    }

    action def RecordEnrollmentTransaction :> SystemFunction {
        doc /* Write the enrollment transaction to the system of
               record, reserve a seat in the section, and return
               an EnrollmentRecord.  This function is the single
               point of write for enrollment status and must be
               atomic with respect to concurrent requests for the
               same section. */
        in  request : EnrollmentRequest;
        out record  : EnrollmentRecord;
    }

    action def UpdateEnrollmentStatus :> SystemFunction {
        doc /* Apply an enrollment status transition to an existing
               EnrollmentRecord (e.g., Pending → Registered,
               Registered → Enrolled).  Produces a StatusUpdateRecord
               that preserves the prior state for audit purposes. */
        in  record        : EnrollmentRecord;
        out statusUpdate  : StatusUpdateRecord;
    }

    action def TriggerFinancialAidReview :> SystemFunction {
        doc /* Emit a FinancialAidTrigger when a status change affects
               the student's credit-hour load.  The trigger is
               consumed by the financial aid system to initiate an
               eligibility review before the next disbursement. */
        in  statusUpdate : StatusUpdateRecord;
        out trigger      : FinancialAidTrigger;
    }

    action def GenerateEnrollmentConfirmation :> SystemFunction {
        doc /* Produce an EnrollmentConfirmation from a committed
               EnrollmentRecord.  The confirmation is the artifact
               delivered to the student and logged as evidence of
               the completed transaction. */
        in  record       : EnrollmentRecord;
        out confirmation : EnrollmentConfirmation;
    }

    action def NotifyStakeholders :> SystemFunction {
        doc /* Deliver a StatusNotification to one or more parties
               (student, registrar office, faculty) when enrollment
               status changes.  Also delivers an EnrollmentConfirmation
               to the student on the success path.  On the failure
               path, delivers a rejection notice with a reason code. */
        in  notification : StatusNotification;
    }

    // ─────────────────────────────────────────────────────────────
    // COMPLETE ENROLLMENT ACTION SEQUENCE
    //
    // ProcessEnrollmentSequence shows the full enrollment workflow
    // as a SysML v2 action decomposition using first / then / decide.
    //
    // Success path:
    //   start → validateEligibility → decide (eligible?)
    //     → checkCapacity → recordTransaction → updateStatus
    //     → triggerFinancialAid → generateConfirmation
    //     → notifySuccess → done
    //
    // Failure path (ineligible):
    //   decide (not eligible?) → notifyFailure → done
    //
    // The capacity failure path (section full → waitlist) is
    // documented in OperationalPackage (CapacityGate) and would
    // appear here as a second decision node in a more detailed model.
    // ─────────────────────────────────────────────────────────────

    action def ProcessEnrollmentSequence :> SystemFunction {
        doc /* The complete enrollment workflow from request receipt
               through confirmation delivery.  Integrates all nine
               system functions in a single sequenced, branching
               action definition that can be parsed and visualised
               by the OMG SysML v2 Pilot Implementation. */

        in  item request      : EnrollmentRequest;
        out item confirmation : EnrollmentConfirmation;

        // ── Entry point ──
        first start;

        // ── Step 1: Validate eligibility ──
        then action validateEligibility : ValidateStudentEligibility {
            in item enrollmentRequest;
            out isEligible : Boolean;
        }

        // ── Decision: eligible or not? ──
        then decide;
            if validateEligibility.isEligible then checkCapacity;
            if !validateEligibility.isEligible then notifyFailure;

        // ── Success path ──────────────────────────────────────────

        // Step 2: Check section capacity
        action checkCapacity : CheckSectionCapacity {
            in item enrollmentRequest;
            out hasCapacity : Boolean;
        }
        then recordTransaction;

        // Step 3: Record the enrollment transaction
        action recordTransaction : RecordEnrollmentTransaction {
            in item enrollmentRequest;
            out item enrollmentRecord : EnrollmentRecord;
        }
        then updateStatus;

        // Step 4: Update enrollment status (Pending → Registered)
        action updateStatus : UpdateEnrollmentStatus {
            in item record = recordTransaction.enrollmentRecord;
            out item statusUpdate : StatusUpdateRecord;
        }
        then triggerFinancialAid;

        // Step 5: Trigger financial aid review
        action triggerFinancialAid : TriggerFinancialAidReview {
            in item statusUpdate = updateStatus.statusUpdate;
        }
        then generateConfirmation;

        // Step 6: Generate enrollment confirmation
        action generateConfirmation : GenerateEnrollmentConfirmation {
            in item record = recordTransaction.enrollmentRecord;
            out item enrollmentConfirmation : EnrollmentConfirmation;
        }
        then notifySuccess;

        // Step 7: Notify student — success
        action notifySuccess : NotifyStakeholders {
            in item notification : StatusNotification;
        }
        then done;

        // ── Failure path ──────────────────────────────────────────

        // Step 2 (alt): Notify student — ineligible
        action notifyFailure : NotifyStakeholders {
            in item notification : StatusNotification;
        }
        then done;

        // ── Item flows ────────────────────────────────────────────
        flow from recordTransaction.enrollmentRecord
             to   updateStatus.record;

        flow from updateStatus.statusUpdate
             to   triggerFinancialAid.statusUpdate;

        flow from recordTransaction.enrollmentRecord
             to   generateConfirmation.record;

        flow from generateConfirmation.enrollmentConfirmation
             to   ProcessEnrollmentSequence::confirmation;
    }
}
