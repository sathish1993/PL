#!/usr/bin/env perl

#var declared local is a dynamically-scoped var. @1@
local $dynamic = 2;

#var declared using my is a lexically-scoped var.
my $static = 2;

sub out($$$) {
  my($msg, $stat, $dyn) = @_;
  print "$msg: static=$stat, dynamic=$dyn\n";    
}
sub f() {
  local $dynamic = 3;
  my $static = 3;
  h();
}
#@2@
sub h() {
  my $caller = (caller(1))[3];
  out("in h() called from $caller", 
      $static, $dynamic);
}    

sub go() { 
  out("before f()", $static, $dynamic);
  f();
  out("after f()", $static, $dynamic);
  h();
}

go();
