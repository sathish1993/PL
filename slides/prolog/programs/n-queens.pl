% -*- mode: prolog -*-
% vi: set ft=prolog :

%@1@
n_queens(N, Zs):-
  length(Zs, N),
  place_queens(0, N, Zs).

place_queens(N, N, _Zs).
place_queens(RowIndex, N, Zs):-
  RowIndex < N,
  N1 is N - 1,
  between(0, N1, ColIndex), 
  \+attack_queen(0, coord(RowIndex, ColIndex), Zs),
  nth0(RowIndex, Zs, ColIndex), 
  RowIndex1 is RowIndex + 1,    
  place_queens(RowIndex1, N, Zs).

%@2@
attack_queen(I, coord(RowIndex, ColIndex), Zs):-
  I < RowIndex,
  nth0(I, Zs, IColIndex),
  attack_queen(coord(I, IColIndex), 
               coord(RowIndex, ColIndex)).
attack_queen(I, coord(RowIndex, ColIndex), Zs):-
  I < RowIndex,
  I1 is I + 1,
  attack_queen(I1, coord(RowIndex, ColIndex), Zs).
%@3@
%attack_queen(coord(RowIndex1, ColIndex1), coord(RowIndex2,
%ColIndex2)).  will always have RowIndex1 < RowIndex2.  so, queens
%attack on same row not possible.
%@4@
%queens attack on same col
attack_queen(coord(_, ColIndex), 
	     coord(_, ColIndex)).

%queens attack on major diagonal
attack_queen(coord(RowIndex1, ColIndex1), 
             coord(RowIndex2, ColIndex2)):-
  ColIndex1 \== ColIndex2,
  RowDiff is RowIndex2 - RowIndex1,
  ColIndex2 is ColIndex1 + RowDiff.

%queens attack on minor diagonal
attack_queen(coord(RowIndex1, ColIndex1), 
             coord(RowIndex2, ColIndex2)):-
  ColIndex1 \== ColIndex2,
  RowDiff is RowIndex2 - RowIndex1,
  ColIndex2 is ColIndex1 - RowDiff.
