module YJPark.Game.Model.Component exposing (..)

import YJPark.Util exposing (..)
import YJPark.Data exposing (..)

import Game.TwoD.Render exposing (Renderable)


type Type g s e msg = Component
    { data : Data
    , ticker : Maybe (Ticker g s e msg)
    , renderer : Maybe (Renderer g s e msg)
    }


type alias Ticker g s e msg = (g -> s -> e -> Type g s e msg -> (Type g s e msg, Cmd msg))
type alias Renderer g s e msg = (g -> s -> e -> Type g s e msg -> Renderable)


init : Data -> Type g s e msg
init data = Component
    { data = data
    , ticker = Nothing
    , renderer = Nothing
    }


setTicker : Ticker g s e msg -> Type g s e msg -> Type g s e msg
setTicker ticker (Component component) = Component
    { component
    | ticker = Just ticker
    }


setRenderer : Renderer g s e msg -> Type g s e msg -> Type g s e msg
setRenderer renderer (Component component) = Component
    { component
    | renderer = Just renderer
    }



