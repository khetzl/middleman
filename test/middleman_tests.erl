-module(middleman_tests).

-include_lib("eunit/include/eunit.hrl").

-define(M, middleman).
-define(TIMEOUT(Timeout, Callback), {timeout, Timeout, ?_test(Callback)}).

-compile(export_all).

async_test_() ->
    ?TIMEOUT(15, async()).

async() ->
    Throw = fun() -> throw(something_thrown) end,
    ?assertMatch({{nocatch, something_thrown}, _}, ?M:async(Throw)),
    
    Error = fun() -> error(some_error) end,
    ?assertEqual(some_error, ?M:async(Error)),
    
    Exit = fun() -> exit(some_exit_reason) end,
    ?assertEqual(some_exit_reason, ?M:async(Exit)),
    
    ThreeSec = fun() -> timer:sleep(3000), returned_normally end,
    SixSec = fun() -> timer:sleep(6000), returned_normally end,
    ?assertEqual(returned_normally, ?M:async(ThreeSec)),
    ?assertEqual({error, timeout}, ?M:async(ThreeSec, 1000)),
    ?assertEqual({error, timeout}, ?M:async(SixSec)),
    
    ok.
