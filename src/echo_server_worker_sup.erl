-module(echo_server_worker_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    {ok, {{simple_one_for_one, 1, 5}, [worker_spec()]}}.

worker_spec() ->
    #{id => worker,
      start => {echo_server_worker, start_link, []},
      restart => temporary,
      type => worker}.
