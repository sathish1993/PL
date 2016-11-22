xlength([], 0).
xlength([_|Xs], L):-
  xlength(Xs, LXs),
  L is LXs + 1.

