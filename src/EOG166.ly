\include "common/global.ily"
\paper {
  \include "common/paper.ily"
  systems-per-page = ##f
  system-count = #(cond (is-eogsized 4) (#t #f)) % original has 3 systems
  oddFooterMarkup = \markup { \fill-line { \on-the-fly \first-page "Alternate tune: No. 270." } }
  score-markup-spacing.padding = 2
  score-markup-spacing.basic-distance = 2
}

\header{
  hymnnumber = "166"
  title = "In Hope We Lift Our Wishful, Longing Eyes"
  tunename = "Ellers"
  meter = "10s."
  poet = "J. G. Deck"
  composer = "Dr. E. J. Hopkins"
  tagline = ##f
}

patternAA = { c1 c2 c2 | c1 c1 | c2 c2 c2 c2 | c\breve }

global = {
  \include "common/overrides.ily"
  \override Staff.TimeSignature.style = #'numbered
  \time 4/2
  \override Score.MetronomeMark.transparent = ##t % hide all fermata changes too
  \tempo 2=100
  \key aes \major
  \autoBeamOff
}

notesSoprano = {
\global
\relative c' {

  \changePitch \patternAA { ees ees f | ees aes | aes g aes bes | c }
  \changePitch \patternAA { aes aes bes | aes c | c bes c d | ees }
  \changePitch \patternAA { ees aes, aes | des des | des bes c des | c }
  \changePitch \patternAA { aes bes aes | aes f | ees ees f ees | ees }
  \bar "|."

}
}

notesAlto = {
\global
\relative e' {

  \changePitch \patternAA { c c c | ees ees | des des des des | c }
  \changePitch \patternAA { ees ees ees | f aes | aes aes aes aes | g }
  \changePitch \patternAA { ees ees ees | g f | ees ees ees ees | ees }
  \changePitch \patternAA { c c c | bes bes | bes bes des des | c }

}
}

notesTenor = {
\global
\relative a {

  \changePitch \patternAA { aes aes aes | aes aes | ees ees f g | aes }
  \changePitch \patternAA { c c c | c c | d d c bes | bes }
  \changePitch \patternAA { aes c c | des bes | bes bes g g | aes }
  \changePitch \patternAA { aes aes aes | f aes | g g g g | aes }

}
}

notesBass = {
\global
\relative f, {

  \changePitch \patternAA { aes aes aes | c c | bes bes bes bes | aes }
  \changePitch \patternAA { aes' aes aes | f f | bes, bes bes bes | ees }
  \changePitch \patternAA { c c' c | bes aes | g g ees ees | aes, }
  \changePitch \patternAA { f' f f | des des | ees ees ees ees | aes, }

}
}

wordsA = \lyricmode {
\set stanza = "1."

In hope we lift our wish -- ful, long -- ing eyes, \bar "."
Wait -- ing to see the Morn -- ing Star a -- rise; \bar "."
How bright, how glad -- some will His ad -- vent be, \bar "."
Be -- fore the Sun shines forth in ma -- jes -- ty! \bar "."

}

wordsB = \lyricmode {
\set stanza = "2."

How will our eyes to see His face de -- light,
Whose love has cheered us thro’ the dark -- some night;
How will our ears drink in His well -- known voice,
Whose faint -- est whis -- pers make our soul re -- joice.

}

wordsC = \lyricmode {
\set stanza = "3."

No stain with -- in; no foes, or snares a -- round;
No jar -- ring notes shall there dis -- cord -- ant sound;
All pure with -- out, all pure with -- in the breast;
No thorns to wound, no toil to mar our rest.

}

wordsD = \markuplist {

\line { If here on earth the thoughts of Jesus’ love }
\line { Lift our poor hearts this weary world above; }
\line { If even here the taste of heavenly springs }
\line { So cheers the spirit, that the pilgrim sings, }

}

wordsE = \markuplist {

\line { What will the sunshine of His glory prove? }
\line { What the unmingled fulness of His love? }
\line { What hallelujahs will His presence raise? }
\line { What but one loud eternal burst of praise! }

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
      \context Lyrics = three \lyricsto sopranos \wordsC
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

\noPageBreak

\markup { \fill-line { \column {
  \line{ \bold 4 \column { \wordsD } } \combine \null \vspace #0.4
  \line{ \bold 5 \column { \wordsE } } \combine \null \vspace #0.4
} } }

\version "2.19.49"  % necessary for upgrading to future LilyPond versions.

% vi:set et ts=2 sw=2 ai nocindent syntax=lilypond:
