exp(E) -->
  term(T), exp_rest(T, E).

exp_rest(T, E) -->
  [0'+], term(T1), exp_rest(add(T, T1), E).
exp_rest(T, E) -->
  [0'-], term(T1), exp_rest(sub(T, T1), E).
exp_rest(T, T) -->
  [].

term(T) -->
  factor(F), term_rest(F, T).

term_rest(F, T) -->
  [0'*], factor(F1), term_rest(mul(F, F1), T).
term_rest(F, T) -->
  [0'/], factor(F1), term_rest(div(F, F1), T).
term_rest(F, F) -->
  [].

factor(F) -->
  [X], { 0'0 =< X, X =< 0'9, F is X - 0'0 }.
factor(F) -->
  [0'(], exp(F), [0')].
factor(neg(F)) -->
  [0'-], factor(F).
