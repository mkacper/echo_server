%%%-------------------------------------------------------------------
%% @doc echo_server top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(echo_server_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

init([]) ->
    {ok, {{one_for_one, 1, 5}, child_spec()}}.

%%====================================================================
%% Internal functions
%%====================================================================


child_spec() ->
    [#{id => acceptor_sup,
       start => {echo_server_acceptor_sup, start_link, []},
       restart => permanent,
       type => supervisor},
     #{id => worker_sup,
       start => {echo_server_worker_sup, start_link, []},
       restart => permanent,
       type => supervisor}].
