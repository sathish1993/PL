perms([], []).
perms([X|Xs], Zs):-
  perms(Xs, Ys),
  insert(X, Ys, Zs).

insert(X, Ys, [X|Ys]).
insert(X, [Y|Ys], [Y|Zs]):-
  insert(X, Ys, Zs).
