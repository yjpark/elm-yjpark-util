module YJPark.Game.Logic.Game exposing (..)
import YJPark.Game.Logic.Scene as SceneLogic
import YJPark.Game.Logic.Entity as EntityLogic

import YJPark.Game.Model.Game as Game exposing (Type(..), Game, Scene, Entity, Component, SceneTicker, EntityTicker)
import YJPark.Game.Model.Scene as Scene exposing (Type(..))

import YJPark.Game.Meta.Scene as SceneMeta

import YJPark.Util exposing (..)

import Game.TwoD.Camera as Camera exposing (Camera)
import Game.Resources as Resources
import Game.TwoD.Render exposing (Renderable)

import WebGL.Texture as Texture exposing (Texture)

import Keyboard.Extra


getTexture : String -> Game msg -> Maybe Texture
getTexture texture (Game game) =
    Resources.getTexture (game.base_url ++ texture) game.resources
