-module(middleman).

-define(DEFAULT_TIMEOUT, 5000).

%% API exports
-export([async/1,
         async/2]).


%% API functions
async(Fun) when is_function(Fun) ->
    async(Fun, ?DEFAULT_TIMEOUT).

async(Fun, Timeout) when is_function(Fun) ->
    F = fun() ->
                exit(Fun, [])
        end,
    {Pid, Ref} = spawn_monitor(F),
    receive
        {'DOWN', Ref, process, Pid, Return} ->
            Return
    after Timeout ->
            {error, timeout}
    end.                                                  


%% Internal functions

