module Types exposing (..)

import Dict exposing (Dict)
import Material
import Material.Color as Color
import Random exposing (Seed)


type Msg
    = Mdl (Material.Msg Msg)
    | SearchSongs String
    | SearchRequesters String
    | SelectTab Int
    | Raise String
    | Lower String


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
    { mdl : Material.Model
    , searchSongsString : String
    , searchRequestersString : String
    , allRequests : List SongRequest
    , searchedRequests : List SongRequest
    , people : List String
    , showPercentages : Bool
    , randomSeed : Random.Seed
    , selectedTab : Int
    , raisedId : String
    , primaryColor : Color.Hue
    , accentColor : Color.Hue
    , primaryShade : Color.Shade
    , accentShade : Color.Shade
    }


type alias Flags =
    { randomSeed : Float
    , requests : List SongRequest
    , showPercentages : Bool
    }
