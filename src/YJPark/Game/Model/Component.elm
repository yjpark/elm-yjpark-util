module YJPark.Game.Model.Component exposing (..)

import YJPark.Util exposing (..)
import YJPark.Data as Data exposing (Data, Value)

import Game.TwoD.Render exposing (Renderable)


type Type g s e msg = Component
    { kind : String
    , data : Data
    , ticker : Maybe (Ticker g s e msg)
    , renderer : Maybe (Renderer g s e msg)
    }


type alias Ticker g s e msg = (g -> s -> List e -> e -> Type g s e msg -> (Type g s e msg, List msg))
type alias Renderer g s e msg = (g -> s -> List e -> e -> Type g s e msg -> List Renderable)

type alias ElementTicker g s e msg c = (g -> s -> List e -> e -> Type g s e msg -> c -> (c, List msg))


initWithData : String -> Data -> Type g s e msg
initWithData kind data = Component
    { kind = kind
    , data = data
    , ticker = Nothing
    , renderer = Nothing
    }


init : String -> Type g s e msg
init key =
    initWithData key Data.empty


getData : Type g s e msg -> Data
getData (Component component) =
    component.data


setData : Data -> Type g s e msg -> Type g s e msg
setData data (Component component) = Component
    (Data.setData data component)


updateData : String -> Value -> Type g s e msg -> Type g s e msg
updateData key val (Component component) = Component
    (Data.updateData key val component)


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



