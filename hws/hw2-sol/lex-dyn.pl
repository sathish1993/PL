local $b = 3;

sub f($) {
  my($a) = @_;     #a = 5
  my $static1 = $a * 2;  #10
  my $static2 = $b; #8
  return sub ($) { my($x) = @_; return $x + $static1*$static2 + $b; }
}

sub h($) {
  my($a) = @_;
  local $b = $a + 5;  #b = 8
  return f(5)
}

print h(3)->(5), "\n";
