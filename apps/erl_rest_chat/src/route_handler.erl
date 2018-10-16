%%%-------------------------------------------------------------------
%%% @author pratimachainani
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. Oct 2018 12:43
%%%-------------------------------------------------------------------
-module(route_handler).
-author("pratimachainani").

-export([init/2]).
-export([content_types_provided/2]).
-export([content_types_accepted/2]).
-export([allowed_methods/2]).
-export([handle/2]).
-record(state, {op, response}).

init(Req, Opts) ->
  [{op, Op} | _] = Opts,
  io:fwrite("in init, Opts: ~p ~n", [Opts]),
  State = #state{op=Op, response=none},
  {cowboy_rest, Req, State}.

content_types_provided(Req, State) ->
  {[
    {<<"text/html">>, handle},
    {<<"application/json">>, hello_to_json},
    {<<"text/plain">>, hello_to_text}
  ], Req, State}.

allowed_methods(Req, State) ->
  {[<<"GET">>, <<"POST">>], Req, State}.

content_types_accepted(Req, State) ->
  {[
    {<<"application/x-www-form-urlencoded">>, handle}
  ],Req, State}.

handle(Req, State = #state{op=Op}) ->
  Method = cowboy_req:method(Req),
  case Method of
    <<"POST">> ->
      io:fwrite("in POST ~n"),
      case Op of
        subscribe ->
          io:fwrite("in subscribe ~n"),
          Topic = cowboy_req:binding(topic, Req),
          QoS = cowboy_req:binding(qos, Req),
          io:fwrite("QoS: ~p ~n", [QoS]),
          io:fwrite("list_to_integer(binary_to_list(Qos)): ~p ~n~n", [list_to_integer(binary_to_list(QoS))]),
          emqttc_server ! {subscribe, Topic, list_to_integer(binary_to_list(QoS))},
          Body = <<"<h2>Subscribed!</h2>">>,
          io:fwrite("in subscribe, topic: ~p qos: ~p ~n", [Topic,QoS]);
        publish ->
          io:fwrite("in publish ~n"),
          Topic = cowboy_req:binding(topic, Req),
          Message = cowboy_req:binding(message, Req),
          QoS = cowboy_req:binding(qos, Req),
          emqttc_server ! {publish, Topic, Message, list_to_integer(binary_to_list(QoS))},
          Body = <<"<h2>Published!</h2>">>,
          io:fwrite("in publish, topic: ~p qos: ~p message: ~p ~n", [Topic,QoS, Message]);
        read ->
          io:fwrite("in read"),
          Body = <<"<h2>Read Message</h2>">>
      end;
    <<"GET">> ->
      Body = <<"<h1>This is a response for GET</h1>">>
  end,
  {ok, Req2} = cowboy_req:reply(200, #{}, Body, Req),
  {Body, Req2, State}.
