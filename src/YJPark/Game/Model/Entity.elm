module YJPark.Game.Model.Entity exposing (..)
import YJPark.Game.Model.Component as Component
import YJPark.Game.Model.Transform as Transform

import YJPark.Util exposing (..)


type alias Component g s msg = Component.Type g s (Type g s msg) msg


type Type g s msg = Entity
    { parent : Maybe (Type g s msg)
    , key : String
    , transform : Transform.Type
    , children : List (Type g s msg)
    , components : List (Component g s msg)
    , tickers : List (g -> s -> Type g s msg -> (Type g s msg, Cmd msg))
    }


type alias EntityTicker g s msg = g -> s -> Type g s msg -> (Type g s msg, Cmd msg)


init : Maybe (Type g s msg) -> String -> Type g s msg
init parent key = Entity
    { parent = parent
    , key = key
    , transform = Transform.null
    , children = []
    , components = []
    , tickers = []
    }


addTicker : EntityTicker g s msg -> Type g s msg -> Type g s msg
addTicker ticker (Entity entity) = Entity
    { entity
    | tickers = entity.tickers ++ [ticker]
    }


getChild : String -> Type g s msg -> Maybe (Type g s msg)
getChild key (Entity entity) =
    entity.children
        |> List.filter (\(Entity e) -> e.key == key)
        |> List.head


addChild : Type g s msg -> Type g s msg -> Type g s msg
addChild (Entity child) (Entity entity) =
    case getChild child.key (Entity entity) of
        Nothing -> Entity
            { entity
            | children = entity.children ++ [(Entity child)]
            }
        Just exist_child ->
            let _ = error4 "Entity.addChild Failed, Already Exist:" exist_child "->" child in
            Entity entity


addComponent : (Component.Type g s (Type g s msg) msg) -> Type g s msg -> Type g s msg
addComponent component (Entity entity) = Entity
    { entity
    | components = entity.components ++ [component]
    }


