-module(users).
-include_lib("n2o/include/wf.hrl").
-include("users.hrl").
-compile(export_all).

?map(user).
?unmap(user).
?rest().

init() -> ets:new(users, [public, named_table, {keypos, #user.id}]).
populate(Users) -> ets:insert(users, Users).
exists(Id) -> ets:member(users, wf:to_list(Id)).
get() -> ets:tab2list(users).
get(Id) -> [User] = ets:lookup(users, wf:to_list(Id)), User.
delete(Id) -> ets:delete(users, Id).
post(Data) -> ets:insert(users, unmap(Data, #user{})).
