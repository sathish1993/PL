f(a). f(b). f(c).
g(1). g(2). g(3).
h(x). h(y). h(z).

p1(X):- f(X).
p1(X):- g(X).
p1(X):- h(X).

p2(X):- f(X).
p2(X):- g(X), !.
p2(X):- h(X).

p3(X):- f(X).
p3(X):- !, g(X).
p3(X):- h(X).


