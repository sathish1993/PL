#! /usr/bin/perl

sub newAccount {
  my($balance) = @_;
  return 
    { withdraw => sub {
        my($amount) = @_;
        return $balance -= $amount;
      },
      deposit => sub {
        my($amount) = @_;
        return $balance += $amount;
      }
    }
}

my $a1 = newAccount(100);
my $a2 = newAccount(150);
print $a1->{withdraw}->(24), "\n";
print $a2->{deposit}->(20), "\n";
print $a1->{withdraw}->(26), "\n";

