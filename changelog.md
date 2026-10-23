# Changelog

## 0.13.0

2026-10-22

* Common Weal Press artwork in the package (`press/`): the woodcut seal
  (`press-seal`, `press-seal-knockout`, `press-seal-positive`, any colours)
  and the device, the seal's fountain in its town square with "Drink
  freely" and "Let the one who is thirsty come" (Rev. 22:17) on the ribbons
  (`press-device`), with the public-domain badge.
* `publisher-page(note:, isbn:)`: the press's publisher's page, for
  `book(publishing-info: ...)`, in place of the text each book pasted in.
  A book that does not use it is unchanged.

## 0.12.0

2026-10-15

* A list inside a numbered list item is set one step further in, so its
  numbers no longer line up with a paragraph's first-line indent and read
  on into the numbered paragraphs after it (Gouge vol. 4 p. 34, "4. Good
  will" and its four points; printed numbers kept). Only books with nested
  lists change (Gouge, Sibbes).

## 0.11.0

2026-10-14

* Footnote markers that touch ("titles223224", two margin notes on one
  word) are kept apart by a superscript comma (223,224), also across the
  space between them.
* An em dash set straight after a word stays with it, so a paragraph
  ending "phrases,—" never leaves the dash alone on a line.

## 0.10.0

2026-10-14

* `parallel`: two printed tables "laid even one against another" (Gouge's
  parallel of husbands' and wives' duties; colophon's
  table/@rend="parallel") set as two columns, the heads side by side and
  kept with the first items, then item n against item n. Used through
  `#[ ... ] <parallel>` (book() shows the label, so a chapter file needs
  no import); the text inside stays plain lines and lists. No other book changes.

## 0.9.0

2026-10-13

* A paragraph after a list is indented like any other (Typst indents only a
  paragraph that follows a paragraph, so a numbered paragraph right after a
  list read as one more item: Gouge vol. 1 pp. 107, 128). Lists and the
  space after them do not move; no book's page count changes.
* 0.8.0's rule (a bullet list no taller than half the text area kept on one
  page) is withdrawn and the 0.8.0 tag deleted (no book used it). Diagrams
  printed as lists are kept whole by colophon instead (DIAGRAM_LISTS,
  colophon 0.12.0), and other lists break as text does.

## 0.8.0

2026-10-12

* A bullet list no taller than half the text area is kept on one page
  (Perkins's family trees were cut in two across pages 41-42). Longer lists
  break as before. Pages reflow in books with bullet lists (Perkins, Brooks's
  Secret Key, Gouge).

## 0.7.0

2026-10-12

* `font-size` (default 11pt, was a fixed 12pt): the body text size, which
  the title page, contents and other em sizes follow. A book that must keep
  its pages as they were passes `font-size: 12pt` (Simon Magus). Pages
  reflow: a book on the default changes page count, cover and spine.

## 0.6.2

2026-10-11

* `#speech[...]`: a speech in dialogue, its first line at the margin and the
  rest hung 2em (colophon's SPEECH_BLOCKS; Pilgrim's Progress).
* `#stanza[...]`: a stanza of a section made of verse, unindented, ragged,
  1.2em apart (colophon's STANZA_BLOCKS).

## 0.6.1

2026-10-11

* A running head too long for one line (Libertinus's small capitals are
  wider than Liberation's lower case) is set smaller, down to 70%, instead of
  wrapping onto a second line within 0.5in of the trim.

## 0.6.0

2026-10-11

* The text font is Libertinus Serif (was Liberation Serif). It has real small
  capitals, so the title page, contents, running heads and chapter titles,
  which always asked for `smallcaps`, now get them, as does `#smallcaps[...]`
  in the text (CCEL's small capitals: Owen's "Fourthly", LORD). It covers
  every Greek and pointed Hebrew character the books use. Pages reflow: a
  book's page count, cover and spine change when it moves to 0.6.0.

## 0.5.5

2026-10-09

* Aligned text (`#align(center)[...]`, `#align(right)[...]`, a signature) is
  not justified or hyphenated: a long valediction set right is ragged on the
  left. This also makes 0.5.4's rule for centered text work: its
  `align.where(alignment: center)` selector never matched.

## 0.5.4

2026-10-07

* Level 3 and 4 headings are sticky: never left at the foot of a page apart
  from their text (manual page breaks before headings are no longer needed)
* Level 3 and 4 headings are no longer indented when they follow a
  paragraph, and the paragraph after a heading is not indented
* Centered text (`#align(center)[...]`) is not justified, so a centered
  paragraph of two lines is centered line by line, unhyphenated
* The package description says 5.5x8.5, the trim the template has always
  defaulted to (6x9 is for books that ask for it: the Gill commentary)

## 0.5.3

2026-10-02

* Running head 0.5in from the trim (Lulu's safety margin): top margin 0.9in,
  bottom 0.6in (the text block is the same height, so books do not reflow),
  new `header-ascent` parameter (0.15in)

## 0.5.2

2026-05-31

* level 4 header improvement

## 0.5.0

2026-02-01

* Add foreword section
* Make the front page prettier
* Some heading fixes based on what page we are on
