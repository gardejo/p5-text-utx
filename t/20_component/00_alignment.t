#!perl

use strict;
use warnings;

use lib 't/lib';

use Test::Text::UTX::Component::Locale::Language;
use Test::Text::UTX::Component::Locale::Country;
use Test::Text::UTX::Component::Locale;
use Test::Text::UTX::Component::Alignment;

Test::Class->runtests;

1;
__END__
