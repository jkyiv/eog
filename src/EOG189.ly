\include "common/global.ily"
\paper {
  \include "common/paper.ily"
}

\header{
  hymnnumber = "189"
  title = "Our Sins Were Borne By Jesus"
  tunename = "Bridlington"
  meter = "7. 6. 7. 6. D."
  poet = "H. Bonar"
  composer = "C. Darnton"
  tagline = ##f
}

global = {
  \include "common/overrides.ily"
  \override Staff.TimeSignature.style = #'()
  \time 4/2
  \override Score.MetronomeMark.transparent = ##t % hide all fermata changes too
  \tempo 2=90
  \key f \major
  \partial 2
  \autoBeamOff
}

notesSoprano = {
\global
\relative c'' {

  c2 | bes a g f | bes1 a2
  g2 | a f f g | g1.
  g2 | c bes a c | ees1 d2
  c2 | b c c b | c1.
  g2 | bes a g g | a1 f2
  a2 | bes bes c g | a1.
  c2 | d c bes bes | bes1 a2
  g2 | a f f e | f1.

  \bar "|."

}
}

notesAlto = {
\global
\relative e' {

  f2 | f f e f | f1 f2
  f2 | f f b, b | c1.
  e2 | f e f f | ees( f) f
  f2 | f e d d | e1.
  e2 | g f e d | cis1 d2
  f2 | f f e e | f1.
  g2 | fis fis g g | g1 f2
  f2 | f c c c | c1.

}
}

notesTenor = {
\global
\relative a {

  a2 | d c bes a | bes1 c2
  d2 | c a f f | e1.
  c'2 | c c c c | bes( c) bes
  c2 | d c a g | g1.
  c2 | c c c d | e1 d2
  d2 | d d c c | c1.
  g2 | a d d d | c1 c2
  d2 | c a g bes | a1.

}
}

notesBass = {
\global
\relative f {

  f2 f f f f | d1 c2
  bes2 | c c d d | c1.
  bes'2 | a g f a | g( a) bes
  a2 | g a f g | c,1.
  c2 | c c c bes | a1 d2
  d2 | g, g' c, c | f1.
  ees2 | d d g f! | e1 f2 % why `!` ?
  bes,2 | c c c c | f1.

}
}

wordsA = \lyricmode {
\set stanza = "1."

Our sins were borne by Je -- sus, \bar "."
The ho -- ly Lamb of God: \bar "."
He took them all and freed us \bar "."
From that con -- demn -- ing load. \bar "."
Our guilt was borne by Je -- sus, \bar "."
Who washed the crim -- son stains \bar "."
White in His blood most pre -- cious, \bar "."
Till not a spot re -- mains. \bar "."

}

wordsB = \lyricmode {
\set stanza = "2."

Our wants are known to Je -- sus;
All full -- ness dwells in Him;
He heal -- eth all dis -- eas -- es
Who did our souls re -- deem.
We tell our griefs to Je -- sus–
Our bur -- dens and our cares;
He from them all re -- leas -- es
Who all our sor -- row shares.

}

wordsC = \lyricmode {
\set stanza = "3."

We love the name of Je -- sus,
The Christ of God, the Lord;
Like fra -- grance on the breez -- es,
His name is spread a -- broad.
We long to be with Je -- sus,
With all the ran -- somed throng,
To sing for aye His prais -- es,
The one e -- ter -- nal song.

}

\score {
  \context ChoirStaff <<
    \context Staff = upper <<
      \set ChoirStaff.systemStartDelimiter = #'SystemStartBar
      \context Voice  = sopranos { \voiceOne << \notesSoprano >> }
      \context Voice  = altos { \voiceTwo << \notesAlto >> }
      \context Lyrics = one   \lyricsto sopranos \wordsA
      \context Lyrics = two   \lyricsto sopranos \wordsB
      \context Lyrics = three \lyricsto sopranos \wordsC
    >>
    \context Staff = men <<
      \clef bass
      \context Voice  = tenors { \voiceOne << \notesTenor >> }
      \context Voice  = basses { \voiceTwo << \notesBass >> }
    >>
  >>
  \layout {
    \include "common/layout.ily"
  }
  \midi{
    \include "common/midi.ily"
  }
}

\noPageBreak \markup { \vspace #2 \fill-line { \raise #2 \line { Alternate tune: No. 183. } } }

\version "2.18.2"  % necessary for upgrading to future LilyPond versions.

% vi:set et ts=2 sw=2 ai nocindent syntax=lilypond: