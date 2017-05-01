\include "common/global.ily"
\paper {
  \include "common/paper.ily"
  ragged-last-bottom = ##t
}

\header{
  hymnnumber = "329"
  title = "A Little Lamb Went Straying"
  tunename = "Springfield"
  meter = "7. 6. 7. 6. D."
  poet = "Albert Midlane"
  composer = "J. C. F. Haeffner"
  tagline = ##f
}

global = {
  \include "common/overrides.ily"
  \override Staff.TimeSignature.style = #'numbered
  \time 4/4
  \override Score.MetronomeMark.transparent = ##t % hide all fermata changes too
  \tempo 4=90
  \key bes \major
  \partial 4
  \autoBeamOff
}

notesSoprano = {
\global
\relative c' {

  f4 | f d8[ ees] f4 g | f2 d4
  f4 | g g a a | bes2 r4
  d4 | c a8[ bes] c4 d | c2 a4
  a4 | bes bes g g | f2 r4
  f4 | f f a a | c2 a4
  f4 | bes bes c d | ees2.
  ees4 | d d bes bes | g2 ees4
  ees4 | f f f g8[ a] | bes2.

  \bar "|."

}
}

notesAlto = {
\global
\relative e' {

  d4 | d bes8[ c] d4 ees | d2 bes4
  d4 | ees ees ees ees | d2 r4
  f4 | f f f f | f2 f4
  f4 | g g e e | f2 r4
  f4 | f f f f | g2 f4
  f4 | f g a bes | a2.
  f4 | f f f f | ees2 ees4
  ees4 | d d c ees | d2.

}
}

notesTenor = {
\global
\relative a {

  bes4 | bes bes bes bes | bes2 bes4
  bes4 | bes bes c c | bes2 r4
  bes4 | a f8[ g] a4 bes | a2 c4
  c4 | d d bes bes | a2 r4
  f4 | a a c c | c2 c4
  f,4 | d'4 d c bes | c2.
  a4 | bes bes bes bes | bes2 g4
  bes4 | bes bes a c | bes2.

}
}

notesBass = {
\global
\relative f, {

  bes4 | bes bes bes bes | bes2 bes4
  bes4 | ees ees c f | bes,2 r4
  bes4 | f'4 f f f | f2 f4
  f4 | bes, bes c c | f2 r4
  f4 | f f f f | ees2 f4
  f4 | f f f f | f2.
  f4 | bes, bes d d | ees2 ees4
  g4 | f f f f | bes,2.

}
}

wordsA = \lyricmode {
\set stanza = "1."

A lit -- tle lamb went stray -- ing \bar "."
A -- mong the hills one day, \bar "."
Leav -- ing its faith -- ful shep -- herd, \bar "."
Be -- cause it loved to stray. \bar "."
And while the sun shone bright -- ly, \bar "."
It knew no thought of fear, \bar "."
For flowers a -- round were bloom -- ing, \bar "."
And balm -- y was the air. \bar "."

}

wordsB = \lyricmode {
\set stanza = "2."

But night came o -- ver quick -- ly,
The hol -- low breez -- es blew,
The sun soon ceased its shin -- ing,
All dark and dis -- mal grew.
The lit -- tle lamb stood bleat -- ing,
And well in -- deed it might,
So far from home and shep -- herd,
And on so dark a night.

}

wordsC = \lyricmode {
\set stanza = "3."

But, ah! the faith -- ful shep -- herd
Soon missed the lit -- tle thing,
And on -- ward went to seek it,
And home a -- gain to bring.
He sought on hill and val -- ley,
And called it by its name;
He sought, nor ceased his seek -- ing,
Un -- til he found his lamb.

}

wordsD = \markuplist {

\line { Then to his gentle bosom }
\line { The little lamb he pressed, }
\line { And on his shoulders bore it, }
\line { And fondly it caressed. }
\line { The little lamb was happy }
\line { To find itself secure; }
\line { The shepherd, too, was joyful, }
\line { Because his lamb he bore. }

}

wordsE = \markuplist {

\line { And now, dear little children, }
\line { A Shepherd’s up on high, }
\line { Who came to seek the straying, }
\line { Who all deserved to die. }
\line { For sin each lamb had ruined, }
\line { And far from God had led; }
\line { But O! what love unbounded! }
\line { He suffered in their stead. }

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

\markup { \fill-line {
  \hspace #0.1
  \line{ \bold 4 \column { \wordsD } }
  \hspace #0.1
  \line{ \bold 5 \column { \wordsE } }
  \hspace #0.1
} }

\noPageBreak \markup { \vspace #2 \fill-line { \raise #2 \line { Alternate tune: No. 328. } } }

\version "2.19.49"  % necessary for upgrading to future LilyPond versions.

% vi:set et ts=2 sw=2 ai nocindent syntax=lilypond: