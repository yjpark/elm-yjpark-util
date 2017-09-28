module YJPark.Game.Component.Rigidbody exposing (..)
import YJPark.Game.Consts as Consts
import YJPark.Game.Types as Types exposing (Msg(..))
import YJPark.Game.Model.Game as Game exposing (Type(..), Game, Scene, Entity, Component, SceneTicker, EntityTicker, Registry)
import YJPark.Game.Model.Scene as Scene exposing (Type(..))
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
import BoxesAndBubbles.Bodies as Bodies exposing (Shape(..))
import BoxesAndBubbles.Math2D exposing (Vec2)

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


dataCommon : (Bool, Float, Float) -> String -> Data
dataCommon (is_kinematic, density, bounciness) shape =
    Data.empty
        |> Data.insertBool key_is_kinematic is_kinematic
        |> Data.insertFloat key_density density
        |> Data.insertFloat key_bounciness bounciness
        |> Data.insertString key_shape shape


dataBox : (Bool, Float, Float) -> (Float, Float) -> Data
dataBox common (width, height) =
    dataCommon common shape_box
        |> Data.insertFloat key_width width
        |> Data.insertFloat key_density height


metaBox : (Bool, Float, Float) -> (Float, Float) -> ComponentMeta.Type
metaBox common box =
    { kind = kind
    , data = dataBox common box
    }


dataBubble : (Bool, Float, Float) -> Float -> Data
dataBubble common radius =
    dataCommon common shape_bubble
        |> Data.insertFloat key_radius radius


metaBubble : (Bool, Float, Float) -> Float -> ComponentMeta.Type
metaBubble common circle =
    { kind = kind
    , data = dataBubble common circle
    }


newCommonBody : Entity.Path -> Entity (Msg ext) -> Component (Msg ext) -> (Float -> Float -> Vec2 -> Vec2 -> Entity.Path -> Physics.Body) -> Physics.Body
newCommonBody path (Entity entity) (Component component) new =
    let
        density = Data.getFloat key_density component.data
        bounciness = Data.getFloat key_bounciness component.data
        (x, y, z) = Transform.getPosition entity.transform
    in
        new density bounciness (x, y) (0, 0) path


newBoxBody : Entity.Path -> Entity (Msg ext) -> Component (Msg ext) -> Physics.Body
newBoxBody path entity (Component component) =
    let
        width = Data.getFloat key_width component.data
        height = Data.getFloat key_height component.data
    in
        BB.box (width, height)
            |> newCommonBody path entity (Component component)


newBubbleBody : Entity.Path -> Entity (Msg ext) -> Component (Msg ext) -> Physics.Body
newBubbleBody path entity (Component component) =
    let
        radius = Data.getFloat key_radius component.data
    in
        BB.bubble radius
            |> newCommonBody path entity (Component component)


newBody : Entity.Path -> Entity (Msg ext) -> Component (Msg ext) -> Maybe Physics.Body
newBody path entity (Component component) =
    case Data.getString key_shape component.data of
        "Box" -> --shape_box
            Just <| newBoxBody path entity (Component component)
        "Bubble" -> --shape_bubble
            Just <| newBubbleBody path entity (Component component)
        _ ->
            Nothing


getBody : Scene (Msg ext) -> List (Entity (Msg ext)) -> Entity (Msg ext) -> Component (Msg ext) -> Maybe Physics.Body
getBody (Scene scene) ancestors entity component =
    let
        path = Entity.calcPath ancestors entity
    in
        scene.physics
            |> Maybe.andThen (Physics.getBody path)


getOrNewBody : Scene (Msg ext) -> List (Entity (Msg ext)) -> Entity (Msg ext) -> Component (Msg ext) -> Maybe Physics.Body
getOrNewBody scene ancestors entity component =
    case getBody scene ancestors entity component of
        Nothing ->
            let
                path = Entity.calcPath ancestors entity
            in
                newBody path entity component
        Just body ->
            Just body


tickBody : Game.ComponentElementTicker (Msg ext) Physics.Body
tickBody game scene ancestors (Entity entity) (Component component) body =
    let
        is_kinematic = Data.getBool key_is_kinematic component.data
        updateTransform = case is_kinematic of
            True ->
                let
                    (x, y, z) = Transform.getPosition entity.transform
                in
                    updateObj (\b -> {b | pos = (x, y)})
            False ->
                identity
    in
        (body, [])
            |> updateTransform


tick : Game.ComponentTicker (Msg ext)
tick game scene ancestors entity component =
    let
        path = Entity.calcPath ancestors entity
        body = getOrNewBody scene ancestors entity component
    in case body of
        Nothing ->
            (component, [])
        Just body ->
            let
                (new_body, msgs) = tickBody game scene ancestors entity component body
                updateBody = addMsg <| DoUpdateScene <| Scene.updatePhysics <| Physics.setBody new_body
            in
                (component, msgs)
                    |> updateBody


getShapeParams : Bodies.Shape -> (Float, Float)
getShapeParams shape =
    case shape of
        Box (w, h) ->
            (w, h)
        Bubble r ->
            (r, r)


renderBox : Physics.Body -> Game.ComponentRenderer (Msg ext)
renderBox body game scene ancestors (Entity entity) (Component component) =
    let
        (width, height) = getShapeParams body.shape
    in
        [ Render.shape Render.rectangle
            { color = Color.green
            , position = body.pos
            , size = (width, height)
            }
        ]


renderBubble : Physics.Body -> Game.ComponentRenderer (Msg ext)
renderBubble body game scene ancestors (Entity entity) (Component component) =
    let
        (radius, _) = getShapeParams body.shape
    in
        [ Render.shape Render.circle
            { color = Color.green
            , position = body.pos
            , size = (radius, radius)
            }
        ]


render : Game.ComponentRenderer (Msg ext)
render game scene ancestors entity (Component component) =
    case getOrNewBody scene ancestors entity (Component component) of
        Nothing ->
            []
        Just body ->
            case Data.getString key_shape component.data of
                "Box" -> --shape_box
                    renderBox body game scene ancestors entity (Component component)
                "Bubble" -> --shape_bubble
                    renderBubble body game scene ancestors entity (Component component)
                _ ->
                    []


setup : Game.Component (Msg ext) -> Game.Component (Msg ext)
setup component =
    component
        |> Component.setTicker tick
        |> Component.setRenderer render
