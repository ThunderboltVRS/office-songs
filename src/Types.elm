module Types exposing (..)

import Dict exposing (Dict)

type Msg
    = SearchSongs String
    | SelectRequester String
    | TabSelected TabType


type TabType
    = RequestsTab
    | StatsTab


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
    searchString : String
    , selectedRequester : String
    , allRequests : List SongRequest
    , searchedRequests : List SongRequest
    , people : List String
    , showPercentages : Bool
    , selectedTab : TabType
    }


type alias Flags =
    { randomSeed : Float
    , requests : List SongRequest
    , showPercentages : Bool
    }
