#import "@preview/touying:0.6.3": *
#import themes.metropolis: *
#import "@preview/fontawesome:0.6.0": *
#import "@preview/codly:1.3.0": *
#import "@preview/cetz:0.4.2"
#import "utils.typ": *

#show: codly-init.with()

// Pdfpc configuration
// typst query --root . ./final-year-phd-presentation.typ --field value --one "<pdfpc-file>" > ./final-year-phd-presentation.pdfpc
#let pdfpc-config = pdfpc.config(
  duration-minutes: 20,
  start-time: datetime(hour: 14, minute: 10, second: 0),
  end-time: datetime(hour: 14, minute: 30, second: 0),
  last-minutes: 3,
  note-font-size: 12,
  disable-markdown: false,
  default-transition: (
    type: "push",
    duration-seconds: 2,
    angle: ltr,
    alignment: "vertical",
    direction: "inward",
  ),
)

#let supervisors = block[
  #text(size: 0.90em, fill: ink.lighten(20%))[
    #text(weight: "medium", fill: ink)[Supervisor:] Prof. Mirko Viroli \
    #text(weight: "medium", fill: ink)[Co-supervisor:] Prof. Danilo Pianini
    // #linebreak()
    #v(0.1em)
    #text(weight: "medium", fill: ink)[PhD Coordinator:] Prof.ssa Paola Salomoni
  ]
]

#show: metropolis-theme.with(
  aspect-ratio: "16-9",
  footer: self => self.info.institution,
  config-common(
    preamble: {
      codly(
        languages: (scala: (name: [Scala]), kotlin: (name: [Kotlin])),
        display-icon: false,
        display-name: false,
        number-format: none,
        zebra-fill: none,
        fill: luma(248),
        stroke: .6pt + ink.lighten(78%),
        radius: 10pt,
        inset: (x: .6em, y: .25em),
        smart-indent: false,
        breakable: false,
      )
      pdfpc-config
    },
    show-bibliography-as-footnote: bibliography(title: none, "bibliography.bib"),
  ),
  config-info(
    title: [Engineering Collective Systems in the Edge-Cloud Continuum: Models and Platform],
    subtitle: [#text(size: 1em)[Final-year progress review — Ciclo XXXIX]],
    author: author_list(
      ((first_author("Nicolas Farabegoli"), "nicolas.farabegoli@unibo.it"),),
      // logo: "images/disi.svg",
      width: 35%,
    ) + supervisors,
    date: datetime.today().display("[day] [month repr:long] [year]"),
    institution: [University of Bologna — DISI],
    // logo: context {
    //   if utils.slide-counter.get().first() > 1 [
    //     #align(right)[#image("images/disi.svg", height: 1cm)]
    //   ] else [
    //     #none
    //   ]
    // },
  ),
)

#set text(font: "Fira Sans", weight: "light", size: 20pt)
#show math.equation: set text(font: "Fira Math")

#set raw(tab-size: 2)
#show raw: set text(font: "JetBrains Mono", weight: "light", size: 0.8em)
#show raw.where(block: false): set text(size: 1.2em)

#show bibliography: set text(size: 0.75em)
#show footnote.entry: set text(size: 0.75em)

#title-slide()

// == Outline <touying:hidden>

// #components.adaptive-columns(outline(title: none, indent: 1em, depth: 1))


// =============================================================================
// ACT I -- BACKGROUND (5 minutes)
// =============================================================================

= Background

#pdfpc.speaker-note("Act I, 5 minutes. Context, not contribution: keep it moving and be out of this part at 05:00.")

== The Edge-Cloud Continuum

#components.side-by-side(columns: (1.15fr, 1fr), gutter: 1em)[
  #feature-block("The continuum")[
    _Devices, edge, fog and cloud treated as one pool of computational resources, with no fixed boundary between tiers._
  ]

  #text(size: .88em)[
    - Hardware spans microcontrollers to datacentre
    - Nodes join, leave and fail while the system runs
    - Network partitions happen regularly
  ]
][
  #align(center + horizon)[
    #image("images/edge-cloud-continuum.svg", height: 80%)
  ]
]

#pdfpc.speaker-note("~60s. What matters for the rest of the talk: heterogeneity and volatility are what make a fixed deployment hard to keep working.")

== Collective Adaptive Systems

#components.side-by-side(columns: (1fr, 1fr), gutter: 1.2em)[
  === What they are

  Large sets of devices that *pursue a common goal* using only _local interactions_.

  #text(size: .9em)[
    - The number of participants is not fixed.
    - Global behaviour follows from device-local rules.
    - Resilience and scalability come from the structure itself.
  ]
][
  === Where they run

  #mini-card([IoT ecosystems], [Smart cities, buildings, wearable and pervasive sensing.], color: blue)
  #v(.4em)
  #mini-card([Swarm robotics], [Drone fleets and robot teams coordinating in the field.], color: green)
]

#pdfpc.speaker-note("~45s. Bridge slide: these systems are the workload, the continuum is the substrate. The talk is about the mismatch between the two.")

== Macroprogramming

#statement[
  Describe the behaviour of the whole collective as one program, instead of writing a program per node and relying on the global behaviour to emerge.
]

#v(.5em)

#block(width: 100%, inset: .25em, radius: 6pt, fill: luma(250), stroke: (paint: ink.lighten(72%), thickness: .7pt))[
  #table(
    columns: (1.1fr, 1fr, 1fr, 1fr),
    gutter: .08em,
    stroke: none,
    comparison-header[Paradigm],
    comparison-header[Aggregate Computing],
    comparison-header[Choreographic],
    comparison-header[Multitier],
    comparison-label[Unit of abstraction],
    comparison-cell[#text(size: .72em)[Computational field]],
    comparison-cell[#text(size: .72em)[Global protocol]],
    comparison-cell[#text(size: .72em)[Placed value]],
    comparison-label[Communication],
    comparison-cell[#text(size: .72em)[Implicit, neighbourhood]],
    comparison-cell[#text(size: .72em)[Explicit, first-class]],
    comparison-cell[#text(size: .72em)[Implicit, cross-tier]],
    comparison-label[Participants],
    comparison-cell[#text(size: .72em)[Open, unbounded]],
    comparison-cell[#text(size: .72em)[Fixed, known]],
    comparison-cell[#text(size: .72em)[Fixed tiers]],
    comparison-label[Deployment],
    comparison-cell(fill: red.lighten(93%))[#text(size: .72em)[Uniform, implicit]],
    comparison-cell(fill: red.lighten(93%))[#text(size: .72em)[Endpoint projection]],
    comparison-cell(fill: red.lighten(93%))[#text(size: .72em)[Fixed at compile time]],
  )
]

#v(.25em)
#text(size: .82em)[The three paradigms differ in how behaviour is written, but all of them settle deployment before the system starts.]

#pdfpc.speaker-note("~70s. The row that matters is the last one: all three say what the collective computes, none of them says where it runs.")

== What Is Missing

#components.side-by-side(columns: (1fr, 1fr, 1fr), gutter: .8em)[
  #mini-card([From simulation to hardware], [Collective logic is validated in simulation, then mapped onto heterogeneous hardware by hand.], color: red)
][
  #mini-card([The device is the unit], [A logical device is the smallest deployable unit: it runs on one host, or not at all.], color: red)
][
  #mini-card([Placement is frozen], [Fixed at design time, and no model says what a change to it preserves.], color: red)
]

#v(.6em)
#statement(fill: orange.lighten(90%))[
  How can collective behaviour be written once, and then partitioned, placed and reconfigured while the system runs?
]

#pdfpc.speaker-note("~60s. The research question of the thesis: say it slowly, everything after this answers it.")

== Contributions

#components.side-by-side(columns: (1.25fr, 1fr), gutter: 1em)[
  #align(center + horizon)[
    #image("images/contribution-map.svg", width: 100%)
  ]
][
  #step-item("1", [Pulverization model], [Makes the logical device divisible, so its parts can be placed independently.])
  #v(.35em)
  #step-item("2", [Dynamic deployments], [Self-organising reconfiguration, constraint-based planning, learned offloading.])
  #v(.35em)
  #step-item("3", [Language support], [Type-safe coordination and LLM-assisted macroprogramming.])
  #v(.35em)
  #step-item("4", [Demonstrator], [The model running on real robot hardware.])
]

#pdfpc.speaker-note("~60s. Roadmap: name the four blocks, then say the next ten minutes are mostly blocks 1 and 2. End of Act I, should be at 05:00.")

// =============================================================================
// ACT II -- MAIN CONTRIBUTION (10 minutes)
// =============================================================================

= The Pulverization Model

#pdfpc.speaker-note("Act II, 10 minutes, the core of the talk. Should end at 15:00.")

== The Monolithic Device

#components.side-by-side(columns: (1fr, 1fr), gutter: 1.2em)[
  === The problem

  A logical device bundles its behaviour, its state, its neighbourhood links and its physical interfaces into one unit.

  #text(size: .9em)[
    - It has to be deployed as a whole.
    - A constrained device cannot host it, so it stays out of the collective.
    - Offloading part of the work means rewriting the application.
  ]
][
  === The idea

  #feature-block("Pulverisation")[
    _Split each logical device into computationally independent components that can be deployed, and moved, separately._
  ]

  The collective program stays the same; what changes is how it is partitioned and where the parts run.
]

#pdfpc.speaker-note("~55s. In one sentence: keep the logical structure, dissolve the physical one.")

== Five Components

#align(center)[
  #cetz.canvas(length: 1.0cm, {
    import cetz.draw: *

    // the logical device, before pulverisation
    rect((-7.6, -2.3), (-3.0, 2.3), radius: .2,
      fill: ink.lighten(96%),
      stroke: (paint: ink.lighten(55%), thickness: 1pt, dash: "dashed"))
    content((-5.3, 2.7), text(size: .42em, weight: "medium", fill: ink)[logical device], anchor: "center")
    content((-5.3, 0), text(size: .8em, weight: "medium", fill: ink.lighten(30%))[monolith], anchor: "center")

    line((-2.7, 0), (-1.4, 0), stroke: (paint: orange, thickness: 1.4pt), mark: (end: ">"))
    content((-2.05, .42), text(size: .38em, weight: "medium", fill: orange.darken(10%))[pulverise], anchor: "center")

    // group 1: relocatable components
    rect((-1.2, -2.3), (3.2, 2.3), radius: .15,
      fill: blue.lighten(97%), stroke: (paint: blue.lighten(55%), thickness: .8pt, dash: "dashed"))
    content((1.0, 2.7), text(size: .42em, weight: "medium", fill: blue.darken(10%))[relocatable], anchor: "center")
    pulv-node(cetz.draw, (1.0, 1.25), $beta$, "behaviour", blue)
    pulv-node(cetz.draw, (1.0, 0.0), $sigma$, "state", green)
    pulv-node(cetz.draw, (1.0, -1.25), $chi$, "communication", orange)

    // group 2: components pinned to the physical device
    rect((4.2, -2.3), (8.6, 2.3), radius: .15,
      fill: red.lighten(97%), stroke: (paint: red.lighten(55%), thickness: .8pt, dash: "dashed"))
    content((6.4, 2.7), text(size: .42em, weight: "medium", fill: red.darken(10%))[pinned to the device], anchor: "center")
    pulv-node(cetz.draw, (6.4, 0.62), $s$, "sensors", red)
    pulv-node(cetz.draw, (6.4, -0.62), $a$, "actuators", red)
  })
]

#v(.3em)
#statement[
  Behaviour, state and communication can run on any host. Sensors and actuators stay on the physical device.
]

#pdfpc.speaker-note("~80s. Key slide. Behaviour is the computation, state is what persists between rounds, communication handles the neighbour exchange, sensors and actuators are bound to the hardware. Only the left group can move, and that constraint is what makes placement an interesting problem.")

== Logical Structure and Physical Placement

#components.side-by-side(columns: (1fr, 1fr), gutter: 1em)[
  #align(center + horizon)[
    #cetz.canvas(length: 1cm, {
      import cetz.draw: *

      let dot(pos, color, dashed: false) = circle(
        pos, radius: .32,
        fill: color.lighten(85%),
        stroke: (paint: color.lighten(30%), thickness: .9pt, dash: if dashed { "dashed" } else { "solid" }),
      )

      // logical DAG
      content((0, 2.6), text(size: .55em, weight: "medium", fill: ink)[logical: component DAG], anchor: "center")
      dot((0, 1.7), blue)
      dot((-1.5, .4), green)
      dot((1.5, .4), orange, dashed: true)
      dot((-0.8, -1.0), red, dashed: true)
      dot((0.9, -1.0), green)
      for (a, b) in ((((0,1.7)), ((-1.5,.4))), (((0,1.7)), ((1.5,.4))), (((0,1.7)), ((-0.8,-1.0))), (((0,1.7)), ((0.9,-1.0))), (((-1.5,.4)), ((-0.8,-1.0))), (((1.5,.4)), ((0.9,-1.0)))) {
        line(a, b, stroke: (paint: ink.lighten(55%), thickness: .7pt))
      }
    })
  ]
][
  #align(center + horizon)[
    #cetz.canvas(length: 1cm, {
      import cetz.draw: *

      let tier(y, label, color, h: .95) = {
        rect((-2.6, y - h / 2), (2.6, y + h / 2), radius: .1,
          fill: color.lighten(92%), stroke: (paint: color.lighten(40%), thickness: .8pt))
        content((-2.0, y), text(size: .5em, weight: "medium", fill: color.darken(15%))[#label], anchor: "west")
      }

      content((0, 2.6), text(size: .55em, weight: "medium", fill: ink)[physical: continuum tiers], anchor: "center")
      tier(1.6, "cloud", blue)
      tier(0.2, "edge", green)
      tier(-1.2, "device", orange)

      circle((1.4, 1.6), radius: .26, fill: blue.lighten(70%), stroke: .8pt + blue)
      circle((0.7, 0.2), radius: .26, fill: green.lighten(70%), stroke: .8pt + green)
      circle((1.6, 0.2), radius: .26, fill: green.lighten(70%), stroke: .8pt + green)
      circle((0.9, -1.2), radius: .26, fill: red.lighten(70%), stroke: .8pt + red)
      circle((1.8, -1.2), radius: .26, fill: red.lighten(70%), stroke: .8pt + red)
    })
  ]
]

#v(.2em)
#statement[
  A deployment maps the component graph onto continuum hosts. Many mappings are valid, and the model makes the choice explicit.
]

#pdfpc.speaker-note("~60s. Left, what the program says; right, where it runs. The two are now independent. Sensors and actuators stay at the device tier.")

== Reconfiguration at Runtime

#components.side-by-side(columns: (1fr, 1fr), gutter: 1.2em)[
  === What can change

  #text(size: .9em)[
    - Which host runs behaviour or state.
    - How components are grouped into deployable units.
    - How many hosts take part.
  ]

  All of it while the system is running @pulverisation2024.
][
  === What is preserved

  #mini-card([Semantics], [The collective computes the same result under any valid partitioning.], color: green)
  #v(.35em)
  #mini-card([Consistency], [Per-round state and neighbour exchange survive a re-placement.], color: blue)
]

#v(.3em)
#statement(fill: green.lighten(90%), stroke: green)[
  Deployment can then be decided at runtime, rather than committed to at design time.
]

#pdfpc.speaker-note("~60s. Answer the obvious objection: if computation moves around, does the program still mean the same thing? Yes, and proving that is why the model is formalised.")

= From Model to Deployment

== Choosing a Deployment

#components.side-by-side(columns: (1.1fr, 1fr), gutter: 1em)[
  #step-item("A", [Self-organising rules], [Each device decides where its own components go @flexible2024 @dynamiciot2024.])
  #v(.25em)
  #step-item("B", [Constraint-based planning], [A planner searches the placement space under hardware, network and energy constraints.])
  #v(.25em)
  #step-item("C", [Learned policies], [An agent trained to pick placements from the topology.])
][
  #mini-card([Rules], [Cheap and local, but hand-written.], color: blue)
  #v(.25em)
  #mini-card([Planning], [Meets the declared constraints, needs a global view.], color: green)
  #v(.25em)
  #mini-card([Learning], [Needs training, transfers to unseen topologies.], color: orange)
]

#pdfpc.speaker-note("~80s. Three papers on one slide. The point to make out loud: deployment control is itself a collective behaviour, so the same tools apply to it. Green planning is joint work with Brogi and Forti in Pisa.")

== Learning the Placement

#align(center)[
  #cetz.canvas(length: 1.0cm, {
    import cetz.draw: *

    let w = 4.6
    let stage(x, title, subtitle, color) = {
      rect((x - w / 2, -1.05), (x + w / 2, 1.05), radius: .12,
        fill: color.lighten(90%), stroke: (paint: color.lighten(35%), thickness: .9pt))
      content((x, .42), text(size: .44em, weight: "medium", fill: color.darken(15%))[#title], anchor: "center")
      content((x, -.35), align(center)[#text(size: .34em, fill: ink.lighten(15%))[#subtitle]], anchor: "center")
    }

    let xs = (-8.1, -2.7, 2.7, 8.1)

    stage(xs.at(0), [Heterogeneous graph], [device / edge / cloud nodes \ typed links and features], red)
    stage(xs.at(1), [GNN encoder], [message passing over \ node and edge types], blue)
    stage(xs.at(2), [Deep Q-network], [Q-value per \ placement action], green)
    stage(xs.at(3), [Deployment], [chosen component \ placement], orange)

    for x in xs.slice(0, 3) {
      line((x + w / 2 + .12, 0), (x + 5.4 - w / 2 - .12, 0),
        stroke: (paint: ink.lighten(45%), thickness: 1.1pt), mark: (end: ">"))
    }

    // reward feedback loop, right back to the graph
    line((xs.at(3), -1.05), (xs.at(3), -2.15), (xs.at(0), -2.15), (xs.at(0), -1.05),
      stroke: (paint: ink.lighten(50%), thickness: .9pt, dash: "dashed"), mark: (end: ">"))
    content((0, -2.5), text(size: .34em, fill: ink.lighten(25%))[reward: latency, energy, load], anchor: "center")
  })
]

#v(.3em)
#statement[
  Device class and link quality are part of the graph itself, so the policy sees the heterogeneity of the continuum instead of a flat topology.
]

#pdfpc.speaker-note("~70s. Walk left to right, then the dashed feedback arrow. The novelty is the heterogeneous graph: earlier work flattens the topology and throws away the device diversity that makes placement hard.")

== Evaluation

#components.side-by-side(columns: (1fr, 1fr), gutter: 1em)[
  #placeholder(
    [Scalability under pulverisation],
    body: [From _Scalability through Pulverisation_ (FGCS 2024).],
    height: 52%,
  )
][
  #placeholder(
    [Learned offloading],
    body: [From _Heterogeneous GNN for collective-task offloading_ (FGCS 2026), against heuristic and flat-GNN baselines.],
    height: 52%,
  )
]

#v(.3em)
#statement(fill: red.lighten(92%), stroke: red)[
  #text(size: .82em)[*To fill before the review:* both plots have to be exported from the papers, no result figures are in the thesis repository.]
]

#pdfpc.speaker-note("~50s. Fill this slide. Once the figures are in, quote the headline numbers from each paper.")

== Languages for Placement and Coordination

#components.side-by-side(columns: (1.05fr, 1fr), gutter: 1em)[
  #step-item("A", [CaMiL / LociX], [One type-safe language covering choreographic, multitier and aggregate computing, with placement and communication as capabilities.])
  #v(.3em)
  #step-item("B", [ScalaTropy], [Multiparty coordination with monadic communication primitives: isotropic, anisotropic, co-anisotropic.])
  #v(.3em)
  #step-item("C", [LLM macroprogramming], [Natural-language intent compiled into collective programs.])
][
```scala
type Pinger <: { type Tie <: Single[Ponger] }
type Ponger <: { type Tie <: Single[Pinger] }

def pingPong(using
    Network, Choreography, PlacedValue) =
  val ping = on[Pinger]("ping")
  val received = comm[Pinger, Ponger](ping)
  val pong = on[Ponger]:
    println(received.take)
    "pong"
  comm[Ponger, Pinger](pong)
```
  #align(center)[#chip[TOPLAS · under review] #h(.2em) #chip[COORDINATION 2026]]
]

#pdfpc.speaker-note("~65s. A whole thesis part on one slide, and say so. Framing: pulverisation says where code can run, these languages say how to write it so the compiler checks the placement. Mention TOPLAS is still under review.")

== Demonstrator: Self-organising Robot Teams

#components.side-by-side(columns: (1fr, 1fr), gutter: 1.2em)[
  === From the model to hardware

  #text(size: .92em)[
    - A robot team running a pulverised collective program.
    - Components placed across on-board and off-board hosts.
    - The full path from specification to a moving swarm.
  ]
][
  #note-block("Back to the opening gap")[
    #text(size: .82em)[The step from simulated collective logic to a physical, heterogeneous deployment is the one the talk started with, and here it is done end to end.]
  ]
  #v(.4em)
  #align(center)[#chip[COORDINATION 2025]]
]

#pdfpc.speaker-note("~50s. Callback to the gap slide. End of Act II, should be at 15:00.")

// =============================================================================
// ACT III -- WRAP-UP (5 minutes)
// =============================================================================

= Status and Outlook

#pdfpc.speaker-note("Act III, 5 minutes. This is a progress review: be concrete about what is done and what is left.")

#let status-chip(kind) = if kind == "published" {
  chip([published], fill: green.lighten(88%), stroke: green.lighten(35%))
} else {
  chip([under review], fill: blue.lighten(88%), stroke: blue.lighten(38%))
}

#let pub-row(work, venue, year, status, chapter) = (
  comparison-label(inset: (x: .55em, y: .22em))[#text(size: .62em)[#work]],
  comparison-cell(inset: (x: .4em, y: .22em))[#text(size: .62em)[#venue]],
  comparison-cell(inset: (x: .4em, y: .22em))[#text(size: .62em)[#year]],
  comparison-cell(inset: (x: .4em, y: .22em))[#status-chip(status)],
  comparison-cell(inset: (x: .4em, y: .22em))[#text(size: .62em)[#chapter]],
)

== Publications

#timing-chip[15:00 → 20:00 · wrap-up]

#block(width: 100%, inset: .2em, radius: 6pt, fill: luma(250), stroke: (paint: ink.lighten(72%), thickness: .7pt))[
  #table(
    columns: (2.4fr, 1.3fr, .5fr, 1fr, .55fr),
    gutter: .04em,
    stroke: none,
    comparison-header(inset: (x: .45em, y: .28em))[Work],
    comparison-header(inset: (x: .45em, y: .28em))[Venue],
    comparison-header(inset: (x: .45em, y: .28em))[Year],
    comparison-header(inset: (x: .45em, y: .28em))[Status],
    comparison-header(inset: (x: .45em, y: .28em))[Ch.],

    ..pub-row([Scalability through Pulverisation], [FGCS], [2024], "published", [5]),
    ..pub-row([LLM macroprogramming for IoT], [ACM TOSEM], [2025], "published", [6]),
    ..pub-row([Capabilities to Catch 'em All], [TOPLAS], [2026], "review", [6]),
    ..pub-row([ScalaTropy], [COORDINATION], [2026], "published", [6]),
    ..pub-row([Flexible Self-organisation], [ACSOS], [2024], "published", [7]),
    ..pub-row([Dynamic IoT reconfiguration], [Internet of Things], [2024], "published", [7]),
    ..pub-row([Green deployment planning], [COORDINATION], [2025], "published", [7]),
    ..pub-row([Heterogeneous GNN offloading], [FGCS], [2026], "published", [8]),
    ..pub-row([Demonstrator for robot teams], [COORDINATION], [2025], "published", [9]),
  )
]

#pdfpc.speaker-note("~55s. Do not read the table. Nine works, eight published or accepted, one under review at TOPLAS, and every thesis chapter has a paper behind it.")

== Thesis Status and Timeline

#components.side-by-side(columns: (1fr, 1fr), gutter: 1.2em)[
  #text(size: .78em)[
    *Drafted*
    - Part I, background: structure fixed, related work collected (Ch. 2–4).
    - Part II, model: pulverisation chapter from FGCS 2024 (Ch. 5).
    - Part III: deployment chapters follow the published papers (Ch. 7–8).
  ]
][
  #text(size: .78em)[
    *Left to do*
    - Ch. 6, once TOPLAS replies: consolidate the three language papers.
    - Ch. 9, the demonstrator, plus introduction and conclusions.
    - Unify the notation across chapters taken from different papers.
  ]
]

#v(.3em)

#align(center)[
  #cetz.canvas(length: 0.95cm, {
    import cetz.draw: *

    line((-7.6, 0), (7.9, 0), stroke: (paint: ink.lighten(40%), thickness: 1.2pt), mark: (end: ">"))

    let milestone(x, label, detail, color, up: true) = {
      let y = if up { 1.6 } else { -1.6 }
      circle((x, 0), radius: .14, fill: color, stroke: none)
      line((x, 0), (x, if up { y - .58 } else { y + .58 }),
        stroke: (paint: color.lighten(30%), thickness: .9pt))
      rect((x - 1.5, y - .58), (x + 1.5, y + .58), radius: .1,
        fill: color.lighten(91%), stroke: (paint: color.lighten(40%), thickness: .8pt))
      content((x, y), box(width: 2.6cm)[
        #align(center)[
          #text(size: .38em, weight: "medium", fill: color.darken(15%))[#label]
          #linebreak()
          #text(size: .29em, fill: ink.lighten(18%))[#detail]
        ]
      ], anchor: "center")
    }

    milestone(-6.4, [Now], [chapters from papers], ink, up: true)
    milestone(-3.2, [TOPLAS], [decision pending], blue, up: false)
    milestone(0.0, [Writing], [Ch. 6, 9, intro], green, up: true)
    milestone(3.2, [Submission], [to the reviewers], orange, up: false)
    milestone(6.4, [Esame finale], [2026], red, up: true)
  })
]

#pdfpc.speaker-note("~90s. Progress review: the committee wants to know what is left, and it will ask for dates. Check the drafting state and put real months on the timeline before presenting.")

== Future Directions

#components.side-by-side(columns: (1fr, 1fr), gutter: 1.2em)[
  #feature-block("Edge-cloud deployments")[
    #text(size: .84em)[_The dashed block on the contribution map: learned, self-organising deployment over the full continuum, at scale._]
  ]
][
  #text(size: .95em)[
    - *Learned and declarative together*: planner constraints as safety bounds on the learned policy.
    - *Cross-fleet deployment*: heterogeneous robot fleets under one middleware.
    - *Deployment as a language construct*, checked by the compiler.
  ]
]

#v(.3em)
#statement(fill: orange.lighten(90%))[
  The direction is systems that keep adapting their execution footprint to the context and the resources they find.
]

#pdfpc.speaker-note("~50s. Close on the last sentence, it is the one-line summary of the PhD.")

#focus-slide[
  Thank you
  #v(.5em)
  #text(size: .55em, weight: "light")[Questions?]
]

// =============================================================================
// BACKUP
// =============================================================================

= Backup <touying:hidden>

== Pulverisation: Component Interactions <touying:hidden>

#placeholder(
  [Round structure],
  body: [Backup: the per-round interaction between behaviour, state and communication components.],
)

== Other Work During the PhD <touying:hidden>

- *Intelligent Pulverised Collective-Adaptive Systems*, ACSOS 2024 Doctoral Symposium.
- *Decentralized proximity-aware clustering for collective self-federated learning*, Internet of Things, 2026.
- *HarmoniKt*: unifying middleware for heterogeneous robot fleets.
