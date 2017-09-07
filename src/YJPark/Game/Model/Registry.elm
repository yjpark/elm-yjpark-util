module YJPark.Game.Model.Registry exposing (..)
import YJPark.Game.Model.Scene as Scene exposing (Type(..))
import YJPark.Game.Model.Entity as Entity exposing (Type(..))
import YJPark.Game.Model.Component as Component exposing (Type(..))

import YJPark.Util exposing (..)
import YJPark.Data as Data exposing (Data)

import Dict exposing (Dict)

import Game.TwoD.Camera as Camera exposing (Camera)


type alias Component g msg = Component.Type g (Scene.Type g msg) (Scene.Entity g msg) msg


type alias Type g msg =
    { components : Dict String (Data -> Component g msg)
    }


init : Type g msg
init =
    { components = Dict.empty
    }


registerComponent : String -> (Data -> Component g msg) -> Type g msg -> Type g msg
registerComponent kind spawner model =
    case Dict.get kind model.components of
        Nothing ->
            let
                components = model.components
                    |> Dict.insert kind spawner
                _ = info3 "[Registry] registerComponent Succeed:" kind spawner
            in
                {model | components = components}
        Just exist ->
            let _ = error6 "[Registry] registerComponent Failed: Already Exist:" kind ":" exist "->" spawner in
            model


spawnComponent : String -> Data -> Type g msg -> Maybe (Component g msg)
spawnComponent kind data model =
    case Dict.get kind model.components of
        Nothing ->
            let _ = error3 "[Registry] spawnComponent Failed: Not Registered:" kind data in
            Nothing
        Just spawner ->
            Just <| spawner data

