Erlang REST Chat
================

An OTP application that connects to EMQ broker with the help of emqttc client library and accepts client requests over REST.
Uses Cowboy as a Web Server.

Pre-requisites
--------------
    - Erlang
    - Rebar3
    - EMQ Broker

Build
-----

    $ rebar3 clean
    $ rebar3 compile
    $ rebar3 release


Execute
-------

    $ ./run