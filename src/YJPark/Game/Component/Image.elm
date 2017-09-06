module YJPark.Game.Component.Image exposing (..)
import YJPark.Game.Model.Game as Game exposing (Type(..))
import YJPark.Game.Model.Entity as Entity exposing (Type(..))
import YJPark.Game.Model.Component as Component exposing (Type(..))
import YJPark.Game.Model.Transform as Transform

import YJPark.Util exposing (..)
import YJPark.Data exposing (..)

import Game.TwoD.Render as Render
import WebGL.Texture as Texture exposing (Texture)
import Color


key_width = "width"
key_height = "height"
key_pivot_x = "pivot_x"
key_pivot_y = "pivot_y"
key_texture = "texture"


default =
    empty
        |> insertFloat key_width 0
        |> insertFloat key_height 0
        |> insertFloat key_pivot_x 0
        |> insertFloat key_pivot_y 0
        |> insertString key_texture ""


render : Game.ComponentRenderer msg
render game scene (Entity entity) (Component component) =
    let
        w = getFloat key_width component.data
        h = getFloat key_height component.data
        --_ = error6 "Image.render:" game scene entity component component.data
    in
        Render.shapeZ Render.rectangle
            { position = Transform.getPosition entity.transform
            , size = (w, h)
            , color = Color.black
            }


init : Data -> Game.Component msg
init data =
    Component.init data
        |> Component.setRenderer render


initWH : Float -> Float -> Game.Component msg
initWH w h =
    default
        |> insertFloat key_width w
        |> insertFloat key_height h
        |> init
