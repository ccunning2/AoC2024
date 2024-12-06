:- use_module('../readLines').


part1 :-
        read_file_construct_list('2/input.txt', List),
        make_each_row_list_of_numbers(List,[], NumList),
        count_safe(NumList, 0, Total),
        write('The safe count is '), write(Total).

part2 :-
        read_file_construct_list('2/input.txt', List),
        make_each_row_list_of_numbers(List,[], NumList),
        count_safe_2(NumList, 0, Total),
        write('The safe count is '), write(Total).


make_each_row_list_of_numbers([], Acc, Acc).
make_each_row_list_of_numbers([H|T], Acc, Result) :-
    split_string(H, " ", "", NumStrings),
    convert_to_numbers(NumStrings, [], Nums),
    append(Acc, [Nums], NewAcc),
    make_each_row_list_of_numbers(T, NewAcc, Result).


convert_to_numbers([], Acc, Acc).
convert_to_numbers([H|T], Acc, Result) :-
    number_string(Num, H),
    append(Acc, [Num], NewAcc),
    convert_to_numbers(T, NewAcc, Result).




check_safety(List) :-
    is_sequential(List),
    no_sequential_diff_gt_three(List).   


check_safety_2(List) :-
    (
    is_sequential(List), no_sequential_diff_gt_three(List)
    ;
    is_sequential_2(List), no_sequential_diff_gt_three(List)
    ;
    is_sequential(List), no_sequential_diff_gt_three_2(List)   
    ).

is_sequential([]).
is_sequential([_]).
is_sequential([A, B | Rest]) :-
    A < B, 
    is_increasing([B | Rest]).
is_sequential([A, B | Rest]) :-
    A > B, 
    is_decreasing([B | Rest]).


is_sequential_2([]).
is_sequential_2([_]).
is_sequential_2([A, B | Rest]) :-
    A < B, 
    is_increasing_2([B | Rest]).
is_sequential_2([A, B | Rest]) :-
    A > B, 
    is_decreasing_2([B | Rest]).


is_increasing([]).
is_increasing([_]).
is_increasing([A, B | Rest]) :-
    A < B,
    is_increasing([B | Rest]).


is_increasing_2([]).
is_increasing_2([_]).
is_increasing_2([A, B | Rest]) :-
    (
        A < B -> is_increasing_2([B | Rest]);
        is_increasing([B|Rest])
    ).


is_decreasing([]).
is_decreasing([_]).
is_decreasing([A, B | Rest]) :-
    A > B,
    is_decreasing([B | Rest]).


is_decreasing_2([]).
is_decreasing_2([_]).
is_decreasing_2([A, B | Rest]) :-
    (
    A > B -> is_decreasing_2([B | Rest]);
    is_decreasing([B | Rest])
    ).


no_sequential_diff_gt_three([]).
no_sequential_diff_gt_three([_]).
no_sequential_diff_gt_three([A,B | Rest]) :-
    Diff is abs(A-B),
    Diff < 4,
    no_sequential_diff_gt_three([B | Rest]).



no_sequential_diff_gt_three_2([]).
no_sequential_diff_gt_three_2([_]).
no_sequential_diff_gt_three_2([A,B | Rest]) :-
    Diff is abs(A-B),
    Diff < 4 -> no_sequential_diff_gt_three_2([B | Rest]);
    no_sequential_diff_gt_three([A | Rest]). %Remove B



count_safe([], Acc, Acc).
count_safe([H | T], Acc, Total) :-
    ( check_safety(H) -> (NewAcc is Acc + 1)
    ;
    (NewAcc is Acc)
    ),
    count_safe(T, NewAcc, Total).



count_safe_2([], Acc, Acc).
count_safe_2([H | T], Acc, Total) :-
    (
% Case 1 -- normal safety check passes
    check_safety(H) -> NewAcc is Acc + 1,
    count_safe_2(T, NewAcc, Total)
    ;
    %Case 2 -- we try removing elements
    remove_one_item_check(H, check_safety) -> NewAcc is Acc + 1,
    count_safe_2(T, NewAcc,Total)
    ;
    %Case 3 -- it's not safe
    NewAcc is Acc,
    count_safe_2(T, NewAcc, Total)
    ).
% count_safe_2([H | T], Acc, Total) :-
%     (   
%         % Case 1: H passes check_safety_2
%         check_safety_2(H) -> 
%         NewAcc is Acc + 1, asserta(good(H)),
%         count_safe_2(T, NewAcc, Total)
%     ;
%         % Case 2: H is a list and its tail passes check_safety_2
%         (is_list(H), H = [_ | Tail], check_safety(Tail) ->
%         NewAcc is Acc + 1, asserta(tail(Tail)),
%         count_safe_2(T, NewAcc, Total)
%         ;
%         % Case 3: Neither passes; do not increment
%         NewAcc is Acc, asserta(bad(H)),
%         count_safe_2(T, NewAcc, Total)
%         )
%     ).
% 622, 746

remove_one_item_check(List, Condition) :-
    remove_one(List, NewList),
    call(Condition, NewList),
    !. %Add the 'cut' here to stop more searches


%Example that should pass [37,38,37,34,31]
%Another [73, 71, 69, 68, 65, 66, 62] -- By removing 66
remove_one([_], []).
remove_one([H|T], T).
remove_one([H|T], [H|Modified]) :-
    remove_one(T, Modified).