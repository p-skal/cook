module Api exposing (apiUrl)

import Session.AuthToken exposing (AuthToken(..))
import Session exposing (Session)


apiUrl : String -> String
apiUrl str =
    "http://localhost:4000/api" ++ str
