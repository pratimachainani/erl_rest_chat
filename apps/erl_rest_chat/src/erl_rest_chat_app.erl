%%%-------------------------------------------------------------------
%% @doc erl_rest_chat public API
%% @end
%%%-------------------------------------------------------------------

-module(erl_rest_chat_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_Type, _Args) ->

  Dispatch = cowboy_router:compile([
    {'_',
      [
        {"/hello", route_handler, [{op, hello}]},
        {"/subscribe/:topic/:qos", route_handler, [{op, subscribe}]},
        {"/publish/:topic/:message/:qos", route_handler, [{op, publish}]},
        {"/read/:topic/:message/:qos", route_handler, [{op, read}]}
      ]}
  ]),

  {ok, _} = cowboy:start_clear(http, [{port, 8001}], #{env => #{dispatch => Dispatch}}),

    erl_rest_chat_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
