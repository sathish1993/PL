s_number(0).
s_number(s(X)):-
  s_number(X).

add(0, X, X):-
  s_number(X).
add(s(X), Y, s(Z)):-
  add(X, Y, Z).

mult(0, X, 0):-
  s_number(X).
mult(s(X), Y, Z):-
  mult(X, Y, XY),
  add(Y, XY, Z).

