module YJPark.Game.Logic.Physics exposing (..)
import YJPark.Game.Logic.Entity as EntityLogic
import YJPark.Game.Logic.Camera as CameraLogic

import YJPark.Game.Model.Game as Game exposing (Type(..), Game, Scene, Entity, Component, SceneTicker, EntityTicker, Registry)
import YJPark.Game.Model.Scene as Scene exposing (Type(..))
import YJPark.Game.Model.Physics as Physics

import YJPark.Game.Meta.Physics as PhysicsMeta

import YJPark.Util exposing (..)

import Game.TwoD.Camera as Camera exposing (Camera)
import Game.Resources as Resources
import Game.TwoD.Render exposing (Renderable)

import Keyboard.Extra


tick : SceneTicker msg
tick game (Scene scene) =
    case scene.physics of
        Nothing ->
            (Scene scene, [])
        Just physics ->
            let
                result = physics
            in
                (Scene {scene | physics = Just result}, [])


load : PhysicsMeta.Type -> Physics.Type
load meta =
    Physics.init meta.debug meta.gravity
