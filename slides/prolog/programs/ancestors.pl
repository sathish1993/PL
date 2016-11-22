%Set of facts about tom's genealogy.
mother(tom, jill).
mother(jill, mary).
mother(bill, marge).

father(tom, bill).
father(jill, frank).
father(bill, harry).

%General rule: A parent is a mother or a father.
parent(X, Y) :- mother(X, Y).
parent(X, Y) :- father(X, Y).

%A ancestor is a parent or the ancestor of a parent.
ancestor(X, Y) :- parent(X, Y).
ancestor(X, Z) :- parent(X, Y), ancestor(Y, Z).

