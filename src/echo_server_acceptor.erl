-module(echo_server_acceptor).

-behaviour(gen_server).

-export([start_link/1, init/1, handle_info/2, handle_call/3, handle_cast/2]).

-record(state, {socket = false}).

start_link(Socket) ->
    gen_server:start_link(?MODULE, Socket, []).

init(Socket) ->
    self() ! wait_for_connection,
    {ok, #state{socket = Socket}}.

handle_info(wait_for_connection, State = #state{socket = ListenSocket}) ->
    accept_and_delegate(ListenSocket),
    self() ! wait_for_connection,
    {noreply, State}.

handle_call(_Req, _From, State) ->
    {reply, ok, State}.

handle_cast(_Req, State) ->
    {noreply, State}.

accept_and_delegate(ListenSocket) ->
    {ok, Socket} = gen_tcp:accept(ListenSocket),
    {ok, Pid} = supervisor:start_child(echo_server_worker_sup, [Socket]),
    ok = gen_tcp:controlling_process(Socket, Pid).
