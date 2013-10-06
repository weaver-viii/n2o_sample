-module(users).
-include("users.hrl").
-compile(export_all).

is_rest() -> true.
init() -> ets:new(users, [public, named_table, {keypos, #user.id}]).
populate(Users) -> ets:insert(users, Users).
exists(Id) -> ets:member(users, wf:to_list(Id)).
get() -> ets:tab2list(users).
get(Id) -> [User] = ets:lookup(users, wf:to_list(Id)), User.
delete(Id) -> ets:delete(users, Id).
post(User=#user{}) -> ets:insert(users, User);
post(Data) -> ets:insert(users, unmap(Data, #user{})).

map(#user{id = Id, name = Name, email = Email}) ->
  [ {id,    wf:to_binary(Id)},
    {name,  wf:to_binary(Name)},
    {email, wf:to_binary(Email)} ].

unmap([],                         O) -> O;
unmap([{<<"id">>,    Id}    | T], O) -> unmap(T, O#user{id    = Id});
unmap([{<<"name">>,  Name}  | T], O) -> unmap(T, O#user{name  = Name});
unmap([{<<"email">>, Email} | T], O) -> unmap(T, O#user{email = Email});
unmap([ _                   | T], O) -> unmap(T, O).

keys_allowed(Fields) ->
     lists:subtract(lists:map(fun wf:to_list/1, Fields),
                    lists:map(fun wf:to_list/1, record_info(fields, user))) == [].
