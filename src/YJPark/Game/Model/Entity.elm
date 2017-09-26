module YJPark.Game.Model.Entity exposing (..)
import YJPark.Game.Model.Component as Component
import YJPark.Game.Model.Transform as Transform

import YJPark.Util exposing (..)
import YJPark.Data as Data exposing (Data, Value)


type alias Component g s msg = Component.Type g s (Type g s msg) msg

type alias Path = List String


type Type g s msg = Entity
    { kind : String
    , key : String
    , data : Data
    , transform : Transform.Type
    , components : List (Component g s msg)
    , children : List (Type g s msg)
    , tickers : List (Ticker g s msg)
    }


type alias Ticker g s msg = g -> s -> List (Type g s msg) -> Type g s msg -> (Type g s msg, List msg)


initWithData : String -> String -> Data -> Type g s msg
initWithData kind key data = Entity
    { kind = kind
    , key = key
    , data = data
    , transform = Transform.null
    , components = []
    , children = []
    , tickers = []
    }


init : String -> String -> Type g s msg
init kind key =
    initWithData kind key Data.empty


getKey : Type g s msg -> String
getKey (Entity entity) =
    entity.key


getData : Type g s msg -> Data
getData (Entity entity) =
    entity.data


setData : Data -> Type g s msg -> Type g s msg
setData data (Entity entity) = Entity
    (Data.setData data entity)


updateData : String -> Value -> Type g s msg -> Type g s msg
updateData key val (Entity entity) = Entity
    (Data.updateData key val entity)


addTicker : Ticker g s msg -> Type g s msg -> Type g s msg
addTicker ticker (Entity entity) = Entity
    { entity
    | tickers = entity.tickers ++ [ticker]
    }


getChildren : Type g s msg -> List (Type g s msg)
getChildren (Entity entity) =
    entity.children


getComponents : Type g s msg -> List (Component g s msg)
getComponents (Entity entity) =
    entity.components


getChild : String -> Type g s msg -> Maybe (Type g s msg)
getChild key (Entity entity) =
    entity.children
        |> List.filter (\(Entity e) -> e.key == key)
        |> List.head


updateChild : String -> (Type g s msg -> Type g s msg) -> Type g s msg -> Type g s msg
updateChild key updater (Entity entity) = Entity
    (case getChild key (Entity entity) of
        Nothing ->
            let _ = error4 "Entity.updateChild Failed: child not found" key updater entity in
            entity
        Just child ->
            let
                new_child = updater child
                update = (\(Entity e) ->
                        case e.key == key of
                            True ->
                                new_child
                            False ->
                                Entity e
                    )
                children = entity.children
                    |> List.map update
            in
                {entity | children = children}
    )


insertOrAddChild : Bool -> Type g s msg -> Type g s msg -> Type g s msg
insertOrAddChild insert (Entity child) (Entity entity) =
    case getChild child.key (Entity entity) of
        Nothing ->
            let
                new_child = (Entity child)
                    |> setTransformParent entity.transform.world
                children = case insert of
                    True ->
                        new_child :: entity.children
                    False ->
                        entity.children ++ [new_child]
            in Entity
                { entity
                | children = children
                }
        Just exist_child ->
            let
                msg = case insert of
                    True ->
                        "insertChild"
                    False ->
                        "addChild"
                _ = error6 "[Entity]" msg "Failed: Already Exist:" exist_child "->" child
            in Entity
                entity


insertChild : Type g s msg -> Type g s msg -> Type g s msg
insertChild =
    insertOrAddChild True


addChild : Type g s msg -> Type g s msg -> Type g s msg
addChild =
    insertOrAddChild False


insertComponent : (Component.Type g s (Type g s msg) msg) -> Type g s msg -> Type g s msg
insertComponent component (Entity entity) = Entity
    { entity
    | components = component :: entity.components
    }


addComponent : (Component.Type g s (Type g s msg) msg) -> Type g s msg -> Type g s msg
addComponent component (Entity entity) = Entity
    { entity
    | components = entity.components ++ [component]
    }


setTransformParent : Transform.Value -> Type g s msg -> Type g s msg
setTransformParent parent (Entity entity) = Entity
    { entity
    | transform = Transform.setParent parent entity.transform
    }


updateChildrenTransform : Type g s msg -> Type g s msg
updateChildrenTransform (Entity entity) =
    let
        children = entity.children
            |> List.map (setTransformParent entity.transform.world)
    in Entity
        { entity
        | children = children
        }


setTransformLocal : Transform.Value -> Type g s msg -> Type g s msg
setTransformLocal local (Entity entity) = Entity
    { entity
    | transform = Transform.setLocal local entity.transform
    }
        |> updateChildrenTransform


setTransformWorld : Transform.Value -> Type g s msg -> Type g s msg
setTransformWorld world (Entity entity) = Entity
    { entity
    | transform = Transform.setWorld world entity.transform
    }
        |> updateChildrenTransform


calcPath : List (Type g s msg) -> Type g s msg -> Path
calcPath ancestors entity =
    (ancestors ++ [ entity ])
        |> List.map (\(Entity e) -> e.key)
