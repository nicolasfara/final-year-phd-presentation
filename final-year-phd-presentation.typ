#import "@preview/touying:0.6.3": *
#import themes.metropolis: *
#import "@preview/fontawesome:0.6.0": *
#import "@preview/codly:1.3.0": codly-init
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

// Section dividers double as a "you are here" map: each act shows the thesis
// infographic with its own block at full opacity and the others dimmed. The
// variant is picked from the heading label, so `= Title <languages>` draws
// `images/phd_thesis_infographic_languages.svg`; a section whose label is not
// listed here falls back to the plain, centred divider.
#let section-infographics = (
  "model": "images/phd_thesis_infographic_model.svg",
  "deployment": "images/phd_thesis_infographic_deployment.svg",
  "languages": "images/phd_thesis_infographic_languages.svg",
  "demo": "images/phd_thesis_infographic_demo.svg",
  "future-work": "images/phd_thesis_infographic_future_work.svg",
)

#let infographic-section-slide(config: (:), level: 1, numbered: true, body) = touying-slide-wrapper(self => {
  let headings = self.at("headings", default: ())
  let label = if headings != () and headings.at(-1).has("label") {
    str(headings.at(-1).label)
  } else {
    ""
  }
  let figure-path = section-infographics.at(label, default: none)

  let title = text(
    size: 1.5em,
    fill: self.colors.neutral-darkest,
    utils.display-current-heading(level: level, numbered: numbered, style: auto),
  )
  let rule = block(
    height: 2pt,
    width: 100%,
    spacing: 0pt,
    components.progress-bar(height: 2pt, self.colors.primary, self.colors.primary-light),
  )

  self = utils.merge-dicts(self, config-page(fill: self.colors.neutral-lightest))
  touying-slide(self: self, config: config, {
    set std.align(horizon)
    if figure-path == none {
      // The stock metropolis divider, for sections without a map block.
      show: pad.with(20%)
      stack(dir: ttb, spacing: 1em, title, rule)
      text(self.colors.neutral-dark, body)
    } else {
      show: pad.with(x: 5%, y: 3%)
      grid(
        columns: (.9fr, 1.45fr),
        column-gutter: 1.4em,
        align: horizon,
        stack(dir: ttb, spacing: .9em, title, rule, text(self.colors.neutral-dark, body)),
        align(center + horizon, image(figure-path, width: 100%)),
      )
    }
  })
})

#show: metropolis-theme.with(
  aspect-ratio: "16-9",
  footer: self => self.info.institution,
  config-common(
    preamble: {
      // Replayed on every slide; see `codly-setup` in utils.typ.
      codly-setup()
      pdfpc-config
    },
    show-bibliography-as-footnote: bibliography(title: none, "bibliography.bib"),
    new-section-slide-fn: infographic-section-slide,
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

#set list(marker: text(size: 1.4em, baseline: 0.1em)[•])

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
    _Devices, edge, fog and cloud treated as one pool of computational resources, with no fixed boundary between tiers._ #cite(<moreschini2022continuum>)
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
  #feature-block("Collective-adaptive Systems")[
    _Distributed networks of independent, heterogeneous entities that interact and self-organize without central control to achieve individual or group goals._ #cite(<ferscha2015collective>)
  ]

  #text(size: .88em)[
    - Decentralization: no single coordinator
    - Emergence: global behaviour arises from local interactions
    - Scalability: can grow to thousands of nodes
  ]
][
  #figure(image("images/cas.jpg", width: 100%))
]
// #v(1em)
#components.side-by-side[
  #mini-card([IoT systems], [], color: blue)
][
  #mini-card([Swarm robotics], [], color: green)
][
  #mini-card([Smart cities], [], color: red)
][
  #mini-card([Autonomous vehicles], [], color: orange)
]

#pdfpc.speaker-note("~45s. Bridge slide: these systems are the workload, the continuum is the substrate. The talk is about the mismatch between the two.")

== Macroprogramming

#components.side-by-side[
  #feature-block("Macroprogramming")[
    _The theory and practice of conveniently expressing the macroscopic behaviour of a system as a single program, instead of writing a program per node and relying on the global behaviour to emerge._ #cite(<casadei2023macroprogramming>)
  ]

  #text(size: .88em)[
    - The system is *programmed as a whole*
    - The program is *compiled down to micro-programs* for each node
    - The global behaviour *emerges* from the local effects of the micro-programs
  ]
][
  #align(center)[
  // Macroprogramming at a glance: a macro-program written against
  // macro-abstractions is mapped onto the micro-programs run by the single
  // entities, whose effects in the environment emerge as macro-observables.
  #cetz.canvas(length: 0.95cm, {
    import cetz.draw: *

    let prog-fill = ink.lighten(96%)
    let blk-fill = ink.lighten(85%)
    let ent-fill = ink.lighten(70%)
    let edge = ink.lighten(48%)
    let flow = ink.lighten(35%)

    let lbl(pos, body, anchor: "center", size: .33em, fill: ink.lighten(12%)) = content(
      pos,
      text(size: size, fill: fill)[#body],
      anchor: anchor,
    )

    // A straight arrow whose head stops `gap` before the target, so it never
    // slides underneath the shape it points at.
    let arrow(from, to, gap: 0, ..style) = {
      let dx = to.at(0) - from.at(0)
      let dy = to.at(1) - from.at(1)
      let len = calc.max(calc.sqrt(dx * dx + dy * dy), 1e-6)
      line(from, (to.at(0) - dx / len * gap, to.at(1) - dy / len * gap), ..style)
    }

    let prog(pos, body) = {
      let (x, y) = pos
      rect(
        (x - 1.25, y - 0.8),
        (x + 1.25, y + 0.8),
        radius: .14,
        fill: prog-fill,
        stroke: (paint: edge, thickness: .9pt),
      )
      content(pos, text(size: .42em, weight: "medium", fill: ink)[#body], anchor: "center")
    }

    // ---- macro level ----
    prog((2.15, 5.45), [Macro\ program])

    // macro-abstractions: three overlapping blocks feeding the macro program
    for (a, b) in (
      ((5.27, 5.60), (6.24, 6.03)),
      ((5.66, 5.22), (6.51, 5.66)),
      ((6.29, 5.60), (7.12, 6.04)),
    ) {
      rect(a, b, fill: blk-fill, stroke: (paint: edge, thickness: .8pt))
    }
    lbl((6.20, 6.45), [Macro-abstractions])
    arrow((5.22, 5.70), (3.40, 5.45), stroke: (paint: flow, thickness: .9pt), mark: (end: ">", scale: .6))

    // macro-observables: stacked wavy sheets
    for base in (7.30, 6.96, 6.62) {
      let samples = 26
      let top = range(0, samples + 1).map(i => {
        let x = 1.45 * i / samples
        (8.15 + x, base + 0.09 * calc.sin(250deg * x))
      })
      let bottom = range(0, samples + 1)
        .rev()
        .map(i => {
          let x = 1.45 * i / samples
          (8.15 + x, base - 0.24 + 0.09 * calc.sin(250deg * x))
        })
      line(..top, ..bottom, close: true, fill: ink.lighten(93%), stroke: (paint: edge, thickness: .8pt))
    }
    lbl((8.85, 7.85), [Macro-observables])

    // goals: from the macro program to what the system should be observed to do
    bezier(
      (3.40, 6.25),
      (8.05, 7.05),
      (4.40, 7.50),
      (6.66, 7.17),
      stroke: (paint: flow, thickness: .9pt),
      mark: (end: ">", scale: .6),
    )
    lbl((5.60, 7.58), [Goals])

    // ---- level separator ----
    line((-0.15, 3.75), (13.45, 3.75), stroke: (paint: ink.lighten(58%), thickness: 1pt, dash: "dotted"))
    lbl((12.10, 5.65), [Macro-level], size: .38em, fill: ink)
    lbl((12.10, 1.75), [Micro-level], size: .38em, fill: ink)

    // ---- the two vertical block arrows across the levels ----
    // abstractions: bottom-up, still to be built
    line(
      (6.01, 3.10), (6.19, 3.10), (6.19, 4.72), (6.36, 4.72), (6.10, 5.08), (5.84, 4.72), (6.01, 4.72),
      close: true,
      fill: ink.lighten(94%),
      stroke: (paint: ink.lighten(40%), thickness: .9pt, dash: "dashed"),
    )
    lbl((5.75, 4.05), [Abstractions], anchor: "east")

    // effects and emergence: bottom-up, observed
    line(
      (8.66, 3.10), (8.84, 3.10), (8.84, 5.80), (9.03, 5.80), (8.75, 6.18), (8.47, 5.80), (8.66, 5.80),
      close: true,
      fill: ink.lighten(94%),
      stroke: (paint: ink.lighten(40%), thickness: .9pt),
    )
    lbl((9.30, 4.05), [Effects/emergence], anchor: "west")

    // ---- micro level ----
    prog((2.15, 1.70), [Micro\ program(s)])
    arrow((2.15, 4.65), (2.15, 2.50), stroke: (paint: flow, thickness: .9pt), mark: (end: ">", scale: .6))
    lbl((2.35, 3.25), [macro-to-micro], anchor: "west")

    // environment
    line(
      (5.05, 2.95), (9.40, 2.95), (8.95, 0.40), (4.60, 0.40),
      close: true,
      fill: prog-fill,
      stroke: (paint: edge, thickness: .9pt),
    )
    lbl((7.00, 0.10), [Environment])

    let ent(kind, pos) = {
      let (x, y) = pos
      let style = (fill: ent-fill, stroke: (paint: ink.lighten(30%), thickness: .8pt))
      if kind == "circle" {
        circle(pos, radius: .22, ..style)
      } else if kind == "triangle" {
        line((x, y + .27), (x - .234, y - .135), (x + .234, y - .135), close: true, ..style)
      } else {
        line((x, y + .27), (x + .27, y), (x, y - .27), (x - .27, y), close: true, ..style)
      }
    }

    let entities = (
      ("triangle", (8.17, 2.60), 2.30),
      ("circle", (5.63, 1.90), 2.00),
      ("diamond", (6.69, 1.64), 1.75),
      ("triangle", (7.57, 1.27), 1.50),
      ("diamond", (8.50, 0.90), 1.25),
      ("circle", (5.27, 0.86), 1.00),
    )

    for (kind, pos, y) in entities {
      arrow(
        (3.42, y),
        pos,
        gap: .32,
        stroke: (paint: ink.lighten(45%), thickness: .7pt, dash: "dotted"),
        mark: (end: ">", scale: .5),
      )
    }
    for (kind, pos, _) in entities {
      ent(kind, pos)
    }
  })
]
]

== Macroprogramming Paradigms

#text(size: .88em)[Different paradigms make the same macro-level promise, but write and deploy it differently:]

#v(.4em)

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
    comparison-cell[#text(size: .72em)[Comm. primitives]],
    comparison-cell[#text(size: .72em)[Placed value]],
    comparison-label[Communication],
    comparison-cell[#text(size: .72em)[Implicit, neighbourhood]],
    comparison-cell[#text(size: .72em)[Explicit, first-class]],
    comparison-cell[#text(size: .72em)[Implicit, cross-tier]],
    comparison-label[Participants],
    comparison-cell[#text(size: .72em)[Open, unbounded]],
    comparison-cell[#text(size: .72em)[Fixed/open, known]],
    comparison-cell[#text(size: .72em)[Fixed tiers]],
    comparison-label[Deployment],
    comparison-cell(fill: red.lighten(93%))[#text(size: .72em)[Uniform, implicit]],
    comparison-cell(fill: red.lighten(93%))[#text(size: .72em)[Endpoint projection]],
    comparison-cell(fill: red.lighten(93%))[#text(size: .72em)[Fixed at compile time]],
  )
]

#v(.25em)
#text(size: .82em)[The three paradigms #bold[differ in how behaviour is written], but all of them settle deployment before the system starts.]

#pdfpc.speaker-note("~70s. The row that matters is the last one: all three say what the collective computes, none of them says where it runs.")

== What Is Missing

#components.side-by-side(columns: (1fr, 1fr, 1fr), gutter: .8em)[
  #mini-card([The unit is indivisible], [One logical device maps to one host: sensing, state, computation and actuation move together, or not at all.], color: red)
][
  #mini-card([The mapping is fixed too early], [Uniform assumption, endpoint projection, tier annotation --- all resolve the logical-to-physical map before the system runs.], color: red)
][
  #mini-card([Change has no semantics], [Containers can be moved, but no model says what a redeployment preserves: correctness is re-established case by case.], color: red)
]

#v(.4em)
#text(size: .76em, fill: ink.lighten(15%))[So behaviour validated in simulation is re-implemented by hand on real hardware: the effort goes into the deployment, not the collective logic.]

#v(.4em)
#statement(fill: orange.lighten(90%))[
  How can collective behaviour be written once, then #bold[split], #bold[placed] and #bold[relocated at run time], with a stated guarantee of what each change preserves?
]

#pdfpc.speaker-note("~60s. Three gaps, not one: granularity (the device cannot be split), binding time (the map is fixed before run time), and semantics (nothing says what a redeployment preserves). Then read the question slowly: everything after this answers it.")

== Contributions

#components.side-by-side(columns: (1.25fr, 1fr), gutter: 1em)[
  #align(center + horizon)[
    #image("images/phd_thesis_infographic.svg", width: 100%)
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

= The Pulverization Model <model>

#pdfpc.speaker-note("Act II, 10 minutes, the core of the talk. Should end at 15:00.")

== The Monolithic Device

#components.side-by-side(columns: (.72fr, 1.05fr, 1.05fr), gutter: .9em)[
  #align(center + horizon)[
    #image("images/ac-monolithic-motivation.svg", width: 100%)
  ]
][
  === The problem

  #text(size: .88em)[
    A logical device bundles behaviour, state, neighbourhood links and physical interfaces into one unit.

    - It has to be deployed as a whole.
    - A constrained device cannot host it, so it stays out of the collective.
    - The tiers above the edge stay unused.
  ]
][
  #feature-block("Pulverisation")[
    _Split each logical device into computationally independent components that can be deployed, and moved, separately._
  ]

  #text(size: .88em)[The collective program stays the same; what changes is how it is partitioned and where the parts run.]
]

#pdfpc.speaker-note("~55s. The figure is the continuum from Act I with everything above the edge greyed out: that is what a monolithic deployment buys you. In one sentence: keep the logical structure, dissolve the physical one.")

// == Five Components

// #align(center)[
//   #cetz.canvas(length: 1.0cm, {
//     import cetz.draw: *

//     // --- the logical device, before pulverisation ------------------------
//     rect((-7.3, -2.5), (-2.3, 2.5), radius: .28,
//       fill: orange.lighten(96%),
//       stroke: (paint: orange, thickness: 1.8pt))
//     content((-4.8, 2.86), text(size: .44em, weight: "medium", fill: ink)[logical device], anchor: "center")

//     // links first, so the opaque nodes drawn later cover their endpoints
//     for target in ((-6.1, 1.3), (-3.5, 1.3), (-6.1, -1.3), (-3.5, -1.3)) {
//       line((-4.8, 0), target, stroke: (paint: ink.lighten(25%), thickness: 1.1pt))
//     }

//     pulv-node(cetz.draw, (-6.1, 1.3), $kappa$, "state", green)
//     pulv-node(cetz.draw, (-3.5, 1.3), $chi$, "communication", orange)
//     pulv-node(cetz.draw, (-4.8, 0), $beta$, "behaviour", blue)
//     pulv-node(cetz.draw, (-6.1, -1.3), $sigma$, "sensors", red)
//     pulv-node(cetz.draw, (-3.5, -1.3), $alpha$, "actuators", red)

//     // --- the split --------------------------------------------------------
//     line((-2.0, 0), (-0.7, 0), stroke: (paint: orange, thickness: 1.6pt), mark: (end: ">", scale: .8))
//     content((-1.35, .45), text(size: .4em, weight: "medium", fill: orange.darken(10%))[pulverise], anchor: "center")

//     // --- what may move, and what may not ----------------------------------
//     pulv-group(cetz.draw, (-0.3, 0.3), (5.7, 2.5), [relocatable — any host in the continuum], ink)
//     pulv-node(cetz.draw, (1.1, 1.5), $beta$, "behaviour", blue)
//     pulv-node(cetz.draw, (2.7, 1.5), $kappa$, "state", green)
//     pulv-node(cetz.draw, (4.3, 1.5), $chi$, "communication", orange)

//     pulv-group(cetz.draw, (-0.3, -2.5), (5.7, -0.3), [pinned to the physical device], red, label-above: false)
//     pulv-node(cetz.draw, (1.9, -1.3), $sigma$, "sensors", red)
//     pulv-node(cetz.draw, (3.5, -1.3), $alpha$, "actuators", red)
//   })
// ]

// #v(.3em)
// #statement[
//   Behaviour, state and communication can run on any host. Sensors and actuators stay on the physical device.
// ]

// #pdfpc.speaker-note("~80s. Key slide. Left, the logical device: behaviour is the computation, state is what persists between rounds, communication handles the neighbour exchange, sensors and actuators are bound to the hardware. Right, the same five components regrouped: only the top group can move, and that constraint is what makes placement an interesting problem.")

== Logical Structure and Physical Placement

#components.side-by-side(columns: (.8fr, 1.35fr), gutter: 1.2em)[
  #align(center + horizon)[
    #image("images/partitioned-macro-program.svg", width: 90%)
    #v(-.1em)
    #text(size: .62em, fill: ink.lighten(25%))[logical: component graph]
  ]
][
  #align(center + horizon)[
    #image("images/system-model.svg", width: 88%)
    #v(-.1em)
    #text(size: .62em, fill: ink.lighten(25%))[physical: hosts across the continuum]
  ]
]

#v(.2em)
#statement[
  A deployment maps the component graph onto continuum hosts. Many mappings are valid, and the model makes the choice explicit.
]

#pdfpc.speaker-note("~60s. Left, what the program says; right, where it runs. The two are now independent. Sensors and actuators stay at the device tier.")

== Reconfiguration at Runtime

#components.side-by-side(columns: (1.1fr, .95fr, .95fr), gutter: 1em)[
  #align(center + horizon)[
    #image("images/offloading-surrogate.svg", width: 90%)
  ]
][
  === What can change

  #text(size: .85em)[
    - Which host runs behaviour or state.
    - How components are grouped into deployable units.
    - How many hosts take part.
  ]

  #text(size: .85em)[All of it while the system is running @pulverisation2024.]
][
  === What is preserved

  #mini-card([Semantics], [The collective computes the same result under any valid partitioning.], color: green)
  #v(.25em)
  #mini-card([Consistency], [Per-round state and neighbour exchange survive a re-placement.], color: blue)
]

#v(.15em)
#statement(fill: green.lighten(90%), stroke: green)[
  Deployment can then be decided at runtime, rather than committed to at design time.
]

#pdfpc.speaker-note("~60s. The figure: one component of the device is executed by a surrogate host, and the device keeps a forward reference to it. Answer the obvious objection: if computation moves around, does the program still mean the same thing? Yes, and proving that is why the model is formalised.")

= Language Support for Collective Systems <languages>

== Common Ground: Peers, Ties, Placed Values

#components.side-by-side(columns: (1.2fr, 1fr), gutter: .8em)[
#codly(highlights: (
  (line: 1, start: 29, end: 40, fill: blue),
  (line: 2, start: 29, end: 43, fill: blue),
  (line: 4, start: 11, end: 25, fill: orange),
  (line: 4, start: 29, end: 37, fill: orange),
  (line: 7, start: 25, end: 36, fill: red),
))
```scala
type Phone <: { type Tie <: Single[Edge] }
type Edge  <: { type Tie <: Multiple[Phone] }

val temp: Double on Phone = on[Phone](sense())

on[Phone] { val here: Double = take(temp) }
on[Edge]  { val there = take(temp) }
```

  #v(-.2em)
  #block(width: 100%, inset: (x: .7em, y: .42em), radius: 5pt,
    fill: red.lighten(93%), stroke: (paint: red.lighten(45%), thickness: .8pt))[
    #text(size: .6em, fill: ink)[The edge holds a typed reference, not the reading: `take` outside the owning peer does not compile.]
  ]
][
  #step-item("1", [Peers and ties], [The architecture is a type: which families exist, and who may talk to whom.])
  #v(.15em)
  #step-item("2", [Placed values], [`V on P` says where a value lives; only `P` can open it.])
  #v(.15em)
  #step-item("3", [Explicit movement], [A value reaches another peer only through a communication primitive.])
]

#v(.05em)
#statement[
  #text(size: .7em)[Both works in this part start from this substrate, inherited from multitier programming, and ask a different question of it: CaMiL, #bold[which paradigm's operations] may be used here; ScalaTropy, #bold[which shape] the exchange has.]
]

#pdfpc.speaker-note("~55s. Set the shared vocabulary once, so the next two slides do not each re-explain it. Peers and ties describe the architecture at the type level; a placed value V on P is owned by one peer family and everyone else holds only a typed reference; moving a value is always an explicit primitive. The last line is the roadmap for the section: two papers, one substrate, two different questions asked of it.")

== CaMiL: Paradigms as Capabilities

#components.side-by-side(columns: (1.25fr, 1fr), gutter: .8em)[
  #code(highlights: (
    (line: 2, start: 5, end: 38, fill: orange),
    (line: 3, start: 5, end: 14, fill: blue),
    (line: 5, start: 14, end: 27, fill: green),
  ))[
```scala
def recomm(token: Token on Phone)(using
    Placement, Choreography, Multitier
) = Multitier:
  val reqs = on[Edge] { asLocalAll(token) }
  val auth = Choreography:
    val ask = comm[Edge, Cloud](reqs)
    val ok  = on[Cloud] { grant(ask) }
    comm[Cloud, Edge](ok)
  val recs = on[Edge] { suggest(take(auth)) }
  on[Phone] { asLocal(recs).subscribe(show) }
```
]
][
  #mini-card([`Multitier`], [Placement across tiers; `asLocal` reads a remote placed value.], color: blue)
  #v(.15em)
  #mini-card([`Choreography`], [A global protocol; `comm` moves a placed value between peers.], color: green)
  #v(.15em)
  #mini-card([`Collective`], [Aggregate rounds over an ensemble, emitting streams of placed values.], color: orange)
]

#v(.05em)
#statement[
  #text(size: .7em)[A paradigm's operations are available only where its capability is in scope, and a boundary is crossed through the #bold[same placed values] as before. The three paradigms compose without giving up their own guarantees.]
]

#pdfpc.speaker-note("~70s. Joint work with St. Gallen, Weisenburger and Salvaneschi. The observation: multitier, choreographic and aggregate programming all take a global view of a distributed system, but they are used in isolation and their guarantees do not compose. CaMiL models each as a capability — a value carrying the authority to use that paradigm's operations, passed through Scala's using clauses — over one shared substrate of placement types. Read the snippet: a multitier block opens a choreography, the choreography returns a value placed on Edge, and multitier code consumes it. Two explicit paradigm crossings, both through placed values.")

== CaMiL: What the Types Rule Out

#components.side-by-side(columns: (1.2fr, 1fr), gutter: .8em)[
  #code(size: .72em, highlights: ((line: 6, start: 3, end: 28, fill: red),))[
```scala
Choreography:
  val msg: String on Phone = on[Phone](greet())
  val f: (() => String) on Phone =
    on[Phone](() => take(msg))
  val atCloud = comm[Phone, Cloud](f)
  on[Cloud](take(atCloud)())
```
]

  #v(-.2em)
  #block(width: 100%, inset: (x: .7em, y: .42em), radius: 5pt,
    fill: red.lighten(93%), stroke: (paint: red.lighten(45%), thickness: .8pt))[
    #text(size: .58em, fill: ink)[The function travelled, the value it captured did not: a runtime failure elsewhere, a compile-time error here.]
  ]
][
  #step-item("1", [Safe boundaries], [Paradigm scopes do not interleave: crossing happens only through a placed value.])
  #v(.12em)
  #step-item("2", [No capability leaks], [A placed function cannot be invoked where its captured state does not live.])
  #v(.12em)
  #step-item("3", [No nested-placement deadlocks], [An `on[Q]` nested in `on[P]` can never block peers waiting on it.])
]

#v(.05em)
#statement(fill: green.lighten(88%), stroke: green)[
  #text(size: .68em)[A typed calculus with a #bold[soundness proof], 46 use cases from the literature re-implemented, and prototypes in Koka and Rust.]
]

#v(.1em)
#align(center)[#chip[TOPLAS · under review] #h(.2em) #chip[_Capabilities to Catch 'em All_]]

#pdfpc.speaker-note("~60s. Three static guarantees, all from the capability discipline plus placement types. The snippet is the leak: a closure placed on the phone captures a phone-local value, is sent to the cloud, and is called there — it would fail at runtime, and CaMiL rejects it when compiling. Then the evidence line: the core is formalised and proved sound, 46 use cases from the multitier, choreographic and aggregate literature were re-implemented, and the design was ported to Koka and Rust to show it does not depend on Scala.")

== ScalaTropy: Communication Shapes as Types

// The four communication shapes drawn as one-line glyphs: a sender on the
// left, receivers on the right, one arrow per message. Distinct arrow colours
// mean distinct payloads, which is the whole difference between isotropic and
// anisotropic communication.
#let shape-glyph(kind) = cetz.canvas(length: .58cm, {
  import cetz.draw: *

  let node(pos, color) = circle(pos, radius: .18, fill: color.lighten(88%), stroke: (paint: color, thickness: 1pt))
  let msg(from, to, color) = line(
    (from.at(0) + .22, from.at(1)),
    (to.at(0) - .24, to.at(1)),
    stroke: (paint: color, thickness: .9pt),
    mark: (end: ">", scale: .38),
  )

  let ys = (.56, 0, -.56)
  let payloads = (blue, green, red)

  // A transparent frame, so all four glyphs share one bounding box and the
  // chips underneath them sit on the same line.
  rect((-.25, -.8), (1.95, .8), stroke: none)

  if kind == "point-to-point" {
    msg((0, 0), (1.7, 0), orange)
    node((0, 0), green)
    node((1.7, 0), red)
  } else if kind == "co-anisotropic" {
    for (y, c) in ys.zip(payloads) { msg((0, y), (1.7, 0), c) }
    for y in ys { node((0, y), red) }
    node((1.7, 0), green)
  } else {
    let colors = if kind == "isotropic" { (orange, orange, orange) } else { payloads }
    for (y, c) in ys.zip(colors) { msg((0, 0), (1.7, y), c) }
    node((0, 0), green)
    for y in ys { node((1.7, y), red) }
  }
})

#let shape-cell(kind, caption) = align(center + horizon)[
  #shape-glyph(kind)
  #v(-.45em)
  #chip(kind)
  #v(-.28em)
  #text(size: .5em, fill: ink.lighten(28%))[#caption]
]

#v(-.3em)

#components.side-by-side(columns: (.86fr, 1.32fr), gutter: .8em)[
  #let idea-row(label, color, body, fill: luma(252)) = (
    table.cell(fill: color.lighten(88%), inset: (x: .5em, y: .4em), align: center + horizon)[
      #text(size: .62em, fill: color.darken(12%), weight: "medium")[#label]
    ],
    table.cell(fill: fill, inset: (x: .55em, y: .4em), align: left + horizon)[
      #text(size: .62em, fill: ink)[#body]
    ],
  )

  #block(width: 100%, inset: .2em, radius: 6pt, fill: luma(250), stroke: (paint: ink.lighten(72%), thickness: .7pt))[
    #table(
      columns: (1fr, 2.75fr),
      gutter: .08em,
      stroke: none,
      ..idea-row([Topology], ink, [_as before_: which #bold[peer families] exist, and which #bold[ties] are admissible]),
      ..idea-row([Placement], ink, [_as before_: where each #bold[value lives], written `V on P`], fill: soft),
      ..idea-row([Shape], green, [#bold[new]: which flow is intended --- one-to-one, broadcast, scatter or gather]),
    )
  ]
][
  #code(size: .78em, highlights: (
    (line: 1, start: 6, end: 11, fill: blue),
    (line: 1, start: 30, end: 45, fill: blue),
    (line: 2, start: 6, end: 11, fill: blue),
    (line: 2, start: 30, end: 43, fill: blue),
    (line: 5, start: 10, end: 23, fill: orange),
    (line: 5, start: 28, end: 37, fill: orange),
    (line: 7, start: 11, end: 25, fill: green),
    (line: 8, start: 11, end: 20, fill: orange),
    (line: 9, start: 10, end: 26, fill: green),
  ))[
```scala
type Master <: { type Tie <: Multiple[Worker] }
type Worker <: { type Tie <: Single[Master] }

for
  tasks: Task on Master <- on[Master]:
    buildTasks()
  work <- anisotropicComm[Master, Worker](tasks)
  part <- on[Worker] { take(work).map(_.compute) }
  all <- coAnisotropicComm[Worker, Master](part)
yield all
```
]
]

#v(.1em)

#components.side-by-side(columns: (1fr, 1fr, 1fr, 1fr), gutter: .5em)[
  #shape-cell("point-to-point", [one sender, one receiver])
][
  #shape-cell("isotropic", [same payload to many])
][
  #shape-cell("anisotropic", [tailored payloads to many])
][
  #shape-cell("co-anisotropic", [many payloads to one])
]

#v(.1em)
#statement(fill: green.lighten(88%), stroke: green)[
  #text(size: .76em)[If it compiles, the exchange respects the declared architecture, and no peer receives a payload meant for someone else.]
]

#pdfpc.speaker-note("~70s. ScalaTropy in one slide. The first two rows are the substrate from three slides ago, so move over them fast; the third row is the contribution. The types on the right carry all three at once: the topology (ties), where values live (V on P), and the shape of each exchange. The four glyphs are the vocabulary: point-to-point, isotropic, anisotropic, co-anisotropic — the tropy in the name. Selectivity is not only an optimisation: sending each worker exactly its block is checked by the compiler, so confidentiality is structural. All of it is plain Scala types, no macros, erased at runtime.")

= Deployments <deployment>

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

= Real-World Demonstrator <demo>

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

// // =============================================================================
// // ACT III -- WRAP-UP (5 minutes)
// // =============================================================================

// = Status and Outlook

// #pdfpc.speaker-note("Act III, 5 minutes. This is a progress review: be concrete about what is done and what is left.")

// #let status-chip(kind) = if kind == "published" {
//   chip([published], fill: green.lighten(88%), stroke: green.lighten(35%))
// } else {
//   chip([under review], fill: blue.lighten(88%), stroke: blue.lighten(38%))
// }

// #let pub-row(work, venue, year, status, chapter) = (
//   comparison-label(inset: (x: .55em, y: .22em))[#text(size: .62em)[#work]],
//   comparison-cell(inset: (x: .4em, y: .22em))[#text(size: .62em)[#venue]],
//   comparison-cell(inset: (x: .4em, y: .22em))[#text(size: .62em)[#year]],
//   comparison-cell(inset: (x: .4em, y: .22em))[#status-chip(status)],
//   comparison-cell(inset: (x: .4em, y: .22em))[#text(size: .62em)[#chapter]],
// )

// == Publications

// #timing-chip[15:00 → 20:00 · wrap-up]

// #block(width: 100%, inset: .2em, radius: 6pt, fill: luma(250), stroke: (paint: ink.lighten(72%), thickness: .7pt))[
//   #table(
//     columns: (2.4fr, 1.3fr, .5fr, 1fr, .55fr),
//     gutter: .04em,
//     stroke: none,
//     comparison-header(inset: (x: .45em, y: .28em))[Work],
//     comparison-header(inset: (x: .45em, y: .28em))[Venue],
//     comparison-header(inset: (x: .45em, y: .28em))[Year],
//     comparison-header(inset: (x: .45em, y: .28em))[Status],
//     comparison-header(inset: (x: .45em, y: .28em))[Ch.],

//     ..pub-row([Scalability through Pulverisation], [FGCS], [2024], "published", [5]),
//     ..pub-row([LLM macroprogramming for IoT], [ACM TOSEM], [2025], "published", [6]),
//     ..pub-row([Capabilities to Catch 'em All], [TOPLAS], [2026], "review", [6]),
//     ..pub-row([ScalaTropy], [COORDINATION], [2026], "published", [6]),
//     ..pub-row([Flexible Self-organisation], [ACSOS], [2024], "published", [7]),
//     ..pub-row([Dynamic IoT reconfiguration], [Internet of Things], [2024], "published", [7]),
//     ..pub-row([Green deployment planning], [COORDINATION], [2025], "published", [7]),
//     ..pub-row([Heterogeneous GNN offloading], [FGCS], [2026], "published", [8]),
//     ..pub-row([Demonstrator for robot teams], [COORDINATION], [2025], "published", [9]),
//   )
// ]

// #pdfpc.speaker-note("~55s. Do not read the table. Nine works, eight published or accepted, one under review at TOPLAS, and every thesis chapter has a paper behind it.")

// == Thesis Status and Timeline

// #components.side-by-side(columns: (1fr, 1fr), gutter: 1.2em)[
//   #text(size: .78em)[
//     *Drafted*
//     - Part I, background: structure fixed, related work collected (Ch. 2–4).
//     - Part II, model: pulverisation chapter from FGCS 2024 (Ch. 5).
//     - Part III: deployment chapters follow the published papers (Ch. 7–8).
//   ]
// ][
//   #text(size: .78em)[
//     *Left to do*
//     - Ch. 6, once TOPLAS replies: consolidate the three language papers.
//     - Ch. 9, the demonstrator, plus introduction and conclusions.
//     - Unify the notation across chapters taken from different papers.
//   ]
// ]

// #v(.3em)

// #align(center)[
//   #cetz.canvas(length: 0.95cm, {
//     import cetz.draw: *

//     line((-7.6, 0), (7.9, 0), stroke: (paint: ink.lighten(40%), thickness: 1.2pt), mark: (end: ">"))

//     let milestone(x, label, detail, color, up: true) = {
//       let y = if up { 1.6 } else { -1.6 }
//       circle((x, 0), radius: .14, fill: color, stroke: none)
//       line((x, 0), (x, if up { y - .58 } else { y + .58 }),
//         stroke: (paint: color.lighten(30%), thickness: .9pt))
//       rect((x - 1.5, y - .58), (x + 1.5, y + .58), radius: .1,
//         fill: color.lighten(91%), stroke: (paint: color.lighten(40%), thickness: .8pt))
//       content((x, y), box(width: 2.6cm)[
//         #align(center)[
//           #text(size: .38em, weight: "medium", fill: color.darken(15%))[#label]
//           #linebreak()
//           #text(size: .29em, fill: ink.lighten(18%))[#detail]
//         ]
//       ], anchor: "center")
//     }

//     milestone(-6.4, [Now], [chapters from papers], ink, up: true)
//     milestone(-3.2, [TOPLAS], [decision pending], blue, up: false)
//     milestone(0.0, [Writing], [Ch. 6, 9, intro], green, up: true)
//     milestone(3.2, [Submission], [to the reviewers], orange, up: false)
//     milestone(6.4, [Esame finale], [2026], red, up: true)
//   })
// ]

// #pdfpc.speaker-note("~90s. Progress review: the committee wants to know what is left, and it will ask for dates. Check the drafting state and put real months on the timeline before presenting.")

// == Future Directions

// #components.side-by-side(columns: (1fr, 1fr), gutter: 1.2em)[
//   #feature-block("Edge-cloud deployments")[
//     #text(size: .84em)[_The dashed block on the contribution map: learned, self-organising deployment over the full continuum, at scale._]
//   ]
// ][
//   #text(size: .95em)[
//     - *Learned and declarative together*: planner constraints as safety bounds on the learned policy.
//     - *Cross-fleet deployment*: heterogeneous robot fleets under one middleware.
//     - *Deployment as a language construct*, checked by the compiler.
//   ]
// ]

// #v(.3em)
// #statement(fill: orange.lighten(90%))[
//   The direction is systems that keep adapting their execution footprint to the context and the resources they find.
// ]

// #pdfpc.speaker-note("~50s. Close on the last sentence, it is the one-line summary of the PhD.")

// #focus-slide[
//   Thank you
//   #v(.5em)
//   #text(size: .55em, weight: "light")[Questions?]
// ]

// // =============================================================================
// // BACKUP
// // =============================================================================

// = Backup <touying:hidden>

// == Pulverisation: Component Interactions <touying:hidden>

// #placeholder(
//   [Round structure],
//   body: [Backup: the per-round interaction between behaviour, state and communication components.],
// )

// == Other Work During the PhD <touying:hidden>

// - *Intelligent Pulverised Collective-Adaptive Systems*, ACSOS 2024 Doctoral Symposium.
// - *Decentralized proximity-aware clustering for collective self-federated learning*, Internet of Things, 2026.
// - *HarmoniKt*: unifying middleware for heterogeneous robot fleets.
