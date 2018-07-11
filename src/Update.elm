module Update exposing (..)

import Material
import Regex
import Types exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Types.Mdl msg ->
            Material.update Mdl msg model

        SearchSongs searchText ->
            ( updateSongSearchString model searchText |> filterResultsOnSearch, Cmd.none )

        SearchRequesters searchText ->
            ( updateRequesterSearchString model searchText |> filterResultsOnSearch, Cmd.none )


updateSongSearchString : Model -> String -> Model
updateSongSearchString model searchText =
    { model | searchSongsString = searchText }


updateRequesterSearchString : Model -> String -> Model
updateRequesterSearchString model searchText =
    { model | searchRequestersString = searchText }


filterResultsOnSearch : Model -> Model
filterResultsOnSearch model =
    { model | searchedRequests = List.filter (\i -> matchesSearch i model.searchSongsString model.searchRequestersString) model.allRequests }


matchesSearch : SongRequest -> String -> String -> Bool
matchesSearch songRequest searchSongsText searchRequestersText =
    (match searchSongsText songRequest.artistName || match searchSongsText songRequest.songName)
        && (searchRequestersText == "" || match searchRequestersText songRequest.requesterName)


match : String -> String -> Bool
match conatined inside =
    Regex.contains (Regex.caseInsensitive (Regex.regex conatined)) inside
