module Types exposing (..)

import Material
import Random exposing (Seed)


type Msg
    = Mdl (Material.Msg Msg)
    | SearchSongs String
    | SearchRequesters String


type alias SongRequest =
    { requesterName : String
    , artistName : String
    , songName : String
    }


type alias Model =
    { mdl : Material.Model
    , searchSongsString : String
    , searchRequestersString : String
    , allRequests : List SongRequest
    , searchedRequests : List SongRequest
    , people : List String
    , showPercentages : Bool
    , randomSeed : Random.Seed
    }


type alias Flags =
    { randomSeed : Float
    , requests : List SongRequest
    , showPercentages : Bool
    }
