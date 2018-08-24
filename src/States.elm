module States exposing (..)

import List.Extra exposing (unique)
import Types exposing (..)


initialModelWithFlags : Flags -> ( Model, Cmd Msg )
initialModelWithFlags flags =
    ( initialModel flags, Cmd.none )


initialModel : Flags -> Model
initialModel flags =
    { searchString = ""
    , selectedRequester = "Everyone"
    , allRequests = flags.requests
    , searchedRequests = flags.requests
    , people =
        flags.requests
            |> List.map .requesterName
            |> unique
    , showPercentages = flags.showPercentages
    , selectedTab = RequestsTab
    }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        []
