module Main exposing (..)

import Html
import States exposing (..)
import Types exposing (..)
import Update exposing (..)
import View exposing (..)


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = initialModelWithFlags
        , subscriptions = subscriptions
        , update = update
        , view = View.view
        }
