\include "common/global.ily"
\paper {
  \include "common/paper.ily"
  ragged-bottom = ##t
  systems-per-page = #(cond (is-eogsized 2) (#t #f))
  page-count = #(cond (is-eogsized 2) (#t #f))
  system-count = #(cond (is-eogsized 3) (#t #f))
}

\header{
  hymnnumber = "361"
  title = "There Is a Happy Land"
  tunename = "Happy Land" % similar to EOG056
  meter = "6. 4. 6. 4. 6. 7. 6. 4."
  poet = "Andrew Young"
  composer = ""
  tagline = ##f
}

global = {
  \include "common/overrides.ily"
  \override Staff.TimeSignature.style = #'numbered
  \time 4/4
  \override Score.MetronomeMark.transparent = ##t % hide all fermata changes too
  \tempo 4=140
  \key ees \major % EOG056 is in `f`
  \autoBeamOff
}

patternAA = { c2     c4 c4 | c4 c4 c2 }
patternAB = { c4. c8 c4 c4 | c4 c4 c2 }
patternAC = { c4( c) c4 c4 | c4 c4 c2 }

patternBA = { c2 c4. c8 | c1 }

notesSoprano = {
\global
\transpose f ees
\relative c'' {

  \changePitch \patternAA { a a g | a c c }
  \changePitch \patternBA { a a g | f }
  \changePitch \patternAA { a a g | a c c }
  \changePitch \patternBA { a a g | f }

  \changePitch \patternAA { f' f d | d c c }
  \changePitch \patternAB { a g a c | d c c }
  \changePitch \patternAA { f f d | d c c }
  \changePitch \patternBA { a a g | f }

  \bar "|."

}
}

notesAlto = {
\global
\transpose f ees
\relative e' {

  \changePitch \patternAA { f f e | f f f }
  \changePitch \patternBA { f e e | f }
  \changePitch \patternAA { f f e | f f f }
  \changePitch \patternBA { f e e | f }

  \changePitch \patternAA { f f f | f f f }
  \changePitch \patternAB { f e f f | f f f }
  \changePitch \patternAA { f f f | f f f }
  \changePitch \patternBA { f e e | f }

}
}

notesTenor = {
\global
\transpose f ees
\relative a {

  \changePitch \patternAA { c c c | c c c }
  \changePitch \patternBA { c bes bes | a }
  \changePitch \patternAA { c c c | c c c }
  \changePitch \patternBA { c bes bes | a }

  \changePitch \patternAA { c d bes | bes a a }
  \changePitch \patternAB { c c c c | bes a a }
  \changePitch \patternAC { a( bes) c d | d e f }
  \changePitch \patternBA { c bes bes | a }

}
}

notesBass = {
\global
\transpose f ees
\relative f {

  \changePitch \patternAA { f f c | f a a }
  \changePitch \patternBA { c c, c | f }
  \changePitch \patternAA { f f c | f a a }
  \changePitch \patternBA { c c, c | f }

  \changePitch \patternAA { a bes bes | f f f }
  \changePitch \patternAB { f c f a | bes f f }
  \changePitch \patternAC { f( g) a bes | bes bes a }
  \changePitch \patternBA { c c, c | f }

}
}

wordsA = \lyricmode {
\set stanza = "1."

There is a hap -- py land, \bar "."
Far, far a -- way; \bar "."
Where saints in glo -- ry stand, \bar "."
Bright, bright as day. \bar "."
O, how they sweet -- ly sing! \bar "."
Wor -- thy is the Sav -- iour King; \bar "."
Loud let His prais -- es ring, \bar "."
Praise, praise for aye. \bar "."

}

wordsB = \lyricmode {
\set stanza = "2."

Come to that hap -- py land,
Come, come a -- way–
Why will you doubt -- ing stand?
Why still de -- lay?
O, we shall hap -- py be!
When from sin and sor -- row free:
Lord, we shall live with Thee!
Blest, blest for aye.

}

\score {
  \context ChoirStaff <<
    \context Staff = upper <<
      \set Staff.autoBeaming = ##f
      \set ChoirStaff.systemStartDelimiter = #'SystemStartBar
      \set ChoirStaff.printPartCombineTexts = ##f
      \partcombine #'(2 . 9) \notesSoprano \notesAlto
      \context NullVoice = sopranos { \voiceOne << \notesSoprano >> }
      \context NullVoice = altos { \voiceTwo << \notesAlto >> }
      \context Lyrics = one   \lyricsto sopranos \wordsA
      \context Lyrics = two   \lyricsto sopranos \wordsB
    >>
    \context Staff = men <<
      \set Staff.autoBeaming = ##f
      \clef bass
      \set ChoirStaff.printPartCombineTexts = ##f
      \partcombine #'(2 . 9) \notesTenor \notesBass
      \context NullVoice = tenors { \voiceOne << \notesTenor >> }
      \context NullVoice = basses { \voiceTwo << \notesBass >> }
    >>
  >>
  \layout {
    \include "common/layout.ily"
  }
  \midi{
    \include "common/midi.ily"
  }
}

\version "2.19.49"  % necessary for upgrading to future LilyPond versions.

% vi:set et ts=2 sw=2 ai nocindent syntax=lilypond: