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

  // Foreword (typically by someone other than the author)
  foreword: none,

  // Preface by author
  preface: none,

  // Page dimensions
  page-width: 5.5in,
  page-height: 8.5in,
  // The running head sits in the top margin, header-ascent above the text,
  // so the top margin is the deeper one: with these, the head is 0.5in from
  // the trim (Lulu's safety margin) and nothing prints in the bottom margin.
  // The inside margin should follow Lulu's table for the page count (0.625in
  // for 61-150 pages, 1in for 151-400, 1.125in for 401-600); ./fgb build
  // checks it.
  page-margin: (bottom: 0.6in, top: 0.9in, outside: 0.75in, inside: 0.875in),
  header-ascent: 0.15in,

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

  // The first page - title page with elegant styling
  page(align(center + horizon, {
    // Decorative top ornament
    text(1.2em, tracking: 0.5em, [~ ~ ~])
    v(2em)

    // Title in prominent smallcaps
    text(26pt, weight: 700, tracking: 0.1em, smallcaps(title))

    // Decorative line under title
    v(1.5em)
    line(length: 40%, stroke: 0.75pt)
    v(1.5em)

    // Subtitle in italics
    if subtitle != none {
      text(1.1em, style: "italic", subtitle)
      v(2em)
    }

    // Decorative flourish before author
    text(0.9em, tracking: 0.3em, sym.diamond.filled)
    v(1.5em)

    // Author in elegant smallcaps
    if author != none {
      text(1.3em, tracking: 0.15em, smallcaps(author))
    }

    // Bottom decorative element
    v(3em)
    text(1.2em, tracking: 0.5em, [~ ~ ~])
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
    pagebreak(to: "odd")
  }

  // Display the foreword with proper formatting
  if foreword != none {
    pagebreak(to: "odd", weak: true)
    v(5%)
    align(center, text(22pt, weight: 700)[Foreword])
    v(2.5em)
    set par(spacing: 0.78em, leading: 0.78em, first-line-indent: 0pt, justify: true)
    foreword
  }

  if preface != none {
    pagebreak(to: "odd", weak: true)
    preface
  }

  // Ensure body starts on odd page
  pagebreak(to: "odd", weak: true)

  // Configure paragraph properties.
  set par(spacing: 0.78em, leading: 0.78em, first-line-indent: 12pt, justify: true)

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
    margin: page-margin,
    header-ascent: header-ascent,
    // The header always contains the book chapter title on odd pages and
    // the book title on even pages, unless
    // - we are on an empty page
    // - we are on a page that starts a chapter
    header: context {
      // Is this an empty page inserted to keep page parity?
      if is-page-empty() {
        return
      }

      // Are we on a page that starts a part or chapter?
      let i = here().page()
      if query(heading.where(level: 1)).any(it => it.location().page() == i) {
        return
      }
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
    // Always start on odd pages (recto).
    detectable-pagebreak(to: "odd")

    // Create the heading numbering
    let number = if it.numbering != none {
      counter(heading).display(it.numbering)
    }

    // Part page with decorative styling
    page(header: none, {
      v(1fr)
      align(center, {
        if number != none {
          text(14pt, tracking: 0.2em, upper[Part #number])
          v(1.5em)
        }
        line(length: 30%, stroke: 0.75pt)
        v(1em)
        text(28pt, weight: 700, smallcaps(it.body))
        v(1em)
        line(length: 30%, stroke: 0.75pt)
      })
      v(1fr)
      // Mark for detecting blank verso after part page
      [#metadata(none) <empty-page-start>]
    })
    pagebreak(to: "odd", weak: true)
    [#metadata(none) <empty-page-end>]
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

  // Configure level 4 headings.
  show heading.where(level: 4): it => {
    let number = if it.numbering != none {
      counter(heading).display(it.numbering)
      h(7pt, weak: true)
    }

    v(0.75em)
    text(11pt, weight: 700, [#number #it.body])
    v(0.4em)
  }

  show heading: set text(11pt, weight: 400)

  body
}
