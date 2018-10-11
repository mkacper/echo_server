-module(echo_server_acceptor_sup).

-behaviour(supervisor).

-define(NUM_OF_ACCEPTORS, 10).
-define(LISTEN_PORT, 12345).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    {ok, Socket} = gen_tcp:listen(?LISTEN_PORT, [binary, {active, false}]),
    {ok, {{one_for_one, 1, 5}, acceptors_specs(Socket)}}.

acceptors_specs(Socket) ->
    [#{id => X,
       start => {echo_server_acceptor, start_link, [Socket]},
       restart => permanent,
       type => worker} || X <- lists:seq(1, ?NUM_OF_ACCEPTORS)].
