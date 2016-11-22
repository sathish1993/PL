nrev([], []).
nrev([X|Xs], Zs):-
  nrev(Xs, Ys),
  append(Ys, [X], Zs).
