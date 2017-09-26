module YJPark.Game.Component.Image exposing (..)
import YJPark.Game.Consts as Consts
import YJPark.Game.Model.Game as Game exposing (Type(..))
import YJPark.Game.Model.Entity as Entity exposing (Type(..))
import YJPark.Game.Model.Component as Component exposing (Type(..))
import YJPark.Game.Model.Transform as Transform

import YJPark.Game.Meta.Component as ComponentMeta

import YJPark.Game.Logic.Game as GameLogic
import YJPark.Game.Logic.Scene as SceneLogic

import YJPark.Util exposing (..)
import YJPark.Data as Data exposing (Data)

import Game.TwoD.Render as Render
import WebGL.Texture as Texture exposing (Texture)
import Color


kind = Consts.kind_Image

key_texture = Consts.key_texture
key_width = Consts.key_width
key_height = Consts.key_height
key_pivot_x = Consts.key_pivot_x
key_pivot_y = Consts.key_pivot_y


data : String -> (Float, Float) -> (Float, Float) -> Data
data t (w, h) (px, py) =
    Data.empty
        |> Data.insertString key_texture t
        |> Data.insertFloat key_width w
        |> Data.insertFloat key_height h
        |> Data.insertFloat key_pivot_x px
        |> Data.insertFloat key_pivot_y py


metaWithPivot : String -> (Float, Float) -> (Float, Float) -> ComponentMeta.Type
metaWithPivot t (w, h) (px, py) =
    { kind = kind
    , data = data t (w, h) (px, py)
    }


meta : String -> (Float, Float) -> ComponentMeta.Type
meta t (w, h) =
    metaWithPivot t (w, h) (0.5, 0.5)


render : Game.ComponentRenderer msg
render game scene ancestors (Entity entity) (Component component) =
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


setup : Game.Component msg -> Game.Component msg
setup component =
    component
        |> Component.setRenderer render


gatherTextures : Game.Scene msg -> List (String, Int)
gatherTextures =
    SceneLogic.traverseComponents (\(Component component) ->
        let
            texture = component.data
                |> Data.getString key_texture
            width = component.data
                |> Data.getFloat key_width
            height = component.data
                |> Data.getFloat key_height
            size = round (width * height)
        in
            case (texture == "") of
                True ->
                    Nothing
                False ->
                    Just (texture, size)
    )
