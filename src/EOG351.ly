\include "common/global.ily"
\paper {
  \include "common/paper.ily"
  ragged-last-bottom = ##t
  %systems-per-page = ##f
  %page-count = #(cond (is-eogsized 2) (#t #f))
}

\header{
  hymnnumber = "351"
  title = "One Door and Only One"
  tunename = ""
  meter = ""
  poet = ""
  composer = ""
  tagline = ##f
}

global = {
  \include "common/overrides.ily"
  \override Staff.TimeSignature.style = #'numbered
  \time 4/4
  \override Score.MetronomeMark.transparent = ##t % hide all fermata changes too
  \tempo 4=80
  \key g \major
  \autoBeamOff
}

patternA = { c4 c8. c16 c8. c16 c8. c16 | c8. c16 c8. c16 c2 | }
patternB = { c4 c8. c16 c4 c8. c16 | c4 c8. c16 c2 | }

notesSoprano = {
\global
\relative c'' {

  \changePitch \patternA { g d d g g d d | g a b c d | }
  \changePitch \patternB { e c e d b g | b a b a | }
  \changePitch \patternA { g d d g g d d | g a b c d | }
  \changePitch \patternB { e-> c e d b g | b b a g | }

  \bar "|."

}
}

notesAlto = {
\global
\relative e' {

  \changePitch \patternA { d d d d d d d | d d g g g | }
  \changePitch \patternB { g g g g g g | g e e fis | }
  \changePitch \patternA { d d d d d d d | d fis g a b | }
  \changePitch \patternB { c g c b g g | g g fis g | }

}
}

notesTenor = {
\global
\relative a {

  \changePitch \patternA { b b b b b b b | b c d d d | }
  \changePitch \patternB { c c c b d d | d cis cis d | }
  \changePitch \patternA { b b b b b b b | b d d d d | }
  \changePitch \patternB { c e c d d e | d d c b | }

}
}

notesBass = {
\global
\relative f {

  \changePitch \patternA { g g g g g g g | g g g a b | }
  \changePitch \patternB { c c, c g' g g | g a a d, | }
  \changePitch \patternA { g g g g g g g | g d g g g | }
  \changePitch \patternB { c c c g g c, | d d d g | }

}
}

wordsA = \lyricmode {

One door and on -- ly one, and yet its sides are two, \bar "."
In -- side and out -- side; on which side are you? \bar "."
One door and on -- ly one, and yet its sides are two. \bar "."
I’m on the in -- side; on which side are you? \bar "."

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