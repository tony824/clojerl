-module('clojerl.ILookup').

-clojure(true).
-protocol(true).

-export([get/2, get/3]).

-type type() ::  any().
-export_type([type/0]).

-callback get(any(), any()) -> any().
-callback get(any(), any(), any()) -> any().

-spec get(any(), any()) -> any().
get(X, Key) ->
  clj_protocol:resolve(?MODULE, get, X, Key).

-spec get(any(), any(), any()) -> any().
get(X, Key, NotFound) ->
  clj_protocol:resolve(?MODULE, get, X, Key, NotFound).
