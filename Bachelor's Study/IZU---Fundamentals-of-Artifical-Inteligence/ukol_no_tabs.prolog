%delka linearniho seznamu
delka([],0).
delka([_|T],S) :- delka(T,SS), S is SS + 1.

%je prvek clenem lin. seznamu?
jePrvek([X|_],X).
jePrvek([_|T],X) :- jePrvek(T,X). 

%spojeni dvou linearnich seznamu
spoj([],L,L).
spoj([H|T],L,[H|TT]) :- spoj(T,L,TT).


%doplnte nasledujici predikaty:
% Vytvorte funkci pro rozdeleni linearniho seznamu na poloviny
% divide_half(INPUT, HALF1, HALF2).

%podminka pro pirdavani v prvni poloviny

divide_half(INPUT, HALF1, HALF2) :- delka(INPUT, DD), D is round(DD / 2), divi(INPUT, HALF1, HALF2, D, 0).
divi(INPUT, HALF1, HALF2, DIVISION, DIVISION) :- HALF2 = INPUT, HALF1 = [].
divi([H|INPUT], HALF1, HALF2, DIVISION, I) :- MEZERA is I + 1, divi(INPUT, HLF1, HALF2, DIVISION, MEZERA), spoj([H], HLF1, HALF1).



% Vytvorte funkci pro odstraneni obecneho prvku z obecneho seznamu
% remove_item_GEN(INPUT,ITEM,OUTPUT)
remove_item_GEN([], _, []).
remove_item_GEN([ITEM|INPUT],ITEM,OUTPUT) :- remove_item_GEN(INPUT, ITEM, OUTPUT).
remove_item_GEN([H|INPUT], ITEM, OUTPUT) :- is_list(H), remove_item_GEN(H, ITEM, H_OUT), remove_item_GEN(INPUT, ITEM, OUT), spoj([H_OUT], OUT, OUTPUT).
remove_item_GEN([H|INPUT], ITEM, OUTPUT) :- remove_item_GEN(INPUT, ITEM, OUT), spoj([H], OUT, OUTPUT).

% Vytvorte funkci pro reverzaci obecneho seznamu
% reverse_GEN(INPUT,OUTPUT)
reverse_GEN([], []).
reverse_GEN([H|INPUT], OUTPUT) :- is_list(H), reverse_GEN(H, H_OUT), reverse_GEN(INPUT, OUT),	spoj(OUT, [H_OUT], OUTPUT).
reverse_GEN([H|INPUT], OUTPUT) :- reverse_GEN(INPUT, OUT), spoj(OUT, [H], OUTPUT).

% Vytvorte funkci pro vlozeni prvku na n-tou pozici linearniho seznamu
% insert_pos(LIST,POSITION,ITEM,OUTPUT)
insert_pos(LIST, POSITION, ITEM, OUTPUT) :- delka(LIST, D), POSITION = D+1, spoj(LIST, [ITEM], OUTPUT).
insert_pos(LIST, POSITION, ITEM, OUTPUT) :- POSITION > 0, SS is 1, insert_post(LIST, POSITION, ITEM, OUTPUT, SS, []).
insert_post(LIST, POSITION, ITEM, OUTPUT, POSITION, TEMP) :- spoj(TEMP,[ITEM],TMP), spoj(TMP, LIST, OUTPUT).
insert_post([H|LIST], POSITION, ITEM, OUTPUT, S, TEMP) :- spoj(TEMP, [H], TMP), SS is S + 1,
																										 insert_post(LIST, POSITION, ITEM, OUTPUT, SS, TMP).

% Vytvorte funkci pro inkrementaci kazdeho prvku obecneho seznamu o hodnotu hloubky zanoreni prvku
% increment_general(INPUT,OUTPUT)
% input [0,0,[0]] -> output [1,1,[2]]

increment_general(INPUT, OUTPUT) :- inc(INPUT, OUTPUT, 1).
inc([],[],_).
inc([H|INPUT], OUTPUT, DEPTH) :- is_list(H), TMP is DEPTH + 1, inc(H, OUT1, TMP), inc(INPUT, OUT, DEPTH), spoj([OUT1], OUT, OUTPUT).
inc([H|INPUT], OUTPUT, DEPTH) :- TMP is H + DEPTH, inc(INPUT, TEMP_LIST, DEPTH), spoj([TMP], TEMP_LIST, OUTPUT).
