\include "common/global.ily"
\paper {
  \include "common/paper.ily"
  ragged-last-bottom = ##t
  system-count = #(cond (is-eogsized 3) (#t #f))
  system-system-spacing.padding = 11
}

\header{
  hymnnumber = "3"
  title = "Hail, Sovereign Love"
  tunename = "Cyprus"
  meter = "L. M."
  composer = "Lowell Mason"
  tagline = ##f
}

ta = { \tempo 2=100 }
tb = { \tempo 2=50 }

global = {
  \include "common/overrides.ily"
  \override Staff.TimeSignature.style = #'numbered
  \time 4/2
  \override Score.MetronomeMark.transparent = ##t % hide all fermata changes too
  \ta
  \key a \major
  \partial 1
  \autoBeamOff
}

notesSoprano = {
\global
\relative c'' {

  a1 | a2 a a a | b1 gis | a1. \bar "."
  b2 | b b cis a | gis1 fis | e1. \bar "."
  gis2 | gis gis a1 ~ | a2 b b b | cis1. \bar "."
  a2 | a a a fis | e1 b' | \tb a1\fermata \ta \bar "|."

}
}

notesAlto = {
\global
\relative e' {

  e1 | e2 e fis fis | fis1 e | e1.
  e2 | e e e e | e1 dis | e1.
  eis2 | eis eis fis1 ~ | fis2 gis gis gis | a1. % original fails to extend sharp into next measure
  e2 | e e fis d | cis1 d | cis

}
}

notesTenor = {
\global
\relative a {

  cis1 | cis2 cis cis cis | d1 b | cis1.
  gis2 | gis gis a cis | b1 a | gis1.
  cis2 | cis cis cis1 ~ | cis2 e e e | e1.
  a,2 | a a a a | a1 gis | a1

}
}

notesBass = {
\global
\relative f {

  a1 | a2 a fis fis | d1 e | a,1.
  e'2 | e e a, a | b1 b | e1.
  cis2 | cis cis fis1 ~ | fis2 e e e | a1.
  cis,2 | cis cis d d | e1 e | a,1_\fermata % original does not have fermata in bass clef

}
}

\score {
  \context ChoirStaff <<
    \context Staff = upper <<
      \set Staff.autoBeaming = ##f
      \set ChoirStaff.systemStartDelimiter = #'SystemStartBar
      \set ChoirStaff.printPartCombineTexts = ##f
      \partcombine #'(2 . 9) \notesSoprano \notesAlto
    >>
    \context Staff = men <<
      \set Staff.autoBeaming = ##f
      \clef bass
      \set ChoirStaff.printPartCombineTexts = ##f
      \partcombine #'(2 . 9) \notesTenor \notesBass
    >>
  >>
  \layout {
    \include "common/layout.ily"
  }
  \midi{
    \include "common/midi.ily"
  }
}

\noPageBreak \markup { \fill-line { "Alternate tune for No. 88." } }

\version "2.19.49"  % necessary for upgrading to future LilyPond versions.

% vi:set et ts=2 sw=2 ai nocindent syntax=lilypond:
