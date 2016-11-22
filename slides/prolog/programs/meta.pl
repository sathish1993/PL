solve(true):-
  !.
solve((Goal, Goals)):-
  !, 
  solve(Goal),
  solve(Goals).
solve(Goal):-
  clause(Goal, Body),
  solve(Body).


