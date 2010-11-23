use strict;
use warnings;

package Number::Format::SouthAsian;

use Carp;
use Scalar::Util qw(looks_like_number);

=head1 NAME

Number::Format::SouthAsian - format numbers in the South Asian style

=head1 SYNOPSIS

Formats numbers in the South Asian style. You can read more on Wikipedia here:

    http://en.wikipedia.org/wiki/South_Asian_numbering_system

The format_number() method has a words parameter which tells it to use
words rather than simply separating the numbers with commas.

    my $formatter = Number::Format::SouthAsian->new();
    say $formatter->format_number(12345678);             # 1,23,45,678
    say $formatter->format_number(12345678, words => 1); # 1.2345678 crores

You can also specify words to new(), which has the affect of setting a
default value to be used.

    my $formatter = Number::Format::SouthAsian->new(words => 1);
    say $formatter->format_number(12345678);             # 1.2345678 crores
    say $formatter->format_number(12345678, words => 0); # 1,23,45,678

=head1 METHODS

=head2 new

Optionally takes a named parameter 'words' which sets the default of the
'words' parameter to format_number.

    my $normal_formatter = Number::Format::SouthAsian->new();

    my $wordy_formatter = Number::Format::SouthAsian->new(words => 1);

=cut

sub new {
    my $class = shift;
    my %opts = @_;
    my $self = bless {}, $class;

    $self->_init_defaults(%opts);

    return $self;
}

sub _init_defaults {
    my $self = shift;
    my %opts = @_;

    $self->{'defaults'}{'words'} = $opts{'words'} || 0;
}

=head2 format_number

Takes a positional parameter which should just be a number. Optionally takes
a named parameter 'words' which turns on or off the wordy behaviour. Returns
a string containing the number passed in formatted in the South Asian style.

    my $formatted_number = $formatter->format_number(12345678);

    my $formatted_number = $formatter->format_number(12345678, words => 1);

=cut

sub format_number {
    my $self   = shift;
    my $number = shift;
    my %opts   = @_;

    if (!defined($number) || !looks_like_number($number)) {
        croak "First parameter to format_number() must be a number";
    }

    my $want_words = exists($opts{'words'})
                   ? $opts{'words'}
                   : $self->{'defaults'}{'words'};

    if ($want_words) {
        return $self->_format_number_wordy($number, %opts);
    }
    else {
        return $self->_format_number_separators_only($number, %opts);
    }
}

my %zeroes_to_words = (
    '5'  => 'lakh',
    '7'  => 'crore',
    '9'  => 'arab',
    '11' => 'kharab',
    '13' => 'neel',
    '15' => 'padma',
    '17' => 'shankh',
    '19' => 'maha shankh',
    '21' => 'ank',
###########################################################
#### not supported at 64 bit, disabling for now...
###########################################################
#   '23' => 'jald',
#   '25' => 'madh',
#   '27' => 'paraardha',
#   '29' => 'ant',
#   '31' => 'maha ant',
#   '33' => 'shisht',
#   '35' => 'singhar',
#   '37' => 'maha singhar',
#   '39' => 'adant singhar',
);

sub _format_number_wordy {
    my $self = shift;
    my $number = shift;
    my %opts = @_;

    my $zeroes = length($number) - 1;

    # scientific notation kicks in at a certain size...
    # we have to get around that.
    if ($number =~ m/^ ( \d+ (?: [.]\d+)?) e[+] (\d+) $/msx) {
        my ($mantissa, $exponent) = ($1, $2);

        if ($mantissa < 1) {
            $zeroes = $exponent;
        }
        else {
            $zeroes = $exponent + 1;
        }
    }

    if ($zeroes < 5) {
        return $self->_format_number_separators_only($number);
    }

    my $divisor = "1" . ("0" x $zeroes);

    while (!$zeroes_to_words{$zeroes}) {
        $zeroes  -=  1;
        $divisor /= 10;
    }

    my $fraction = sprintf("%f", ($number / $divisor)); # force no scientific notation
    if ($fraction =~ m/[.]/) {
        $fraction =~ s/0+$//;
        $fraction =~ s/[.]$//;
    }

    my $word = $zeroes_to_words{$zeroes};

    my $pluralization = $fraction eq '1' ? '' : 's';

    my $words = sprintf('%s %s%s', $fraction, $word, $pluralization);

    return $words;
}

sub _format_number_separators_only {
    my $self    = shift;
    my $number  = shift;
    my %opts    = @_;

    $number =~ s{
        (?:
            (?<= \d{2})
            (?= \d{3}$)
        )
        |
        (?:
            (?<= ^\d{1} )
            (?=   \d{3}$)
        )
    }{,}gmsx;

    1 while $number =~ s{
        (?<! ,     )
        (?<! ^     )
        (?=  \d{2},)
    }{,}gmsx;

    return $number;
}

=head1 Copyright

Copyright (C) 2010 Lokku Ltd.

=head1 Author

Alex Balhatchet (alex@lokku.com)

=cut

1;
