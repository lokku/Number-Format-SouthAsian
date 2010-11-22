use strict;
use warnings;

use Test::More;

use Number::Format::SouthAsian;

my @tests = (
    [ 1,                                                          '1', ],
    [ 10,                                                        '10', ],
    [ 100,                                                      '100', ],
    [ 1000,                                                   '1,000', ],
    [ 10000,                                                 '10,000', ],
    [ 100000,                                                '1 lakh', ],
    [ 1000000,                                              '10 lakh', ],
    [ 10000000,                                             '1 crore', ],
    [ 100000000,                                           '10 crore', ],
    [ 1000000000,                                            '1 arab', ],
    [ 10000000000,                                          '10 arab', ],
    [ 100000000000,                                        '1 kharab', ],
    [ 1000000000000,                                      '10 kharab', ],
    [ 10000000000000,                                        '1 neel', ],
    [ 1000000000000000,                                     '1 padma', ],
    [ 100000000000000000,                                  '1 shankh', ],
    [ 10000000000000000000,                           '1 maha shankh', ],
    [ 1000000000000000000000,                                 '1 ank', ],
#########################################################################
#### not supported at 64 bit, disabling for now...
#########################################################################
#   [ 100000000000000000000000,                              '1 jald', ],
#   [ 10000000000000000000000000,                            '1 madh', ],
#   [ 1000000000000000000000000000,                     '1 paraardha', ],
#   [ 100000000000000000000000000000,                         '1 ant', ],
#   [ 10000000000000000000000000000000,                  '1 maha ant', ],
#   [ 1000000000000000000000000000000000,                  '1 shisht', ],
#   [ 100000000000000000000000000000000000,               '1 singhar', ],
#   [ 10000000000000000000000000000000000000,        '1 maha singhar', ],
#   [ 1000000000000000000000000000000000000000,     '1 adant singhar', ],

    [ 123000,                                             '1.23 lakh', ],
    [ 12300000,                                          '1.23 crore', ],
    [ 1230000000,                                         '1.23 arab', ],
    [ 123000000000,                                     '1.23 kharab', ],
    [ 12300000000000,                                     '1.23 neel', ],
    [ 1234560000000000,                               '1.23456 padma', ],
    [ 12345600000000000,                              '12.3456 padma', ],

#### should this be "1 crore 1 lakh"?
    [ 10_100_000,                                        '1.01 crore', ],
);

plan tests => 1 + @tests;

my $formatter = Number::Format::SouthAsian->new();
ok($formatter, 'created $formatter object');

foreach my $test (@tests) {
    my ($input, $output) = @$test;

    is(
        $formatter->format_number($input, words => 1),
        $output,
        sprintf("%.0f => '%s'", $input, $output)
    );
}
