/**
 * PurposePackage.sysml
 *
 * Answers: why does the enrollment process exist?
 *
 * Contents:
 *   — six Stakeholder specializations
 *   — one StakeholderNeed per role, capturing that role's viewpoint
 *   — seven formal requirement definitions covering enrollment policy
 *   — one Mission use case definition
 *
 * All definitions specialize a CoSMA base type via :>
 * No institution-specific or vendor-specific content.
 */
package UniversalU_Purpose {

    import CoSMA::*;

    // ─────────────────────────────────────────────────────────────
    // STAKEHOLDERS
    // ─────────────────────────────────────────────────────────────

    part def Student :> Stakeholder {
        doc /* A person admitted to the institution who seeks to
               enroll in one or more course sections within a given
               academic term.  The primary subject of the enrollment
               process. */
    }

    part def Registrar :> Stakeholder {
        doc /* The institutional office responsible for maintaining
               official academic records, enforcing enrollment
               policies, managing the academic calendar, and
               reporting enrollment data to external bodies. */
    }

    part def FinancialAidOffice :> Stakeholder {
        doc /* The institutional office responsible for determining
               student aid eligibility, managing disbursements, and
               ensuring compliance with applicable federal financial
               aid regulations. */
    }

    part def Faculty :> Stakeholder {
        doc /* Instructors assigned to teach course sections.
               Faculty require accurate class rosters, enforced
               prerequisite rules, and timely notification of
               enrollment changes affecting their sections. */
    }

    part def FederalRegulator :> Stakeholder {
        doc /* Federal agencies and programs that require accurate
               enrollment reporting for statistical, compliance, and
               student aid funding purposes.  Institutional data must
               conform to published federal reporting standards. */
    }

    part def Accreditor :> Stakeholder {
        doc /* Regional and programmatic accreditation bodies that
               rely on enrollment data as evidence of institutional
               health, program viability, and adherence to
               accreditation standards across review cycles. */
    }

    // ─────────────────────────────────────────────────────────────
    // STAKEHOLDER VIEWPOINTS
    // One StakeholderNeed per role captures the perspective that
    // role brings to the enrollment process.  Formal testable
    // requirements are in the section below.
    // ─────────────────────────────────────────────────────────────

    requirement def StudentViewpoint :> StakeholderNeed {
        doc /* Students need a transparent, timely enrollment process
               that surfaces deadlines, prerequisite requirements, and
               seat availability; confirms enrollment status promptly
               upon submission; and notifies them of any changes,
               holds, or waitlist promotions that affect their
               registration. */
    }

    requirement def RegistrarViewpoint :> StakeholderNeed {
        doc /* The registrar needs an enrollment process that
               maintains a single authoritative record of each
               student's enrollment status, enforces institutional
               policies consistently across all transactions, produces
               a complete audit trail, and generates accurate federal
               and accreditation reports without manual reconciliation. */
    }

    requirement def FinancialAidOfficeViewpoint :> StakeholderNeed {
        doc /* The financial aid office needs enrollment status
               changes that affect credit-hour load to trigger
               automatic, timely eligibility reviews so that aid
               awards, Satisfactory Academic Progress evaluations,
               and disbursement calculations reflect the student's
               actual registered status at each relevant point. */
    }

    requirement def FacultyViewpoint :> StakeholderNeed {
        doc /* Faculty need rosters that accurately reflect enrolled
               students as of the add/drop deadline; assurance that
               stated prerequisites have been system-verified before
               any student appears on the roster; and prompt
               notification of late additions, drops, or withdrawals
               affecting their sections. */
    }

    requirement def FederalRegulatorViewpoint :> StakeholderNeed {
        doc /* Federal regulators need enrollment data that is
               accurate, complete, timely, and traceable to the
               institution's authoritative system of record, with
               no manual overrides that bypass audit controls and
               no reconciliation gaps between the system of record
               and submitted reports. */
    }

    requirement def AccreditorViewpoint :> StakeholderNeed {
        doc /* Accreditors need enrollment counts, headcount trends,
               and program-level data to be reproducible from the
               system of record at any historical point in time,
               enabling consistent longitudinal comparisons across
               accreditation review cycles. */
    }

    // ─────────────────────────────────────────────────────────────
    // FORMAL REQUIREMENT DEFINITIONS
    // These define the testable policy constraints the enrollment
    // process must satisfy.  Subject clauses are omitted here;
    // they will be supplied when these defs are used in
    // SpecificationsPackage (future work).
    // ─────────────────────────────────────────────────────────────

    requirement def EnrollmentDeadlineEnforcement :> StakeholderNeed {
        doc /* The enrollment process shall prevent additions after
               the published add deadline and prevent standard drops
               after the published drop deadline for each academic
               term and session.  Exceptions shall require explicit
               registrar authorization and shall produce a
               timestamped, auditable transaction record. */
    }

    requirement def PrerequisiteValidation :> StakeholderNeed {
        doc /* The enrollment process shall verify that a student
               satisfies all stated prerequisites for a course section
               before confirming enrollment.  Prerequisite overrides
               shall require instructor or registrar authorization
               and shall be recorded against the enrollment
               transaction. */
    }

    requirement def CapacityManagement :> StakeholderNeed {
        doc /* The enrollment process shall prevent enrollment in a
               section from exceeding the authorized seat capacity.
               When capacity is reached, subsequent requests shall be
               directed to a managed waitlist.  Capacity overrides
               shall require registrar authorization. */
    }

    requirement def SingleSystemOfRecord :> StakeholderNeed {
        doc /* At any point in time, one and only one system shall
               be the authoritative source of a student's enrollment
               status for a given section and term.  All downstream
               consumers shall derive enrollment data from that
               system; no independent copies shall be maintained
               without a defined synchronization protocol. */
    }

    requirement def FinancialAidEligibilityDetermination :> StakeholderNeed {
        doc /* Any change in a student's enrollment status that
               affects credit-hour load shall automatically trigger
               a review of financial aid eligibility.  The review
               shall be initiated before the next scheduled
               disbursement date for the term. */
    }

    requirement def EnrollmentStatusNotification :> StakeholderNeed {
        doc /* The enrollment process shall notify the student and
               relevant institutional parties within one business day
               of any change in enrollment status, including
               confirmed enrollment, waitlist placement, waitlist
               promotion, drop, or withdrawal. */
    }

    requirement def RecordsAccuracy :> StakeholderNeed {
        doc /* Enrollment records shall accurately and completely
               reflect each student's registration history for every
               section and term.  No record shall be modified without
               generating a timestamped audit entry identifying the
               initiating actor, the prior state, and the stated
               reason for change. */
    }

    // ─────────────────────────────────────────────────────────────
    // MISSION
    // ─────────────────────────────────────────────────────────────

    use case def EnrollStudentMission :> Mission {
        doc /* Enable a student admitted to the institution to
               identify available course sections, confirm eligibility,
               register for and be enrolled in those sections within
               published deadlines, have financial aid eligibility
               assessed, and receive timely confirmation — with the
               institution maintaining a single, accurate, auditable
               record of enrollment status throughout. */

        actor student          : Student;
        actor registrar        : Registrar;
        actor financialAid     : FinancialAidOffice;
        actor faculty          : Faculty;
        actor federalRegulator : FederalRegulator;
        actor accreditor       : Accreditor;

        objective {
            doc /* Produce a confirmed, policy-compliant enrollment
                   record that is accurate as of the transaction date,
                   visible to all authorised parties, and reportable
                   to federal and accreditation bodies without manual
                   intervention. */
        }
    }
}
