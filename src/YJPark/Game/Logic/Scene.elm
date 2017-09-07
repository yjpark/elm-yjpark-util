module YJPark.Game.Logic.Scene exposing (..)
import YJPark.Game.Logic.Entity as EntityLogic
import YJPark.Game.Logic.Camera as CameraLogic

import YJPark.Game.Model.Game as Game exposing (Type(..), Game, Scene, Entity, Component, SceneTicker, EntityTicker, Registry)
import YJPark.Game.Model.Scene as Scene exposing (Type(..))

import YJPark.Game.Meta.Scene as SceneMeta

import YJPark.Util exposing (..)

import Game.TwoD.Camera as Camera exposing (Camera)
import Game.Resources as Resources
import Game.TwoD.Render exposing (Renderable)

import Keyboard.Extra


tick : SceneTicker msg
tick game (Scene scene) =
    let
        fold = (\ticker (current_scene, current_cmds) ->
            let
                (next_scene, cmd) = ticker game current_scene
                next_cmds = if cmd == Cmd.none
                    then
                        current_cmds
                    else
                        cmd :: current_cmds
            in
                (next_scene, next_cmds)
        )
        (Scene result, cmds) = scene.tickers
            |> List.foldr fold (Scene scene, [])
        (root, root_cmd) = EntityLogic.tick game (Scene result) [] result.root
    in
        (Scene {result | root = root}) ! (cmds ++ [root_cmd])


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
        root = EntityLogic.load registry meta.root
    in
        Scene.init camera
            |> Scene.setRoot root
