module YJPark.Game.Logic.Entity exposing (..)
import YJPark.Game.Logic.Component as ComponentLogic

import YJPark.Game.Model.Game as Game exposing (Type(..), Game, Scene, Entity, Component, SceneTicker, EntityTicker, Registry)
import YJPark.Game.Model.Scene as Scene exposing (Type(..))
import YJPark.Game.Model.Entity as Entity exposing (Type(..))
import YJPark.Game.Model.Component as Component exposing (Type(..))
import YJPark.Game.Model.Registry as Registry

import YJPark.Game.Meta.Entity as EntityMeta exposing (Type(..))

import YJPark.Util exposing (..)
import YJPark.Data as Data exposing (Data)

import Game.TwoD.Camera as Camera exposing (Camera)
import Game.TwoD.Render exposing (Renderable)

import Keyboard.Extra

tick : EntityTicker msg
tick game scene ancestors (Entity entity) =
    let
        fold = (\ticker (current_entity, current_cmds) ->
            let
                (next_entity, cmd) = ticker game scene ancestors current_entity
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
        (components, components_cmds) = tickComponents game scene ancestors (Entity result)
        result_with_components = {result | components = components}
        (children, children_cmds) = tickChildren game scene ancestors (Entity result_with_components)
        result_with_children = {result_with_components | children = children}
    in
        (Entity result_with_children) ! (cmds ++ components_cmds ++ children_cmds)


tickComponents : Game msg -> Scene msg -> List (Entity msg) -> Entity msg -> (List (Component msg), List (Cmd msg))
tickComponents game scene ancestors (Entity entity) =
    entity.components
        |> List.map (ComponentLogic.tick game scene ancestors (Entity entity))
        |> List.unzip


tickChildren : Game msg -> Scene msg -> List (Entity msg) -> Entity msg -> (List (Entity msg), List (Cmd msg))
tickChildren game scene ancestors (Entity entity) =
    let
        children_ancestors = (Entity entity) :: ancestors
    in
        entity.children
            |> List.map (\child -> tick game scene children_ancestors child)
            |> List.unzip


render : Game msg -> Scene msg -> List (Entity msg) -> Entity msg -> List Renderable
render game scene ancestors entity =
    [ renderComponents game scene ancestors entity
    , renderChildren game scene ancestors entity
    ]
        |> List.concat


renderComponents : Game msg -> Scene msg -> List (Entity msg) -> Entity msg -> List Renderable
renderComponents game scene ancestors (Entity entity) =
    entity.components
        |> List.map (ComponentLogic.render game scene ancestors (Entity entity))
        |> List.concat


renderChildren : Game msg -> Scene msg -> List (Entity msg) -> Entity msg -> List Renderable
renderChildren game scene ancestors (Entity entity) =
    let
        children_ancestors = (Entity entity) :: ancestors
    in
        entity.children
            |> List.map (\child -> render game scene children_ancestors child)
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


load : Registry msg -> EntityMeta.Type -> Entity msg
load registry (EntityMeta meta) =
    let
        entity = Entity.initWithData meta.kind meta.key meta.data
            |> Registry.setupEntity registry
        with_components = meta.components
            |> List.map (ComponentLogic.load registry)
            |> List.foldr ComponentLogic.insert entity
    in
        meta.children
            |> List.map (load registry)
            |> List.foldr Entity.insertChild with_components
            |> Entity.setTransformLocal meta.transform

