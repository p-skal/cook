module Helpers.View exposing (bold, break, content, emphasis, inputgroup, italic, link, logo, no_drag, small)

import Html exposing (..)
import Html.Attributes exposing (..)


content : List (Html.Attribute msg) -> List (Html msg) -> Html msg
content attr items =
    node "content" attr items


inputgroup : List (Html.Attribute msg) -> List (Html msg) -> Html msg
inputgroup attr items =
    node "inputgroup" attr items


no_drag : Html.Attribute msg
no_drag =
    draggable "false"


small : String -> Html msg
small txt =
    Html.small [] [ text txt ]


break : Html msg
break =
    br [] []


emphasis : String -> Html msg
emphasis txt =
    em [] [ text txt ]


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


link : String -> Html msg
link path =
    li [] [ a [ href path ] [ text path ] ]
