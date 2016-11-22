zlength([], 0).
zlength([_|Xs], L):-
  zlength(Xs, LXs),
  succ(LXs, L),
  !.

