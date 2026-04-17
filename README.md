# universal-u-sysml-v2

<img width="1533" height="551" alt="Screenshot 2026-04-17 at 12 36 47" src="https://github.com/user-attachments/assets/7a0809bc-3f4d-4a1c-a60d-1fb0d78bb1af" />






**From River Rouge to Toulouse**

What Higher Education Can Learn from a Century of Manufacturing Complexity

A Position Paper  ·  MBSE Research Initiative  ·  April 2026  ·  Draft for Review**
 
This paper argues that higher education information technology deployments — and student information system implementations in particular — exhibit the structural characteristics that make Model-Based Systems Engineering the appropriate specification discipline: high interface complexity, multi-vendor distributed delivery, and long asset lifecycles. Drawing on a century of manufacturing evolution from River Rouge to the Airbus A350 program, it situates Model-Based Systems Engineering (MBSE) not as a replacement for Waterfall or Agile practices but as a missing complementary layer. It proposes a vendor-neutral SysML v2 reference model of the university enrollment process as an initial contribution to the infrastructure higher education may require in the future.

 
**The Argument**

Higher education information technology deployments exhibit a structural failure mode that has been solved in other industries and remains largely unaddressed in this one. Student information system implementations — among the most complex and consequential technology undertakings a university will manage — fail at a documented high rate, and requirements problems are consistently identified as the primary cause. Not insufficient governance. Not inadequate vendors. Not undisciplined project management. Requirements that were ambiguous when written, inconsistently interpreted as they moved through implementation, and impossible to validate against the delivered system because they existed only as natural language text in a document driven system.

This is not a new observation. It is a persistent one. And it will remain persistent as long as higher education continues to apply a specification discipline suited to a different class of problem.

The argument of this paper is specific: higher education SIS implementations have the structural characteristics that make Model-Based Systems Engineering the appropriate specification approach, and the sector has not yet recognized this. High interface complexity. Multi-vendor distributed delivery. Long asset lifecycles where the specification must outlast any particular implementation. These are the conditions under which formal models — vendor-neutral, machine-readable, formally traceable from requirement to interface to implementation — provide value that documentation cannot. They are also, precisely, the conditions of every major university technology deployment.

MBSE is not a replacement for project management. It is the missing layer beneath it — the formal interface specification discipline that tells each vendor, unambiguously, what their component must do at its boundaries, independent of how they build what sits behind those boundaries. The absence of that layer is why integration fails at the seams. It is why rework dominates the back half of implementation projects. It is why the next SIS implementation will likely encounter the same problems as the last one, at greater cost, because the systems being integrated are more numerous and more interconnected than they were a decade ago.

This is a solvable problem. It has been solved, under pressure, in aerospace manufacturing — an industry with structurally identical characteristics but considerably higher stakes for getting the interfaces wrong. The evidence for what the solution looks like, and the methodology for implementing it, exists. What does not yet exist in higher education is the infrastructure to use it: the practitioner training, the vendor intake processes, the governance frameworks, and the reference models that give institutions a formal starting point rather than a blank page.

This paper proposes a first contribution toward that infrastructure.


**How Other Industries Got Here First**

In 1928, Henry Ford’s River Rouge complex in Dearborn, Michigan was the largest integrated manufacturing facility in the world. Iron ore entered at one end of a two-mile industrial corridor; finished automobiles emerged from the other. The logic was elegant in its linearity: control every input, sequence every operation, eliminate variability. The project management philosophy that emerged from that era reflected the same assumptions. Requirements arrived at the front of the process. A defined sequence of work followed. A product emerged at the end. The specification document was the authoritative artifact. The model was the factory floor.

This approach worked well for the conditions that produced it: stable requirements, co-located teams, single-organization delivery, and products whose complexity could be fully specified in advance. For several decades, it was the dominant model for managing large, complex undertakings — including, eventually, information technology projects. The software development waterfall methodology, formalized in the early 1970s, drew explicitly on sequential manufacturing process models. Requirements in, product out. Documentation as the connective tissue.


**From Linear to Lean**

The limits of that approach became visible as manufacturing complexity increased and uncertainty rose. When Toyota began systematically utilizing what would become the Toyota Production System in the postwar decades, the target was not sequence but flow — eliminating waste, reducing inventory, responding to actual demand rather than projected demand. W. Edwards Deming’s contributions to quality management, developed in Japan during the same period, addressed a related problem: building quality into the process rather than inspecting it in at the end. Together, these ideas fundamentally reframed how complex production should be organized. The factory floor was no longer a linear corridor but a responsive system.

Software development absorbed those lessons, imperfectly but consequentially, in the Agile movement of the late 1990s and early 2000s. Iterative delivery, working software over comprehensive documentation, response to change over following a plan. The Agile Manifesto of 2001 was, among other things, a rejection of River Rouge logic applied to software. It acknowledged that requirements are not fully knowable at the start of a project, that the right product emerges from iteration rather than specification, and that a functioning increment is worth more than a complete document.

Higher education information technology has, by and large, adopted Agile practices — sprint-based delivery rhythms, iterative releases, cross-functional product teams. Whether those practices have consistently produced Agile outcomes is a more complicated question. Many student information system implementations use Agile vocabulary, "worksets" for example, to describe what remains in practice, a sequential project with renamed phases. That observation is not a criticism. It reflects a structural reality: certain classes of problem resist Agile approaches not because the teams are undisciplined, but because the problem itself has characteristics that iterative discovery does not adequately address.


**The Interface Problem: Hamburg to Toulouse**

Those characteristics became visible at a different scale in a different industry at roughly the same time that Agile was transforming software development. The Airbus A380 program, launched in the late 1990s, attempted to coordinate the design and manufacture of a commercial aircraft across facilities in France, Germany, the United Kingdom, Spain, and elsewhere. Components were engineered and built by different organizations, in different countries, on different schedules, and then physically assembled in Toulouse.

The result, when the wiring harnesses manufactured in Hamburg and those manufactured in Toulouse were brought together for final assembly, was a mismatch that delayed the program by two years and cost Airbus an estimated €4.8 billion. Two facilities within the same company, using the same CAD platform but running incompatible versions of it, had each implemented their component correctly against their own interpretation of what the interface between those components required. The specification — the document — had not been formal enough, precise enough, or machine-readable enough to guarantee that two independently produced components would connect when they met in the physical world.

The A350 program, which followed, was designed differently. A single digital model — the authoritative formal specification of the aircraft — served as the source of truth for every interface, every component, every tolerance. Components still manufactured in distributed facilities. Assembly still happened in Toulouse. But the interfaces were formally specified in a way that made ambiguity structurally impossible. This is the sense in which the Digital Twin concept emerged from industrial necessity rather than engineering ambition: it was the solution to a coordination problem that documentation alone could not solve.


**The Higher Education Parallel**

The relevance to higher education is not metaphorical. It is structural.

A modern university’s technology ecosystem — student information system, customer relationship management platform, learning management system, human capital management system, financial system, identity management infrastructure — exhibits precisely the characteristics that made the A380 program vulnerable. Components are built by different vendors. They are implemented in overlapping phases, often by different implementation partners, against requirements that have been specified in natural language documents subject to interpretation. Each vendor implements their component correctly against their own interpretation of what the interfaces require. Integration fails at the seams. Rework follows.

The higher education sector has recognized this problem and has largely addressed it with the tools available: tighter governance, more rigorous vendor management, better testing protocols, and the adoption of Agile practices that allow course correction when integration failures surface. These are appropriate responses to the problem as currently defined. They are not sufficient responses to the problem as it is becoming.
The Right Tool for the Right Problem

The right tool for a given project is determined by the structural characteristics of the problem, not by the sophistication of the team. Waterfall project management is well-suited to stable requirements, low interface complexity, and single-vendor delivery. Agile methodology is well-suited to high uncertainty, iterative discovery, and single-team delivery. Model-Based Systems Engineering — the formal specification of a system’s structure, behavior, interfaces, and requirements in a machine-readable model — is well-suited to high interface complexity, multi-vendor distributed development, and long asset lifecycles where the specification must outlast any particular implementation.

Higher education SIS implementations sit firmly in the third category. The interface complexity is high: enrollment touches financial aid, which touches student financials, which touches the human capital system, which touches identity management, which touches the learning management system. The delivery is multi-vendor and distributed: no single organization designs and builds all of these components. The asset lifecycle is long: institutions expect their SIS investments to serve them for fifteen to twenty years, across multiple technology generations. And the failure mode — requirements ambiguity producing interface failures that produce rework — is the same failure mode that the A350 program was specifically engineered to avoid.

The question is not whether MBSE is theoretically applicable to higher education IT. It is whether the sector will build the infrastructure to support it before the cost of not doing so becomes impossible to ignore.


**What Is Being Proposed**

This paper proposes neither that higher education abandon Agile practices nor that formal methods will immediately transform how institutions specify and procure technology. The infrastructure required to operationalize MBSE in higher education IT — vendor intake processes designed to accept formal specifications, practitioner training in SysML v2, governance frameworks that include formal model validation — does not yet exist at scale. What does exist is the methodology, the tooling, and the prior art from adjacent domains sufficient to build the formal specification layer that higher education technology deployments will eventually require.

The work described here is a first contribution toward that infrastructure: a vendor-neutral, formally specified reference model of the university enrollment process, built from publicly available higher education standards documentation — IPEDS, PESC, IMS LIS — and structured using the CoSMA five-layer framework expressed in SysML v2. It is modeled directly on the Apollo 11 reference model published by Airbus, which demonstrated that the CoSMA methodology could produce a formally rigorous, reproducible artifact from historical documentation alone.

The proposed reference model covers the Purpose, Operational, Functional, and Logical layers of the enrollment process, stopping deliberately at the Logical layer boundary. This is the boundary at which vendor-neutrality is preserved: the layers above describe what a university enrollment system must do and what abstract components must be responsible for doing it, independent of any specific platform. The Technical layer — the specific mapping of logical components to platform-specific implementations — is demonstrated through two alternative instantiations using representative SIS platforms, showing that the same Logical layer specification can be satisfied by different platforms without modification.

**Why Now, and Why This Matters**

Institutions deploying their next student information system using the same document-driven requirements approach they used for the last one will face the same requirements failures at greater cost, because system complexity is increasing faster than documentation discipline is improving. The integration surface between an SIS and the systems around it is wider than it was a decade ago. The number of vendors involved is larger. The regulatory obligations being captured in requirements documents are more numerous and more interconnected. The tolerance for rework is lower.

MBSE is not inevitable in higher education. What is inevitable is that the current approach will continue to produce predictable failures at predictable costs. The question is not whether a better approach exists — it does, and it has been demonstrated at scale in industries with structurally similar problems. The question is whether the sector will build the infrastructure to support it before that cost becomes impossible to ignore, or whether it will wait until the cost makes the infrastructure unavoidable.

This work is offered as a contribution to the former path. The reference model will be published as an open-source repository, structured for community extension, with a methodology companion that documents how public standards documentation translates to formal model elements. The intent is to give the next generation of higher education systems engineers something to build from — the specification for an airport that the aircraft will eventually require.

 
**References and Notes**

Royce, W.W. (1970). Managing the development of large software systems. Proceedings of IEEE WESCON, 26, 1–9. The paper that defined waterfall methodology, drawing on sequential manufacturing process models.

Ohno, T. (1988). Toyota Production System: Beyond Large-Scale Production. Productivity Press. The foundational text on Toyota Production System and just-in-time manufacturing.

Deming, W.E. (1982). Out of the Crisis. MIT Press. Quality management as a systemic discipline; developed in Japan during the postwar period.

Beck, K. et al. (2001). Manifesto for Agile Software Development. agilemanifesto.org.

Kingsley-Jones, M. (2006). Airbus A380 wiring problems explained. Flight International, October 2006. Documents the CATIA version incompatibility between Hamburg and Toulouse facilities that caused the A380 production delays.

Helle, P. and Schramm, M. (2024). Fly me to the Moon — Modeling Apollo 11 using SysML v2. ResearchGate preprint. The direct methodological precedent for this work.

National Center for Education Statistics. (2024). IPEDS Data Collection Glossary. nces.ed.gov/ipeds.

Postsecondary Electronic Standards Council. (2019). Student Academic History XML Data Dictionary v1.9.0. pesc.org.

IMS Global Learning Consortium. (2012). IMS Learning Information Services (LIS) v2.0 Final Specification. imsglobal.org.

 
 **From River Rouge to Toulouse  ·  Position Paper Draft  ·  MBSE Research Initiative  ·  April 2026**
