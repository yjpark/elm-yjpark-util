module YJPark.Game.Model.Registry exposing (..)
import YJPark.Game.Consts exposing (..)
import YJPark.Game.Model.Scene as Scene exposing (Type(..))
import YJPark.Game.Model.Entity as Entity exposing (Type(..))
import YJPark.Game.Model.Component as Component exposing (Type(..))

import YJPark.Util exposing (..)
import YJPark.Data as Data exposing (Data)

import Dict exposing (Dict)

import Game.TwoD.Camera as Camera exposing (Camera)


type alias Entity g msg = Scene.Entity g msg
type alias Component g msg = Entity.Component g (Scene.Type g msg) msg


type alias EntitySetup g msg = Entity g msg -> Entity g msg
type alias ComponentSetup g msg = Component g msg -> Component g msg


type alias Type g msg =
    { entities : Dict String (EntitySetup g msg)
    , components : Dict String (ComponentSetup g msg)
    }


empty : Type g msg
empty =
    { entities = Dict.empty
    , components = Dict.empty
    }


merge : Type g msg -> Type g msg -> Type g msg
merge extra model =
    let
        with_entities = extra.entities
            |> Dict.foldl registerEntity model
    in
        extra.components
            |> Dict.foldl registerComponent with_entities



registerEntity : String -> (EntitySetup g msg) -> Type g msg -> Type g msg
registerEntity kind setup model =
    case Dict.get kind model.entities of
        Nothing ->
            let
                entities = model.entities
                    |> Dict.insert kind setup
                _ = info3 "[Registry] registerEntity Succeed:" kind setup
            in
                {model | entities = entities}
        Just exist ->
            let _ = error6 "[Registry] registerEntity Failed: Already Exist:" kind ":" exist "->" setup in
            model


setupEntity : Type g msg -> Entity g msg -> Entity g msg
setupEntity model (Entity entity) =
    case entity.kind == kind_Entity of
        True -> Entity
            entity
        False ->
            case Dict.get entity.kind model.entities of
                Nothing ->
                    let _ = error3 "[Registry] setupEntity Failed: Not Registered:" entity.kind entity in
                    Entity entity
                Just setup ->
                    setup (Entity entity)


registerComponent : String -> (ComponentSetup g msg) -> Type g msg -> Type g msg
registerComponent kind setup model =
    case Dict.get kind model.components of
        Nothing ->
            let
                components = model.components
                    |> Dict.insert kind setup
                _ = info3 "[Registry] registerComponent Succeed:" kind setup
            in
                {model | components = components}
        Just exist ->
            let _ = error6 "[Registry] registerComponent Failed: Already Exist:" kind ":" exist "->" setup in
            model


setupComponent : Type g msg -> Component g msg -> Component g msg
setupComponent model (Component component) =
    case component.kind == kind_Entity of
        True -> Component
            component
        False ->
            case Dict.get component.kind model.components of
                Nothing ->
                    let _ = error3 "[Registry] setupComponent Failed: Not Registered:" component.kind component in
                    Component component
                Just setup ->
                    setup (Component component)

