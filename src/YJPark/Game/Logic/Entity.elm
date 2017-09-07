module YJPark.Game.Logic.Entity exposing (..)
import YJPark.Game.Model.Game as Game exposing (Type(..), Game, Scene, Entity, Component, SceneTicker, EntityTicker)
import YJPark.Game.Model.Scene as Scene exposing (Type(..))
import YJPark.Game.Model.Entity as Entity exposing (Type(..))
import YJPark.Game.Model.Component as Component exposing (Type(..))

import YJPark.Util exposing (..)

import Game.TwoD.Camera as Camera exposing (Camera)
import Game.TwoD.Render exposing (Renderable)

import Keyboard.Extra

tick : EntityTicker msg
tick game scene (Entity entity) =
    let
        fold = (\ticker (current_entity, current_cmds) ->
            let
                (next_entity, cmd) = ticker game scene current_entity
                next_cmds = if cmd == Cmd.none
                    then
                        current_cmds
                    else
                        cmd :: current_cmds
            in
                (next_entity, next_cmds)
        )
        (Entity result, cmds) = entity.tickers
            |> List.foldr fold (Entity entity, [])
        (components, components_cmds) = tickComponents game scene (Entity result)
        result_with_components = {result | components = components}
        (children, children_cmds) = tickChildren game scene (Entity result_with_components)
        result_with_children = {result_with_components | children = children}
    in
        (Entity result_with_children) ! (cmds ++ components_cmds ++ children_cmds)


tickComponents : Game msg -> Scene msg -> Entity msg -> (List (Component msg), List (Cmd msg))
tickComponents game scene (Entity entity) =
    entity.components
        |> List.map (\(Component component) ->
            case component.ticker of
                Nothing ->
                    (Component component) ! []
                Just ticker ->
                    ticker game scene (Entity entity) (Component component)
            )
        |> List.unzip


tickChildren : Game msg -> Scene msg -> Entity msg -> (List (Entity msg), List (Cmd msg))
tickChildren game scene (Entity entity) =
    entity.children
        |> List.map (\child -> tick game scene child)
        |> List.unzip


render : Game msg -> Scene msg -> Entity msg -> List Renderable
render game scene entity =
    [ renderComponents game scene entity
    , renderChildren game scene entity
    ]
        |> List.concat


renderComponents : Game msg -> Scene msg -> Entity msg -> List Renderable
renderComponents game scene (Entity entity) =
    entity.components
        |> List.map (\(Component component) ->
            case component.renderer of
                Nothing ->
                    []
                Just renderer ->
                    [renderer game scene (Entity entity) (Component component)]
            )
        |> List.concat


renderChildren : Game msg -> Scene msg -> Entity msg -> List Renderable
renderChildren game scene (Entity entity) =
    entity.children
        |> List.map (\child -> render game scene child)
        |> List.concat


traverseEntities : (Entity msg -> Maybe a) -> Entity msg -> List a
traverseEntities handler (Entity entity) =
    (case (handler (Entity entity)) of
        Nothing ->
            []
        Just result ->
            [result])
    ++ (entity.children
        |> List.map (traverseEntities handler)
        |> List.concat)


traverseOwnComponents : (Component msg -> Maybe a) -> Entity msg -> List a
traverseOwnComponents handler (Entity entity) =
    entity.components
        |> List.foldr (\component results ->
            case (handler component) of
                Nothing ->
                    results
                Just result ->
                    result :: results) []


traverseComponents : (Component msg -> Maybe a) -> Entity msg -> List a
traverseComponents handler (Entity entity) =
    (traverseOwnComponents handler (Entity entity))
    ++ (entity.children
        |> List.map (traverseComponents handler)
        |> List.concat)

