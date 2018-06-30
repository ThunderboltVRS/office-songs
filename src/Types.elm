module Types exposing (..)

import Material


type Msg
    = Mdl (Material.Msg Msg)
    | Search String


type alias SongRequest =
    { requesterName : String
    , artistName : String
    , songName : String
    }


type alias Model =
    { mdl : Material.Model
    , searchString : String
    , allRequests : List SongRequest
    , searchedRequests : List SongRequest
    , people : List String
    , showPercentages : Bool
    }

type alias Flags =
    {
        people : List String
        , requests : List SongRequest
        , showPercentages : Bool
    }