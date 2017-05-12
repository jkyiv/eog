#!/usr/bin/env perl
use strict;
use warnings;

use CGI qw(:standard); # just for HTML shortcuts
use File::Basename qw(basename dirname);
use List::MoreUtils qw(uniq);

sub get_key ($$)
{
    my ($stem, $key) = @_;
    open my $fh, "headers/$stem.$key" or return "";
    chomp(my $val = <$fh> || "");
    return $val;
}

my %globs = (
        PDF  => [ glob "PDF/*/*.pdf"   ],
        MP3  => [ glob "MP3/*/*.mp3"   ],
        TXT  => [ glob "TXT/*/*.txt"   ],
        MIDI => [ glob "MIDI/*/*.midi" ],
    );

my @srcs     = glob "src/EOG???.ly";
my @lists    = glob "*.m3u";
my %exts     = map { uc, lc } keys %globs;
my @dirs     = sort keys %globs;
my @stems    = uniq sort map m#(\w+)\.ly#, @srcs;
my %variants = map { $_ => [ uniq sort map basename(dirname($_)), @{ $globs{$_} } ] } @dirs;
my %vcount   = map { $_ => scalar @{ $variants{$_} } } keys %variants;

my $total = 376 + 8;

print
    start_html(-title  => "Echoes of Grace layout project",
        -style  => { -src => "scripts/main.css" },
        -head   => [ meta({ -http_equiv => "Content-Type",
                            -content => "text/html; charset=UTF-8" }), ],
        -script => [ { -src => "scripts/sorttable.js" },
                     { -src => "scripts/table.js"     }, ],
        -onLoad => "document.getElementById('searchbox').focus()",
    ),
    h1({ -style => "text-align: center" },
        "Hymns from the", i("Echoes of Grace")),
    p("This site hosts sheet-music PDFs, lyric text files, and computer-generated audio files",
        "for the hymns in the",
        a({ -href => "http://bibletruthpublishers.com/echoes-of-grace-hymn-book-large-music-edition-plastic-coil-binding/pd2535" },
            "Echoes of Grace hymn book") . ".",
        "These hymns were engraved with",
        a({ -href => "http://www.lilypond.org/" }, "LilyPond") . ",",
        "and source files are",
        a({ -href => "https://github.com/kulp/eog" }, "available") . "."),
    p("Playlists for all available MP3s:", map { a({ -href => "$_" }, $_), " " } @lists),
    p(sprintf "Progress: %d/%d files = %4.2f%% complete as of %s",
            scalar(@srcs), $total, 100.0 * scalar(@srcs)/$total, qx(git log -1 --format=%ai)),
    table({ -class => "sortable", -id => "main" },
        thead(
            Tr(
                th({ -class => "corner" }, "Filter:"),
                th({ -class => "sortbox", -colspan => 3 }, # title poet composer
                    start_form({ -onSubmit => "return false;", -action => "" }),
                        input({ -id      => "searchbox",
                                -name    => "filter",
                                -onkeyup => "filter2(this, 'main')",
                                -type    => "text",
                                -size    => 35 }),
                        button({ -onclick => "return do_reset();",
                                 -value   => "Reset" }, "Reset"),
                    end_form,
                ),

             (map th({ -class => "wide", -colspan => $vcount{$_} }, $_), @dirs),
            ),
            Tr({ -class => "realhead" },
                (map th($_), qw(No. Title Poet Composer)),
                (map th({ -class => "nosort" }, $_), map @{ $variants{$_} }, @dirs),
            ),
        ),
        tbody(
            (map {
                my $stem = $_;
                my $src      = "src/$stem.ly";

                my $title    = get_key $stem => "title";
                my $poet     = get_key $stem => "poet";
                my $composer = get_key $stem => "composer";

                my $index    = int(($stem =~ /EOG(\d+)/)[0]);
                (my $safetitle = $title) =~ s/[^\s\w]//g;

                Tr(
                    th({ -class => "index"                          } , $index),
                    td({ -class => "title", customkey => $safetitle } , $title),
                    td({ -class => "poet"                           } , $poet),
                    td({ -class => "composer"                       } , $composer),
                    (map { my $dir = $_; map {
                        my $where = "$dir/$_/$stem.$exts{$dir}";
                        td({ -class => "link" }, (-e $where) ? a({ -href => $where }, $dir) : ""),
                    } @{ $variants{$dir} } } @dirs),
                );
            } @stems),
        ),
    ),
    end_html;

