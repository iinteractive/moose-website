#!perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";

use Moose::Website;

Moose::Website->new_with_options->run;