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


groupWithData : String -> Data -> Transform.Type -> List Component.Type -> List Type -> Type
groupWithData key data transform components children = EntityMeta
    { key = key
    , data = data
    , transform = transform
    , components = components
    , children = children
    }


group : String -> Transform.Type -> List Component.Type -> List Type -> Type
group key transform components children =
    groupWithData key Data.empty transform components children


leafWithData : String -> Data -> Transform.Type -> List Component.Type -> Type
leafWithData key data transform components =
    groupWithData key data transform components []


leaf : String -> Transform.Type -> List Component.Type -> Type
leaf key transform components =
    leafWithData key Data.empty transform components


rootWithData : Data -> Transform.Type -> List Component.Type -> List Type -> Type
rootWithData data transform components children =
    groupWithData "" data transform components children


root : Transform.Type -> List Component.Type -> List Type -> Type
root transform components children =
    rootWithData Data.empty transform components children

