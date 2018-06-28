module Update exposing (..)

import Types exposing (..)
import Char
import Material
import Regex


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Types.Mdl msg ->
            Material.update Mdl msg model

        Search searchText ->
            (updateSearchString model searchText |> filterResultsOnSearch, Cmd.none)

updateSearchString : Model -> String -> Model
updateSearchString model searchText =
    {model | searchString = searchText}

filterResultsOnSearch : Model -> Model
filterResultsOnSearch model =
    {model | searchedRequests = List.filter (\i -> matchesSearch i model.searchString) model.allRequests }

matchesSearch : SongRequest -> String -> Bool
matchesSearch songRequest searchText =
    Regex.contains (Regex.caseInsensitive (Regex.regex searchText)) songRequest.artistName
    || Regex.contains (Regex.caseInsensitive (Regex.regex searchText)) songRequest.songName