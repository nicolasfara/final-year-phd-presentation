#import "@preview/touying:0.6.3": *
#import themes.metropolis: *
#import "@preview/fontawesome:0.6.0": *
#import "@preview/codly:1.3.0": *
#import "@preview/cetz:0.4.2"
#import "utils.typ": *

#show: codly-init.with()

// Temporary workaround: https://github.com/Dherse/codly/issues/131
#let inset = 0.32em
#state("highlight-inset").update((y: 0em, x: inset))
#state("codly-highlight-outset").update((y: inset))

// Pdfpc configuration
// typst query --root . ./final-year-phd-presentation.typ --field value --one "<pdfpc-file>" > ./final-year-phd-presentation.pdfpc
// #let pdfpc-config = pdfpc.config(
//   duration-minutes: 20,
//   start-time: datetime(hour: 14, minute: 10, second: 0),
//   end-time: datetime(hour: 14, minute: 30, second: 0),
//   last-minutes: 3,
//   note-font-size: 12,
//   disable-markdown: false,
//   default-transition: (
//     type: "push",
//     duration-seconds: 2,
//     angle: ltr,
//     alignment: "vertical",
//     direction: "inward",
//   ),
// )

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
    show-bibliography-as-footnote: bibliography(title: none, "bibliography.bib"),
    preamble: {
      // Replayed on every slide; see `codly-setup` in utils.typ.
      // codly-setup()
      codly(
        languages: (
          scala: (name: [Scala]),
        ),
        display-icon: false,
        display-name: false,
        number-format: none,
        zebra-fill: none,
        fill: luma(248),
        stroke: .6pt + ink.lighten(78%),
        radius: 10pt,
        inset: (x: .6em, y: .3em),
        smart-indent: false,
        breakable: false,
      )
      // pdfpc-config
    },
    new-section-slide-fn: infographic-section-slide,
  ),
  config-info(
    title: [Engineering Collective Systems in the Edge-Cloud Continuum: Models and Platform],
    subtitle: [#text(size: 1em)[Final-year progress review — Ciclo XXXIX]],
    author: author_list(
      ((first_author("Nicolas Farabegoli"), "nicolas.farabegoli@unibo.it"),),
      // logo: "images/disi.svg",
      // width: 35%,
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
#show raw.where(block: false): set text(size: 1.3em)
// #show raw.line: set text(size: 0.9em)

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

Different paradigms make the same macro-level promise, but write and deploy it differently:

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

The three paradigms #bold[differ in how behaviour is written], are used #bold[in isolation], and all of them settle deployment before the system starts.

#pdfpc.speaker-note("~70s. The row that matters is the last one: all three say what the collective computes, none of them says where it runs. And the columns never meet: each paradigm is used on its own, so its guarantees stop at its own border.")

== Research Gap

#components.side-by-side(columns: (1fr, 1fr, 1fr), gutter: .8em)[
  #gap-card(
    [Monolithic devices],
    // [A device is deployed #bold[all at once]: behaviour, state and interfaces cannot be split across machines.]
    [Typical CAS deployments are #bold[monolithic]: the device is the unit of deployment, few approaches exploit the continuum]
  )
][
  #gap-card(
    [Isolated paradigms],
    // [Each paradigm works #bold[on its own]: placement and interaction stay outside the language, so guarantees do not add up.]
    [Macroprogramming paradigms are developed #bold[in isolation]: each can cover a part of the system, but integration unexplored.]
  )
][
  #gap-card(
    [ECC deployments],
    [Deployments typically relies only on #bold[edge devices]: when the ecc comes to play, no guarantees on self-organization are given.]
  )
]

// #text(size: .76em, fill: ink.lighten(15%))[Consequence: behaviour verified in simulation is re-implemented and re-validated per deployment.]

#statement[
  Can collective behaviour be #bold[partitioned] into independently deployable parts, #bold[written and checked] in a language that knows where they run, and #bold[placed and relocated at run time] under a semantics of what each change preserves?
]

#pdfpc.speaker-note("~60s. Three gaps, one per act of the talk. Monolithic devices: the device is the unit of deployment, so pulverisation is the answer — act two. Isolated paradigms: each takes a global view but on its own, and placement and communication are outside the language, so nothing can be checked — that is the language act. Static deployment: the mapping is settled before the system starts and nothing says what a redeployment preserves — that is the deployment act. Then read the research question slowly: the three clauses are the three acts, in order.")

== Contributions

#components.side-by-side(columns: (1.25fr, 1fr), gutter: 1em)[
  #align(center + horizon)[
    #image("images/phd_thesis_infographic.svg", width: 100%)
  ]
][
  #step-item("1", [Pulverization model], [Makes the logical device divisible, so its parts can be placed independently.])
  #v(.35em)
  #step-item("2", [Language support], [Placement and communication in the type system, so paradigms compose.])
  #v(.35em)
  #step-item("3", [Dynamic deployments], [Self-organising rules, constraint-based planning, learned offloading.])
  #v(.35em)
  #step-item("4", [Demonstrator], [The model running on real robot hardware.])
]

#pdfpc.speaker-note("~60s. Roadmap: the first three blocks answer the three gaps in the same order — model, languages, deployments — and the fourth shows the whole thing on real hardware. End of Act I, should be at 05:00.")

// =============================================================================
// ACT II -- MAIN CONTRIBUTION (10 minutes)
// =============================================================================

= The Pulverization Model <model>

#pdfpc.speaker-note("Act II, 10 minutes, the core of the talk. Should end at 15:00.")

== The pulverization model

#components.side-by-side(columns: (.72fr, 1.05fr, 1.05fr), gutter: .9em)[
  #align(center + horizon)[
    #image("images/ac-monolithic-motivation.svg", width: 100%)
  ]
][
  === The problem

  A (macro)program typically #underline[requires different capabilities] to run:
  - *sensors* and *actuators*
  - *computational* resources
  - *latency* requirements

  But a single physical device #underline[may not have all of them], so the program *cannot run*.

  // #text(size: .88em)[
  //   A logical device bundles behaviour, state, neighbourhood links and physical interfaces into one unit.

  //   - It has to be deployed as a whole.
  //   - A constrained device cannot host it, so it stays out of the collective.
  //   - The tiers above the edge stay unused.
  // ]
][
  === The solution
  #feature-block("Pulverisation")[
    _#underline[Split] each logical device into computationally independent components that can be deployed, and moved, separately._
  ]

  The collective program stays the same; what changes is #bold[how it is partitioned] and #bold[where the parts run].
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

== Logical Structure and Physical Deployment

#components.side-by-side(columns: (.8fr, 1.35fr), gutter: 0.95em)[
  #align(center + horizon)[
    #image("images/partitioned-macro-program.svg", width: 90%)
    #v(-.1em)
    #text(size: .62em, fill: ink.lighten(25%))[logical: component graph]
  ]

  The #bold[macroprogram] is modeled as a DAG of components, each *independently deployable*.
][
  #align(center + horizon)[
    #image("images/system-model.svg", width: 88%)
    #v(-.1em)
    #text(size: .62em, fill: ink.lighten(25%))[physical: hosts across the continuum]
  ]
  A _physical device_ can be either an *application* or *infrastructural* device, on which one or more components can be deployed.
]

// #v(.2em)
// #statement[
//   A deployment maps the component graph onto continuum hosts. Many mappings are valid, and the model makes the choice explicit.
// ]

#pdfpc.speaker-note("~60s. Left, what the program says; right, where it runs. The two are now independent. Sensors and actuators stay at the device tier.")

== Dynamic (re-)deployments

#components.side-by-side(columns: (1.1fr, 1fr, .95fr), gutter: 1em)[
  #align(center + horizon)[
    #image("images/offloading-surrogate.svg", width: 80%)
  ]
][
  === What can change

  - Physical devices can join, leave or fail.
  - Components can be moved between hosts.

  We offer a partitioning model to #underline[cope with these changes]. @pulverisation2024

  // #text(size: .85em)[
  //   - Which host runs behaviour or state.
  //   - How components are grouped into deployable units.
  //   - How many hosts take part.
  // ]

  // #text(size: .85em)[All of it while the system is running @pulverisation2024.]
][
  === What is preserved

  #mini-card(
    [Self-organization],
    [The partitioning #bold[preserves] the self-organization properties.],
    // [The collective computes the same result under any valid partitioning.],
    color: green
  )
  #mini-card(
    [Functional behaviour],
    [The system #bold[maintains its intended functionality] despite changes in deployment.],
    // [Per-round state and neighbour exchange survive a re-placement.],
    color: blue
  )
]

#statement(accent: green)[
  The model *preserves* the same functional behaviour and self-organizing properties of the "monolithic" deployment, even when the components are moved at run time.
]

#pdfpc.speaker-note("~60s. The figure: one component of the device is executed by a surrogate host, and the device keeps a forward reference to it. Answer the obvious objection: if computation moves around, does the program still mean the same thing? Yes, and proving that is why the model is formalised.")

= Language Support for Collective Systems <languages>

== Common Ground: Peers, Ties, Placed Values

#components.side-by-side(columns: (1.2fr, 1fr))[
#codly(highlights: (
  (line: 1, start: 29, end: 40, fill: blue),
  (line: 2, start: 29, end: 43, fill: blue),
  (line: 4, start: 11, end: 25, fill: orange),
  (line: 4, start: 29, end: 37, fill: orange),
  (line: 7, start: 25, end: 34, fill: red),
))
```scala
type Phone <: { type Tie <: Single[Edge] }
type Edge  <: { type Tie <: Multiple[Phone] }

val temp: Double on Phone = on[Phone](sense())

on[Phone] { val here = take(temp) }
on[Edge]  { val there = take(temp) }
```
All the invalid operations are *rejected at compile time* by the Scala type system, #bold[preventing unintended behaviors] at runtime.
  // #block(width: 100%, inset: (x: .7em, y: .42em), radius: 5pt,
  //   fill: red.lighten(93%), stroke: (paint: red.lighten(45%), thickness: .8pt))[
  //   #text(size: .6em, fill: ink)[The edge holds a typed reference, not the reading: `take` outside the owning peer does not compile.]
  // ]
][
  #step-item("1", [Type-encoded Architecture], [The architecture is a type: which families exist, and who may talk to whom.], accent: blue)

  #step-item("2", [Placement Types], [`V on P` says where a value lives; only `P` can open it.], accent: orange)

  #step-item("3", [Explicit data-flow], [A value reaches another peer only through a communication primitive.], accent: red)
]

#pdfpc.speaker-note("~55s. Set the shared vocabulary once, so the next two slides do not each re-explain it. Peers and ties describe the architecture at the type level; a placed value V on P is owned by one peer family and everyone else holds only a typed reference; moving a value is always an explicit primitive. The last line is the roadmap for the section: two papers, one substrate, two different questions asked of it.")

== CaMiL: Paradigms as Capabilities

#components.side-by-side(columns: (1.5fr, 1fr), gutter: .8em)[
  #codly(highlights: (
    // (line: 1, start: 19, end: 32, fill: orange),
    (line: 2, start: 16, end: 24, fill: blue),
    (line: 2, start: 27, end: 38, fill: green),
    (line: 2, start: 41, end: 50, fill: purple),
    // (line: 3, start: 5, end: 13, fill: blue),
    // (line: 4, start: 13, end: 24, fill: orange),
    // (line: 5, start: 13, end: 25, fill: orange),
    (line: 6, start: 19, end: 35, fill: green),
    (line: 8, start: 17, end: 33, fill: green),
    // (line: 7, start: 13, end: 24, fill: orange),
    (line: 10, start: 5, end: 16, fill: purple),
    (line: 11, start: 7, end: 12, fill: purple),
    (line: 12, start: 15, end: 27, fill: blue),
  ))
```scala
def recomm(token: Token on Phone)(using
    Placement, Multitier, Choreography, Collective
) = Multitier:
  val reqs: Reqs on Edge = on[Edge] { ... }
  val auth: Grant on Edge = Choreography:
    val onCloud = comm[Edge, Cloud](reqs)
    val tokenOnCloud = // Authentication protocol
    val token = comm[Cloud, Edge](tokenOnCloud)
  val recs: Signal[Recs] on Edge = Collective:
    rep(initial): v =>
      nbr(v).sum
  on[Phone] { asLocal(recs).subscribe(show) }
```
][
  #mini-card([`Multitier`], [Placement across tiers; `asLocal` reads a remote placed value.], color: blue)

  #mini-card([`Choreography`], [A global protocol; `comm` moves a placed value between peers.], color: green)

  #mini-card([`Collective`], [Aggregate rounds over an ensemble, emitting streams of placed values.], color: purple)
]

// #statement[
//   #text[Each paradigm's operations stay #bold[behind its own capability]: the bodies never mix. What crosses a boundary is only a #bold[placed value], the same one all three already agree on --- so the paradigms compose without giving up their guarantees.]
// ]

#pdfpc.speaker-note("~70s. Joint work with St. Gallen, Weisenburger and Salvaneschi. The observation: multitier, choreographic and aggregate programming all take a global view of a distributed system, but they are used in isolation and their guarantees do not compose. CaMiL models each as a capability — a value carrying the authority to use that paradigm's operations, passed through Scala's using clauses — over one shared substrate of placement types. I have elided the bodies on purpose: what each paradigm does inside its own block is its own business, and none of it escapes. What is left visible is the seam — three values placed on Edge, produced by three different paradigms and consumed by the next one. That is the whole composition story.")

== CaMiL: What the Types Rule Out

#components.side-by-side(columns: (1.2fr, 1fr))[
#codly(highlights: ((line: 7, start: 3, end: 28, fill: red),))
```scala
Choreography:
  val msg: String on Phone = on[Phone](greet())
  val f: (() => String) on Phone = on[Phone] {
    () => take(msg)
  }
  val atCloud = comm[Phone, Cloud](f)
  on[Cloud](take(atCloud)())
```
][
  #step-item("1", [Safe boundaries], [Paradigm scopes do not interleave: crossing happens only through a placed value.])
  #v(.12em)
  #step-item("2", [No capability leaks], [A placed function cannot be invoked where its captured state does not live.])
  #v(.12em)
  #step-item("3", [No nested-placement deadlocks], [An `on[Q]` nested in `on[P]` can never block peers waiting on it.])
]

#statement(accent: green)[
  A typed calculus with a #bold[soundness proof] regarding the placement discipline and paradigms interoperability, 46 use cases from the literature re-implemented.
]

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
      ..idea-row([Topology], blue, [_as before_: which #bold[peer families] exist, and which #bold[ties] are admissible]),
      ..idea-row([Placement], orange, [_as before_: where each #bold[value lives], written `V on P`], fill: soft),
      ..idea-row([Shape], green, [#bold[new]: which flow is intended --- one-to-one, broadcast, scatter or gather]),
    )
  ]
][
#codly(highlights: (
    (line: 1, start: 6, end: 11, fill: blue),
    (line: 1, start: 30, end: 45, fill: blue),
    (line: 2, start: 6, end: 11, fill: blue),
    (line: 2, start: 30, end: 43, fill: blue),
    (line: 4, start: 10, end: 23, fill: orange),
    (line: 4, start: 28, end: 37, fill: orange),
    (line: 6, start: 11, end: 25, fill: green),
    (line: 7, start: 11, end: 20, fill: orange),
    (line: 8, start: 10, end: 26, fill: green),
  ))
```scala
type Master <: { type Tie <: Multiple[Worker] }
type Worker <: { type Tie <: Single[Master] }

for
  tasks: Task on Master <- on[Master] { buildTasks() }
  work <- anisotropicComm[Master, Worker](tasks)
  part <- on[Worker] { take(work).map(_.compute) }
  all <- coAnisotropicComm[Worker, Master](part)
yield all
```
]

#components.side-by-side(columns: (1fr, 1fr, 1fr, 1fr), gutter: .5em)[
  #shape-cell("point-to-point", [])
][
  #shape-cell("isotropic", [])
][
  #shape-cell("anisotropic", [])
][
  #shape-cell("co-anisotropic", [])
]

#v(.1em)
#statement(accent: green)[
  Combines the #bold[expressiveness] of choreographic programming with the #bold[static guarantees] of placement types from Multitier programming, all in a single Scala (monadic) type system.
]

#pdfpc.speaker-note("~70s. ScalaTropy in one slide. The first two rows are the substrate from three slides ago, so move over them fast; the third row is the contribution. The types on the right carry all three at once: the topology (ties), where values live (V on P), and the shape of each exchange. The four glyphs are the vocabulary: point-to-point, isotropic, anisotropic, co-anisotropic — the tropy in the name. Selectivity is not only an optimisation: sending each worker exactly its block is checked by the compiler, so confidentiality is structural. All of it is plain Scala types, no macros, erased at runtime.")

= Deployments <deployment>

// == Choosing a Deployment

// #components.side-by-side(columns: (1.1fr, 1fr), gutter: 1em)[
//   #step-item("A", [Self-organising rules], [Each device decides where its own components go @flexible2024 @dynamiciot2024.])
//   #v(.25em)
//   #step-item("B", [Constraint-based planning], [A planner searches the placement space under hardware, network and energy constraints.])
//   #v(.25em)
//   #step-item("C", [Learned policies], [An agent trained to pick placements from the topology.])
// ][
//   #mini-card([Rules], [Cheap and local, but hand-written.], color: blue)
//   #v(.25em)
//   #mini-card([Planning], [Meets the declared constraints, needs a global view.], color: green)
//   #v(.25em)
//   #mini-card([Learning], [Needs training, transfers to unseen topologies.], color: orange)
// ]

// #pdfpc.speaker-note("~80s. Three papers on one slide. The point to make out loud: deployment control is itself a collective behaviour, so the same tools apply to it. Green planning is joint work with Brogi and Forti in Pisa.")

== Different Deployment Strategies

#block(width: 100%, inset: .25em, radius: 6pt, fill: luma(250), stroke: (paint: ink.lighten(72%), thickness: .7pt))[
  #table(
    columns: (1.0fr, 1fr, 1fr, 1fr),
    gutter: .08em,
    stroke: none,
    comparison-header[Policy],
    comparison-header[What it is told],
    comparison-header[What it buys],
    comparison-header[What it costs],
    comparison-label(inset: (x: .55em, y: .4em))[#chip([A], fill: blue.lighten(88%), stroke: blue.lighten(38%)) Local rule #cite(<flexible2024>)],
    comparison-cell(inset: (x: .45em, y: .4em))[#text(size: .68em)[offload when below a given battery threshold]],
    comparison-cell(fill: green.lighten(94%), inset: (x: .45em, y: .4em))[#text(size: .68em)[#bold[extended battery life] compared to baseline]],
    comparison-cell(inset: (x: .45em, y: .4em))[#text(size: .68em)[latency: extra hops to the surrogate]],
    comparison-label(inset: (x: .55em, y: .4em))[#chip([B], fill: green.lighten(88%), stroke: green.lighten(35%)) Field regions @dynamiciot2024],
    comparison-cell(inset: (x: .45em, y: .4em))[#text(size: .68em)[leaders resize their region to match their own load]],
    comparison-cell(fill: green.lighten(94%), inset: (x: .45em, y: .4em))[#text(size: .68em)[#bold[spatially-aware] offloading, and #bold[failure tolerant]]],
    comparison-cell(inset: (x: .45em, y: .4em))[#text(size: .68em)[a stabilisation transient depending on the topology]],
    comparison-label(inset: (x: .55em, y: .4em))[#chip([C], fill: orange.lighten(85%), stroke: orange.lighten(40%)) Prolog planner @brogi2025green],
    comparison-cell(inset: (x: .45em, y: .4em))[#text(size: .68em)[an energy/carbon objective with latency bounds]],
    comparison-cell(fill: green.lighten(94%), inset: (x: .45em, y: .4em))[#text(size: .68em)[#bold[a third of the energy] and #bold[carbon] consumption]],
    comparison-cell(inset: (x: .45em, y: .4em))[#text(size: .68em)[sub-optimal performance; a replan every 30 min]],
  )
]

#pdfpc.speaker-note("~75s. The concrete results behind the previous slide, one row each. A: the two charts in the paper say where the cost lands — the offloaded devices have more battery, not less, so the price is paid in messages. B: quality of service is the share of devices that manage to offload at all; the field-based policy beats the nearest-hop baseline once its regions settle, and can dip below it during the transient. It helps more on scale-free than on lobster topologies, because removing a node from a lobster network segments it. C: joint work with Brogi and Forti in Pisa — roughly a third of the energy at every network size, and the baseline's carbon tracks the day-night sinusoid exactly because its deployment never changes. Then land the last line: that is the requirement the next slides drop.")

== Learning the Placement

=== Informed Deep Hetero-Graph Q-Learning (IDHGQL) 

#align(center)[
  #cetz.canvas(length: 1.18cm, {
    import cetz.draw: *

    // Four cards on one baseline. The two middle ones are the learned model, so
    // they sit inside a dashed frame and the outer two read as plain data: the
    // world goes in on the left, a decision comes out on the right.
    let w = 4.3        // card width
    let hh = 1.5       // card half-height
    let pitch = 5.7
    let xs = (-1.5, -.5, .5, 1.5).map(i => i * pitch)
    let cy = .62       // centre of the glyph band inside a card
    let bg = rgb("#fafafa")   // the slide fill, used to mask labels that sit on a line

    // Shorten a segment at both ends, so an arrowhead never slides underneath
    // the shape it points at.
    let trim(from, to, head: .0, tail: .0) = {
      let dx = to.at(0) - from.at(0)
      let dy = to.at(1) - from.at(1)
      let len = calc.max(calc.sqrt(dx * dx + dy * dy), 1e-6)
      (
        (from.at(0) + dx / len * tail, from.at(1) + dy / len * tail),
        (to.at(0) - dx / len * head, to.at(1) - dy / len * head),
      )
    }

    // The same small topology is drawn twice — once as the input state, once as
    // the output with the chosen hosts filled in — so the audience sees that the
    // pipeline answers a question about the very graph it was given. Node shape
    // carries the device class, line style carries the link type: that is the
    // heterogeneity the encoder gets to see.
    let topology(cx, chosen: ()) = {
      let wire = ink.lighten(58%)
      let cloud = (cx, cy + .5)
      let edges = ((cx - .8, cy - .06), (cx + .8, cy - .06))
      let devices = ((cx - 1.24, cy - .62), (cx - .36, cy - .62), (cx + 1.12, cy - .62))

      for e in edges { line(cloud, e, stroke: (paint: wire, thickness: .7pt)) }
      for (d, e) in devices.zip((edges.at(0), edges.at(0), edges.at(1))) {
        line(d, e, stroke: (paint: wire, thickness: .6pt, dash: "dashed"))
      }

      // A chosen host is filled in the accent colour and haloed in its own
      // outline; the rest stay on a grey ramp that runs cloud -> edge -> device,
      // so the three classes read apart even in monochrome.
      let skin(id, tint) = if chosen.contains(id) {
        (fill: orange.lighten(28%), stroke: (paint: orange.darken(12%), thickness: .9pt))
      } else {
        (fill: ink.lighten(tint), stroke: (paint: ink.lighten(38%), thickness: .8pt))
      }
      let halo = (paint: orange.lighten(50%), thickness: .7pt)

      // cloud: a rounded slab
      if chosen.contains("c") {
        rect((cloud.at(0) - .6, cloud.at(1) - .31), (cloud.at(0) + .6, cloud.at(1) + .31),
          radius: .14, fill: none, stroke: halo)
      }
      rect((cloud.at(0) - .46, cloud.at(1) - .18), (cloud.at(0) + .46, cloud.at(1) + .18),
        radius: .09, ..skin("c", 68%))
      // edge: squares
      for (i, e) in edges.enumerate() {
        if chosen.contains("e" + str(i)) {
          rect((e.at(0) - .3, e.at(1) - .3), (e.at(0) + .3, e.at(1) + .3), radius: .07, fill: none, stroke: halo)
        }
        rect((e.at(0) - .17, e.at(1) - .17), (e.at(0) + .17, e.at(1) + .17), radius: .04, ..skin("e" + str(i), 80%))
      }
      // devices: dots
      for (i, d) in devices.enumerate() {
        if chosen.contains("d" + str(i)) { circle(d, radius: .27, fill: none, stroke: halo) }
        circle(d, radius: .14, ..skin("d" + str(i), 88%))
      }
    }

    // Message passing: four neighbours folding into one node.
    let mp-glyph(cx, color) = {
      let c = (cx, cy)
      let nbrs = ((cx - 1.18, cy + .58), (cx + 1.18, cy + .58), (cx - 1.18, cy - .58), (cx + 1.18, cy - .58))
      for n in nbrs {
        let (a, b) = trim(n, c, head: .44, tail: .24)
        line(a, b, stroke: (paint: color.lighten(35%), thickness: .8pt), mark: (end: ">", scale: .35))
      }
      for n in nbrs {
        circle(n, radius: .16, fill: color.lighten(86%), stroke: (paint: color.lighten(25%), thickness: .8pt))
      }
      circle(c, radius: .32, fill: color.lighten(50%), stroke: (paint: color.darken(10%), thickness: 1pt))
    }

    // One Q-value per action, with the argmax standing out.
    let q-glyph(cx, color) = {
      let hs = (.36, .68, .26, .96, .48)
      let step = .52
      let x0 = cx - step * 2
      let base = cy - .62
      line((x0 - .44, base), (x0 + step * 4 + .44, base), stroke: (paint: ink.lighten(62%), thickness: .6pt))
      for (i, h) in hs.enumerate() {
        let x = x0 + i * step
        let best = i == 3
        rect((x - .15, base), (x + .15, base + h), radius: .03,
          fill: if best { color.lighten(40%) } else { color.lighten(86%) },
          stroke: (paint: if best { color.darken(12%) } else { color.lighten(38%) }, thickness: .7pt))
      }
      let bx = x0 + 3 * step
      let top = base + hs.at(3) + .3
      line((bx - .15, top), (bx, top - .2), (bx + .15, top), close: true,
        fill: color.darken(8%), stroke: none)
    }

    // The card itself: glyph on top, name, then the one-line gloss.
    let card(x, color, glyph, title, subtitle) = {
      rect((x - w / 2, -hh), (x + w / 2, hh), radius: .16,
        fill: color.lighten(95%), stroke: (paint: color.lighten(38%), thickness: .9pt))
      glyph
      content((x, -.62), text(size: .54em, weight: "medium", fill: color.darken(18%))[#title], anchor: "center")
      content((x, -1.1), align(center)[#text(size: .4em, fill: ink.lighten(18%))[#subtitle]], anchor: "center")
    }

    // The learned part of the pipeline, framed off from the data at either end.
    rect((xs.at(1) - w / 2 - .42, -hh - .42), (xs.at(2) + w / 2 + .42, hh + .42),
      radius: .2, fill: none, stroke: (paint: ink.lighten(55%), thickness: .8pt, dash: "dashed"))
    content((0, hh + .42), text(size: .4em, weight: "medium", fill: ink.lighten(22%))[learned policy],
      frame: "rect", fill: bg, stroke: none, padding: .12, anchor: "center")

    card(xs.at(0), ink, topology(xs.at(0)), [Heterogeneous graph], [device, edge and cloud hosts \ typed links and features])
    card(xs.at(1), blue, mp-glyph(xs.at(1), blue), [GNN encoder], [message passing over \ node and edge types])
    card(xs.at(2), green, q-glyph(xs.at(2), green), [Deep Q-network], [one Q-value per \ placement action])
    card(xs.at(3), orange, topology(xs.at(3), chosen: ("c", "e0", "d2")), [Deployment], [components pinned \ to chosen hosts])

    // What travels between the stages, named on the arrows. The two outer
    // labels sit where the dashed frame crosses, so each one is masked with the
    // slide background and the border passes behind it.
    for (i, label) in (([features], [embeddings], [argmax])).enumerate() {
      let a = xs.at(i) + w / 2 + .14
      let b = xs.at(i + 1) - w / 2 - .14
      line((a, 0), (b, 0), stroke: (paint: ink.lighten(45%), thickness: 1.1pt), mark: (end: ">", scale: .5))
      content(((a + b) / 2, .36), text(size: .36em, fill: ink.lighten(32%))[#label],
        frame: "rect", fill: bg, stroke: none, padding: (x: .1, y: .06), anchor: "center")
    }

    // The environment closes the loop: the deployment is executed, and what it
    // costs comes back as the reward that trains the policy.
    let ry = -2.7
    line((xs.at(3), -hh), (xs.at(3), ry), (xs.at(0), ry), (xs.at(0), -hh),
      stroke: (paint: ink.lighten(52%), thickness: .9pt, dash: "dashed"), mark: (end: ">", scale: .5))
    content((0, ry), text(size: .38em, fill: ink.lighten(25%))[reward: latency, energy, load],
      frame: "rect", fill: bg, stroke: none, padding: (x: .2, y: .08), anchor: "center")
  })
]


Device class and link quality are part of the graph itself, so the policy sees the heterogeneity of the continuum instead of a flat topology.#cite(<farabegoli2026gnn>)


#pdfpc.speaker-note("~70s. Walk left to right, then the dashed feedback arrow. The novelty is the heterogeneous graph: earlier work flattens the topology and throws away the device diversity that makes placement hard.")

== Informing the Policy with Collective State

#components.side-by-side(columns: (1fr, 1.15fr), gutter: .9em, align: top)[
  === Two kinds of node from pulverization

  #v(0.5em)
  #align(center)[
    #cetz.canvas(length: 1.15cm, {
      import cetz.draw: *

      let w = 4.45       // width of a type card
      let rh = 3.6       // its height
      let gap = .4       // between the two cards
      let cw = 3.6       // width of a feature chip
      let ch = .38       // and its height

      // One feature. The collective term is the accented chip: it is the only
      // feature on the slide that the device cannot measure about itself.
      let feat(x, y, color, label, accent: false) = {
        rect((x, y - ch / 2), (x + cw, y + ch / 2), radius: .09,
          fill: if accent { orange.lighten(80%) } else { color.lighten(94%) },
          stroke: (paint: if accent { orange.lighten(30%) } else { color.lighten(52%) }, thickness: .7pt))
        content((x + cw / 2, y), text(size: .46em, fill: ink)[#label], anchor: "center")
      }

      // A node type: glyph on top, name under it, its own feature vector stacked
      // underneath. The two stacks have different lengths and different
      // meanings, which is the whole point.
      let card(x0, color, glyph, title, feats) = {
        rect((x0, 0), (x0 + w, rh), radius: .15,
          fill: color.lighten(97%), stroke: (paint: color.lighten(48%), thickness: .9pt))
        glyph((x0 + w / 2, rh - .85))
        content((x0 + w / 2, rh - 1.75), text(size: .52em, weight: "medium", fill: color.darken(18%))[#title], anchor: "center")
        for (i, f) in feats.enumerate() {
          feat(x0 + (w - cw) / 2, rh - 2.25 - i * (ch + .12), color, f.at(0), accent: f.at(1))
        }
      }

      // Application devices are dots with a peer-to-peer neighbourhood hanging
      // off them; infrastructural ones are the cloud slab and edge square of the
      // previous slide. Same shapes as the topology drawn there.
      let app-glyph(pos) = {
        let (x, y) = pos
        for n in ((x - .5, y + .42), (x + .52, y + .38), (x - .46, y - .44), (x + .5, y - .4)) {
          line((x, y), n, stroke: (paint: blue.lighten(58%), thickness: .55pt, dash: "dashed"))
          circle(n, radius: .09, fill: blue.lighten(72%), stroke: none)
        }
        circle((x, y), radius: .28, fill: blue.lighten(52%), stroke: (paint: blue.darken(10%), thickness: 1pt))
      }

      let infra-glyph(pos) = {
        let (x, y) = pos
        line((x, y + .2), (x, y - .18), stroke: (paint: green.lighten(50%), thickness: .6pt))
        rect((x - .48, y + .2), (x + .48, y + .56), radius: .09,
          fill: green.lighten(72%), stroke: (paint: green.darken(10%), thickness: .9pt))
        rect((x - .24, y - .56), (x + .24, y - .18), radius: .05,
          fill: green.lighten(86%), stroke: (paint: green.darken(10%), thickness: .9pt))
      }

      card(0, blue, app-glyph, [Application Device],
        ((
          [battery level], false,
        ), (
          [processor load], false,
        ), (
          [collective term $c_(delta,t)$], true,
        )))

      card(w + gap, green, infra-glyph, [Infrastructural Device],
        ((
          [price per hour], false,
        ), (
          [spare capacity], false,
        ), (
          [round-trip latency], false,
        )))
    })
  ]

  #v(0.5em)
  #mini-card(
    [Density estimation via collective computation],
    [A #bold[density field] from an aggregate program on the same devices, instead of #bold[$O(D)$ GNN layers].],
    color: orange,
  )
][
  === Collective info vs. local view

  #components.side-by-side(columns: (1fr, 1fr), gutter: .5em, align: top)[
    #align(center)[
      #image("images/idhgql-density-ac.svg", width: 80%)
      #v(-.5em)
      #text(size: .54em, fill: ink.lighten(25%))[with the collective density field]
    ]
  ][
    #align(center)[
      #image("images/idhgql-density-no-ac.svg", width: 80%)
      #v(-.5em)
      #text(size: .54em, fill: ink.lighten(25%))[without it (ablation)]
    ]
  ]

  #components.side-by-side(columns: (1fr, 1fr), gutter: .5em, align: top)[
    #mini-card(
      [With density field],
      [Dense zones stay local, sparse regions offload, the boundary #bold[splits].],
      color: blue,
    )
  ][
    #mini-card(
      [Uniform without it],
      [Every device converges on the #bold[same fraction], wherever it sits.],
      color: red,
    )
  ]
]

#v(.15em)
#statement(accent: green)[
  #text[The #bold[collective computation] gives the policy a #bold[global view] without requiring a deep GNN, so the #bold[per-component action space] can be used to deploy partial topologies.]
]

#pdfpc.speaker-note("~100s. The slide that carries the chapter, so give it time. Left first: the two node types do not carry the same features. An application device is battery, processor load, and the collective term; an infrastructural device is price, spare capacity, latency. Different dimensions, different meanings, so there is no single input layer --- each type gets its own projection into the shared space where the per-edge-type messages are summed, and the Q-head is applied only at application devices, since servers take no decisions. Then point at the orange chip: that third feature is the one no device can measure about itself. Congestion is caused by the offloading decisions themselves and belongs to an area; a GNN could recover it, but only by being deep enough to carry it across the whole crowded region. An aggregate program computes it natively on the same devices, self-stabilising, no synchronisation barrier with the learner, so the field can be refreshed several times between decisions. Then move right, to the ablation --- same learner, same graph, same environment, one feature apart. With the field the policy is differentiated by position: dense zones stay local, sparse regions offload, and the fringe devices split their components, which is the group to point at, because partial deployments are exactly what the per-component action space was introduced to make available. Remove only the density term and every device settles on roughly the same fraction regardless of where it sits. If asked about generalisation: the trained network was applied unchanged while three devices walked out of a dense zone at t=100, and by t=150 they had switched to offloading on their own, following the field rather than the positions it was trained on. If asked about the objectives: the weighted reward moves the outcome along a battery-versus-cost curve, and single-objective settings give the extreme each one asks for. Close on the statement.")

// == Evaluation

// #components.side-by-side(columns: (1fr, 1fr), gutter: 1em)[
//   #placeholder(
//     [Scalability under pulverisation],
//     body: [From _Scalability through Pulverisation_ (FGCS 2024).],
//     height: 52%,
//   )
// ][
//   #placeholder(
//     [Learned offloading],
//     body: [From _Heterogeneous GNN for collective-task offloading_ (FGCS 2026), against heuristic and flat-GNN baselines.],
//     height: 52%,
//   )
// ]

// #v(.3em)
// #statement(accent: red)[
//   #text(size: .82em)[*To fill before the review:* both plots have to be exported from the papers, no result figures are in the thesis repository.]
// ]

// #pdfpc.speaker-note("~50s. Fill this slide. Once the figures are in, quote the headline numbers from each paper.")

= Real-World Demonstrator <demo>

== Project Emerge: a swarm robotic platform

#components.side-by-side(columns: (1fr, 1.12fr), gutter: 1.1em)[
  #align(center + horizon)[
    #image("images/emerge-execution-cycle.svg", width: 82%)
    #v(-.35em)
    #text(size: .54em, fill: ink.lighten(25%))[one round: build the network model, evaluate, dispatch, actuate]
  ]
][
  // === The setup
    - An #bold[ESP32] too small for a runtime: only #bold[sensors and actuators] and #bold[connectivity].
    - An overhead camera reads every robot's #bold[position and orientation].
    - #bold[Collective programs] offloaded to an edge server

  #mini-card(
    [The "pulverized" deployment],
    [Robots are the #bold[application devices], the server their #bold[shared surrogate], the broker a #bold[pure relay].],
    color: blue,
  )
]

#warning-block("Pulverization to the rescue")[
Without a partitioning model such as the pulverization, on thiny devices the collective program would have to be #bold[deployed monolithically] on each robot, which is impossible on the ESP32.
]

#pdfpc.speaker-note("~55s. This is the physical check on everything Act II argued in simulation: can a deployment the model admits actually be built? Nine robots, chassis printed in-house, each carrying an ESP32 that does radio and wheels and nothing else --- there is no aggregate runtime on the robot, because the microcontroller cannot host one. The figure is one round: the environment provider assembles a logical network from the physical robot states at time t, the orchestrator evaluates the collective program over it, the updater dispatches the commands, the robots move, and that is t+1. What the program emits is an intention --- rotate along this vector, move forward, hold --- not a motor setting, so a different chassis means a different updater and no change to the program. Then the blue card, which is the point of the slide and is my reading, not the paper's: the paper calls its own architecture centralised and never says pulverisation. Restated in the model, the robots are the application devices that own the behaviour, the server is the shared surrogate that executes all nine instances, and the broker is the relay hop. That is the forwarding-chain case, and it is licensed because component instances hold no state beyond their round-inputs. The sensing substitution is the sharper instance: the camera reports each robot's own position and orientation, the same quantity an onboard sensor would have read, which is exactly the uniformity hypothesis the deployment-independence theorem needs. If asked why it was built this way: ESP32s that cannot host a runtime, and wanting a public demo to be robust --- the capability mismatches offloading exists for, met without the model in hand.")

== Real world testbed

#components.side-by-side(columns: (1.2fr, 1fr), gutter: 1.1em)[
  #let shot(path, caption) = align(center)[
    #image(path, width: 65%)
    #v(-0.8em)
    #text(size: .5em, fill: ink.lighten(25%))[#caption]
  ]

  #shot("images/emerge-selfhealing-1.jpg", [line formation reached])
  #shot("images/emerge-selfhealing-2.jpg", [one robot displaced by hand, mid-execution])
  #shot("images/emerge-selfhealing-3.jpg", [formation recovered, no intervention])
  
][
  // === Reproducible & self-stabilising

  // #mini-card(
  //   [Self-stabilisation],
  //   [The formation recovers from a #bold[physical perturbation] without intervention. The formation reorganises itself when robots are #bold[displaced] or #bold[removed].],
  //   color: green,
  // )

  === Low-cost and open source
  #let repo = "https://github.com/project-emerge"
  #block(height: 65%)[
  #grid(
    columns: (1fr, 60%),
    column-gutter: .6em,
    align: horizon,
    link(repo)[
      #align(center)[
        #stack(
          spacing: .8em,
          image("images/github.svg", height: 4em),
          image("images/open-hardware.svg", height: 4em),
        )
      ]
    ],
    image("images/dropbot_chassis_v2_2026_Sep_15_05_06_11PM_000_CustomizedView47537546704.png", width: 100%),
  )
  #v(1fr)
  #align(center)[
    #text(size: .6em, fill: ink.lighten(25%))[#link(repo)[#raw("github.com/project-emerge")]]
  ]
  ]
]

#statement(accent: green)[
  // Offloading the collective program to a shared #bold[edge server], we overcome the ESP32's lack of compute power and memory, ensuring the #bold[deployment-independence] property of the model.
  We achieved a #bold[pulverized deployment] with almost computationallyless robots, preserving the #bold[deployment-independence] property of the model.
]

#pdfpc.speaker-note("~55s. Ran twice as a public exhibit at the Researchers' Night, indoors, with people walking through the arena. Five programs, chosen to exercise different coordination requirements --- symmetry, alignment, leader-based coordination --- rather than to look varied, and switched over the broker while the team was running: that is what the homogeneous-loading requirement was for, and the audience sees one formation dissolve into the next without a restart. The dashboard was part of the exhibit rather than an operator tool, because the neighbourhood relation is invisible otherwise; a visitor could drag the radius and watch the formation reorganise. Now the photo strip, which is the result worth having. Simulation confirmed that an offloaded deployment converges where a monolithic one does, under mobility and interrupted movement. A physical arena admits a perturbation neither of those covers --- a hand. Formation reached, a robot picked up and put somewhere else mid-execution, formation recovered with no intervention, every time it was tried. Be honest about its status: qualitative, nothing measured, so it supports the claim that self-stabilisation survives physical embodiment and adversarial handling, and no claim about recovery time or how deployments compare. Then the orange box, unprompted, because the review will ask: the deployment here is fixed by hand and never revised, so the demonstrator exercises none of the reconfiguration or the learned offloading from Act II, and it runs one aggregate program rather than a component DAG. It is one point of the deployment space, realised on hardware --- and, because the simulator can replace robots and camera behind the same broker interface, it is the natural place to exercise the rest. End of Act II, should be at 15:00.")

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
// #statement[
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
