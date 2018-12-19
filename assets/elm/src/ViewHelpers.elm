module ViewHelpers exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


container : List (Html.Attribute msg) -> List (Html msg) -> Html msg
container attr content =
    node "container" attr content


inputgroup : List (Html.Attribute msg) -> List (Html msg) -> Html msg
inputgroup attr content =
    node "inputgroup" attr content


no_drag : Html.Attribute msg
no_drag =
    draggable "false"


break : Html msg
break =
    br [] []


bold : String -> Html msg
bold txt =
    b [] [ text txt ]


italic : String -> Html msg
italic txt =
    i [] [ text txt ]


logo : String -> Html.Attribute msg
logo style =
    case style of
        "icon" ->
            src "/images/logo.png"

        _ ->
            src "/images/logo.png"
