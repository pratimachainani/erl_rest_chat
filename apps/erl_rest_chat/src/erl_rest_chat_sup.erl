-module(erl_rest_chat_sup).
-behaviour(supervisor).

%% API.
-export([start_link/0]).

%% supervisor.
-export([init/1]).

%% API.

-spec start_link() -> {ok, pid()}.
start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

init([]) ->
    MsgServ = {emqttc_server, {emqttc_server, start_link, [[],[]]}, permanent, 10000, worker, [emqttc_server]},
    {ok, { {one_for_one, 0, 1}, [MsgServ]} }.
