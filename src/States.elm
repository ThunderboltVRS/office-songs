module States exposing (..)

import Types exposing (..)
import Material
import List.Extra exposing (uniqueBy)

initialModelWithFlags : Flags -> ( Model, Cmd Msg )
initialModelWithFlags flags =
    ((initialModel flags), Cmd.none)


initialModel : Flags -> Model
initialModel flags =
    { mdl = Material.model
    , searchString = ""
    , allRequests = flags.requests
    , searchedRequests = flags.requests
    , people = flags.requests
        |> List.map .requesterName
        |> uniqueBy toString
    , showPercentages = flags.showPercentages
    }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        []