module Main exposing (..)

import Html
import View exposing (..)
import States exposing (..)
import Update exposing (..)
import Types exposing (..)

main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = initialModelWithFlags
        , subscriptions = subscriptions
        , update = update
        , view = View.view
        }