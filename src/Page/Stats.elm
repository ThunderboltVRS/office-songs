module Page.Stats exposing (view)

import Dict exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Material.Card as Card
import Material.Color as Color
import Material.Elevation as Elevation
import Material.Layout as Layout
import Material.Options as Options exposing (Style, css)
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


cell =
    css "width" "50%"


row : ( String, Int ) -> Html Msg
row stats =
    Card.subhead
        [ css "display" "flex"
        , css "justify-content" "space-between"
        , css "align-items" "center"
        , css "padding" ".3rem 2.5rem"
        ]
        [ Options.span [ cell, css "overflow" "hidden" ] [ text (Tuple.first stats) ]
        , Options.span [ cell, css "text-align" "right" ] [ text (toString (Tuple.second stats)) ]
        ]


list : List ( String, Int ) -> List (Html Msg)
list topthree =
    [ Options.div
        [ css "display" "flex"
        , css "flex-direction" "column"
        , css "padding" "1rem 0"
        , css "color" "rgba(0, 0, 0, 0.54)"
        ]
        (List.map row topthree)
    ]


personCard : Model -> String -> Html Msg
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
                [ Card.head []
                    [ Options.span
                        [ Typography.display2
                        , Color.text Color.primary
                        ]
                        [ text person ]
                    ]
                ]
            , Card.actions []
                (list (topThreeArtists stats))
            , Card.menu []
                [ Options.span
                    [ Typography.display2
                    , Color.text Color.primary
                    ]
                    [ text (percentageToString stats.percentage) ]
                , Layout.spacer
                , Options.span []
                    [ text (toString stats.numberPerPerson ++ "/" ++ toString (List.length model.allRequests))
                    ]
                ]
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
    , artistsSongCount = groupAndCount (List.map (\r -> r.artistName) (requestsPerPerson person model.allRequests))
    }


groupAndCount : List String -> Dict String Int
groupAndCount tags =
    tags
        |> List.foldr
            (\tag carry ->
                Dict.update
                    tag
                    (\existingCount ->
                        case existingCount of
                            Just existingCount ->
                                Just (existingCount + 1)

                            Nothing ->
                                Just 1
                    )
                    carry
            )
            Dict.empty


percentageToString : Float -> String
percentageToString percentage =
    Round.round 0 percentage ++ "%"


getPercentage : Int -> Int -> Float
getPercentage number total =
    case number of
        0 ->
            0

        _ ->
            clamp 0 100 ((toFloat number / toFloat total) * 100)


countPerPerson : String -> List SongRequest -> Int
countPerPerson personName songRequests =
    requestsPerPerson personName songRequests
        |> List.length


requestsPerPerson : String -> List SongRequest -> List SongRequest
requestsPerPerson personName allSongRequests =
    allSongRequests
        |> List.filter (\r -> r.requesterName == personName)


topThreeArtists : Stats -> List ( String, Int )
topThreeArtists stats =
    stats.artistsSongCount
        |> Dict.toList
        |> List.sortBy Tuple.second
        |> List.reverse
        |> List.take 3
