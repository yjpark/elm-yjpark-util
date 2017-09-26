module YJPark.Game.Logic.Entity exposing (..)
import YJPark.Game.Consts as Consts exposing (path_separator)
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

import String


reverseMsgs : (a, List b) -> (a, List b)
reverseMsgs (model, msgs) =
    (model, List.reverse msgs)


tick : EntityTicker msg
tick game scene ancestors entity =
    let
        (Entity result, self_msgs) = tickSelf game scene ancestors entity
        (components, components_msgs) = tickComponents game scene ancestors (Entity result)
        result_with_components = {result | components = components}
        (children, children_msgs) = tickChildren game scene ancestors (Entity result_with_components)
        result_with_children = {result_with_components | children = children}
        msgs = [ self_msgs, components_msgs, children_msgs ]
            |> List.map List.concat
            |> List.concat
    in
        (Entity result_with_children, msgs)


tickSelf : Game msg -> Scene msg -> List (Entity msg) -> Entity msg -> (Entity msg, List (List msg))
tickSelf game scene ancestors (Entity entity) =
    let
        fold = (\ticker (current_entity, current_msgs) ->
            let
                (next_entity, msgs) = ticker game scene ancestors current_entity
                next_msgs = msgs :: current_msgs
            in
                (next_entity, next_msgs)
            )
    in
        entity.tickers
            |> List.foldl fold (Entity entity, [])
            |> reverseMsgs


tickComponents : Game msg -> Scene msg -> List (Entity msg) -> Entity msg -> (List (Component msg), List (List msg))
tickComponents game scene ancestors (Entity entity) =
    entity.components
        |> List.map (ComponentLogic.tick game scene ancestors (Entity entity))
        |> List.unzip


tickChildren : Game msg -> Scene msg -> List (Entity msg) -> Entity msg -> (List (Entity msg), List (List msg))
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


updateEntity : Entity.Path -> (Entity msg -> Entity msg) -> Entity msg -> Entity msg
updateEntity path updater =
    case List.head path of
        Nothing ->
            updater
        Just key ->
            case List.tail path of
                Nothing ->
                    Entity.updateChild key updater

                Just left ->
                    Entity.updateChild key (updateEntity left updater)


