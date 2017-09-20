module YJPark.Mdl.Card exposing (..)
import YJPark.Mdl.Action as Action
import YJPark.Mdl.Types exposing (..)
import YJPark.Mdl.Events as MdlEvents
import YJPark.Events as Events

import Html exposing (..)
import Html.Events

import Material
import Material.Card as Card
import Material.Color as Color exposing (Color)
import Material.Icon as Icon
import Material.Button as Button
import Material.List as Lists
import Material.Options as Options exposing (when, css)


-- color, title (color, head, subhead), action, options
type alias Meta msg = (Color, Maybe(Color, String, String), Maybe (Action.Meta msg), List (Options.Style msg))


renderCard : List (Card.Block msg) -> Meta msg -> Int -> Renderer (WithIndex obj) msg
renderCard content (color, title, action, options) index events mdl obj =
    let
        titleSection = case title of
            Nothing ->
                []
            Just (color, head, subhead) ->
                [ Card.title []
                    ([Card.head [ Color.text color ] [ text head ]
                    ] ++ case (subhead == "") of
                        True ->
                            []
                        False ->
                            [ Card.subhead [ Color.text color ] [ text subhead ]])
                ]
        actionSection = case action of
            Nothing ->
                []
            Just action ->
                [ Card.menu []
                    [ Action.renderAction action [index] events mdl obj ]
                ]
    in
        Card.view
            (Color.background color :: options)
            (titleSection ++ actionSection ++ content)
