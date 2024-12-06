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



is_increasing([]).
is_increasing([_]).
is_increasing([A, B | Rest]) :-
    A < B,
    is_increasing([B | Rest]).


is_decreasing([]).
is_decreasing([_]).
is_decreasing([A, B | Rest]) :-
    A > B,
    is_decreasing([B | Rest]).


no_sequential_diff_gt_three([]).
no_sequential_diff_gt_three([_]).
no_sequential_diff_gt_three([A,B | Rest]) :-
    Diff is abs(A-B),
    Diff < 4,
    no_sequential_diff_gt_three([B | Rest]).


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

remove_one_item_check(List, Condition) :-  %Here 'condition' can be any rule/1 (that takes a List)
    remove_one(List, NewList),
    call(Condition, NewList),
    !. %Add the 'cut' here to stop more searches


remove_one([_], []).
remove_one([H|T], T).
remove_one([H|T], [H|Modified]) :-
    remove_one(T, Modified).