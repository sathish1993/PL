count_vars(X):-
  \+ \+ write_count_vars(X).

write_count_vars(X):-
  count_vars(X, 0, NVars), 
  write(NVars), nl.

count_vars(X, N, N1):-
  var(X), !, X = N, N1 is N + 1.
count_vars([], N, N):- !.
count_vars([X|Xs], N, Z):-
  !,
  count_vars(X, N, N1),
  count_vars(Xs, N1, Z).
count_vars(X, N, Z):-
  X =.. [_|Args],
  count_vars(Args, N, Z).

