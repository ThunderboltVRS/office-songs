module View exposing (..)

import Charty.PieChart as PieChart
import Html exposing (..)
import Html.Attributes exposing (..)
import Material.Color as Color
import Material.Layout as Layout
import Material.Options as Options exposing (Style, css)
import Material.Scheme
import Material.Table as Table
import Material.Textfield
import Material.Typography as Typo
import Round
import Types exposing (..)


view : Model -> Html Msg
view model =
    div
        []
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
            [ div
                [ Html.Attributes.class "grid-container" ]
                [ div [ Html.Attributes.class "grid-item search-songs-item" ] [ searchSongsBox model ]
                , div [ Html.Attributes.class "grid-item search-requesters-item" ] [ searchRequestersBox model ]
                , div [ Html.Attributes.class "grid-item counter-item" ] [ counter model ]
                , div [ Html.Attributes.class "grid-item chart-item" ] [ pieChart model ]
                , div [ Html.Attributes.class "grid-item table-item" ] [ mainTable model ]
                ]
            ]
        }
        |> Material.Scheme.topWithScheme Color.Blue Color.LightBlue


counter : Model -> Html Msg
counter model =
    Options.styled p
        [ Typo.display3 ]
        [ text (List.length model.allRequests |> toString |> (++) "/" |> (++) (toString (List.length model.searchedRequests))) ]


searchSongsBox : Model -> Html Msg
searchSongsBox model =
    Material.Textfield.render Mdl
        [ 0 ]
        model.mdl
        [ Options.onInput SearchSongs
        , Material.Textfield.autofocus
        , Material.Textfield.label "Search by Artist or Song"
        , Material.Textfield.floatingLabel
        , Material.Textfield.text_
        , Material.Textfield.value model.searchSongsString
        ]
        []


searchRequestersBox : Model -> Html Msg
searchRequestersBox model =
    Material.Textfield.render Mdl
        [ 1 ]
        model.mdl
        [ Options.onInput SearchRequesters
        , Material.Textfield.autofocus
        , Material.Textfield.label "Search Requesters"
        , Material.Textfield.floatingLabel
        , Material.Textfield.text_
        , Material.Textfield.value model.searchRequestersString
        ]
        []


mainTable : Model -> Html Msg
mainTable model =
    Table.table [ Options.css "width" "100%" ]
        [ Table.thead []
            [ Table.tr []
                [ Table.th [] [ Html.text "Artist" ]
                , Table.th [] [ Html.text "Song" ]
                , Table.th [] [ Html.text "Requester" ]
                ]
            ]
        , Table.tbody []
            (model.searchedRequests
                |> List.map
                    (\request ->
                        Table.tr []
                            [ Table.td [] [ Html.text request.artistName ]
                            , Table.td [] [ Html.text request.songName ]
                            , Table.td [] [ Html.text request.requesterName ]
                            ]
                    )
            )
        ]


pieChart : Model -> Html Msg
pieChart model =
    let
        defaults =
            PieChart.defaults

        colorAssignment =
            -- Keep color assignment consistent with respect to group names
            List.sortBy (\{ label } -> label) >> defaults.colorAssignment

        chartConfig =
            { defaults | colorAssignment = colorAssignment }
    in
    Html.div
        []
        [ PieChart.view chartConfig (getPieData model)
        ]


getPieData : Model -> PieChart.Dataset
getPieData model =
    List.map (\p -> getPieDataForPerson model p) model.people


getPieDataForPerson : Model -> String -> PieChart.Group
getPieDataForPerson model person =
    let
        numberPerPerson =
            countPerPerson person model.searchedRequests
    in
    { label = getPieLabel model.showPercentages person (List.length model.searchedRequests) numberPerPerson, value = toFloat numberPerPerson }


getPieLabel : Bool -> String -> Int -> Int -> String
getPieLabel showPercentages personName total forPerson =
    if showPercentages then
        personName ++ " " ++ toString forPerson ++ " (" ++ Round.round 2 (getPercentage forPerson total) ++ "%)"
    else
        personName ++ " " ++ toString forPerson


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
