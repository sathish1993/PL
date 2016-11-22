mother(joe, jane).
father(joe, frank).


non_parent(X, Y):-
  \+ mother(X, Y),
  \+ father(X, Y).

student(joe).
