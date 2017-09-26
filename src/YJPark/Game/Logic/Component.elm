module YJPark.Game.Logic.Component exposing (..)
import YJPark.Game.Model.Game as Game exposing (Type(..), Game, Scene, Entity, Component, SceneTicker, EntityTicker, Registry)
import YJPark.Game.Model.Scene as Scene exposing (Type(..))
import YJPark.Game.Model.Entity as Entity exposing (Type(..))
import YJPark.Game.Model.Registry as Registry
import YJPark.Game.Model.Component as Component exposing (Type(..))

import YJPark.Game.Meta.Component as ComponentMeta

import YJPark.Util exposing (..)
import YJPark.Data as Data exposing (Data)

import Game.TwoD.Camera as Camera exposing (Camera)
import Game.TwoD.Render exposing (Renderable)

import Keyboard.Extra


tick : Game msg -> Scene msg -> List (Entity msg) -> Entity msg -> Component msg -> (Component msg, List msg)
tick game scene ancestors (Entity entity) (Component component) =
    case component.ticker of
        Nothing ->
            (Component component, [])
        Just ticker ->
            ticker game scene ancestors (Entity entity) (Component component)


render : Game msg -> Scene msg -> List (Entity msg) -> Entity msg -> Component msg -> List Renderable
render game scene ancestors (Entity entity) (Component component) =
    case component.renderer of
        Nothing ->
            []
        Just renderer ->
            [renderer game scene ancestors (Entity entity) (Component component)]


load : Registry msg -> ComponentMeta.Type -> Component msg
load registry meta =
    Component.initWithData meta.kind meta.data
        |> Registry.setupComponent registry


insert : Component msg -> Entity msg -> Entity msg
insert component entity =
    Entity.insertComponent component entity
