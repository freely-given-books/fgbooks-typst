# Changelog

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
