module Page.BasePage
    exposing
        ( demo
        , package
        , mds
        , mdl
        , body1
        , body2
        , body1_
        , background
        )

import Html exposing (..)
import Html.Attributes exposing (href, class)
import Markdown
import Material.Grid exposing (..)
import Material.Options as Options exposing (styled, cs, css)
import Material.Color as Color


--import Material.Typography as Typography
-- REFERENCES


demo : String -> ( String, String )
demo url =
    ( "Demo source", url )


package : String -> ( String, String )
package url =
    ( "Package documentation", url )


mds : String -> ( String, String )
mds url =
    ( "Material Design Specification", url )


mdl : String -> ( String, String )
mdl url =
    ( "Material Design Lite documentation", url )


references : List ( String, String ) -> List (Html a)
references links =
    [ header "References"
    , ul
        [ Html.Attributes.style
            [ ( "padding-left", "0" )
            ]
        ]
        (links
            |> List.map
                (\( str, url ) ->
                    li
                        [ Html.Attributes.style
                            [ ( "list-style-type", "none" )
                            ]
                        ]
                        [ a [ href url ] [ text str ] ]
                )
        )
    ]



-- TITLES


title : String -> Html a
title t =
    Options.styled Html.h1
        [ Color.text Color.primary ]
        [ text t ]


header : String -> Html a
header str =
    text str


boxed : List (Options.Property a b)
boxed =
    [ css "margin" "auto"
    , css "padding-left" "8%"
    , css "padding-right" "8%"
    ]


background : Color.Color
background =
    Color.color Color.Yellow Color.S50


body1 : String -> String -> Html a -> List ( String, String ) -> List (Html a) -> Html a
body1 t srcUrl contents links demo =
    Options.div
        boxed
        [ title t
        , grid [ noSpacing ]
            [ cell [ size All 6, size Phone 4 ] [ contents ]
            , cell
                [ size All 5
                , offset Desktop 1
                , size Phone 4
                , align Top
                , css "position" "relative"
                ]
                (references <| ( "Demo source", srcUrl ) :: links)
            ]
        , Options.div
            [ css "margin-bottom" "48px"
            ]
            demo
        ]


body1_ : String -> String -> Html a -> List ( String, String ) -> List (Html a) -> List (Html a) -> Html a
body1_ t srcUrl contents links demo1 demo2 =
    Options.div
        []
        [ Options.div
            boxed
            [ title t
            , grid [ noSpacing ]
                [ cell [ size All 6, size Phone 4 ] [ contents ]
                , cell
                    [ size All 5
                    , offset Desktop 1
                    , size Phone 4
                    , align Top
                    , css "position" "relative"
                    ]
                    (references <| ( "Demo source", srcUrl ) :: links)
                ]
            , Options.div
                [ css "margin-bottom" "48px"
                ]
                demo1
            ]
        , Options.div
            boxed
            []
        , Options.div
            [ Color.background <| background
            , css "position" "relative"
            , css "margin" "auto"
            , css "padding-top" "2rem"
            , css "padding-bottom" "5rem"
            , css "padding-left" "8%"
            , css "padding-right" "8%"
            ]
            demo2
        ]


body2 : String -> String -> Html a -> List ( String, String ) -> List (Html a) -> Html a
body2 =
    body1


body3 : String -> String -> Html a -> List ( String, String ) -> List (Html a) -> Html a
body3 t srcUrl contents links demo =
    div
        []
        [ title t
        , grid [ noSpacing ]
            [ cell
                [ size All 4, size Desktop 5, size Tablet 8 ]
                [ contents
                , div
                    []
                    (references <| ( "Demo source", srcUrl ) :: links)
                ]
            , cell
                [ size Phone 4, size Desktop 5, offset Desktop 1, size Tablet 8 ]
                demo
            ]
        ]
