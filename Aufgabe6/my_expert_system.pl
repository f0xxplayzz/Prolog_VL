:-dynamic wants_to/2.
:-dynamic likes_taste_of/2.
:-dynamic can_still_walk/1.
:-dynamic is_over_18/1.
:-dynamic is_not_driver/1.
:-dynamic is_thirsty/1.
:-dynamic is_tired/1.
:-dynamic is_poor/1.


cleanup :- 
    retractall(wants_to(_,_)),
    retractall(likes_taste_of(_,_)), 
    retractall(can_still_walk(_)),
    retractall(is_over_18(_)),
    retractall(is_not_driver),
    retractall(is_thirsty),
    retractall(is_tired(_)),
    retractall(is_poor(_)),
    cleanup_shell.

:- consult('expert_system_shell2').

%%  next_drink(Person,Drink)
% Person should drink Drink as his/her next drink
%
%   Top Level predicate, to be used as Goal in solve(Goal)
%   the top level predicate of the expert system shell
next_drink(Person,scotch):-
    allowed_to_drink(Person),
    wants_to(Person,celebrate_something_special),
    likes_taste_of(Person,whisky).
next_drink(Person,champagner):-
    allowed_to_drink(Person),
    wants_to(Person,celebrate_something_special),
    likes_taste_of(Person,sparkling_wine).
next_drink(Person,long_island_ice_tea):-
    likes_taste_of(Person,tequila), 
    wants_to(Person,drink_alcohol),
    wants_to(Person,be_drunk), 
    allowed_to_drink(Person).
next_drink(Person,pina_colada):-
    likes_taste_of(Person,cream),
    likes_taste_of(Person,pineapple),
    allowed_to_drink(Person),
    wants_to(Person,drink_alcohol).
next_drink(Person,gin_tonic):-
    likes_taste_of(Person,tonic_water),
    likes_taste_of(Person,gin), 
    wants_to(Person,drink_alcohol),
    allowed_to_drink(Person).
next_drink(Person,tequila):-
    likes_taste_of(Person,tequila), 
    wants_to(Person,drink_alcohol),
    allowed_to_drink(Person).
next_drink(Person,coffee):-
    likes_taste_of(Person,coffee),
    is_tired(Person),
    wants_to(Person,stay_longer).
next_drink(Person,red_bull):-
    is_tired(Person),
    wants_to(Person,stay_longer).
next_drink(Person,wodka_bull):-
    is_tired(Person),
    wants_to(Person,stay_longer),
    wants_to(Person,drink_alcohol),
    allowed_to_drink(Person).
next_drink(Person,zombie):-
    likes_taste_of(Person,tropical_fruit),
    allowed_to_drink(Person),
    wants_to(Person,drink_alcohol).
next_drink(Person,mona_lisa):-
    likes_taste_of(Person,watermelon),
    allowed_to_drink(Person),
    wants_to(Person,drink_alcohol).
next_drink(Person,whisky_sour):-
    likes_taste_of(Person,orange),
    likes_taste_of(Person,whisky),
    allowed_to_drink(Person),
    wants_to(Person,drink_alcohol).
next_drink(Person,halbe):-
    likes_taste_of(Person,export_beer),
    wants_to(Person,drink_some_alcohol),
    allowed_to_drink(Person).
next_drink(Person,pils):-
    likes_taste_of(Person,pilsner_beer),
    wants_to(Person,drink_some_alcohol),
    allowed_to_drink(Person).
next_drink(Person,sparkling_wine):-
    allowed_to_drink(Person),
    wants_to(Person,drink_some_alcohol),
    likes_taste_of(Person,sparkling_wine).
next_drink(Person,wine):-
    likes_taste_of(Person,grapes),
    allowed_to_drink(Person),
    wants_to(Person,drink_some_alcohol).
next_drink(Person,apple_juice):-
    likes_taste_of(Person,apple),
    is_thirsty(Person).
next_drink(Person,apple_juice):-
    likes_taste_of(Person,apple),
    wants_to(Person,drink_no_alcohol).
next_drink(Person,orange_juice):-
    likes_taste_of(Person,orange),
    is_thirsty(Person).
next_drink(Person,orange_juice):-
    likes_taste_of(Person,orange),
    wants_to(Person,drink_no_alcohol).
next_drink(Person,fanta):-
    likes_taste_of(Person,orange),
    is_thirsty(Person).
next_drink(Person,fanta):-
    likes_taste_of(Person,orange),
    wants_to(Person,drink_no_alcohol).
next_drink(Person,coke_light):-
    likes_taste_of(Person,coke),
    wants_to(Person,lose_weight),
    is_thirsty(Person).
next_drink(Person,coke):-
    likes_taste_of(Person,coke),
    is_thirsty(Person).
next_drink(Person,grape_juice):-
    likes_taste_of(Person,grapes).
next_drink(Person,water):-
    is_thirsty(Person),
    is_poor(Person).
next_drink(Person,water):-
    wants_to(Person,lose_weight).
next_drink(Person,water):-
    wants_to(Person,save_some_money).

allowed_to_drink(Person):-
    can_still_walk(Person),
    is_over_18(Person),
    is_not_driver(Person).

askable(wants_to(_,_)).
askable(likes_taste_of(_,_)).
askable(can_still_walk(_)).
askable(is_not_driver(_)).
askable(is_over_18(_)).
askable(is_thirsty(_)).
askable(is_tired(_)).
askable(is_poor(_)).