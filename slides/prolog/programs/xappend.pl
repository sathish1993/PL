xappend([], X, X).
xappend([X|Xs], Ys, [X|Zs]):-
  xappend(Xs, Ys, Zs).
