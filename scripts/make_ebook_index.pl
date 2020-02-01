#!/usr/bin/env perl
use strict;
use warnings;

my @top;
my @nest;
for (my $i = 0; $i <= 379; $i += 10) {
    my $end = $i + 9;
    my $start = $i < 1 ? 1 : $i;
    my $label = sprintf "index%02sx", $i / 10;
    push @top, qq(\\hyperlink{$label}{$start -- $end}\n\n);

    push @nest, <<EOF;
\\newpage

\\hypertarget{$label}{}
\\begin{multicols}{2}
[
\\section*{Hymns $start -- $end}
]
EOF
    for my $j (0..9) {
        my $num = $i + $j;
        next if $num == 0; # there is no hymn zero
        push @nest, sprintf qq(\\hyperlink{EOG%03d}{%d}\n\n), $num, $num;
    }
    push @nest, qq(\\end{multicols}\n);
}

print <<'EOF';
\newgeometry{margin=1in}

\setlength{\parindent}{0pt}
\setlength{\parskip}{0.5in}

\centering
\LARGE
\hypertarget{topindex}{}
\begin{multicols}{4}
[
\section*{All Hymns}
]
EOF

print for @top;

print <<'EOF';
\end{multicols}
EOF

print for @nest;

print <<'EOF';
\restoregeometry
EOF
