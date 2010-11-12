use strict;
use warnings;

use Test::More;

use Number::Formatter::SouthAsian;

my @tests = (
    [              1,                    '1', ],  # 1
    [             10,                   '10', ],  # 10
    [            100,                  '100', ],  # 100
    [           1000,                '1,000', ],  # 1 thousand
    [          10000,               '10,000', ],  # 10 thousand
    [         100000,             '1,00,000', ],  # 100 thousand    / 1 lakh
    [        1000000,            '10,00,000', ],  # 1 million
    [       10000000,          '1,00,00,000', ],  # 10 million      / 1 crore
    [      100000000,         '10,00,00,000', ],  # 100 million
    [     1000000000,       '1,00,00,00,000', ],  # 1 billion       / 1 arab
    [    10000000000,    '1,00,00,00,00,000', ],  # 10 billion
    [   100000000000,   '10,00,00,00,00,000', ],  # 100 billion     / 1 kharab
    [  1000000000000,  '100,00,00,00,00,000', ],  # 1 trillion
    [ 10000000000000, '1,00,00,00,00,00,000', ],  # 10 trillion     / 1 neel

    [ 1234,                          '1,234', ],
    [ 12345,                        '12,345', ],
    [ 123456,                     '1,23,456', ],
    [ 1234567,                   '12,34,567', ],
    [ 12345678,                '1,23,45,678', ],
    [ 123456789,              '12,34,56,789', ],
    [ 1234567890            '1,23,45,67,890', ],
);

plan tests => 1 + @tests;

my $formatter = Number::Formatter::SouthAsian->new();
ok($formatter, 'created $formatter object');

foreach my $test (@tests) {
    my ($input, $output) = @$test;

    is(
        $formatter->format_number($input, words => 0),
        $output,
        sprintf("%s => '%s'", $input, $output)
    );
}
