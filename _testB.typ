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

= Deployments <deployment>

== Learning the Placement: Informed Deep Hetero-Graph Q-Learning

#v(-.4em)
#align(center)[
  #scale(56%, reflow: true, cetz.canvas(length: 1.18cm, {
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
  }))
]

#v(-.1em)
#components.side-by-side(columns: (1fr, 1.08fr), gutter: .9em, align: top)[
  // The heterogeneity the encoder sees: two node types that do not share a
  // feature space, so each gets its own projection. The accented chip is the
  // only feature no device can measure about itself.
  #block(
    width: 100%,
    inset: (x: .7em, y: .45em),
    radius: 5pt,
    fill: luma(250),
    stroke: (paint: ink.lighten(72%), thickness: .7pt),
  )[
    #text(size: .7em, weight: "medium", fill: ink)[Two kinds of node, two feature spaces]
    #v(.35em)
    #grid(
      columns: (auto, 1fr),
      column-gutter: .55em,
      row-gutter: .38em,
      align: (left + horizon, left + horizon),
      chip([Application], fill: blue.lighten(88%), stroke: blue.lighten(38%)),
      [#text(size: .58em, fill: ink)[battery level · processor load ·] #text(size: .82em)[#chip([collective term $c_(delta,t)$])]],
      chip([Infrastructural], fill: green.lighten(88%), stroke: green.lighten(35%)),
      text(size: .58em, fill: ink)[price per hour · spare capacity · round-trip latency],
    )
    #v(.4em)
    #text(size: .56em, fill: ink.lighten(20%))[The accented term is what #bold[no device can measure about itself]: a #bold[density field] from an aggregate program, not #bold[$O(D)$ GNN layers].]
  ]
][
  #components.side-by-side(columns: (1fr, 1fr), gutter: .5em, align: top)[
    #align(center)[
      #image("images/idhgql-density-ac.svg", width: 56%)
      #v(-.4em)
      #mini-card(
        [With the density field],
        [Dense zones stay local, sparse regions offload, the boundary #bold[splits].],
        color: green,
      )
    ]
  ][
    #align(center)[
      #image("images/idhgql-density-no-ac.svg", width: 56%)
      #v(-.4em)
      #mini-card(
        [Without it (ablation)],
        [Every device converges on the #bold[same fraction], wherever it sits.],
        color: red,
      )
    ]
  ]
]

#v(.1em)
// A slim band rather than the usual statement block: the slide is already at
// its height budget, and the citation below it costs a footnote of its own.
#block(
  width: 100%,
  inset: (x: .9em, y: .42em),
  radius: 5pt,
  fill: green.lighten(88%),
  stroke: (paint: green.lighten(35%), thickness: .8pt),
)[
  #text(size: .74em, weight: "medium", fill: ink)[Device class and link quality live in the graph itself, and the #bold[collective computation] gives a #bold[global view] without a deep GNN --- so the #bold[per-component action space] can deploy partial topologies.#cite(<farabegoli2026gnn>)]
]

#pdfpc.speaker-note("~120s. The slide that carries the chapter, so give it time. Walk the pipeline left to right, then the dashed feedback arrow: the novelty is the heterogeneous graph, where earlier work flattens the topology and throws away the device diversity that makes placement hard. Then drop to the feature box: the two node types do not carry the same features --- an application device is battery, processor load and the collective term; an infrastructural one is price, spare capacity, latency. Different dimensions, different meanings, so there is no single input layer: each type gets its own projection into the shared space where the per-edge-type messages are summed, and the Q-head is applied only at application devices, since servers take no decisions. Point at the orange chip: that third feature is the one no device can measure about itself. Congestion is caused by the offloading decisions themselves and belongs to an area; a GNN could recover it, but only by being deep enough to carry it across the whole crowded region. An aggregate program computes it natively on the same devices, self-stabilising, no synchronisation barrier with the learner, so the field can be refreshed several times between decisions. Then move right, to the ablation --- same learner, same graph, same environment, one feature apart. With the field the policy is differentiated by position: dense zones stay local, sparse regions offload, and the fringe devices split their components, which is the group to point at, because partial deployments are exactly what the per-component action space was introduced to make available. Remove only the density term and every device settles on roughly the same fraction regardless of where it sits. If asked about generalisation: the trained network was applied unchanged while three devices walked out of a dense zone at t=100, and by t=150 they had switched to offloading on their own, following the field rather than the positions it was trained on. If asked about the objectives: the weighted reward moves the outcome along a battery-versus-cost curve, and single-objective settings give the extreme each one asks for. Close on the statement.")

