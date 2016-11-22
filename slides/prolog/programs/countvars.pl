count_vars(X, NVars):-
  count_vars(X, 0, NVars).

count_vars(X, N, N1):-
  var(X), !, N1 is N + 1.
count_vars([], N, N):- !.
count_vars([X|Xs], N, Z):-
  !,
  count_vars(X, N, N1),
  count_vars(Xs, N1, Z).
count_vars(X, N, Z):-
  X =.. [_|Args],
  count_vars(Args, N, Z).

count_distinct_vars(X, NVars):-
  count_distinct_vars(X, [], DistinctVars),
  length(DistinctVars, NVars).

count_distinct_vars(X, Vs, Zs):-
  var(X), !, 
  (memberq(X, Vs) -> Zs = Vs ; Zs = [X|Vs]).
count_distinct_vars([], Vs, Vs):- !.
count_distinct_vars([X|Xs], Vs, Zs):-
  !,
  count_distinct_vars(X, Vs, Vs1),
  count_distinct_vars(Xs, Vs1, Zs).
count_distinct_vars(X, Vs, Zs):-
  X =.. [_|Args],
  count_distinct_vars(Args, Vs, Zs).

memberq(X, [A|_]):-
  X == A.
memberq(X, [_|Z]):-
  memberq(X, Z).
