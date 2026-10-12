# Changelog

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
