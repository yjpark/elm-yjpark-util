module YJPark.Game.Model.Entity exposing (..)
import YJPark.Game.Model.Component as Component
import YJPark.Game.Model.Transform as Transform

import YJPark.Util exposing (..)

import Game.TwoD.Render exposing (Renderable)


type Type s msg = Entity
    { parent : Maybe (Type s msg)
    , transform : Transform.Type
    , children : List (Type s msg)
    , components : List (Component.Type (Type s msg) msg)
    , update : Type s msg -> s -> (s, Cmd msg)
    , render : Maybe (Type s msg -> s -> Renderable)
    }


new : Maybe (Type s msg) -> Type s msg
new parent = Entity
    { parent = parent
    , transform = Transform.null
    , children = []
    , components = []
    , update = (\(Entity e) scene -> (scene, Cmd.none))
    , render = Nothing
    }
