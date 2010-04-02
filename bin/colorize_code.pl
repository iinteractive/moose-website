#!/usr/bin/perl

use strict;
use warnings;

use Syntax::Highlight::Perl::Improved ':FULL';

my $color_table = {
    'Variable_Scalar'   => 'color:#080;',
    'Variable_Array'    => 'color:#f70;',
    'Variable_Hash'     => 'color:#80f;',
    'Variable_Typeglob' => 'color:#f03;',
    'Subroutine'        => 'color:#980;',
    'Quote'             => 'color:#00a;',
    'String'            => 'color:#00a;',
    'Comment_Normal'    => 'color:#069;font-style:italic;',
    'Comment_POD'       => 'color:#014;font-size:11pt;',
    'Bareword'          => 'color:#3A3;',
    'Package'           => 'color:#900;',
    'Number'            => 'color:#f0f;',
    'Operator'          => 'color:#000;',
    'Symbol'            => 'color:#000;',
    'Keyword'           => 'color:#000;',
    'Builtin_Operator'  => 'color:#300;',
    'Builtin_Function'  => 'color:#001;',
    'Character'         => 'color:#800;',
    'Directive'         => 'color:#399;font-style:italic;',
    'Label'             => 'color:#939;font-style:italic;',
    'Line'              => 'color:#000;',
};

my $formatter = Syntax::Highlight::Perl::Improved->new();

$formatter->define_substitution(
    '<' => '&lt;',
    '>' => '&gt;',
    '&' => '&amp;'
);

while ( my ( $type, $style ) = each %{$color_table} ) {
    $formatter->set_format(
        $type,
        [
            qq|<span style="$style">|,
            '</span>'
        ]
    );
}

my $file = shift || die "Give me a perl file to colorize!\n";
-e $file or die "There's no such file: $file\n";

open F, '<', $file or die $!;

print '<pre style="font-size:10pt;color:#336;">';
while (<F>) {
    print $formatter->format_string;
}
print "</pre>";
close F;

exit 0;

1;
