xmember(X, [X|_]).
xmember(X, [_|Xs]):-
  xmember(X, Xs).
