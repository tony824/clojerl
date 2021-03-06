-module(clojerl_reader_TaggedLiteral_SUITE).

-include("clojerl.hrl").
-include("clj_test_utils.hrl").

-export([ all/0
        , init_per_suite/1
        , end_per_suite/1
        ]).

-export([ equiv/1
        , get/1
        , str/1
        ]).

-spec all() -> [atom()].
all() -> clj_test_utils:all(?MODULE).

-spec init_per_suite(config()) -> config().
init_per_suite(Config) -> clj_test_utils:init_per_suite(Config).

-spec end_per_suite(config()) -> config().
end_per_suite(Config) -> Config.

%%------------------------------------------------------------------------------
%% Test Cases
%%------------------------------------------------------------------------------

-spec equiv(config()) -> result().
equiv(_Config) ->
  ErlSymbol = clj_rt:symbol(<<"erl">>),
  JsSymbol  = clj_rt:symbol(<<"js">>),

  ct:comment("Compare two different tagged literals"),
  TaggedLit1 = 'clojerl.reader.TaggedLiteral':?CONSTRUCTOR(ErlSymbol, []),
  TaggedLit2 = 'clojerl.reader.TaggedLiteral':?CONSTRUCTOR(JsSymbol, []),
  false = clj_rt:equiv(TaggedLit1, TaggedLit2),

  ct:comment("Compare the same tagged literals"),
  true = clj_rt:equiv(TaggedLit1, TaggedLit1),

  ct:comment("Compare a tagged literal with something else"),
  false = clj_rt:equiv(TaggedLit1, []),

  {comments, ""}.

-spec get(config()) -> result().
get(_Config) ->
  ErlSymbol = clj_rt:symbol(<<"erl">>),

  ct:comment("Only :form and :tag keys return something"),
  TaggedLit = 'clojerl.reader.TaggedLiteral':?CONSTRUCTOR(ErlSymbol, [a, b]),
  [a, b]    = clj_rt:get(TaggedLit, form),
  ErlSymbol = clj_rt:get(TaggedLit, tag),
  ?NIL      = clj_rt:get(TaggedLit, bla),
  not_found = clj_rt:get(TaggedLit, bla, not_found),

  {comments, ""}.

-spec str(config()) -> result().
str(_Config) ->
  ErlSymbol = clj_rt:symbol(<<"erl">>),
  List      = clj_rt:list([]),

  ct:comment("Check the str representation of tagged literals"),
  TaggedLit1 = 'clojerl.reader.TaggedLiteral':?CONSTRUCTOR(ErlSymbol, List),
  Regex1 = <<"#erl \\(\\)">>,
  {match, _} = re:run(clj_rt:str(TaggedLit1), Regex1),

  TaggedLit2 = 'clojerl.reader.TaggedLiteral':?CONSTRUCTOR(ErlSymbol, hello),
  Regex2 = <<"#erl :hello">>,
  {match, _} = re:run(clj_rt:str(TaggedLit2), Regex2),

  {comments, ""}.
