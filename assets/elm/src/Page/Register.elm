module Page.Register exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Helpers.View exposing (logo, no_drag, bold)


view : List (Html msg)
view =
    [ div [ class "wrapper" ] [ text "Register" ] ]
