module States exposing (..)

import List.Extra exposing (uniqueBy)
import Material
import Random exposing (Seed)
import RandomUtil exposing (shuffle)
import Types exposing (..)


initialModelWithFlags : Flags -> ( Model, Cmd Msg )
initialModelWithFlags flags =
    ( initialModel flags, Cmd.none )


initialModel : Flags -> Model
initialModel flags =
    let
        suffleResult =
            shuffleRequests (Random.initialSeed (round flags.randomSeed)) flags.requests
    in
    { mdl = Material.model
    , searchSongsString = ""
    , searchRequestersString = ""
    , allRequests = Tuple.first suffleResult
    , searchedRequests = Tuple.first suffleResult
    , people =
        flags.requests
            |> List.map .requesterName
            |> uniqueBy toString
    , showPercentages = flags.showPercentages
    , randomSeed = Tuple.second suffleResult
    }


shuffleRequests : Random.Seed -> List SongRequest -> ( List SongRequest, Random.Seed )
shuffleRequests seed songs =
    Random.step (shuffle songs) seed


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        []
