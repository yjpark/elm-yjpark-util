module YJPark.Game.Meta.Entity exposing (..)
import YJPark.Game.Consts exposing (..)
import YJPark.Game.Meta.Transform as Transform
import YJPark.Game.Meta.Component as Component

import YJPark.Data as Data exposing (Data)


type Type = EntityMeta
    { key : String
    , data : Data
    , transform : Transform.Type
    , components : List Component.Type
    , children : List Type
    }
