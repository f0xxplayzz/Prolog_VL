
%%% The London Underground example %%%

connected(bond_street,oxford_circus,central).
connected(oxford_circus,tottenham_court_road,central).
connected(bond_street,green_park,jubilee).
connected(green_park,charing_cross,jubilee).
connected(green_park,piccadilly_circus,piccadilly).
connected(piccadilly_circus,leicester_square,piccadilly).
connected(green_park,oxford_circus,victoria).
connected(oxford_circus,piccadilly_circus,bakerloo).
connected(piccadilly_circus,charing_cross,bakerloo).
connected(tottenham_court_road,leicester_square,northern).
connected(leicester_square,charing_cross,northern).

same_line(X,Y):-
	connected(X,Y,_).
same_line(X,Y):-
	connected(X,Z,L),connected(Z,Y,L).

reachable(X,Y,Intermediate) :-
	reachable_(X,Y,Intermediate0),
	reverse(Intermediate0,Intermediate).

reachable_(X,Y,[]):-
	same_line(X,Y). 
reachable_(X,Y,[Z|R]):-
	same_line(X,Z),
	reachable_(Z,Y,R).

% Here starts my own code
on_line(X,Y,Line):- connected(X,Y,Line).

%!	remove_duplicates(+List:list,-Result:list) is det
% remove_duplicates is apredicate to remove all duplicates from a list
remove_duplicates([],[]).
remove_duplicates([H | T], List) :- 
	member(H, T),
	remove_duplicates( T, List).
remove_duplicates([H | T], [H|T1]) :- 
	\+member(H, T), 
	remove_duplicates( T, T1).

%! reachable(+Start:station,+Goal:station,-Intermediate:list,-Lines:list) is nondet
% this predicate is a variation to the reachable/3 predicate. This predicate also 
% returns all the visited lines. 
reachable(X,Y,Intermediate,Lines):-
	reachable_(X,Y,Intermediate0,Lines0),
	reverse(Intermediate0, Intermediate),
	remove_duplicates(Lines0,Lines).

reachable_(X,Y,[],[Line|[]]):-
	on_line(X,Y,Line). 
reachable_(X,Y,[Z|R],[Line|Lines]):-
	on_line(X,Z,Line),
	reachable_(Z,Y,R,Lines).

%Aufgabe 4
%!	connected_sym(+Station1:station,+Station2:station,-Line:line) is det
%!	connected_sym(+Station1:station,+Station2:station,+Line:line) is det
%!	connected_sym(+Station1:station,-Station2:station,-Line:line) is nondet
%!	connected_sym(-Station1:station,+Station2:station,-Line:line) is nondet
%!	connected_sym(-Station1:station,-Station2:station,-Line:line) is nondet
% this predicate is a symmetrical variation to the normal connected predicate
% only difference is that it works symmetrically
connected_sym(X,Y,Line):-connected(X,Y,Line);
	connected(Y,X,Line).

%!	same_line_sym(+Station1:station,+Station2:station) is det
%!	same_line_sym(+Station1:station,-Station2:station) is nondet
%!	same_line_sym(-Station1:station,+Station2:station) is nondet
%!	same_line_sym(-Station1:station,-Station2:station) is nondet
% this predicate is the same as the same_line predicate except that is working
% symmetrically
same_line_sym(X,Y):-
	connected_sym(X,Y,_).
same_line_sym(X,Y):-
	connected_sym(X,Z,L),connected_sym(Z,Y,L),\+ Y==X.

%! reachable_sym(+Start:station,+Goal:station,+Intermediate:list,+Lines:list) is det
%! reachable_sym(+Start:station,+Goal:station,+Intermediate:list,-Lines:list) is det
%! reachable_sym(+Start:station,+Goal:station,-Intermediate:list,+Lines:list) is nondet
%! reachable_sym(+Start:station,+Goal:station,-Intermediate:list,-Lines:list) is nondet
% this is the symmetrical version of the reachable predicate
reachable_sym(X,Y,Intermediate,Lines):-
	reachable_sym_(X,Y,Intermediate,Lines0,0),
	remove_duplicates(Lines0,Lines).

reachable_sym_(X,Y,[],[Line|[]],Count):-
	Count =<5,
	connected_sym(X,Y,Line). 
reachable_sym_(X,Y,[Z|R],[Line|Lines],Count):-
	Count =< 5,
	plus(Count,1,Temp),
	connected_sym(X,Z,Line),
	reachable_sym_(Z,Y,R,Lines,Temp),
	\+ member(Z,R),
	\+ member(Y,R),
	\+ member(X,R).

%Aufgabe 5:
%!	stations(+Line:line,+Stations:list) is det
%!	stations(+Line:line,-Stations:list) is det
%!	stations(-Line:line,-Stations:list) is nondet
% this predicate return all stationson a specified line
stations(Line,Stations):-
	setof(X,station_is_on_line(X,Line),Stations).

%!	station_is_on_line(+Sation:station,+Line:line) is det
%!	station_is_on_line(+Sation:station,-Line:line) is nondet
%!	station_is_on_line(-Sation:station,+Line:line) is nondet
%!	station_is_on_line(-Sation:station,-Line:line) is nondet
% this predicate returns true if the station is on the line
station_is_on_line(X,Line):-
	connected(X,_,Line);
	connected(_,X,Line).

%Aufgabe 3:
% Finde eine Station, die von Picadilly Circus erreichbar ist unter Benutzung von exakt 2 Linien.
%	reachable(piccadilly_circus,Y,Stations,Lines),length(Lines,2). 
% Prolog Antwort:
%	Y = charing_cross,
%	Stations = [leicester_square],
%	Lines = [piccadilly, northern] ;
%	false.
%
% Finde eine Station die von Bond Street erreichbar ist, wo man startet auf der Central Linie,
% wobei mindestens 2 Weitere Stations dazwischen sind.
% 	reachable(bond_street,Y,Stations,[central|Lines]), length(Stations,Length), Length >=2.
% Prologs Antwort
% 	Y = leicester_square,
%	Stations = [tottenham_court_road, oxford_circus],
%	Lines = [northern],
%	Length = 2 ;
%	Y = charing_cross,
%	Stations = [leicester_square, tottenham_court_road, oxford_circus],
%	Lines = [northern],
%	Length = 3 ;
%	Y = leicester_square,
%	Stations = [piccadilly_circus, oxford_circus],
%	Lines = [bakerloo, piccadilly],
%	Length = 2 ;
%	Y = charing_cross,
%	Stations = [piccadilly_circus, oxford_circus],
%	Lines = [bakerloo],
%	Length = 2 ;
%	Y = charing_cross,
%	Stations = [leicester_square, piccadilly_circus, oxford_circus],
%	Lines = [bakerloo, piccadilly, northern],
%	Length = 3 ;
%	false.
%
% Finde alle Stations die 4 Stations zwischen sich haben auf 5 Linien.
% 	reachable(X,Y,Stations,Lines),length(Stations,4),length(Lines,5).
% Prologs Antwort:
%	X = bond_street,  
%	Y = charing_cross,
%	Stations = [leicester_square, piccadilly_circus, oxford_circus, green_park],
%	Lines = [jubilee, victoria, bakerloo, piccadilly, northern] ;
%	false.