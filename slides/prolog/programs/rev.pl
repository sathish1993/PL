rev(Xs, Zs):-
  rev(Xs, [], Zs).

rev([], Acc, Acc).
rev([X|Xs], Acc, Zs):-
  rev(Xs, [X|Acc], Zs).
