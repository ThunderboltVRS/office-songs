module Main exposing (main)

import States exposing (..)
import Types exposing (..)
import Update exposing (update)
import Browser exposing (..)
import View exposing (view)


main =
    Browser.element
        { init = initialModelWithFlags
        , subscriptions = subscriptions
        , update = update
        , view = View.view
        }