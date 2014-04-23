%% @doc <%= _.capitalize(name) %> model
-module(<%= baseName %>_<%= pluralize(name) %>).

-behaviour(sumo_doc).

-export([new/2]).
-export([sumo_schema/0, sumo_wakeup/1, sumo_sleep/1]).

new(Id, Params) ->
    [{id, Id}
     <% _.each(attrs, function(attr) { %>, {<%= attr.attrName %>, proplists:get_value(<<"<%= attr.attrName %>">>, Params)}
     <% }); %>].

sumo_schema() ->
    sumo:new_schema(?MODULE,
        [ sumo:new_field(id, integer, [id, not_null, auto_increment])
        <% _.each(attrs, function(attr) { %>, sumo:new_field(<%= attr.attrName %>, <%= attr.attrImplType %>, [<% if (attr.attrImplType == 'string') { %>{length, <% if (attr.maxLength) { %><%= attr.maxLength %><% } else { %>255<% }; %>}<% }; %><% if (attr.required) { %><% if (attr.attrImplType == 'string') { %>, <% }; %>not_null<% }; %>])
        <% }); %>
        ]).

sumo_sleep(Entity) -> Entity.

attr_wakeup(Value) ->
    case Value of
        {date, {Year, Month, Day}} ->
            list_to_binary(io_lib:format("~p-~p-~p", [Year, Month, Day]));
        <<"true">> ->
            true;
        <<"false">> ->
            false;
        _ ->
            Value
    end.

sumo_wakeup(Entity) -> 
    lists:map(
        fun({Key, Value}) ->
            {Key, attr_wakeup(Value)}
        end, Entity).

