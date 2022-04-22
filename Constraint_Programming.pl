/*
Simplification:
H <=> G | B.
Propagation:
H ==> G |B.
Simpagation:
H1\H2 <=> G | B.
*/
:- use_module(library(chr)).
:- use_module(library(clpfd)).


% Minimum Berechnung

:- chr_constraint min(?int).
:- chr_constraint min2(?int).
:- chr_constraint min3(?int).

min(N)\min(M) <=> N < M | true.

min2(N)\min2(M) <=> N<M | true.
min2(N)\min2(M) <=> N=M | true.

min3(N)\min3(M) <=> N =< M | true.

% Primzahlenaufzählung

:-chr_constraint prime(?number).
:-chr_constraint upto(?number).

prime(I)\prime(J) <=> J mod I =:= 0 | true.

upto(1) <=> true.
upto(N) <=> N>1 | prime(N), K #= N - 1, upto(K).

:-chr_constraint prime2(?number).

prime2(I)\prime2(J) <=> J mod I =:= 0 | true.
prime2(N) ==> N>2 | K #= N-1,prime2(K).

% Wurzelberechnung

:-chr_constraint sqrt(?number,?number).

sqrt(X,G) <=> var(G) |sqrt(X,1).
sqrt(X,G) <=> T is G*G/X-1, abs(T)>0.0001 | Res is (G+X/G)/2, sqrt(X,Res).


:-chr_constraint nonOverlapping(?any).
:-chr_constraint nonOverlapping(?any,?any,?any).

nonOverlapping(A) <=> nonOverlapping(A,[],[]).

nonOverlapping([H|T],[],[]) <=> nonOverlapping(T,[H],[]).
nonOverlapping([H|T],[H2|T2],R) <=> H #\= H2 | nonOverlapping([H|T],T2,[H2|R]).
nonOverlapping([H|_],[H2|_],_) <=> H #= H2 | false.
nonOverlapping([H|T],[],R) <=> nonOverlapping(T,[H|R],[]).
nonOverlapping([],_,_) <=> true.

:-chr_constraint minOneLecturePerDay(?any,?int).
:-chr_constraint minOneLecturePerDay_(?any,?int).
:-chr_constraint lectures(?any,?int).
:-chr_constraint lectureDay(?int,?int).
:-chr_constraint repeat(?any,?int).

%minOneLecturePerDay([],[],[]),lectureDay(A) <=> A #= 5 | true.

minOneLecturePerDay(X,ID) <=> minOneLecturePerDay_(X,ID), repeat(0,ID).

minOneLecturePerDay_([H|T],ID),repeat(A,ID1) <=> ID #= ID1 | New #= (H-1) // 3, A2 #= A +1, lectureDay(New,ID),minOneLecturePerDay_(T,ID),repeat(A2,ID).

minOneLecturePerDay_([],ID) <=> lectures([0,0,0,0,0],ID).

lectures([A,B,C,D,E],ID), lectureDay(Day,ID2),repeat(X,ID3) <=> Day #= 0, ID #=ID2 , ID2 #= ID3| NewA #= A +1 ,lectures([NewA,B,C,D,E],ID),A2 #= X -1, repeat(A2,ID).
lectures([A,B,C,D,E],ID), lectureDay(Day,ID2),repeat(X,ID3) <=> Day #= 1, ID #=ID2 , ID2 #= ID3| NewB #= B +1 ,lectures([A,NewB,C,D,E],ID),A2 #= X -1, repeat(A2,ID).
lectures([A,B,C,D,E],ID), lectureDay(Day,ID2),repeat(X,ID3) <=> Day #= 2, ID #=ID2 , ID2 #= ID3| NewC #= C +1 ,lectures([A,B,NewC,D,E],ID),A2 #= X -1, repeat(A2,ID).
lectures([A,B,C,D,E],ID), lectureDay(Day,ID2),repeat(X,ID3) <=> Day #= 3, ID #=ID2 , ID2 #= ID3| NewD #= D +1 ,lectures([A,B,C,NewD,E],ID),A2 #= X -1, repeat(A2,ID).
lectures([A,B,C,D,E],ID), lectureDay(Day,ID2),repeat(X,ID3) <=> Day #= 4, ID #=ID2 , ID2 #= ID3| NewE #= E +1 ,lectures([A,B,C,D,NewE],ID),A2 #= X -1, repeat(A2,ID).

lectures([A|_],ID),repeat(0,ID2) <=> A #= 0, ID #= ID2 | false.
lectures([A|T],ID),repeat(0,ID2) <=> A #\= 0, ID #= ID2 | lectures(T,ID),repeat(0,ID).
lectures([],ID),repeat(0,ID2) <=> ID #= ID2 | true.

:-chr_constraint maxTwoLecturesPerDay(?any,?int).
:-chr_constraint maxTwoLecturesPerDay_(?any,?int).
:-chr_constraint lectureDayDoz(?int,?int).
:-chr_constraint lecturesDoz(?any,?int).
:-chr_constraint repeatDoz(?any,?int).

maxTwoLecturesPerDay(X,ID) <=> maxTwoLecturesPerDay_(X,ID), repeatDoz(0,ID).

maxTwoLecturesPerDay_([H|T],ID),repeatDoz(A,ID2) <=> ID #= ID2 | New #= (H-1) // 3, A2 #= A +1, lectureDayDoz(New,ID),maxTwoLecturesPerDay_(T,ID),repeatDoz(A2,ID).

maxTwoLecturesPerDay_([],ID) <=> lecturesDoz([0,0,0,0,0],ID).

lecturesDoz([A,B,C,D,E],ID), lectureDayDoz(Day,ID2),repeatDoz(X,ID3) <=> Day #= 0, ID#= ID2, ID2 #= ID3 | NewA #= A +1 ,lecturesDoz([NewA,B,C,D,E],ID),A2 #= X -1, repeatDoz(A2,ID).
lecturesDoz([A,B,C,D,E],ID), lectureDayDoz(Day,ID2),repeatDoz(X,ID3) <=> Day #= 1, ID#= ID2, ID2 #= ID3 | NewB #= B +1 ,lecturesDoz([A,NewB,C,D,E],ID),A2 #= X -1, repeatDoz(A2,ID).
lecturesDoz([A,B,C,D,E],ID), lectureDayDoz(Day,ID2),repeatDoz(X,ID3) <=> Day #= 2, ID#= ID2, ID2 #= ID3 | NewC #= C +1 ,lecturesDoz([A,B,NewC,D,E],ID),A2 #= X -1, repeatDoz(A2,ID).
lecturesDoz([A,B,C,D,E],ID), lectureDayDoz(Day,ID2),repeatDoz(X,ID3) <=> Day #= 3, ID#= ID2, ID2 #= ID3 | NewD #= D +1 ,lecturesDoz([A,B,C,NewD,E],ID),A2 #= X -1, repeatDoz(A2,ID).
lecturesDoz([A,B,C,D,E],ID), lectureDayDoz(Day,ID2),repeatDoz(X,ID3) <=> Day #= 4, ID#= ID2, ID2 #= ID3 | NewE #= E +1 ,lecturesDoz([A,B,C,D,NewE],ID),A2 #= X -1, repeatDoz(A2,ID).

lecturesDoz([A|_],ID),repeatDoz(0,ID2) <=> A #> 2, ID #= ID2 | false.
lecturesDoz([A|T],ID),repeatDoz(0,ID2) <=> A #=< 2, ID #= ID2 | lecturesDoz(T,ID),repeatDoz(0,ID).
lecturesDoz([],ID),repeatDoz(0,ID2) <=> ID #= ID2 | true.

:-chr_constraint nonOverlappingRooms(?any,?any,?int).
:-chr_constraint lectureUnit(?int,?int,?int).



nonOverlappingRooms([H|T],[H2|T2],ID) <=> lectureUnit(H,H2,ID),nonOverlappingRooms(T,T2,ID).
nonOverlappingRooms([],[],_) <=> true.
nonOverlappingRooms([],[_|_],_) ==> false.
nonOverlappingRooms([_|_],[],_) ==> false.

lectureUnit(A,B,ID),lectureUnit(C,D,ID2) <=> A #= C, B #= D, ID #= ID2 | false.

lectureUnit(A,B,ID),lectureUnit(C,D,ID) ==> A #\=C ; B #\= D | true.

schedule(Subs,Rooms) :-
    Subs = [DB2,ITS,KI,LP,FP,ASWE,SV,DB1,TINF3,SWE,M2,P2,RA,BS,DT,TINF1,M1,P1,VLA,WE,BWL],
    Rooms = [R_DB2,R_ITS,R_KI,R_LP,R_FP,R_ASWE,R_SV,R_DB1,R_TINF3,R_SWE,R_M2,R_P2,R_RA,R_BS,R_DT,R_TINF1,R_M1,R_P1,R_VLA,R_WE,R_BWL],
    Subs ins 1..15,
    Rooms ins 1..5,
    Inf2019 = [DB2,ITS,KI,LP,FP,ASWE,SV],
    Inf2020 = [DB1,TINF3,SWE,M2,P2,RA,BS],
    Inf2021 = [DT,TINF1,M1,P1,VLA,WE,BWL] ,
    nonOverlapping(Inf2019), minOneLecturePerDay(Inf2019,2), 
    nonOverlapping(Inf2020), minOneLecturePerDay(Inf2020,4),
    nonOverlapping(Inf2021), minOneLecturePerDay(Inf2021,6),
    A=[DB1,DB2],
    B=[TINF1,KI,LP,ASWE],
    C=[FP,TINF3,P1],
    D=[WE,BWL],
    E=[SWE,P2],
    G=[RA,DT,BS],
    H=[ITS,SV],
    I=[M1,M2],
    nonOverlapping(A), maxTwoLecturesPerDay(A,8),
    nonOverlapping(B), maxTwoLecturesPerDay(B,10),
    nonOverlapping(C), maxTwoLecturesPerDay(C,12),
    nonOverlapping(D), maxTwoLecturesPerDay(D,14),
    nonOverlapping(E), maxTwoLecturesPerDay(E,16),
    nonOverlapping(G), maxTwoLecturesPerDay(G,18),
    nonOverlapping(H), maxTwoLecturesPerDay(H,20),
    nonOverlapping(I), maxTwoLecturesPerDay(I,22),
    nonOverlappingRooms(Subs,Rooms,23).

genHelpers([H|T],[H2|T2],[H3|T3]):-H3 in 1..75,H3 #= H * H2, genHelpers(T,T2,T3).
genHelpers([],[],[]).

genDays([H|T],[H2|T2]):- H2 in 0..4, Temp #= H -1, H2 #= Temp div 3, genDays(T,T2).
genDays([],[]).

schedule_(Subs,Rooms):-
    Subs = [DB2,ITS,KI,LP,FP,ASWE,SV,DB1,TINF3,SWE,M2,P2,RA,BS,DT,TINF1,M1,P1,VLA,WE,BWL],
    Rooms = [R_DB2,R_ITS,R_KI,R_LP,R_FP,R_ASWE,R_SV,R_DB1,R_TINF3,R_SWE,R_M2,R_P2,R_RA,R_BS,R_DT,R_TINF1,R_M1,R_P1,R_VLA,R_WE,R_BWL],
    Subs ins 1..15,
    Rooms ins 1..5,
    Inf2019 = [DB2,ITS,KI,LP,FP,ASWE,SV],
    Inf2020 = [DB1,TINF3,SWE,M2,P2,RA,BS],
    Inf2021 = [DT,TINF1,M1,P1,VLA,WE,BWL] ,
    A=[DB1,DB2],
    B=[TINF1,KI,LP,ASWE],
    C=[FP,TINF3,P1],
    D=[WE,BWL],
    E=[SWE,P2],
    G=[RA,DT,BS],
    H=[ITS,SV],
    I=[M1,M2],
    all_distinct(Inf2019),
    all_distinct(Inf2020),
    all_distinct(Inf2021),
    all_distinct(A),
    all_distinct(B),
    all_distinct(C),
    all_distinct(D),
    all_distinct(E),
    all_distinct(G),
    all_distinct(H),
    all_distinct(I),
    genHelpers(Subs,Rooms,Helpers),
    all_distinct(Helpers),
    genDays(Inf2019,Days19),
    genDays(Inf2020,Days20),
    genDays(Inf2021,Days21),
    genDays(B,DaysB),
    genDays(C,DaysC),
    genDays(G,DaysG),
    StudDays = [Mon19,Mon20,Mon21,Tue19,Tue20,Tue21,Wed19,Wed20,Wed21,Thu19,Thu20,Thu21,Fri19,Fri20,Fri21],
    DozDays = [MonB,MonC,MonG,TueB,TueC,TueG,WedB,WedC,WedG,ThuB,ThuC,ThuG,FriB,FriC,FriG],
    DozDays ins 0..2,
    StudDays ins 1..3,
    global_cardinality(Days19,[0-Mon19,1-Tue19,2-Wed19,3-Thu19,4-Fri19]),
    global_cardinality(Days20,[0-Mon20,1-Tue20,2-Wed20,3-Thu20,4-Fri20]),
    global_cardinality(Days21,[0-Mon21,1-Tue21,2-Wed21,3-Thu21,4-Fri21]),
    global_cardinality(DaysB,[0-MonB,1-TueB,2-WedB,3-ThuB,4-FriB]),
    global_cardinality(DaysC,[0-MonC,1-TueC,2-WedC,3-ThuC,4-FriC]),
    global_cardinality(DaysG,[0-MonG,1-TueG,2-WedG,3-ThuG,4-FriG]).