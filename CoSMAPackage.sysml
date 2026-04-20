/**
 * CoSMAPackage.sysml
 *
 * Root abstract type definitions for the Universal University
 * Reference Model — Enrollment Process Example.
 *
 * Three layers are in scope for this example:
 *   Purpose → Operational → Functional
 * Logical and Technical layers are explicitly out of scope.
 *
 * Every definition in the three domain packages specializes
 * one of these base types using the :> (specialization) operator.
 *
 * Framework : CoSMA (Complex-Systems-Modeling-Architecture), Airbus
 * Reference  : github.com/airbus/apollo-11-sysml-v2
 */
package CoSMA {

    // ─────────────────────────────────────────────────────────────
    // PURPOSE LAYER — why does the enrollment process exist?
    // ─────────────────────────────────────────────────────────────

    abstract part def Stakeholder {
        doc /* A person, office, or external body with an interest in
               the enrollment process.  Concrete specializations in
               PurposePackage name the six roles: Student, Registrar,
               FinancialAidOffice, Faculty, FederalRegulator,
               Accreditor. */
    }

    abstract requirement def StakeholderNeed {
        doc /* A statement of what a Stakeholder requires the
               enrollment process to provide.  Stakeholder needs
               are the root inputs that drive every enterprise
               process and system function defined in the layers
               below. */
    }

    abstract use case def Mission {
        doc /* The top-level purpose the enrollment process is
               designed to fulfil, expressed as a use-case narrative.
               A Mission names its participating actors and states
               its objective. */
    }

    // ─────────────────────────────────────────────────────────────
    // OPERATIONAL LAYER — what happens, and in what order?
    // ─────────────────────────────────────────────────────────────

    abstract part def Actor {
        doc /* A participant who performs one or more steps in the
               enrollment process.  Actors correspond to Stakeholder
               roles but are typed for operational participation
               rather than for needs and interests. */
    }

    abstract state def LifecycleState {
        doc /* A discrete, named state in the enrollment lifecycle.
               Specializations represent the standard enrollment
               status vocabulary: Pending, Registered, Enrolled,
               Waitlisted, Dropped, Withdrawn, Completed. */
    }

    abstract action def EnterpriseProcess {
        doc /* A coarse-grained operational step performed by one or
               more Actors.  Enterprise processes sequence the
               enrollment lifecycle and are decomposed into
               SystemFunctions in the Functional layer. */
    }

    abstract part def DecisionGate {
        doc /* A branching point in the process where a condition
               determines whether the workflow advances along the
               normal path or branches to an alternative path such
               as waitlisting or an ineligibility notification. */
    }

    // ─────────────────────────────────────────────────────────────
    // FUNCTIONAL LAYER — what must the process be capable of?
    // ─────────────────────────────────────────────────────────────

    abstract action def SystemFunction {
        doc /* A discrete capability the enrollment process must
               provide, expressed independently of which actor or
               component delivers it.  Functional definitions are
               actor-agnostic by design. */
    }

    abstract item def InformationArtifact {
        doc /* A document, record, or data payload that flows between
               system functions.  Examples: enrollment requests,
               eligibility results, enrollment records, confirmation
               notices, federal reporting extracts. */
    }

    abstract requirement def SystemConstraint {
        doc /* A constraint imposed on the process by regulation,
               policy, or technology that is not itself a stakeholder
               need but must be satisfied by any conforming
               implementation of the enrollment process. */
    }
}
