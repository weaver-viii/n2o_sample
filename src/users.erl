-module(users).
-include("users.hrl").
-export([init/0]).
-export([keys_allowed/1]).
-export([is_rest/0, exists/1, get/0, get/1, post/1, delete/1, to_html/1, to_json/1, fill/2]).

-define(USERS, [#user{id = "maxim",  email= "maxim@synrc.com"},
                #user{id = "doxtop", email = "doxtop@synrc.com"},
                #user{id = "roman",  email = "roman@github.com"}]).

is_rest() -> true.
init() -> ets:new(users, [public, named_table, {keypos, #user.id}]), ets:insert(users, ?USERS).
exists(Id) -> ets:member(users, binary_to_list(Id)).
get() -> ets:tab2list(users).
get(Id) -> [User] = ets:lookup(users, binary_to_list(Id)), User.
delete(Id) -> ets:delete(users, Id).
post(User=#user{}) -> ets:insert(users, User);
post(Data) -> ets:insert(users, fill(Data, #user{})).

to_html(#user{id = Id, name = Name, email = Email}) ->
  [ <<"<p>  Id: ">>, wf:to_binary(Id),
    <<",  Name: ">>, wf:to_binary(Name),
    <<", Email: ">>, wf:to_binary(Email), <<"</p>">> ].

to_json(#user{id = Id, name = Name, email = Email}) ->
  [ {id,    wf:to_binary(Id)},
    {name,  wf:to_binary(Name)},
    {email, wf:to_binary(Email)} ].

keys_allowed(Fields) ->
     lists:subtract(lists:map(fun erlang:binary_to_list/1, Fields),
                    lists:map(fun erlang:atom_to_list/1, record_info(fields, user))) == [].

fill([],                        User) -> User;
fill([{"id",    Id}    | Tail], User) -> fill(Tail, User#user{id = Id});
fill([{"name",  Name}  | Tail], User) -> fill(Tail, User#user{name = Name});
fill([{"email", Email} | Tail], User) -> fill(Tail, User#user{email = Email});
fill([{Key, Value}     | Tail], User) when is_binary(Key) -> fill([{wf:to_list(Key),wf:to_list(Value)}|Tail],User);
fill([ _               | Tail], User) -> fill(Tail, User).

