diff_nrev(X, Xrev):-
  diff_nrev_lo(X, Xrev-[]).

diff_nrev_lo([], X-X).
diff_nrev_lo([X|Xs], Y-Z):-
  diff_nrev_lo(Xs, Y-[X|Z]).
