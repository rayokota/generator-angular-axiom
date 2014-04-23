-module(<%= baseName %>).
-export([start/0, start/2, stop/0, stop/1]).

start() -> application:ensure_all_started(<%= baseName %>).

stop() -> application:stop(<%= baseName %>).

start(_StartType, _StartArgs) ->
    application:start(crypto),
    application:start(ranch),
    application:start(cowboy),
    Options = [{port, 8080}],
    axiom:start(<%= baseName %>_routes, Options),
    <%= baseName %>_sup:start_link().

stop(_State) ->
    ok.
