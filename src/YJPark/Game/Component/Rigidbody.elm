module YJPark.Game.Component.Rigidbody exposing (..)
import YJPark.Game.Consts as Consts
import YJPark.Game.Model.Game as Game exposing (Type(..))
import YJPark.Game.Model.Entity as Entity exposing (Type(..))
import YJPark.Game.Model.Component as Component exposing (Type(..))
import YJPark.Game.Model.Transform as Transform
import YJPark.Game.Model.Physics as Physics

import YJPark.Game.Meta.Component as ComponentMeta

import YJPark.Game.Logic.Game as GameLogic
import YJPark.Game.Logic.Scene as SceneLogic
import YJPark.Game.Logic.Entity as EntityLogic

import YJPark.Util exposing (..)
import YJPark.Data as Data exposing (Data)

import BoxesAndBubbles as BB

import Game.TwoD.Render as Render
import WebGL.Texture as Texture exposing (Texture)
import Color


kind = Consts.kind_Rigidbody

-- Common
key_is_kinematic = Consts.key_is_kinematic
key_density = Consts.key_density
key_bounciness = Consts.key_bounciness
key_shape = Consts.key_shape

-- Box
shape_box = Consts.shape_box
key_width = Consts.key_width
key_height = Consts.key_height

-- Bubble
shape_bubble = Consts.shape_bubble
key_radius = Consts.key_radius


dataCommon : (Float, Float, Float) -> Data
dataCommon (is_kinematic, density, bounciness) shape =
    Data.empty
        |> Data.insertString key_is_kinematic is_kinematic
        |> Data.insertFloat key_density density
        |> Data.insertFloat key_bounciness bounciness
        |> Data.insertFloat key_shape shape


dataBox : (Float, Float, Float) -> (Float, Float) -> Data
dataBox common (width, height) =
    dataCommon common shape_box
        |> Data.insertString key_width width
        |> Data.insertFloat key_density height


metaBox : (Float, Float, Float) -> (Float, Float) -> ComponentMeta.Type
metaBox common box =
    { kind = kind
    , data = dataBox common box
    }


dataBubble : (Float, Float, Float) -> Float -> Data
dataBubble common radius =
    dataCommon common shape_bubble
        |> Data.insertString key_radius radius


metaBubble : (Float, Float, Float) -> Float -> ComponentMeta.Type
metaBubble common circle =
    { kind = kind
    , data = dataBubble common circle
    }


newBoxBody : String -> Entity msg -> Component msg -> Physics.Body
newBoxBody path (Entity entity) (Component component) =
    let
        width = Data.getFloat key_width component.data
        height = Data.getFloat key_height component.data
        density = Data.getFloat key_density component.data
        bounciness = Data.getFloat key_bounciness component.data
        position = Transform.getPosition entity.transform
    in
        BB.box (width, height) density bounciness position (0, 0) path


newBody : String -> Entity msg -> Component msg -> Physics.Body
newBody path entity (Component component) =
    case Data.getString key_shape component.data of
        shape_box ->
            newBoxBody path entity (Component component)


getOrAddBody : Scene msg -> List (Entity msg) -> Entity msg -> Component msg -> Physics.Body
getOrAddBody (Scene scene) ancestors (Entity entity) (Component component) =
    let
        path = EntityLogic.calcPath ancestors (Entity entity)
        body = scene.physics
            |> Maybe.map (Physics.getBody path)
            |> Maybe.withDefault (newBody path (Entity entity) (Component component))


tick : Game.ComponentTicker msg
tick game scene ancestors (Entity entity) (Component component) =
    let
        body = getOrAddBody scene ancestors (Entity entity) (Component component)
    in
        (Component component) ! []


renderBox : Game.ComponentRenderer msg
renderBox game scene ancestors (Entity entity) (Component component) =
    let
        body = getOrAddBody scene ancestors (Entity entity) (Component component)
    in
        Render.spriteWithOptions
            { texture = GameLogic.getTexture t game
            , position = Transform.getPosition entity.transform
            , rotation = Transform.getRotation entity.transform
            , size = (w, h)
            , pivot = (px, py)
            , tiling = (1, 1)
            }


render : Game.ComponentRenderer msg
render game scene ancestors entity (Component component) =
    case Data.getString key_shape component.data of
        shape_box ->
            renderBox game scene ancenstors entity (Component component)
        shape_bubble ->
            renderBubble game scene ancenstors entity (Component component)


setup : Game.Component msg -> Game.Component msg
setup component =
    component
        |> Component.setTicker tick
        |> Component.setRenderer render
