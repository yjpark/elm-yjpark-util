module YJPark.Game.Logic.Scene exposing (..)
import YJPark.Game.Logic.Entity as EntityLogic
import YJPark.Game.Logic.Camera as CameraLogic
import YJPark.Game.Logic.Physics as PhysicsLogic

import YJPark.Game.Model.Game as Game exposing (Type(..), Game, Scene, Entity, Component, SceneTicker, EntityTicker, Registry)
import YJPark.Game.Model.Scene as Scene exposing (Type(..))
import YJPark.Game.Model.Entity as Entity exposing (Type(..))

import YJPark.Game.Meta.Scene as SceneMeta

import YJPark.Util exposing (..)

import Game.TwoD.Camera as Camera exposing (Camera)
import Game.Resources as Resources
import Game.TwoD.Render exposing (Renderable)

import Keyboard.Extra


tick : SceneTicker msg
tick game scene =
    let
        (Scene result, self_msgs) = tickSelf game scene
        root = result.root
        (new_root, root_msgs) = EntityLogic.tick game (Scene result) [] root
    in
        (Scene {result | root = new_root}, (List.concat self_msgs) ++ root_msgs)


tickSelf : Game msg -> Scene msg -> (Scene msg, List (List msg))
tickSelf game (Scene scene) =
    let
        fold = (\ticker (current_scene, current_msgs) ->
            let
                (next_scene, msgs) = ticker game current_scene
                next_msgs = msgs :: current_msgs
            in
                (next_scene, next_msgs)
            )
    in
        scene.tickers
            |> List.foldl fold (Scene scene, [])
            |> EntityLogic.reverseMsgs


render : Game msg -> Scene msg -> List Renderable
render game (Scene scene) =
    EntityLogic.render game (Scene scene) [] scene.root


traverseEntities : (Entity msg -> Maybe a) -> Scene msg -> List a
traverseEntities handler (Scene scene) =
    EntityLogic.traverseEntities handler scene.root


traverseComponents : (Component msg -> Maybe a) -> Scene msg -> List a
traverseComponents handler (Scene scene) =
    EntityLogic.traverseComponents handler scene.root


load : Registry msg -> SceneMeta.Type -> Scene msg
load registry meta =
    let
        camera = CameraLogic.load meta.camera
        setupPhysics = case meta.physics of
            Nothing ->
                identity
            Just physics_meta ->
                let
                    physics = PhysicsLogic.load physics_meta
                in
                    Scene.setPhysics physics
                    >> Scene.addTicker PhysicsLogic.tick
        root = EntityLogic.load registry meta.root
    in
        Scene.init camera
            |> setupPhysics
            |> Scene.setRoot root


updateEntity : Entity.Path -> (Entity msg -> Entity msg) -> Scene msg -> Scene msg
updateEntity path updater (Scene scene) = Scene
    (case List.head path of
        Nothing ->
            let _ = error3 "SceneLogic.updateEntity Failed: invalid path" path scene in
            scene
        Just key ->
            case key == Entity.getKey scene.root of
                True ->
                    let
                        left = List.drop 1 path
                        root = EntityLogic.updateEntity left updater scene.root
                    in
                        {scene | root = root}
                False ->
                    let _ = error3 "SceneLogic.updateEntity Failed: root key not matched" path scene in
                    scene
    )
