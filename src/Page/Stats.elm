module Page.Stats exposing (view)


import Charty.PieChart as PieChart
import Html exposing (..)
import Html.Attributes exposing (..)
import Round
import Types exposing (..)


view : Model -> Html Msg
view model =
    -- div
    --             [ Html.Attributes.class "stats-grid-container" ]
    --             [ 
                    div [ Html.Attributes.class "grid-item chart-item" ] [ pieChart model ]
                -- ]
    


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
        PieChart.view chartConfig (getPieData model)



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