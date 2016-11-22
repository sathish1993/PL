xmsort([], []):- !.
xmsort([A], [A]):- !.
xmsort([A|As], Sorted):-
  xsplit([A|As], Odds, Evens),
  xmsort(Odds, SortedOdds),
  xmsort(Evens, SortedEvens),
  xmerge(SortedOdds, SortedEvens, Sorted).

xsplit([], [], []).
xsplit([A|As], [A|Odds], Evens):-
  xsplit(As, Evens, Odds).

xmerge([], Xs, Xs):- !.
xmerge(Xs, [], Xs):- !.
xmerge([X|Xs], [Y|Ys], Zs):-
  X @< Y ->
    Zs = [X|Zs1], xmerge(Xs, [Y|Ys], Zs1)
  ; Zs = [Y|Zs1], xmerge([X|Xs], Ys, Zs1).
