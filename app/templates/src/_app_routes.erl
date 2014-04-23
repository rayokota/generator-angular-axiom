-module(<%= baseName %>_routes).
-compile(export_all).

start() ->
    axiom:start(?MODULE).

<% _.each(entities, function (entity) { %>
handle(<<"GET">>, [<<"<%= baseName %>">>, <<"<%= pluralize(entity.name) %>">>], _Req) ->
    {200, jsx:encode(sumo:find_all(<%= baseName %>_<%= pluralize(entity.name) %>))};

handle(<<"GET">>, [<<"<%= baseName %>">>, <<"<%= pluralize(entity.name) %>">>, Id], _Req) ->
    Entity = sumo:find(<%= baseName %>_<%= pluralize(entity.name) %>, Id),
    case Entity of
        notfound ->
            {404, <<"No entity found">>};
        _ ->
            {200, jsx:encode(Entity)}
    end;

handle(<<"POST">>, [<<"<%= baseName %>">>, <<"<%= pluralize(entity.name) %>">>], _Req) ->
    {ok, Body, Req1} = cowboy_req:body(_Req),
    case json_decode(Body) of
        {{incomplete, _}} ->
            {400, jsx:encode(<<"Incomplete input">>)};
        {Params} ->
            Entity = sumo:persist(<%= baseName %>_<%= pluralize(entity.name) %>, <%= baseName %>_<%= pluralize(entity.name) %>:new(0, Params)),
            {201, jsx:encode(Entity)};
        {bad_json, Reason} ->
            {400, jsx:encode(Reason)}
    end;

handle(<<"PUT">>, [<<"<%= baseName %>">>, <<"<%= pluralize(entity.name) %>">>, Id], _Req) ->
    {ok, Body, Req1} = cowboy_req:body(_Req),
    case json_decode(Body) of
        {{incomplete, _}} ->
            {400, jsx:encode(<<"Incomplete input">>)};
        {Params} ->
            Entity = sumo:find(<%= baseName %>_<%= pluralize(entity.name) %>, Id),
            case Entity of
                notfound ->
                    {404, <<"No entity found">>};
                _ ->
                    NewEntity = sumo:persist(<%= baseName %>_<%= pluralize(entity.name) %>, <%= baseName %>_<%= pluralize(entity.name) %>:new(Id, Params)),
                    {200, jsx:encode(NewEntity)}
            end;
        {bad_json, Reason} ->
            {400, jsx:encode(Reason)}
    end;

handle(<<"DELETE">>, [<<"<%= baseName %>">>, <<"<%= pluralize(entity.name) %>">>, Id], _Req) ->
    Entity = sumo:find(<%= baseName %>_<%= pluralize(entity.name) %>, Id),
    case Entity of
        notfound ->
            {404, <<"No entity found">>};
        _ ->
            sumo:delete(<%= baseName %>_<%= pluralize(entity.name) %>, Id),
            {204, <<"">>}
    end;
<% }); %>

handle(<<"GET">>, [<<"/">>], Req) ->
    Req1 = axiom:redirect("/index.html", Req),
    Req.

json_decode(Bin) ->
    try {jsx:decode(Bin)}
    catch
        _:Error ->
            {bad_json, iolist_to_binary(io_lib:format("~p", [Error]))}
    end.

