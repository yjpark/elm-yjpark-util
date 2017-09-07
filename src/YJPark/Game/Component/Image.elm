module YJPark.Game.Component.Image exposing (..)
import YJPark.Game.Model.Game as Game exposing (Type(..))
import YJPark.Game.Model.Entity as Entity exposing (Type(..))
import YJPark.Game.Model.Component as Component exposing (Type(..))
import YJPark.Game.Model.Transform as Transform

import YJPark.Game.Logic.Game as GameLogic
import YJPark.Game.Logic.Scene as SceneLogic

import YJPark.Util exposing (..)
import YJPark.Data as Data exposing (Data)

import Game.TwoD.Render as Render
import WebGL.Texture as Texture exposing (Texture)
import Color


kind = "Image"

key_texture = "texture"
key_width = "width"
key_height = "height"
key_pivot_x = "pivot_x"
key_pivot_y = "pivot_y"


default =
    Data.empty
        |> Data.insertString key_texture ""
        |> Data.insertFloat key_width 0
        |> Data.insertFloat key_height 0
        |> Data.insertFloat key_pivot_x 0
        |> Data.insertFloat key_pivot_y 0


render : Game.ComponentRenderer msg
render game scene (Entity entity) (Component component) =
    let
        t = Data.getString key_texture component.data
        w = Data.getFloat key_width component.data
        h = Data.getFloat key_height component.data
        px = Data.getFloat key_pivot_x component.data
        py = Data.getFloat key_pivot_y component.data
        --_ = error6 "Image.render:" game scene entity component component.data
    in
        Render.spriteWithOptions
            { texture = GameLogic.getTexture t game
            , position = Transform.getPosition entity.transform
            , rotation = Transform.getRotation entity.transform
            , size = (w, h)
            , pivot = (px, py)
            , tiling = (1, 1)
            }


initWithData : Data -> Game.Component msg
initWithData data =
    Component.init kind data
        |> Component.setRenderer render


init : String -> Float -> Float -> Float -> Float -> Game.Component msg
init t w h px py=
    default
        |> Data.insertString key_texture t
        |> Data.insertFloat key_width w
        |> Data.insertFloat key_height h
        |> Data.insertFloat key_pivot_x px
        |> Data.insertFloat key_pivot_y py
        |> initWithData


initTWH : String -> Float -> Float -> Game.Component msg
initTWH t w h =
    init t w h 0.5 0.5


gatherTextures : Game.Scene msg -> List String
gatherTextures =
    SceneLogic.traverseComponents (\(Component component) ->
            let
                texture = component.data
                    |> Data.getString key_texture
            in
                case (texture == "") of
                    True ->
                        Nothing
                    False ->
                        Just texture
        )


