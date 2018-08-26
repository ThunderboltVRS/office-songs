module Main exposing (main)

import Browser exposing (..)
import States exposing (..)
import Types exposing (..)
import Update exposing (update)
import View exposing (view)


main =
    Browser.element
        { init = initialModelWithFlags
        , subscriptions = subscriptions
        , update = update
        , view = View.view
        }
