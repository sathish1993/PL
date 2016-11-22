% -*- mode: prolog -*-
% vi: set ft=prolog


%@1@
river_cross:-
  init_state(Init),
  length(Moves, _),  %iterative depth-first search
                     %gen Moves of increasing length
  river_cross(Init, Moves),
  out_river_cross_moves(Moves). %output, unimportant

river_cross(State, []):-
  final_state(State).
river_cross(State, [State-Move-StateX|Moves]):-
  \+ final_state(State),
  move(State, Move, StateX),
  \+ forbidden_state(StateX),
  river_cross(StateX, Moves).

%@2@
%Initialize problem state:
init_state(
  state([f, c, g, w], %farmer, cabbage, goat, wolf on one bank
        []            %no one on other bank
       )).

final_state(state([], Bank2)):-
  member(f, Bank2),
  member(c, Bank2),
  member(g, Bank2),
  member(w, Bank2).

%@3@
forbidden_state(state(Bank1, _Bank2)):-
  forbidden_cohorts(Bank1).
forbidden_state(state(_Bank1, Bank2)):-
  forbidden_cohorts(Bank2).

forbidden_cohorts(Cohorts):-
  \+member(f, Cohorts),
  member(c, Cohorts),
  member(g, Cohorts).
forbidden_cohorts(Cohorts):-
  \+member(f, Cohorts),
  member(g, Cohorts),
  member(w, Cohorts).

%@4@
%farmer can row herself from Bank1 to Bank2
move(state(Bank1, Bank2), forward(f), 
     state(Bank1Z, [f|Bank2])):-
  select(f, Bank1, Bank1Z).

%farmer can row herself from Bank2 to Bank1
move(state(Bank1, Bank2), backward(f), 
     state([f|Bank1], Bank2Z)):-
  select(f, Bank2, Bank2Z).
%@5@
%farmer can row herself + some X from Bank1 to Bank2
move(state(Bank1, Bank2), forward(f, X), 
     state(Bank1Z, [f, X|Bank2])):-
  select(f, Bank1, Bank1X),
  select(X, Bank1X, Bank1Z).

%farmer can row herself + some X from Bank2 to Bank1
move(state(Bank1, Bank2), backward(f, X), 
     state([f, X|Bank1], Bank2Z)):-
  select(f, Bank2, Bank2X),
  select(X, Bank2X, Bank2Z).

%@6@
out_river_cross_moves([]).
out_river_cross_moves([State-Move-StateX|Moves]):-
  format("~w~20+ --~w~16+--> ~w~n", 
         [State, Move, StateX]),
  out_river_cross_moves(Moves).

