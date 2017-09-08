module YJPark.Game.Meta.Entity exposing (..)
import YJPark.Game.Consts exposing (..)
import YJPark.Game.Meta.Transform as Transform
import YJPark.Game.Meta.Component as Component

import YJPark.Data as Data exposing (Data)


type Type = EntityMeta
    { kind : String
    , key : String
    , data : Data
    , transform : Transform.Type
    , components : List Component.Type
    , children : List Type
    }


groupOfKindWithData : String -> String -> Data -> Transform.Type -> List Component.Type -> List Type -> Type
groupOfKindWithData kind key data transform components children = EntityMeta
    { kind = kind
    , key = key
    , data = data
    , transform = transform
    , components = components
    , children = children
    }


groupOfKind : String -> String -> Transform.Type -> List Component.Type -> List Type -> Type
groupOfKind kind key transform components children =
    groupOfKindWithData kind key Data.empty transform components children


group : String -> Transform.Type -> List Component.Type -> List Type -> Type
group key transform components children =
    groupOfKind kind_Entity key transform components children


leafOfKindWithData : String -> String -> Data -> Transform.Type -> List Component.Type -> Type
leafOfKindWithData kind key data transform components =
    groupOfKindWithData kind key data transform components []


leafOfKind : String -> String -> Transform.Type -> List Component.Type -> Type
leafOfKind kind key transform components =
    leafOfKindWithData kind key Data.empty transform components


leaf : String -> Transform.Type -> List Component.Type -> Type
leaf key transform components =
    leafOfKind kind_Entity key transform components


rootOfKindWithData : String -> Data -> Transform.Type -> List Component.Type -> List Type -> Type
rootOfKindWithData kind data transform components children =
    groupOfKindWithData kind kind_Entity data transform components children


rootOfKind : String -> Transform.Type -> List Component.Type -> List Type -> Type
rootOfKind kind transform components children =
    rootOfKindWithData kind Data.empty transform components children


root : Transform.Type -> List Component.Type -> List Type -> Type
root transform components children =
    rootOfKind kind_Entity transform components children

