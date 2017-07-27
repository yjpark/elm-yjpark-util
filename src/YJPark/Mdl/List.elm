module YJPark.Mdl.List exposing (..)
import YJPark.Mdl.Types exposing (..)

import Html exposing (..)
import Html.Events

import Material
import Material.List as Lists
import Material.Options as Options exposing (when, css)
import Material.Table as Table


renderList : Renderer obj msg -> Events obj msg -> Type msg -> List obj -> Html msg
renderList renderer events mdl objects =
    let
        items = objects
            |> List.map (renderListItem renderer events mdl)
    in
        Lists.ul
            [] items


renderListItem : Renderer obj msg -> Renderer obj msg
renderListItem renderer events mdl obj =
    let
        attribs = case events.onClick of
            Nothing ->
                []
            Just wrapper ->
                [ Options.attribute <| Html.Events.onClick (wrapper obj) ]
    in
        Lists.li []
            [ Lists.content
                attribs
                [ renderer events mdl obj ]
            ]


