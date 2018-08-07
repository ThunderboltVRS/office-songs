module Page.Requests exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Material.Options as Options exposing (Style, css)
import Material.Table as Table
import Material.Textfield
import Material.Typography as Typo
import Types exposing (..)


view : Model -> Html Msg
view model =
    div
        []
        [ display model
        ]


display : Model -> Html Msg
display model =
    div
        [ Html.Attributes.class "requests-grid-container" ]
        [ div [ Html.Attributes.class "grid-item search-songs-item" ] [ searchSongsBox model ]
        , div [ Html.Attributes.class "grid-item search-requesters-item" ] [ searchRequestersBox model ]
        , div [ Html.Attributes.class "grid-item table-item" ] [ mainTable model ]
        ]


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
                [ Table.th [ Options.css "width" "33%"] [ Html.text "Song" ]
                , Table.th [Options.css "width" "33%"] [ Html.text "Artist" ]
                , Table.th [Options.css "width" "33%"] [ Html.text "Requester" ]
                ]
            ]
        , Table.tbody []
            (model.searchedRequests
                |> List.map
                    (\request ->
                        Table.tr []
                            [ Table.td [] [ Html.text request.songName ]
                            , Table.td [] [ Html.text request.artistName ]
                            , Table.td [] [ Html.text request.requesterName ]
                            ]
                    )
            )
        ]
