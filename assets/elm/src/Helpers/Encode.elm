module Helpers.Encode exposing (..)

import Json.Encode as Encode exposing (Value, encode, int, null, object)


maybe : (a -> Value) -> Maybe a -> Value
maybe encoder =
    Maybe.map encoder >> Maybe.withDefault null
