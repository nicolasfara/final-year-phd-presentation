#import "@preview/fontawesome:0.6.0": *

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

#let styled-block(
  title, 
  content, 
  icon: "", 
  fill-color: rgb("#23373b").lighten(90%),
  stroke-color: rgb("#23373b").lighten(50%),
  title-color: rgb("#000000"),
  title-size: 20pt
) = {
  block(
    width: 100%,
    inset: (x: 24pt, y: 18pt),
    fill: fill-color,
    radius: 8pt,
    stroke: (
      paint: stroke-color, 
      thickness: 1pt,
      dash: "solid"
    ),
    [
      #text(weight: "bold", size: title-size, fill: title-color)[#icon #title]
      #v(-12pt)
      #line(length: 100%, stroke: (paint: stroke-color, thickness: 1.5pt))
      #v(-10pt)
      #content
    ]
  )
}

/// Blocks
#let feature-block(title, content, icon: "") = {
  styled-block(
    title, 
    content, 
    icon: icon,
    fill-color: rgb("#23373b").lighten(90%),
    stroke-color: rgb("#23373b").lighten(50%),
    title-size: 22pt
  )
}

#let note-block(title, content, icon: fa-info-circle() + " ") = {
  styled-block(
    title, 
    content, 
    icon: icon,
    fill-color: rgb("#fffde7"),
    stroke-color: rgb("#ffecb3"),
  )
}

#let warning-block(title, content, icon: fa-exclamation-triangle() + " ") = {
  styled-block(
    title, 
    content, 
    icon: icon,
    fill-color: rgb("#fff3e0"),
    stroke-color: rgb("#ffcc80"),
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

#let chip(body, fill: orange.lighten(85%), stroke: orange.lighten(40%)) = box(
  inset: (x: .65em, y: .32em),
  radius: 4pt,
  fill: fill,
  stroke: (paint: stroke, thickness: .7pt),
  text(size: .72em, weight: "medium", fill: ink)[#body],
)

#let statement(body, fill: soft, stroke: orange) = block(
  width: 100%,
  inset: (x: .95em, y: .65em),
  radius: 5pt,
  fill: fill,
  stroke: (paint: stroke.lighten(35%), thickness: .8pt),
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

#let step-item(n, label, body) = block(width: 100%)[
  #grid(
    columns: (auto, 1fr),
    column-gutter: .45em,
    row-gutter: .5em,
    align: (center + horizon, left + horizon),
    chip(n, fill: ink.lighten(88%), stroke: ink.lighten(58%)),
    text(size: 0.95em, weight: "medium", fill: ink)[#label],
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

/// A CeTZ node for one pulverisation component. Symbol and name sit on a single
/// line so the label always fits inside the box.
///
/// Must be called inside a `cetz.canvas` block, passing the `cetz.draw` module.
#let pulv-node(draw, pos, symbol, name, color, width: 3.9, height: 0.85) = {
  let (x, y) = pos
  draw.rect(
    (x - width / 2, y - height / 2),
    (x + width / 2, y + height / 2),
    radius: .1,
    fill: color.lighten(88%),
    stroke: (paint: color.lighten(30%), thickness: .9pt),
  )
  draw.content(
    pos,
    box[
      #text(size: .46em, weight: "medium", fill: color.darken(18%))[#symbol]
      #h(.4em)
      #text(size: .38em, fill: ink.lighten(10%))[#name]
    ],
    anchor: "center",
  )
}
