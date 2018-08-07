module Page.Stats exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Material.Card as Card
import Material.Color as Color
import Material.Elevation as Elevation
import Material.Icon as Icon
import Material.Layout as Layout
import Material.Options as Options exposing (Style, css)
import Material.Scheme
import Material.Table as Table
import Material.Textfield
import Material.Typography as Typography
import Round
import Types exposing (..)


view : Model -> Html Msg
view model =
    div
        [ Html.Attributes.class "stats-grid-container" ]
        (statCards model)


statCards : Model -> List (Html Msg)
statCards model =
    List.map (\p -> personCard model p) model.people


sun =
    Color.color Color.Amber Color.S500


rain =
    Color.color Color.LightBlue Color.S500


today =
    [ ( "now", 21, -1, Color.primary, "cloud" )
    , ( "16", 21, -1, Color.primary, "cloud" )
    , ( "17", 20, -1, Color.primary, "cloud" )
    , ( "18", 20, -1, rain, "grain" )
    , ( "19", 19, -1, rain, "grain" )
    , ( "20", 19, -1, Color.primary, "cloud_queue" )
    , ( "21", 28, -1, Color.primary, "cloud_queue" )
    ]


next3 =
    [ ( "thu", 21, 14, sun, "wb_sunny" )
    , ( "fri", 22, 15, rain, "grain" )
    , ( "sat", 20, 13, sun, "wb_sunny" )
    , ( "sun", 21, 13, rain, "grain" )
    , ( "mon", 20, 13, rain, "grain" )
    , ( "tue", 20, 13, sun, "wb_sunny" )
    , ( "wed", 21, 15, sun, "wb_sunny" )
    ]


cell =
    css "width" "64px"


row ( time, high, low, color, icon ) =
    Card.subhead
        [ css "display" "flex"
        , css "justify-content" "space-between"
        , css "align-items" "center"
        , css "padding" ".3rem 2.5rem"
        ]
        [ Options.span [ cell ] [ text time ]
        , Options.span [ cell, css "text-align" "center" ]
            [ Icon.view icon [ Color.text color, Icon.size18 ] ]
        , Options.span [ cell, css "text-align" "right" ]
            [ text <| toString high ++ "° "
            , Options.span
                [ css "color" "rgba(0,0,0,0.37)" ]
                [ text <|
                    if low >= 0 then
                        toString low ++ "°"
                    else
                        ""
                ]
            ]
        ]


list items =
    [ Options.div
        [ css "display" "flex"
        , css "flex-direction" "column"
        , css "padding" "1rem 0"
        , css "color" "rgba(0, 0, 0, 0.54)"
        ]
        (List.map row items)
    ]


personCard model person =
    let
        stats =
            getStatsForPerson model person
    in
    div [ Html.Attributes.class "grid-item stats-card-item" ]
        [ Card.view
            [ Elevation.e8, css "width" "100%" ]
            [ Card.title
                []
                [ Card.head [] [ text person ]

                , Card.subhead [] [ text ((toString stats.numberPerPerson) ++ "/"  ++ (toString (List.length model.allRequests))) ]
                , Options.div
                    [ css "padding" "2rem 2rem 0 2rem" ]
                    [ Options.span
                        [ Typography.display4
                        , Color.text Color.primary
                        ]
                        [ text (percentageToString stats.percentage) ]
                    ]
                ]
            , Card.actions []
                [-- Tabs.render Mdl [5,2] model.mdl
                 -- [ Tabs.ripple
                 -- , Tabs.onSelectTab SetTab
                 -- , Tabs.activeTab model.tab
                 -- ]
                 -- [ Tabs.label [] [ text "Today" ]
                 -- , Tabs.label [] [ text "7-day" ]
                 -- ]
                 -- (list (if model.tab == 0 then today else next3))
                ]
            , Card.menu []
                [ Icon.i "music_note" ]
            ]
        ]


getStatsForPerson : Model -> String -> Stats
getStatsForPerson model person =
    let
        numberPerPerson =
            countPerPerson person model.allRequests
    in
    { person = person
    , numberPerPerson = numberPerPerson
    , percentage = getPercentage numberPerPerson (List.length model.allRequests)
    }


percentageToString : Float -> String
percentageToString percentage =
    (Round.round 2 percentage) ++ "%"


getPercentage : Int -> Int -> Float
getPercentage number total =
    case number of
        0 ->
            0

        _ ->
            clamp 0 100 ((toFloat number / toFloat total) * 100)


countPerPerson : String -> List SongRequest -> Int
countPerPerson personName songRequests =
    songRequests
        |> List.filter (\r -> r.requesterName == personName)
        |> List.length
