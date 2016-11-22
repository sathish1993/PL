exp -->
  term, exp_rest.

exp_rest -->
  [0'+], term, exp_rest.
exp_rest -->
  [0'-], term, exp_rest.
exp_rest -->
  [].

term -->
  factor, term_rest.

term_rest -->
  [0'*], factor, term_rest.
term_rest -->
  [0'/], factor, term_rest.
term_rest -->
  [].

factor -->
  [X], { 0'0 =< X, X =< 0'9 }.
factor -->
  [0'(], exp, [0')].
factor -->
  [0'-], factor.
