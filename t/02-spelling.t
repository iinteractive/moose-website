#!perl
use 5.010;
use utf8;
use strict;
use warnings FATAL => 'all';
use autodie qw(:all);
use Capture::Tiny qw(capture);
use Encode qw(decode_utf8);
use File::Next qw();
use File::Temp qw(tempfile);
use File::Which qw(which);
use Test::More;
use XML::LibXML qw();
use XML::LibXSLT qw();

binmode Test::More->builder->$_, ':encoding(UTF-8)'
    for qw(output failure_output todo_output);

# Skip means sweep bugs under the rug.
# I want this test to be actually run.
BAIL_OUT 'aspell is not installed.' unless which 'aspell';

my @stopwords;
for (<DATA>) {
    chomp;
    push @stopwords, $_ unless /\A (?: \# | \s* \z)/msx;    # skip comments, whitespace
}

my $destdir;
{
    my $runtime_params_file = '_build/runtime_params';
    my $runtime_params      = do $runtime_params_file;
    die "Could not load $runtime_params_file. Run Build.PL first.\n"
      unless $runtime_params;
    $destdir = $runtime_params->{destdir};
}

my $iter = File::Next::files({
        file_filter => sub {/\.html \z/msx},
        sort_files  => 1,
    },
    $destdir
);

my $file_counter;

my $stylesheet = XML::LibXSLT->new->parse_stylesheet(
    XML::LibXML->load_xml(string => <<''));
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xhtml="http://www.w3.org/1999/xhtml" version="1.0">
    <xsl:template match="xhtml:abbr"/>
    <xsl:template match="xhtml:acronym"/>
    <xsl:template match="xhtml:code"/> <!-- filter computerese -->
    <xsl:template match="@* | node()"> <!-- apply identity function to rest of nodes -->
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>

while (defined(my $html_file = $iter->())) {
    $file_counter++;

    my ($temp_handle, $temp_file) = tempfile;
    my $transformed = $stylesheet->transform(XML::LibXML->load_xml(location => $html_file, load_ext_dtd => 0,));
    $stylesheet->output_fh($transformed, $temp_handle);

    my ($stdout) = capture {
        system "aspell -H --encoding=UTF-8 -l en list < $temp_file";
    };
    my @misspelt_words = grep {!($_ ~~ @stopwords)} split /\n/, decode_utf8 $stdout;
    ok !@misspelt_words, "$html_file ($temp_file) spell-check";
    diag join "\n", sort @misspelt_words if @misspelt_words;
}

done_testing($file_counter);

__DATA__
## personal names
Brocard
Bunce's
# Pierce Cawley
Cawley's
Champoux
chromatic
# Sam Crawley
Crawley
cuny's
Doran
franck
Grünauer
hakobe's
hanekomu
Hengst's
# Kanat-Alexander
Kanat
Kogman's
Léon
Napiorkowski
Pearcey's
Prather
Prather's
Ragwitz
Rockway
Rolsky's
Stevan
sunnavy's
Treder's
trombik
Vecchi
Vilain's
Yanick
Yuval

## proper names
BizRate
Cisco
Cloudtone
Endeworks
GitHub
Gource
IMDb
# Kansai.pm
Kansai
LinuxMag
MedTouch
MusicBrainz
OCaml
Omni
OnLAMP
PerlMonks
Pobox
Shadowcat
Shopzilla
SimplyClick
Simula
SocialText
Symantec
Takkle
Tamarou
TextMate
ValueClick

## Moose-specific

## computerese
parameterized

## other jargon

## neologisms
blog
podcast

## compound
# post-mortem
mortem
# PDX.pm
PDX
# London.pm's
pm's

## slang

## things that should be in the dictionary, but are not
Bioinformatics
Committers
refactoring
Refactoring

## single foreign words

## misspelt on purpose
