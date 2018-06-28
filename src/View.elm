module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)
import Material.Color as Color
import Material.Scheme
import Material.Color
import Material.Textfield
import Material.Options exposing (Style, css)
import Material.Layout as Layout
import Material.Table as Table
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Wheel
import Html.Events exposing (on)
import Json.Decode as Json
import Chart as C exposing (..)


view : Model -> Html Msg
view model =
    div
        [ 
        ]
        [ display model
        ]


display : Model -> Html Msg
display model =
    Layout.render Mdl
        model.mdl
        [ Layout.fixedHeader
        ]
        { header = []
        , drawer = []
        , tabs = ( [], [] )
        , main =
            [ additionalCSS
            , div
                [][
                    searchBox model,
                    pieChart model,
                    mainTable model
                ]
            ]
        }
        |> Material.Scheme.topWithScheme Material.Color.Blue Material.Color.LightBlue



searchBox : Model -> Html Msg
searchBox model =
    Material.Textfield.render Mdl [0] model.mdl
        [ Material.Options.onInput Search
        , Material.Textfield.label "Search by Artist or Song"
        , Material.Textfield.floatingLabel ]
        []

mainTable : Model -> Html Msg
mainTable model =
    Table.table []
    [ Table.thead []
    [ Table.tr []
        [ Table.th [] [ Html.text "Requester" ]
        , Table.th [ ] [ Html.text "Artist" ]
        , Table.th [ ] [ Html.text "Song" ]
        ]
    ]
    , Table.tbody []
        (model.searchedRequests |> List.map (\request ->
        Table.tr []
            [ Table.td [] [ Html.text request.requesterName ]
            , Table.td [] [ Html.text request.artistName ]
            , Table.td [] [ Html.text request.songName ]
            ]
        )
        )
    ]

pieChart : Model -> Html Msg
pieChart model =
    C.pie (getPieData model)
    |> C.toHtml

getPieData : Model -> List (Float, String)
getPieData model =
    List.map (\p -> ((getPieCount p model.searchedRequests), p)) model.people

getPieCount : String -> List SongRequest -> Float
getPieCount person songRequests =
    List.filter (\r -> r.requesterName == person) songRequests 
    |> List.length 
    |> toFloat

additionalCSS : Html Msg
additionalCSS =
    Material.Options.stylesheet """
    .mdl-layout__content {
        height: 100% !important;
    }
  """
