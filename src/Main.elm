module Main exposing (main)

import Array exposing (Array)
import Dict exposing (Dict)
import Html exposing (..)
import States exposing (..)
import String
import Types exposing (..)
import Update exposing (update)
import Browser exposing (..)
import View exposing (view)


-- APP



main =
    Browser.element
        { init = initialModelWithFlags
        , subscriptions = subscriptions
        , update = update
        , view = View.view
        }