-module(echo_server_worker).

-behaviour(gen_server).

-export([start_link/1, init/1, handle_info/2, handle_call/3, handle_cast/2,
         terminate/2]).

-record(state, {socket = false}).

start_link(Socket) ->
    gen_server:start_link(?MODULE, Socket, []).

init(Socket) ->
    self() ! init,
    {ok, #state{socket = Socket}}.

handle_info(init, State = #state{socket = Socket}) ->
    ok = receive_next_packet(Socket),
    ok = inet:setopts(Socket, [{active, once}]),
    {noreply, State};
handle_info({tcp, _Port, Msg}, State = #state{socket = Socket}) ->
    ok = gen_tcp:send(Socket, Msg),
    ok = receive_next_packet(Socket),
    {noreply, State}.

terminate(_Reson, #state{socket = Socket}) ->
    gen_tcp:close(Socket).

handle_call(_Req, _From, State) ->
    {reply, ok, State}.

handle_cast(_Req, State) ->
    {noreply, State}.

receive_next_packet(Socket) ->
    inet:setopts(Socket, [{active, once}]).
