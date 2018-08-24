module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy
import Types exposing (..)


view : Model -> Html Msg
view =
    Html.Lazy.lazy view_


view_ : Model -> Html Msg
view_ model =
    div []
        (List.append (header model) (tabContent model))


header : Model -> List (Html Msg)
header model =
    [ 
    --     div
    --     [ class "level" ]
    --     [ div[class "level-item"][ text "Song Requests"]
    --      ]
    -- , 
    mainTabs model
    ]


tabContent : Model -> List (Html Msg)
tabContent model =
    case model.selectedTab of
        RequestsTab ->
            requestTabContent model

        StatsTab ->
            statsTabContent model


mainTabs : Model -> Html Msg
mainTabs model =
    div [ class "tabs is-toggle is-fullwidth is-large" ]
        [ ul []
            [ li [ class (tabClass model RequestsTab) ]
                [ a [ onClick (TabSelected RequestsTab) ]
                    [ span [ class "icon" ]
                        [ i [ attribute "aria-hidden" "true", class "fas fa-music" ]
                            []
                        ]
                    , span []
                        [ text "Requests" ]
                    ]
                ]
            , li [ class (tabClass model StatsTab) ]
                [ a [ onClick (TabSelected StatsTab) ]
                    [ span [ class "icon" ]
                        [ i [ attribute "aria-hidden" "true", class "fas fa-chart-bar" ]
                            []
                        ]
                    , span []
                        [ text "Stats" ]
                    ]
                ]
            ]
        ]


tabClass : Model -> TabType -> String
tabClass model tabType =
    if model.selectedTab == tabType then
        "is-active"

    else
        ""


requestTabContent : Model -> List (Html Msg)
requestTabContent model =
    [ div [ class "section" ] [ searchAndFilter model ]
    , results model
    ]


statsTabContent : Model -> List (Html Msg)
statsTabContent model =
    []


results : Model -> Html Msg
results model =
    table [ class "table is-bordered is-striped is-narrow is-hoverable is-fullwidth" ]
        [ thead []
            [ tr []
                [ th [ style "width" "33%" ]
                    [ text "Song" ]
                , th [ style "width" "33%" ]
                    [ text "Artist" ]
                , th [ style "width" "33%" ]
                    [ text "Requester" ]
                ]
            ]
        , tbody []
            (model.searchedRequests
                |> List.map
                    (\request ->
                        tr []
                            [ td [ style "width" "33%" ] [ Html.text request.songName ]
                            , td [ style "width" "33%" ] [ Html.text request.artistName ]
                            , td [ style "width" "33%" ] [ Html.text request.requesterName ]
                            ]
                    )
            )
        ]


searchAndFilter : Model -> Html Msg
searchAndFilter model =
    div [ class "field is-horizontal has-addons" ]
        [ div [ class "control has-icons-left is-expanded" ]
            [ input [ class "input is-medium is-rounded", placeholder "Search", type_ "search", Html.Events.onInput SearchSongs ]
                []
            , span [ class "icon is-medium is-left" ]
                [ i [ class "fas fa-search" ]
                    []
                ]
            ]
        , div [ class "control has-icons-left" ]
            [ span [ class "select is-medium is-rounded" ]
                [ select [ onInput SelectRequester ]
                    (peopleOptions model)
                ]
            , span [ class "icon is-small is-left" ]
                [ i [ class "fas fa-user" ]
                    []
                ]
            ]
        ]


peopleOptions : Model -> List (Html Msg)
peopleOptions model =
    model.people
        |> List.map
            (\p ->
                option [] [ text p ]
            )
        |> List.append
            [ option [ attribute "selected" "" ]
                [ text "Everyone" ]
            ]



-- module Page.Stats exposing (view)
-- import Dict exposing (..)
-- import Html exposing (..)
-- import Html.Attributes exposing (..)
-- import Material.Card as Card
-- import Material.Color as Color
-- import Material.Elevation as Elevation
-- import Material.Layout as Layout
-- import Material.Options as Options exposing (Style, css)
-- import Material.Typography as Typography
-- import Round
-- import Types exposing (..)
-- view : Model -> Html Msg
-- view model =
--     div
--         [ Html.Attributes.class "stats-grid-container" ]
--         (statCards model)
-- statCards : Model -> List (Html Msg)
-- statCards model =
--     List.map (\p -> personCard model p) model.people
-- cell =
--     css "width" "50%"
-- row : ( String, Int ) -> Html Msg
-- row stats =
--     Card.subhead
--         [ css "display" "flex"
--         , css "justify-content" "space-between"
--         , css "align-items" "center"
--         , css "padding" ".3rem 2.5rem"
--         ]
--         [ Options.span [ cell, css "overflow" "hidden" ] [ text (Tuple.first stats) ]
--         , Options.span [ cell, css "text-align" "right" ] [ text (toString (Tuple.second stats)) ]
--         ]
-- list : List ( String, Int ) -> List (Html Msg)
-- list topthree =
--     [ Options.div
--         [ css "display" "flex"
--         , css "flex-direction" "column"
--         , css "padding" "1rem 0"
--         , css "color" "rgba(0, 0, 0, 0.54)"
--         ]
--         (List.map row topthree)
--     ]
-- personCard : Model -> String -> Html Msg
-- personCard model person =
--     let
--         stats =
--             getStatsForPerson model person
--     in
--     div [ Html.Attributes.class "grid-item stats-card-item" ]
--         [ Card.view
--             [ Elevation.e8, css "width" "100%" ]
--             [ Card.title
--                 []
--                 [ Card.head []
--                     [ Options.span
--                         [ Typography.display2
--                         , Color.text Color.primary
--                         ]
--                         [ text person ]
--                     ]
--                 , Card.subhead []
--                     [ Options.span [ css "float" "right", css "opacity" "0.6" ]
--                         [ text (toString stats.numberPerPerson)
--                         ]
--                     ]
--                 ]
--             , Card.actions [ Card.border ]
--                 (list (topThreeArtists stats))
--             , Card.menu []
--                 [ Options.span
--                     [ Typography.display2
--                     , Color.text Color.primary
--                     ]
--                     [ text (percentageToString stats.percentage) ]
--                 ]
--             ]
--         ]
-- getStatsForPerson : Model -> String -> Stats
-- getStatsForPerson model person =
--     let
--         numberPerPerson =
--             countPerPerson person model.allRequests
--     in
--     { person = person
--     , numberPerPerson = numberPerPerson
--     , percentage = getPercentage numberPerPerson (List.length model.allRequests)
--     , artistsSongCount = groupAndCount (List.map (\r -> r.artistName) (requestsPerPerson person model.allRequests))
--     }
-- groupAndCount : List String -> Dict String Int
-- groupAndCount tags =
--     tags
--         |> List.foldr
--             (\tag carry ->
--                 Dict.update
--                     tag
--                     (\existingCount ->
--                         case existingCount of
--                             Just existingCount ->
--                                 Just (existingCount + 1)
--                             Nothing ->
--                                 Just 1
--                     )
--                     carry
--             )
--             Dict.empty
-- percentageToString : Float -> String
-- percentageToString percentage =
--     Round.round 0 percentage ++ "%"
-- getPercentage : Int -> Int -> Float
-- getPercentage number total =
--     case number of
--         0 ->
--             0
--         _ ->
--             clamp 0 100 ((toFloat number / toFloat total) * 100)
-- countPerPerson : String -> List SongRequest -> Int
-- countPerPerson personName songRequests =
--     requestsPerPerson personName songRequests
--         |> List.length
-- requestsPerPerson : String -> List SongRequest -> List SongRequest
-- requestsPerPerson personName allSongRequests =
--     allSongRequests
--         |> List.filter (\r -> r.requesterName == personName)
-- topThreeArtists : Stats -> List ( String, Int )
-- topThreeArtists stats =
--     stats.artistsSongCount
--         |> Dict.toList
--         |> List.sortBy Tuple.second
--         |> List.reverse
--         |> List.take 3
