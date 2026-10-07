# Changelog

## 0.5.4

2026-10-07

* Level 3 and 4 headings are sticky: never left at the foot of a page apart
  from their text (manual page breaks before headings are no longer needed)
* Level 3 and 4 headings are no longer indented when they follow a
  paragraph, and the paragraph after a heading is not indented
* Centered text (`#align(center)[...]`) is not justified, so a centered
  paragraph of two lines is centered line by line, unhyphenated

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
