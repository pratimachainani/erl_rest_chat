erl_rest_chat
=====

An OTP application that connects to EMQ broker with the help of emqttc library and accepts client requests over REST.
Uses Cowboy as a Web Server

Build
-----

    $ rebar3 clean
    $ rebar3 compile
    $ rebar3 release
