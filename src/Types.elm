module Types exposing (Flags, Model, Msg(..), SongRequest, Stats)

import Dict exposing (Dict)

type Msg
    = SearchSongs String
    | SelectRequester String


type alias SongRequest =
    { requesterName : String
    , artistName : String
    , songName : String
    }


type alias Stats =
    { person : String
    , numberPerPerson : Int
    , percentage : Float
    , artistsSongCount : Dict String Int
    }


type alias Model =
    {
    searchSongsString : String
    , selectedRequester : String
    , allRequests : List SongRequest
    , searchedRequests : List SongRequest
    , people : List String
    , showPercentages : Bool
    }


type alias Flags =
    { randomSeed : Float
    , requests : List SongRequest
    , showPercentages : Bool
    }
