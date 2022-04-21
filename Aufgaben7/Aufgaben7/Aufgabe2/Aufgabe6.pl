% Aufgabe 6:
line(central,[bond_street,oxford_circus,tottenham_court_road]).
line(jubilee,[bond_street,green_park,charing_cross]).
line(piccadilly,[green_park,piccadilly_circus,leicester_square]).
line(victoria,[green_park,oxford_circus]).
line(bakerloo,[oxford_circus,piccadilly_circus,charing_cross]).
line(northern,[tottenham_court_road,leicester_square,charing_cross]).

%!	stations(+Line:line,+Stations:list) is det
%!	stations(+Line:line,-Stations:list) is det
%!	stations(-Line:line,-Stations:list) is nondet
% this predicate return all stationson a specified line
stations(Line,Stations):-line(Line,Stations).

%! connected(+Station1:station,+Station2:station,-Line:line) is det
%! connected(+Station1:station,-Station2:station,-Line:line) is nondet
%! connected(+Station1:station,-Station2:station,+Line:line) is nondet
%! connected(-Station1:station,-Station2:station,-Line:line) is nondet
%! connected(-Station1:station,-Station2:station,+Line:line) is nondet
% this predicate can evaluate whether two stations are connected or not.
connected_(X,Y,Line):-
	stations(Line,Temp),
	con_(X,Y,Temp).

con_(_,_,[_]):-fail.
con_(X,Y,[H|[T|_]]):-X == H, Y == T.
con_(X,Y,[H|[T|Ts]]):-
	\+ X == H,
	\+ Y == T,
	con_(X,Y,[T|Ts]).