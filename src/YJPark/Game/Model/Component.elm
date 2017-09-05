module YJPark.Game.Model.Component exposing (..)

import YJPark.Util exposing (..)
import YJPark.Data exposing (..)

import Game.TwoD.Render exposing (Renderable)


type Type e msg = Component
    { data : Data
    , update : Maybe (Type e msg -> e -> (e, Cmd msg))
    , render : Maybe (Type e msg -> e -> Renderable)
    }
