\include "common/global.ily"
\paper {
  \include "common/paper.ily"
}

\header{
  hymnnumber = "268"
  title = "There Is a Stream of Precious Blood"
  tunename = "Cowper"
  meter = "C. M."
  poet = "Wm. Cowper"
  composer = "Dr. L. Mason"
  tagline = ##f
}

global = {
  \include "common/overrides.ily"
  \override Staff.TimeSignature.style = #'()
  \time 4/4
  \override Score.MetronomeMark.transparent = ##t % hide all fermata changes too
  \tempo 4=80
  \key c \major
  \partial 4
  \autoBeamOff
}

notesSoprano = {
\global
\relative c' {

  c8[ e] | g4. a8 g4 c | c4. a8 g4
  c,8[ e] | g4. g8 a[ g] e[ c] | d2. \eogbreak
  c8[ e] | g4. a8 g4 c | c4. a8 g4
  c8[ d] | e4. c8 d4 e | c2. \eogbreak

  c8[ d] | e4. c8 d4 e | c4.( a8 c4)
  a4 | g4. g8 a8[ g] e[ c] | d2. \eogbreak
  c8[ e] | g4. a8 g4 c | c4. a8 g4
  c8[ d] | e4. c8 d4 e | c2. \eogbreak

  \bar "|."

}
}

notesAlto = {
\global
\relative e' {

  c4 | e4. f8 e4 g | f4. f8 e4
  c4 | e4. e8 f[ e] c4 | b2.
  c4 | e4. f8 e4 g | f4. f8 e4
  e8[ f] | g4. g8 f4 g | e2.

  e8[ f] | g4. g8 f4 g | f2.
  f4 | e4. e8 f8[ e] c4 | b2.
  c4 | e4. f8 e4 g | f4. f8 e4
  e8[ f] | g4. g8 f4 g | e2.

}
}

notesTenor = {
\global
\relative a {

  e8[ g] | c4. c8 c4 g | a4. c8 c4
  e,8[ g] | c4. c8 c4 g8[ e] | g2.
  e8[ g] | c4. c8 c4 g | a4. c8 c4
  c4 | c4. c8 g4 g | g2.

  g4 | g4. g8 b4 c | a2.
  c4 | c4. c8 c4 g | g2.
  e8[ g] | c4. c8 c4 g | a4. c8 c4
  c4 | c4. c8 g4 g | g2.

}
}

notesBass = {
\global
\relative f {

  c4 | c4. c8 c4 e4 | f4. f8 c4
  c4 | c4. c8 c4 c | g2.
  c4 | c4. c8 c4 e4 | f4. f8 c4
  c4 | c4. e8 g4 g | c,2.

  c4 | c4. e8 g4 c,4 | f2.
  f4 | c4. c8 c4 c8[ e] | g2.
  c,4 | c4. c8 c4 e4 | f4. f8 c4
  c4 | c4. e8 g4 g | c,2.

}
}

wordsA = \lyricmode {
\set stanza = "1."

There is a stream of pre -- cious blood \bar "."
Which flowed from Je -- su’s veins; \bar "."
And sin -- ners washed in that blest flood \bar "."
%{HIDE>%} Lose all their guilt -- y stains, \bar "." %{HIDE<%}
%{HIDE>%} Lose all their guilt -- y stains, __ \bar "." %{HIDE<%}
%{HIDE>%} Lose all their guilt -- y stains, \bar "." %{HIDE<%}
%{HIDE>%} And sin -- ners washed in that blest flood \bar "." %{HIDE<%}
Lose all their guilt -- y stains. \bar "."

}

wordsB = \lyricmode {
\set stanza = "2."

The dy -- ing thief re -- joiced to see
That Sav -- iour in his day;
And by that blood, tho’ vile as he,
%{HIDE>%} Our sins are washed a -- way, %{<HIDE%}
%{HIDE>%} Our sins are washed a -- way, __ %{<HIDE%}
%{HIDE>%} Our sins are washed a -- way, %{<HIDE%}
%{HIDE>%} And by that blood, tho’ vile as he, %{<HIDE%}
Our sins are washed a -- way.

}

wordsC = \lyricmode {
\set stanza = "3."

Blest Lamb of God, Thy pre -- cious blood
Shall nev -- er lose its pow’r,
Till ev -- ’ry ran -- somed saint of God
%{HIDE>%} Be saved to sin no more, %{<HIDE%}
%{HIDE>%} Be saved to sin no more, __ %{<HIDE%}
%{HIDE>%} Be saved to sin no more, %{<HIDE%}
%{HIDE>%} Till ev -- ’ry ran -- somed saint of God %{<HIDE%}
Be saved to sin no more.

}

wordsD = \lyricmode {
\set stanza = "4."

E’er since, by faith, we saw the stream
Thy wounds sup -- plied for sin,
Re -- deem -- ing love has been our theme,
%{HIDE>%} Our joy and peace has been, %{<HIDE%}
%{HIDE>%} Our joy and peace has been, __ %{<HIDE%}
%{HIDE>%} Our joy and peace has been, %{<HIDE%}
%{HIDE>%} Re -- deem -- ing love has been our theme, %{<HIDE%}
Our joy and peace has been.

}

wordsE = \lyricmode {
\set stanza = "5."

Soon in a no -- bler, sweet -- er song,
We’ll sing Thy pow’r to save;
No more with lisp -- ing stam -- m’ring tongue,
%{HIDE>%} But con -- querors o’er the grave, %{<HIDE%}
%{HIDE>%} But con -- querors o’er the grave, __ %{<HIDE%}
%{HIDE>%} But con -- querors o’er the grave, %{<HIDE%}
%{HIDE>%} No more with lisp -- ing stam -- m’ring tongue, %{<HIDE%}
But con -- querors o’er the grave.

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
      \context Lyrics = four  \lyricsto sopranos \wordsD
      \context Lyrics = five  \lyricsto sopranos \wordsE
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

\version "2.18.2"  % necessary for upgrading to future LilyPond versions.

% vi:set et ts=2 sw=2 ai nocindent syntax=lilypond: