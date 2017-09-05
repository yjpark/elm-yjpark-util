module YJPark.Game.Logic.Scene exposing (..)
import YJPark.Game.Logic.Entity as EntityLogic

import YJPark.Game.Model.Game as Game exposing (Type(..))
import YJPark.Game.Model.Scene as Scene exposing (Type(..), SceneTicker)

import YJPark.Util exposing (..)

import Game.TwoD.Camera as Camera exposing (Camera)
import Game.Resources as Resources
import Game.TwoD.Render exposing (Renderable)

import Keyboard.Extra


tick : SceneTicker g msg
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
            |> List.foldl fold (Scene scene, [])
        (root, root_cmd) = EntityLogic.tick game (Scene result) result.root
    in
        (Scene {result | root = root}) ! (List.reverse cmds ++ [root_cmd])


render : g -> Scene.Type g msg -> List Renderable
render game (Scene scene) =
    EntityLogic.render game (Scene scene) scene.root
