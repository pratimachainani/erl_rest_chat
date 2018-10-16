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
        hello ->
          io:fwrite("in hello ~n");
        subscribe ->
          io:fwrite("in subscribe ~n"),
          Topic = cowboy_req:binding(topic, Req),
          QoS = cowboy_req:binding(qos, Req),
          io:fwrite("in subscribe, topic: ~p qos: ~p ~n", [Topic,QoS]);
        publish ->
          io:fwrite("in publish ~n"),
          Topic = cowboy_req:binding(topic, Req),
          Message = cowboy_req:binding(message, Req),
          QoS = cowboy_req:binding(qos, Req),
          io:fwrite("in publish, topic: ~p qos: ~p message: ~p ~n", [Topic,QoS, Message]);
        read ->
          io:fwrite("in read")
      end,
      Body = <<"<h1>This is a response for POST</h1>">>;
    <<"GET">> ->
      io:fwrite("in GET ~n"),
      case Op of
        hello ->
          io:fwrite("in hello ~n");
        subscribe ->
          io:fwrite("in subscribe ~n"),
          Topic = cowboy_req:binding(topic, Req),
          QoS = cowboy_req:binding(qos, Req),
          io:fwrite("in subscribe, topic: ~p qos: ~p ~n", [Topic,QoS]);
        publish ->
          io:fwrite("in publish ~n"),
          Topic = cowboy_req:binding(topic, Req),
          Message = cowboy_req:binding(message, Req),
          QoS = cowboy_req:binding(qos, Req),
          io:fwrite("in publish, topic: ~p qos: ~p message: ~p ~n", [Topic,QoS, Message]);
        read ->
          io:fwrite("in read")
      end,
      Body = <<"<h1>This is a response for GET</h1>">>;
    _ ->
      io:fwrite("in default"),
      Body = <<"<h1>This is a response for other methods</h1>">>
  end,
  {ok, Req2} = cowboy_req:reply(200, #{}, Body, Req),
  {Body, Req2, State}.
