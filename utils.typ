#import "@preview/fontawesome:0.6.0": *
#import "@preview/codly:1.3.0": codly, local as codly-local

/// #mail
///
/// - email (str): the email address of the author
/// -> (block): a block containing the email address
#let mail(email) = {
  text(size: 1.2em)[#raw(email)]
}

/// 
/// - name (str): the name of the author
/// -> (block): a block containing the name of the author
#let first_author(name) = {
  strong(name)
}

/// #author_list
///
/// - authors (list of tuples): a list of tuples containing names and emails
/// -> (block): a block containing the authors' information
#let author_list(authors, logo: none, width: 35%) = block[
  #table(
    inset: (0em, 0em), column-gutter: 1em, row-gutter: 0.75em, stroke: none, columns: (auto, 4fr), align: (left, left),
    ..authors.map((record) => (record.at(0), mail(record.at(1)))).flatten()
  )
  #if logo != none {
    place(right)[
      #figure(image(logo, width: width))
    ]
  }
  #v(1em)
]

/// #bold
///
/// - content (block): the content to be displayed in bold
/// -> (block): a block containing the bolded content
#let bold(content) = {
  text(weight: "bold")[#content]
}

// Compact, modern callout: a flat tint with a single accent-coloured left
// edge instead of a full border, and no separator line under the title —
// title and body are spaced with one weak gap so it never wastes space.
#let styled-block(
  title,
  content,
  icon: "",
  fill-color: rgb("#23373b").lighten(94%),
  stroke-color: rgb("#23373b").lighten(45%),
  title-color: rgb("#000000"),
  title-size: 1em,
  body-size: .78em,
) = block(
  width: 100%,
  inset: (left: 16pt, right: 16pt, top: 10pt, bottom: 11pt),
  fill: fill-color,
  // Round only the corners away from the accent bar: rounding all four
  // while stroking just the left edge makes that stroke mitre into a
  // diagonal spike at the top/bottom-left corners.
  radius: (top-right: 5pt, bottom-right: 5pt),
  stroke: (left: (paint: stroke-color, thickness: 2.6pt)),
)[
  #text(weight: "bold", size: title-size, fill: title-color)[
    #if icon != "" {
      icon
    }
    #title
  ]
  #v(.7em, weak: true)
  #text(size: body-size)[#content]
]

/// Blocks
#let feature-block(title, content, icon: "") = {
  styled-block(
    title,
    content,
    icon: icon,
    fill-color: rgb("#23373b").lighten(94%),
    stroke-color: rgb("#23373b").lighten(45%),
    title-size: 1.1em,
    body-size: .82em,
  )
}

#let note-block(title, content, icon: fa-info-circle() + " ") = {
  styled-block(
    title,
    content,
    icon: icon,
    fill-color: rgb("#fffde7"),
    stroke-color: rgb("#ffca28"),
  )
}

#let warning-block(title, content, icon: fa-exclamation-triangle() + " ") = {
  styled-block(
    title,
    content,
    icon: icon,
    fill-color: rgb("#fff3e0"),
    stroke-color: rgb("#fb8c00"),
    title-color: rgb("#e65100"),
  )
}

// Presentation palette and compact slide components.
#let orange = rgb("#eb811b")
#let ink = rgb("#23373b")
#let soft = rgb("#f7f4ef")
#let blue = rgb("#2a6f97")
#let green = rgb("#517f4a")
#let red = rgb("#b64b4b")

// Code blocks ---------------------------------------------------------------
//
// Touying renders every slide in its own context, so a `codly(..)` call made
// once at the top of the document would not survive to the slides. The whole
// configuration therefore lives here and is replayed from the theme's
// `preamble`, which touying re-runs for each slide.
#let codly-setup() = codly(
  // Slides show a handful of lines, already introduced by the surrounding
  // text: line numbers, the zebra stripes and the language tag would all be
  // furniture the audience has no use for.
  display-icon: false,
  display-name: false,
  number-format: none,
  zebra-fill: none,
  fill: luma(248),
  stroke: .6pt + ink.lighten(78%),
  radius: 10pt,
  inset: (x: .6em, y: .25em),
  // A snippet that splits across a slide boundary is a snippet that no longer
  // fits, and re-indenting a wrapped line hides that from us.
  smart-indent: false,
  breakable: false,
  // Highlights are the pointer: a pale tint with a thin edge, inset tightly so
  // that marks on consecutive lines sit apart instead of touching.
  highlight-radius: 3pt,
  highlight-inset: (x: .25em, y: .08em),
  highlight-outset: (x: 0pt, y: .06em),
  highlight-fill: color => color.lighten(86%),
  highlight-stroke: color => .7pt + color.lighten(40%),
)

/// #code
///
/// A code block for a slide. Every named argument other than `size` is a codly
/// setting — `highlights`, `annotations`, `range`, ... — applied to this block
/// alone and restored afterwards, so a snippet never inherits the highlights of
/// the previous one and no explicit reset is needed.
///
/// - body (content): a raw block, normally a fenced ```` ```scala ... ``` ```` literal
/// - size (length): size of the snippet, relative to the slide text size
/// -> (content): the styled code block
#let code(body, size: 1em, ..settings) = codly-local(text(size: size, body), ..settings)

#let chip(body, fill: orange.lighten(85%), stroke: orange.lighten(40%)) = box(
  inset: (x: .65em, y: .32em),
  radius: 4pt,
  fill: fill,
  stroke: (paint: stroke, thickness: .7pt),
  text(size: .72em, weight: "medium", fill: ink)[#body],
)

// The take-away: the sentence a slide is meant to leave behind. Every other
// panel --- callout, mini-card, chip --- is a pale tint held by a thin outline
// or a left edge, so this one carries no outline at all and is capped by a
// solid accent rule instead, which reads as a banner rather than one more box.
// Only the corners away from that rule are rounded: rounding all four would
// make the cap mitre into diagonal spikes at the top.
#let statement(body, accent: orange) = block(
  width: 100%,
  inset: (x: .95em, top: .6em, bottom: .7em),
  radius: (bottom-left: 5pt, bottom-right: 5pt),
  fill: accent.lighten(88%),
  stroke: (top: (paint: accent, thickness: 3pt)),
)[
  #text(size: .92em, weight: "medium", fill: ink)[#body]
]

#let mini-card(title, body, color: orange) = block(
  width: 100%,
  inset: (x: .75em, y: .62em),
  radius: 5pt,
  fill: color.lighten(90%),
  stroke: (paint: color.lighten(42%), thickness: .7pt),
)[
  #text(size: .74em, weight: "medium", fill: color.darken(12%))[#title]
  #v(.12em)
  #text(size: .7em, fill: ink)[#body]
]

// A gap is an absence, so it is drawn as a hole rather than as one more panel:
// no tint, a dashed accent outline and a muted body, against the solid fill of
// `mini-card`. The title keeps the accent and a leading cross, so the three
// still scan as one group and each one reads as something that is missing.
#let gap-card(title, body, color: red) = block(
  width: 100%,
  inset: (x: .78em, y: .66em),
  radius: 5pt,
  fill: none,
  stroke: (paint: color.lighten(38%), thickness: .8pt, dash: "dashed"),
)[
  #text(size: 1em, weight: "medium", fill: color.darken(8%))[
    #box(baseline: .06em)[#text(size: .9em)[#sym.times]]~#title
  ]
  #v(.12em)
  #text(size: .75em, fill: ink.lighten(22%))[#body]
]

#let placeholder(title, body: [drop-in figure], height: 63%) = block(
  width: 100%,
  height: height,
  inset: 1em,
  radius: 6pt,
  fill: luma(248),
  stroke: (paint: luma(170), thickness: 1pt, dash: "dashed"),
  align(center + horizon)[
    #text(size: .9em, weight: "medium", fill: ink.lighten(15%))[#title]
    #linebreak()
    #text(size: .68em, fill: ink.lighten(42%))[#body]
  ],
)

// `accent` ties the item to a code highlight of the same colour: the chip and
// the label pick it up, the explanation stays in ink so the tint stays a cue
// rather than a second voice. Without it the item is neutral, as before.
#let step-item(n, label, body, accent: none) = block(width: 100%)[
  #grid(
    columns: (auto, 1fr),
    column-gutter: .45em,
    row-gutter: .5em,
    align: (center + horizon, left + horizon),
    if accent == none {
      chip(n, fill: ink.lighten(88%), stroke: ink.lighten(58%))
    } else {
      chip(n, fill: accent.lighten(85%), stroke: accent.lighten(40%))
    },
    text(
      size: 0.95em,
      weight: "medium",
      fill: if accent == none { ink } else { accent.darken(25%) },
    )[#label],
    [],
    text(size: .8em, fill: ink.lighten(12%))[#body],
  )
]

#let support-chip(kind) = {
  if kind == "native" {
    chip([native], fill: green.lighten(88%), stroke: green.lighten(35%))
  } else if kind == "pattern" {
    chip([pattern], fill: blue.lighten(88%), stroke: blue.lighten(38%))
  } else {
    chip([absent], fill: red.lighten(88%), stroke: red.lighten(40%))
  }
}

#let comparison-header(body, inset: (x: .55em, y: .45em)) = table.cell(
  fill: ink,
  align: center + horizon,
  inset: inset,
)[#text(fill: white, weight: "medium", size: .78em)[#body]]

#let comparison-label(body, fill: luma(252), inset: (x: .7em, y: .5em)) = table.cell(
  fill: fill,
  align: left + horizon,
  inset: inset,
)[#text(weight: "medium", size: .78em, fill: ink)[#body]]

#let comparison-cell(body, fill: luma(252), inset: (x: .5em, y: .5em)) = table.cell(
  fill: fill,
  align: center + horizon,
  inset: inset,
)[#body]

// ---------------------------------------------------------------------------
// Deck-specific helpers
// ---------------------------------------------------------------------------

/// A small right-aligned timing cue for section dividers, so the running order
/// stays visible while rehearsing.
#let timing-chip(body) = align(right)[
  #chip(body, fill: ink.lighten(90%), stroke: ink.lighten(60%))
]

/// A CeTZ node for one pulverisation component: a rounded square carrying the
/// Greek symbol, with the component name set underneath it.
///
/// Must be called inside a `cetz.canvas` block, passing the `cetz.draw` module.
#let pulv-node(draw, pos, symbol, name, color, size: 1.2) = {
  let (x, y) = pos
  draw.rect(
    (x - size / 2, y - size / 2),
    (x + size / 2, y + size / 2),
    radius: .18,
    fill: color.lighten(88%),
    stroke: (paint: color.darken(8%), thickness: 1.1pt),
  )
  draw.content(pos, text(size: .62em, weight: "medium", fill: color.darken(28%))[#symbol], anchor: "center")
  draw.content(
    (x, y - size / 2 - .3),
    text(size: .34em, fill: ink.lighten(12%))[#name],
    anchor: "center",
  )
}

/// The dashed frame grouping a set of pulverisation components, with its label
/// placed either above or below the group.
#let pulv-group(draw, a, b, label, color, label-above: true) = {
  let (x0, y0) = a
  let (x1, y1) = b
  draw.rect(
    a, b,
    radius: .15,
    fill: color.lighten(97%),
    stroke: (paint: color.lighten(45%), thickness: .9pt, dash: "dashed"),
  )
  draw.content(
    ((x0 + x1) / 2, if label-above { y1 + .36 } else { y0 - .36 }),
    text(size: .4em, weight: "medium", fill: color.darken(12%))[#label],
    anchor: "center",
  )
}
