module View exposing (view)

import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Round
import Types exposing (..)


view : Model -> Html Msg
view model =
    div []
        (List.append (header model) (tabContent model))


header : Model -> List (Html Msg)
header model =
    [ mainTabs model
    , modal model
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



-- REQUESTS


requestTabContent : Model -> List (Html Msg)
requestTabContent model =
    [ div [ class "container is-fluid" ] [ searchAndFilter model ]
    , div [ class "container is-fluid", style "padding-top" "20px" ] [ results model ]
    ]


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



-- STATS


statsTabContent : Model -> List (Html Msg)
statsTabContent model =
    [ div [ class "container is-fluid", style "padding-top" "20px" ]
        [ div [ class "columns is-multiline" ]
            (List.map (\ps -> shortPersonStatsCard ps) model.personStats)
        ]
    ]
    


shortPersonStatsCard : PersonStats -> Html Msg
shortPersonStatsCard personStats =
    div [ class "column is-6" ]
        [ div [ class "card" ]
            [ div [ class "card-content" ]
                [ div [ class "media" ]
                    [ div [ class "media-content" ]
                        [ p [ class "title is-3" ]
                            [ text personStats.person ]
                        ]
                    , div [ class "media-right" ]
                        [ p [ class "subtitle is-4" ]
                            [ text (percentageToString personStats.percentage) ]
                        ]
                    ]
                , div [ class "content" ]
                    [ topArtistsTable (topThreeArtists personStats)
                    ]
                ]
            , footer [ class "card-footer" ]
                [ div [ class "card-footer-item" ]
                    [ a [ class "button is-link is-outlined", onClick (ShowMoreStats personStats.person) ]
                        [ span []
                            [ text "More" ]
                        , span [ class "icon" ]
                            [ i [ class "fas fa-caret-square-down" ]
                                []
                            ]
                        ]
                    ]
                ]
            ]
        ]


findPersonStats : String -> Model -> Maybe PersonStats
findPersonStats person model =
    List.filter (\p -> p.person == person) model.personStats
        |> List.head


fullPersonStatsCard : PersonStats -> Html Msg
fullPersonStatsCard personStats =
    div [ class "card" ]
        [ div [ class "card-content" ]
            [ div [ class "media" ]
                [ div [ class "media-content" ]
                    [ p [ class "title is-3" ]
                        [ text personStats.person ]
                    ]
                , div [ class "media-right" ]
                    [ p [ class "subtitle is-4" ]
                        [ text (percentageToString personStats.percentage) ]
                    ]
                ]
            , div [ class "content" ]
                [ topArtistsTable personStats.artistsSongCount
                ]
            ]
        ]


topArtistsTable : List ( String, Int ) -> Html Msg
topArtistsTable topArtists =
    table [ class "table is-narrow" ]
        [ thead []
            [ tr []
                [ th [] [ text "Artist" ]
                , th [] [ text "Count" ]
                ]
            ]
        , tbody []
            (topArtists
                |> List.map
                    (\t ->
                        tr []
                            [ td [ style "width" "50%" ] [ text (Tuple.first t) ]
                            , td [ style "width" "50%" ] [ text (String.fromInt (Tuple.second t)) ]
                            ]
                    )
            )
        ]


modal : Model -> Html Msg
modal model =
    case model.modalState of
        Shown person ->
            div
                [ onClick CloseModalStats
                , class "modal is-active"
                ]
                [ div [ class "modal-background" ]
                    []
                , div [ class "modal-content" ]
                    [ Maybe.withDefault (div [] [])
                        (findPersonStats person model
                            |> Maybe.map fullPersonStatsCard
                        )
                    ]
                , button [ attribute "aria-label" "close", class "modal-close is-large" ]
                    []
                ]

        NotShown ->
            div [ class "modal" ] []


topThreeArtists : PersonStats -> List ( String, Int )
topThreeArtists stats =
    stats.artistsSongCount
        |> List.take 3


percentageToString : Float -> String
percentageToString percentage =
    Round.round 0 percentage ++ "%"
