module YJPark.Game.Model.ImageActor exposing (..)
import YJPark.Game.Model.BaseActor as BaseActor

import YJPark.Util exposing (..)
import YJPark.Json exposing (..)

import WebGL.Texture as Texture exposing (Texture)


type alias Type =
    { pos : Float2
    , size : Float2
    , angle : Float
    , texture : Maybe Texture
    }


null : Type
null =
    { pos = (0, 0, 0)
    , size = (0, 0)
    , angle = 0
    , texture = Nothing
    }
