-module(login).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").

title() -> [ <<"Login">> ].
main() -> #dtl{file = "login", app=n2o_sample,bindings=[{title,title()},{body,body()}]}.

body() ->
 [ #span{id=display}, #br{},
            #span{body="Login: "}, #textbox{id=user}, #br{},
            #span{body="Password: "}, #password{id=pass},
            #button{id=login,body="Login",postback=login,source=[user,pass]} ].
%    react:x().

event(init) -> [];
event(login) ->
    User = wf:q(user),
    wf:update(display,User),
    wf:user(User),
    <<"/ws/",X/binary>> = wf:path(?REQ),
    case X of
        <<>> -> wf:redirect("/index");
        <<"login">> -> wf:redirect("/index");
         _ -> wf:redirect("/static/spa/index.htm") end.
