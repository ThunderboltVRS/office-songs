module Types exposing (Flags, ModalState(..), Model, Msg(..), PersonStats, SongRequest, TabType(..))

import Dict exposing (Dict)


type Msg
    = SearchSongs String
    | SelectRequester String
    | TabSelected TabType
    | ShowMoreStats String
    | CloseModalStats


type TabType
    = RequestsTab
    | StatsTab


type alias SongRequest =
    { requesterName : String
    , artistName : String
    , songName : String
    }


type ModalState
    = NotShown
    | Shown String


type alias PersonStats =
    { person : String
    , numberPerPerson : Int
    , percentage : Float
    , artistsSongCount : List ( String, Int )
    }


type alias Model =
    { searchString : String
    , selectedRequester : String
    , allRequests : List SongRequest
    , searchedRequests : List SongRequest
    , people : List String
    , showPercentages : Bool
    , selectedTab : TabType
    , personStats : List PersonStats
    , modalState : ModalState
    }


type alias Flags =
    { randomSeed : Float
    , requests : List SongRequest
    , showPercentages : Bool
    }
