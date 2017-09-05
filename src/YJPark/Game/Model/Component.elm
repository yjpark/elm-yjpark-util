module YJPark.Game.Model.Component exposing (..)

import YJPark.Util exposing (..)
import YJPark.Data exposing (..)

import Game.TwoD.Render exposing (Renderable)


type Type g s e msg = Component
    { data : Data
    , tick : Maybe (g -> s -> e -> Type g s e msg -> (Type g s e msg, Cmd msg))
    , render : Maybe (g -> s -> e -> Type g s e msg -> Renderable)
    }


init : Data -> Type g s e msg
init data = Component
    { data = data
    , tick = Nothing
    , render = Nothing
    }

