module Types exposing (..)

import Material
import Random exposing (Seed)
import Material.Color as Color


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
