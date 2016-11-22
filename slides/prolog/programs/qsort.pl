qsort([], []).
qsort([X|Xs], Zs):-
  partition(Xs, X, LEs, GTs),
  qsort(LEs, SortedLEs),
  qsort(GTs, SortedGTs),
  append(SortedLEs, [X|SortedGTs], Zs).

partition([], _, [], []).
partition([X|Xs], E, [X|LEs], GTs):-
  X @=< E,
  partition(Xs, E, LEs, GTs).
partition([X|Xs], E, LEs, [X|GTs]):-
  X @> E, 
  partition(Xs, E, LEs, GTs).

