-module(<%= baseName %>_sup).

-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() -> 
    supervisor:start_link({local, ?MODULE}, ?MODULE, {}).

init({}) ->
    <% if (entities.length > 0) { %>sumo:create_schema(),<% }; %>
    {ok, {{one_for_one, 10, 10}, []}}.
