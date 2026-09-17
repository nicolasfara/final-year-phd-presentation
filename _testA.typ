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

== Choosing a Deployment

// The three deployment-control families and what each one actually bought,
// folded into one table: the left column names the family and the paper, the
// other three read as the trade-off. The fourth family — learned policies — is
// the closing line, because it is the next two slides.
#block(width: 100%, inset: .25em, radius: 6pt, fill: luma(250), stroke: (paint: ink.lighten(72%), thickness: .7pt))[
  #table(
    columns: (1.12fr, 1fr, 1fr, 1fr),
    gutter: .08em,
    stroke: none,
    comparison-header[Policy],
    comparison-header[What it is told],
    comparison-header[What it buys],
    comparison-header[What it costs],
    comparison-label(inset: (x: .55em, y: .22em))[
      #chip([A], fill: blue.lighten(88%), stroke: blue.lighten(38%)) Battery rule #cite(<flexible2024>)
      #linebreak()
      #text(size: .66em, weight: "regular", fill: ink.lighten(30%))[self-organising, per-device]
    ],
    comparison-cell(inset: (x: .45em, y: .22em))[#text(size: .63em)[one threshold: offload below 30% battery]],
    comparison-cell(fill: green.lighten(94%), inset: (x: .45em, y: .22em))[#text(size: .63em)[more battery left at the end of the run]],
    comparison-cell(inset: (x: .45em, y: .22em))[#text(size: .63em)[bandwidth, not energy: extra hops]],
    comparison-label(inset: (x: .55em, y: .22em))[
      #chip([B], fill: green.lighten(88%), stroke: green.lighten(35%)) Field regions @dynamiciot2024
      #linebreak()
      #text(size: .66em, weight: "regular", fill: ink.lighten(30%))[self-organising, leader regions]
    ],
    comparison-cell(inset: (x: .45em, y: .22em))[#text(size: .63em)[leaders resize regions by their own load]],
    comparison-cell(fill: green.lighten(94%), inset: (x: .45em, y: .22em))[#text(size: .63em)[more devices offload at all; graceful recovery]],
    comparison-cell(inset: (x: .45em, y: .22em))[#text(size: .63em)[a stabilisation transient; topology-dependent]],
    comparison-label(inset: (x: .55em, y: .22em))[
      #chip([C], fill: orange.lighten(85%), stroke: orange.lighten(40%)) Green planner @brogi2025green
      #linebreak()
      #text(size: .66em, weight: "regular", fill: ink.lighten(30%))[constraint-based, global planner]
    ],
    comparison-cell(inset: (x: .45em, y: .22em))[#text(size: .63em)[an energy/carbon objective, hard latency bounds]],
    comparison-cell(fill: green.lighten(94%), inset: (x: .45em, y: .22em))[#text(size: .63em)[#bold[a third of the energy] and carbon of peer-to-peer]],
    comparison-cell(inset: (x: .45em, y: .22em))[#text(size: .63em)[intra-component latency; replan every 30 min]],
    // The take-away rides in the table rather than in a statement block: at
    // three footnoted citations this slide has no room for a second frame.
    table.cell(colspan: 4, fill: soft, inset: (x: .7em, y: .45em))[
      #text(size: .7em, weight: "medium", fill: ink)[Every row is a policy #bold[someone wrote] --- a threshold, a region rule, an objective function. Next: #bold[learn] it from the topology.]
    ],
  )
]

#pdfpc.speaker-note("~110s. Three papers on one slide, one row each. Say it up front: deployment control is itself a collective behaviour, so the same tools apply to it — A and B are self-organising policies written as macro-programs, C is a planner. A: one threshold, one component; the two charts in the paper say where the cost lands — the offloaded devices have more battery, not less, so the price is paid in messages. B: quality of service is the share of devices that manage to offload at all; the field-based policy beats the nearest-hop baseline once its regions settle, and can dip below it during the transient. It helps more on scale-free than on lobster topologies, because removing a node from a lobster network segments it. C: joint work with Brogi and Forti in Pisa — roughly a third of the energy at every network size, and the baseline's carbon tracks the day-night sinusoid exactly because its deployment never changes. Then land the last line: every row is hand-written, and that is the requirement the next slide drops.")

