year_1953_1996_novels(Name) :-
  novel(Name, Year),
  (Year = 1953; Year = 1996).

period_1800_1900_novels(Name) :-
  novel(Name, Year),
  Year >= 1800,
  Year =< 1900.

lotr_fans(Name) :-
  fan(Name, List),
  isMember(the_lord_of_the_rings, List).

author_names(Name) :-
  fan(chandler, List),
  author(Name, Lists),
  any_member(List, Lists).

any_member([F|_], [F|_]) :- !.
any_member(F1, [_|I2]) :-
  any_member(F1, I2), !.
any_member([_|I1], F2) :-
  any_member(I1, F2), !.

fans_names(Name) :-
  author(brandon_sanderson, Lists),
  fan(Name, List),
  any_member(List, Lists).

mutual_novels(Name) :-
  fan(ross, List1),
  fan(monica, List2),
  mutual_check(Name, List1, List2).

mutual_novels(Name) :-
  fan(monica, List1),
  fan(phoebe, List2),
  mutual_check(Name, List1, List2).

mutual_novels(Name) :-
  fan(phoebe, List1),
  fan(ross, List2),
  mutual_check(Name, List1, List2).

mutual_check(Name, [F|_], L2) :-
  Name = F,
  isMember(F, L2).

mutual_check(Name, [_|R], L2) :-
  mutual_check(Name, R, L2).

isMember(Item, [Item|_]).
isMember(Item, [_|R]) :-
  isMember(Item, R).

isUnion([], U, U).
isUnion([F|R], Y, U) :-
  isMember(F, Y),!,
  isUnion(R, Y, U).
isUnion([F|R], Y, [F|U]) :-
  isUnion(R, Y, U).

isIntersection([], _, []).
isIntersection([F|R1], Y, I) :-
  isMember(F, Y),!,
  I = [F|R3],
  isIntersection(R1, Y, R3).
isIntersection([_|R1], Y, I) :-
  isIntersection(R1, Y, I).

isEqual(X, Y) :-
  isIntersection(X, Y, Z),
  Z = X.

powerSet(X, Y) :-
  bagof(Z, powerSetHelper(X, Z), H),
  reverse(H, Y).

powerSetHelper([], []).
powerSetHelper([_|T], P) :-
  powerSetHelper(T, P).
powerSetHelper([H|T], [H|P]) :-
  powerSetHelper(T, P).

state(F, W, G, C).

opposite(left, right).
opposite(right, left).

safe(state(F, _, G, _)) :-
  F = G.
safe(state(_, W, G, C)) :-
  opposite(W, G),
  opposite(G, C).

unsafe(A) :- \+ safe(A).

take(X,A,B) :-
  opposite(A, B).

arc(take(wolf, W1, W2), state(W1, W1, G, C), state(W2, W2, G, C)) :-
  take(wolf, W1, W2),
  safe(state(W2, W2, G, C)).

arc(take(goat, G1, G2), state(G1, W, G1, C), state(G2, W, G2, C)) :-
  take(goat, G1, G2),
  safe(state(G2, W, G2, C)).

arc(take(cabbage, C1, C2), state(C1, W, G, C1), state(C2, W, G, C2)) :-
  take(cabbage, C1, C2),
  safe(state(C2, W, G, C2)).

arc(take(none, F1, F2), state(F1, W, G, C), state(F2, W, G, C)) :-
  take(none, F1, F2),
  safe(state(F2, W, G, C)).

step(A, B, History) :-
	safe(A),
  S = arc(_, A, B),
  S,
  \+ isMember(S, History),
  print_step([S|History]),
	!.
step(A, B, History) :-
	safe(A),
	S = arc(_, A, I),
	\+ member(S, History),
	S,
	step(I, B, [S|History]).

print_step([]).
print_step([arc(take(X, A, B), _, _)|T]) :-
	print_step(T),
	print('take('), print(X), print(','), print(A), print(','), print(B), print(')'), nl.

solve(F1, W1, G1, C1, F2, W2, G2, C2) :- step(state(F1, W1, G1, C1), state(F2, W2, G2, C2), []), !.
