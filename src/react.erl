-module(react).
-include_lib("n2o/include/wf.hrl").
-compile(export_all).
-record(react,{props=[],state,name,init,render,willMount=fun(X)->X end}).
get_users() -> [[{id,maxim},{email,"maxim@synrc.com"},{tokens,1}],
                [{id,doxtop},{email,"doxtop@synrc.com"},{tokens,2}],
                [{id,vlad},{email,"vlad@synrc.com"},{tokens,3}]].
value(Key,Map) -> proplists:get_value(Key,Map). % Erlang
store(Key,Map,Value) -> proplists:delete(Key,Map), [{Key,Value}|Map].

main() ->

    User = #react{
        render = fun(This) ->
            #'div'{ body=[ #h2 { body = value(id,This) },
                "E-mail: ", value(email,This), #br{},
                "Tokens: ", value(tokens,This) ] } end },

    CommentList = #react{
        props = [{data,[]}],
        render = fun(Props) ->
            Users = lists:map(fun(Item) ->
                User#react{props=Item} end,value(data,Props)),
            #'div'{class=commentList,body=render(Users)} end },

    CommentBox = #react{
        props = [{url,"http://localhost:8000/rest/users"},{data,[]}],
        willMount = fun(Props) ->
            store(data,Props,get_users()) end,
        render = fun(Props) -> [ #h1{body=["Users"]}, CommentList#react{props=Props} ] end }.

render(List) when is_list(List) -> [ render(React) || React <- List];
render(React=#react{render=Render,props=Props,willMount=Mount}) -> render(Render(Mount(Props)));
render(Unknown) -> Unknown.

x() -> wf:render(render(main())).
