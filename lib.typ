// This function gets your whole document as its `body` and formats
// it as a simple book.
#let book(
  // The book's title.
  title: [Book title],
  subtitle: none,

  // The book's author.
  author: none,

  // A dedication to display on the third page.
  dedication: none,

  // Details about the book's publisher that are
  // display on the second page.
  publishing-info: none,

  // Preface by author
  preface: none,

  // Page dimensions
  page-width: 5.5in,
  page-height: 8.5in,
  page-margin: (bottom: 0.75in, top: 0.75in, outside: 0.625in, inside: 0.875in),

  // Make outline optional - good for small books with no chapters  
  show-outline: true,

  // The book's content.
  body,
) = {
  // Creates a pagebreak to the given parity where empty pages
  // can be detected via `is-page-empty`.
  let detectable-pagebreak(to: "odd") = {
    [#metadata(none) <empty-page-start>]
    pagebreak(to: to)
    [#metadata(none) <empty-page-end>]
  }

  // Workaround for https://github.com/typst/typst/issues/2722
  let is-page-empty() = {
    let page-num = here().page()
    query(<empty-page-start>)
      .zip(query(<empty-page-end>))
      .any(((start, end)) => {
        (start.location().page() < page-num
          and page-num < end.location().page())
      })
  }

  // Set the document's metadata.
  set document(title: title, author: if author != none { author } else { () })

  // set text(font: "Libertinus Serif")
  set text(font: "Liberation Serif", size: 12pt)

  // Configure the page properties.
  set page(
    width: page-width,
    height: page-height,
    margin: page-margin,
  )

  // The first page.
  show std.title: set text(size: 22pt)
  show std.title: strong
  page(align(center + horizon, {
    std.title()
    v(2em, weak: true)
    if subtitle != none {
      text(1.0em, subtitle)
    }
    v(2em, weak: true)
    if author != none {
      text(1.6em, author)
    }
  }))

  // Display publisher info at the bottom of the second page.
  if publishing-info != none {
    align(center + bottom, text(0.8em, publishing-info))
  }

  pagebreak()

  // Display the dedication at the top of the third page.
  if dedication != none {
    v(15%)
    align(center, strong(dedication))
  }

  // Books like their empty pages.
  pagebreak(to: "odd")

  if preface != none {
    preface
  }

  // Books like their empty pages.
  pagebreak(to: "odd")

  // Configure paragraph properties.
  set par(spacing: 1.5em, leading: 0.78em, first-line-indent: 12pt, justify: true)

  // Start with a chapter outline.
  // Use short titles in the outline if available
  if show-outline {
    show outline.entry.where(level: 1): it => {
      let loc = it.element.location()
      v(1em)
      text(1.1em, weight: 600, smallcaps(link(loc, it.element.body)))
      h(1fr)
      text(1.1em, weight: 600, link(loc, str(loc.page())))
      linebreak()
    }
    show outline.entry.where(level: 2): it => {
      let loc = it.element.location()
      let all-short = query(<short>)
      let all-h2 = query(heading.where(level: 2))
      let has-h1 = query(heading.where(level: 1)).len() > 0

      // Find this heading's index in the list of all level 2 headings
      let idx = all-h2.position(h => h.location() == loc)

      // Get the corresponding short title by index
      let title = if idx != none and idx < all-short.len() {
        all-short.at(idx).value
      } else {
        it.element.body
      }

      // Indent if level 1 headings exist
      let indent = if has-h1 { 1.5em } else { 0em }

      pad(left: indent, link(loc)[
        #title
        #box(width: 1fr, it.fill)
        #loc.page()
        #linebreak()
      ])
    }
    outline(title: [Chapters], depth: 2)
  }
  pagebreak(to: "odd", weak: true)

  set quote(block: true)

  // Configure page properties.
  set page(
    width: page-width,
    height: page-height,
    margin: (..page-margin, top: 0.6in),
    // The header always contains the book chapter title on odd pages and
    // the book title on even pages, unless
    // - we are on an empty page
    // - we are on a page that starts a chapter
    header: context {
      // Is this an empty page inserted to keep page parity?
      if is-page-empty() {
        return
      }

      // Are we on a page that starts a chapter?
      let i = here().page()
      if query(heading.where(level: 2)).any(it => it.location().page() == i) {
        return
      }

      // Get the short chapter title from metadata
      let short-title = {
        let meta-query = query(selector(metadata).before(here()))
          .filter(it => it.value != none and it.label == <short>)
        if meta-query.len() > 0 {
          meta-query.last().value
        } else {
          // Fallback to chapter heading if no metadata found
          let before = query(selector(heading.where(level: 2)).before(here()))
          if before != () {
            before.last().body
          }
        }
      }

      if short-title != none {
        set text(0.9em)
        let chapter-header = smallcaps(short-title)
        let book-title = smallcaps(title)
        set heading(numbering: "1.1")
        show heading.where(level: 1): it => pagebreak(weak: true) + it
        grid(
          columns: (1fr, 10fr, 1fr),
          align: (left, center, right),
          row-gutter: 0pt,
          if calc.even(i) [#i],
          if calc.even(i) { book-title } else { chapter-header },
          if calc.odd(i) [#i],
        )
        v(-0.4em)
        line(length: 100%, stroke: 0.5pt)
      }
    },
  )

  // Configure part/section headings (level 1).
  show heading.where(level: 1): it => {
    // Part pages start on odd pages
    detectable-pagebreak(to: "odd")

    // Create the heading numbering
    let number = if it.numbering != none {
      counter(heading).display(it.numbering)
    }

    page(header: none, align(center + horizon, {
      if number != none {
        text(14pt, tracking: 0.2em, upper[Part #number])
        v(1.5em)
      }
      line(length: 30%, stroke: 0.75pt)
      v(1em)
      text(28pt, weight: 700, smallcaps(it.body))
      v(1em)
      line(length: 30%, stroke: 0.75pt)
    }))
  }

  // Configure chapter headings.
  show heading.where(level: 2): it => {
    // Always start on odd pages.
    detectable-pagebreak(to: "odd")

    // Create the heading numbering.
    let number = if it.numbering != none {
      counter(heading).display(it.numbering)
      h(7pt, weak: true)
    }

    v(5%)
    set par(justify: false)
    align(center, text(22pt, weight: 700, hyphenate: false, [#number#it.body]))
    v(2.5em)
  }

  // Configure level 3 headings.
  show heading.where(level: 3): it => {
    let number = if it.numbering != none {
      counter(heading).display(it.numbering)
      h(7pt, weak: true)
    }

    v(1em)
    text(1.2em, weight: 600, [#number #it.body])
    v(0.75em)
  }

  show heading: set text(11pt, weight: 400)

  body
}
