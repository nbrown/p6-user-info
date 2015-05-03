use v6;
use Test;

plan 1;

EVAL('use User::Info;');

cmp_ok( $!, 'eq', '', 'loading User::Info');


# vim:ft=perl6
