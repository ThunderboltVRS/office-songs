module States exposing (initialModelWithFlags, subscriptions)

import Dict exposing (..)
import List.Extra exposing (unique)
import Types exposing (..)


initialModelWithFlags : Flags -> ( Model, Cmd Msg )
initialModelWithFlags flags =
    ( initialModel flags, Cmd.none )


initialModel : Flags -> Model
initialModel flags =
    let
        people =
            flags.requests
                |> List.map .requesterName
                |> unique
    in
    { searchString = ""
    , selectedRequester = "Everyone"
    , allRequests = flags.requests
    , searchedRequests = flags.requests
    , people = people
    , showPercentages = flags.showPercentages
    , selectedTab = RequestsTab
    , personStats = getAllPersonStats people flags.requests
    }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        []


getAllPersonStats : List String -> List SongRequest -> List PersonStats
getAllPersonStats people allRequests =
    List.map (\p -> getStatsForPerson allRequests p) people


getStatsForPerson : List SongRequest -> String -> PersonStats
getStatsForPerson allRequests person =
    let
        numberPerPerson =
            countPerPerson person allRequests
    in
    { person = person
    , numberPerPerson = numberPerPerson
    , percentage = getPercentage numberPerPerson (List.length allRequests)
    , artistsSongCount = groupAndCount (List.map (\r -> r.artistName) (requestsPerPerson person allRequests)) |> sortedList
    }


sortedList : Dict String Int -> List ( String, Int )
sortedList dict =
    dict
        |> Dict.toList
        |> List.sortBy Tuple.second
        |> List.reverse


groupAndCount : List String -> Dict String Int
groupAndCount tags =
    tags
        |> List.foldr
            (\tag carry ->
                Dict.update
                    tag
                    (\existingCount ->
                        case existingCount of
                            Just c ->
                                Just (c + 1)

                            Nothing ->
                                Just 1
                    )
                    carry
            )
            Dict.empty


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
