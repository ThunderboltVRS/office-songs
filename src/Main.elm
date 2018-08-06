module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (href, class, style, id, height, width)
import Html.Lazy
import Platform.Cmd exposing (..)
import Array exposing (Array)
import Dict exposing (Dict)
import String
import Navigation
import RouteUrl as Routing
import Material
import Material.Color as Color
import Material.Layout as Layout
import Material.Options as Options exposing (styled, css)
import Material.Typography as Typography
import Page.Requests
import Page.Stats
import Types exposing (..)
import States exposing (..)
import Update exposing (update)


-- APP


main : Routing.RouteUrlProgram Flags Model Msg
main =
    Routing.programWithFlags
        { delta2url = delta2url
        , location2messages = location2messages
        , init = initialModelWithFlags
        , view = view
        , subscriptions = subscriptions
        , update = update
        }


-- VIEW


view : Model -> Html Msg
view =
    Html.Lazy.lazy view_


view_ : Model -> Html Msg
view_ model =
    let
        top =
            (Array.get model.selectedTab tabViews |> Maybe.withDefault e404) model
    in
        Layout.render Mdl
            model.mdl
            [ Layout.selectedTab model.selectedTab
            , Layout.onSelectTab SelectTab
            , Layout.fixedHeader
            , Layout.seamed
            , Layout.fixedTabs
            ]
            { header = newHeader model
            , drawer = drawer model
            , tabs =
                ( tabTitles
                , [ 
                    --Color.background (Color.color model.primaryColor model.primaryShade) 
                    ] 
                )
            , main = [ stylesheet, top ]
            }


tabs : List ( String, String, Model -> Html Msg )
tabs =
    [ ( "Requests", "requests", \m -> Page.Requests.view m )
    , ( "Stats", "stats", \m -> Page.Stats.view m )
    ]


tabTitles : List (Html a)
tabTitles =
    List.map (\( x, _, _ ) -> text x) tabs


tabViews : Array (Model -> Html Msg)
tabViews =
    List.map (\( _, _, v ) -> v) tabs |> Array.fromList


tabUrls : Array String
tabUrls =
    List.map (\( _, x, _ ) -> x) tabs |> Array.fromList


urlTabs : Dict String Int
urlTabs =
    List.indexedMap (\idx ( _, x, _ ) -> ( x, idx )) tabs |> Dict.fromList


e404 : Model -> Html Msg
e404 _ =
    div
        []
        [ Options.styled Html.h1
            [ Options.cs "mdl-typography--display-4"
            , Typography.center
            ]
            [ text "404 - Page not found" ]
        ]


drawer : Model -> List (Html Msg)
drawer model =
    [ Layout.title [] [ text "Menu" ]
    , Layout.navigation
        []
        [ Layout.link
            [ Layout.href "#requests"
            , Options.onClick (Layout.toggleDrawer Mdl)
            ]
            [ text "Requests" ]
        , Layout.link
            [ Layout.href "#stats"
            , Options.onClick (Layout.toggleDrawer Mdl)
            ]
            [ text "Stats" ]
        ]
    ]


newHeader : Model -> List (Html Msg)
newHeader model =
    [ Layout.row
        [ css "height" "50px"
        , css "transition" "height 333ms ease-in-out 0s"
        ]
        [ Layout.title [] [ text "Office Songs" ]
        , Layout.spacer
        , Layout.navigation []
            [ 
                -- Layout.link
                -- [ Options.onClick ToggleHeader]
                -- [ Icon.i "photo" ]
            ]
        ]
    ]



-- ROUTING


urlOf : Model -> String
urlOf model =
    "#" ++ (Array.get model.selectedTab tabUrls |> Maybe.withDefault "")


delta2url : Model -> Model -> Maybe Routing.UrlChange
delta2url model1 model2 =
    if model1.selectedTab /= model2.selectedTab then
        { entry = Routing.NewEntry
        , url = urlOf model2
        }
            |> Just
    else
        Nothing


location2messages : Navigation.Location -> List Msg
location2messages location =
    [ case String.dropLeft 1 location.hash of
        "" ->
            SelectTab 0

        x ->
            Dict.get x urlTabs
                |> Maybe.withDefault -1
                |> SelectTab
    ]



-- CSS


stylesheet : Html a
stylesheet =
    Options.stylesheet ""
-- """
--   /* The following line is better done in html. We keep it here for
--      compatibility with elm-reactor.
--    */
--   @import url("assets/highlight/github-gist.css");

--   blockquote:before { content: none; }
--   blockquote:after { content: none; }
--   blockquote {
--     border-left-style: solid;
--     border-width: 1px;
--     padding-left: 1.3ex;
--     border-color: rgb(255,82,82);
--       /* Really need a way to specify "secondary color" in
--          inline css.
--        */
--     font-style: normal;
--   }

--   pre {
--     display: inline-block;
--     -- box-sizing: border-box;
--     min-width: 100%;
--     padding-top: .5rem;
--     padding-bottom: 1rem;
--     padding-left:1rem;
--     margin: 0;
--   }
--   code {
--     font-family: 'Roboto Mono';
--   }
--   .mdl-layout__content{
--       background-color: lightpink;
--   }
--   .mdl-grid.center-items {
--     justify-content: center;
--   }
--   .mdl-grid {
--       justify-content: center;
--   }
--   .mdl-layout__header--transparent .mdl-layout__drawer-button {
--     /* This background is dark, so we set text to white. Use 87% black instead if
--        your background is light. */
--     color: white;
--   }
-- """
