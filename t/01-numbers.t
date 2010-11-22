use strict;
use warnings;

use Test::More;

use Number::Format::SouthAsian;

my @tests = (
    [                   1,                    '1', ],  # 1
    [                  10,                   '10', ],  # 10
    [                 100,                  '100', ],  # 100
    [               1_000,                '1,000', ],  # 1 thousand
    [              10_000,               '10,000', ],  # 10 thousand
    [             100_000,             '1,00,000', ],  # 100 thousand / 1 lakh
    [           1_000_000,            '10,00,000', ],  # 1 million
    [          10_000_000,          '1,00,00,000', ],  # 10 million / 1 crore
    [         100_000_000,         '10,00,00,000', ],  # 100 million
    [       1_000_000_000,       '1,00,00,00,000', ],  # 1 billion / 1 arab
    [      10_000_000_000,      '10,00,00,00,000', ],  # 10 billion
    [     100_000_000_000,    '1,00,00,00,00,000', ],  # 100 billion / 1 kharab
    [   1_000_000_000_000,   '10,00,00,00,00,000', ],  # 1 trillion
    [  10_000_000_000_000, '1,00,00,00,00,00,000', ],  # 10 trillion

    [            1234,                '1,234', ],
    [           12345,               '12,345', ],
    [          123456,             '1,23,456', ],
    [         1234567,            '12,34,567', ],
    [        12345678,          '1,23,45,678', ],
    [       123456789,         '12,34,56,789', ],
    [      1234567890,       '1,23,45,67,890', ],
);

plan tests => 1 + @tests;

my $formatter = Number::Format::SouthAsian->new();
ok($formatter, 'created $formatter object');

foreach my $test (@tests) {
    my ($input, $output) = @$test;

    is(
        $formatter->format_number($input, words => 0),
        $output,
        sprintf("%s => '%s'", $input, $output)
    );
}
