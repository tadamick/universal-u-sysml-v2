/**
 * PurposePackage.sysml
 *
 * Answers: why does this process exist?
 * Contains the five stakeholders, one need per stakeholder,
 * and the single top-level mission that the process must fulfil.
 *
 * All definitions specialize a CoSMA base type via :>
 * All names are imported from CoSMAPackage via  import CoSMA::*
 */
package CrossRegistration_Purpose {

    import CoSMA::*;

    // ─────────────────────────────────────────────────────────────
    // STAKEHOLDERS
    // ─────────────────────────────────────────────────────────────

    part def Student :> Stakeholder {
        doc /* The degree-seeking student enrolled at the home
               institution who wishes to take a course offered
               by the host institution. The student is the primary
               actor and the subject of every downstream phase. */
    }

    part def HomeRegistrar :> Stakeholder {
        doc /* The registrar's office at the home institution.
               Confirms student eligibility, facilitates inter-
               institutional communication, evaluates transfer
               credit, and posts the final grade to the student's
               official transcript. */
    }

    part def HostRegistrar :> Stakeholder {
        doc /* The registrar's office at the host institution.
               Admits the student to a non-degree cross-registration
               program of study, manages course enrollment, and
               transmits the final grade report to the home
               institution. */
    }

    part def FinancialAidOffice :> Stakeholder {
        doc /* The financial aid office at the home institution.
               Confirms that the student's aid package applies to
               the cross-registered course and ensures that tuition
               billing is established at the correct institution. */
    }

    part def Instructor :> Stakeholder {
        doc /* The course instructor at the host institution.
               Delivers instruction and submits the final grade,
               which must be transmitted to the home institution
               for transfer-credit evaluation. */
    }

    // ─────────────────────────────────────────────────────────────
    // STAKEHOLDER NEEDS
    // ─────────────────────────────────────────────────────────────

    requirement def StudentEnrollmentNeed :> StakeholderNeed {
        doc /* The student needs to identify a course at the host
               institution, confirm eligibility, enroll, attend,
               and receive academic credit that is recognised toward
               their degree at the home institution — without being
               required to apply for full admission to the host. */
    }

    requirement def HomeRegistrarProcessingNeed :> StakeholderNeed {
        doc /* The home registrar needs a defined, auditable process
               for confirming student eligibility, facilitating
               inter-institutional communication, and accurately
               posting transfer credit to the student's transcript
               once the course is complete. */
    }

    requirement def HostRegistrarAdmissionNeed :> StakeholderNeed {
        doc /* The host registrar needs a mechanism to admit and
               enroll a non-degree visiting student without
               disrupting normal enrollment management, seat
               allocation, or prerequisite enforcement for
               degree-seeking students at the host institution. */
    }

    requirement def FinancialAidNeed :> StakeholderNeed {
        doc /* The financial aid office needs assurance that the
               student's aid eligibility is evaluated against the
               cross-registered course and that billing is correctly
               established — at the home institution, the host
               institution, or both — before the course begins. */
    }

    requirement def InstructorGradeSubmissionNeed :> StakeholderNeed {
        doc /* The instructor needs a clear, reliable channel for
               submitting a final grade that will be accurately
               transmitted to the home institution and applied as
               transfer credit on the student's official record,
               with no additional action required from the student. */
    }

    // ─────────────────────────────────────────────────────────────
    // MISSION
    // ─────────────────────────────────────────────────────────────

    use case def CrossRegistrationMission :> Mission {
        doc /* Enable a degree-seeking student enrolled at a home
               institution to identify, enroll in, attend, and
               receive transferable academic credit for a course
               offered by a host institution within the same
               university system — subject to eligibility
               confirmation, institutional approval, and the
               system constraint that host-institution credit is
               processed as transfer credit at the home institution. */

        actor student          : Student;
        actor homeRegistrar    : HomeRegistrar;
        actor hostRegistrar    : HostRegistrar;
        actor financialAid     : FinancialAidOffice;
        actor instructor       : Instructor;
    }
}
