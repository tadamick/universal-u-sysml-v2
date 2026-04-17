/**
 * CoSMAPackage.sysml
 *
 * Root abstract type definitions for the Cross-Registration Model.
 * Every definition in the five domain packages specializes one of
 * these base types using the :> (specialization) operator.
 *
 * Framework : CoSMA (Complex-Systems-Modeling-Architecture), Airbus
 * Reference  : github.com/airbus/apollo-11-sysml-v2
 * Scope      : Purpose → Operational → Functional → Logical
 *              (Technical layer is out of scope for this model)
 */
package CoSMA {

    // ─────────────────────────────────────────────────────────────
    // PURPOSE LAYER — why does the process exist?
    // ─────────────────────────────────────────────────────────────

    abstract part def Stakeholder {
        doc /* A person or organisation with an interest in the
               cross-registration process. Concrete specializations
               in PurposePackage will be: Student, HomeRegistrar,
               HostRegistrar, FinancialAidOffice, Instructor. */
    }

    abstract requirement def StakeholderNeed {
        doc /* A high-level statement of what a Stakeholder needs
               the process to deliver. These are the root inputs
               that drive every function and logical component
               defined in the layers below. */
    }

    abstract use case def Mission {
        doc /* The top-level purpose the process is designed to
               fulfil, expressed as a use-case narrative. A Mission
               may decompose into multiple OperationalActivities. */
    }

    // ─────────────────────────────────────────────────────────────
    // OPERATIONAL LAYER — what happens, and in what order?
    // ─────────────────────────────────────────────────────────────

    abstract state def LifecyclePhase {
        doc /* One discrete, named phase of the end-to-end process.
               Modelled as a state so that entry conditions, exit
               conditions, and outgoing decision gates can be
               attached. The six cross-registration phases each
               specialize this type. */
    }

    abstract action def OperationalActivity {
        doc /* A step carried out by one or more Stakeholders during
               a LifecyclePhase. Actions have typed inputs and outputs
               (InformationArtifacts) that flow between them. */
    }

    abstract part def DecisionGate {
        doc /* A branching point where a Boolean condition determines
               whether the process advances or terminates. The three
               required gates are: eligibility check, host-institution
               approval, and course-equivalency evaluation. */
    }

    // ─────────────────────────────────────────────────────────────
    // FUNCTIONAL LAYER — what must the process be capable of?
    // ─────────────────────────────────────────────────────────────

    abstract action def SystemFunction {
        doc /* A capability the process (and its supporting systems)
               must provide, expressed independently of who or what
               delivers it. Functional definitions are deliberately
               implementation-agnostic. */
    }

    abstract item def InformationArtifact {
        doc /* A document, record, or data payload that flows between
               Stakeholders or SystemFunctions. Examples: eligibility
               confirmation, enrollment record, grade report,
               transfer-credit posting. */
    }

    // ─────────────────────────────────────────────────────────────
    // LOGICAL LAYER — which abstract components are responsible?
    // ─────────────────────────────────────────────────────────────

    abstract part def LogicalComponent {
        doc /* An abstract responsible entity named by role or
               responsibility, not by product or vendor. Concrete
               specializations in LogicalPackage will be things like
               HomeSISSubsystem and HostEnrollmentSubsystem.
               The Technical layer (out of scope) would map these
               onto real platforms such as Workday Student. */
    }

    abstract part def LogicalInterface {
        doc /* An abstract connection through which two
               LogicalComponents exchange InformationArtifacts.
               Captures the interaction contract without specifying
               protocol, API, or integration technology. */
    }

    // ─────────────────────────────────────────────────────────────
    // CROSS-CUTTING — constraints that span all layers
    // ─────────────────────────────────────────────────────────────

    abstract requirement def SystemConstraint {
        doc /* A constraint imposed on the process by technology,
               regulation, or policy that is not itself a stakeholder
               need but must be satisfied by any conforming design.
               The Workday multi-tenant transfer-credit constraint
               is the canonical example in this model. */
    }
}
