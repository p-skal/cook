module Page.Register exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import ViewHelpers exposing (logo, no_drag, bold)


view : Html msg
view =
    div [ class "wrapper" ] [ text "Register" ]
