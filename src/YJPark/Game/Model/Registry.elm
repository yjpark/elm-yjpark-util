module YJPark.Game.Model.Registry exposing (..)
import YJPark.Game.Model.Scene as Scene exposing (Type(..))
import YJPark.Game.Model.Entity as Entity exposing (Type(..))
import YJPark.Game.Model.Component as Component exposing (Type(..))

import YJPark.Util exposing (..)
import YJPark.Data as Data exposing (Data)

import Dict exposing (Dict)


type alias Component g msg = Component.Type g (Scene.Type g msg) (Scene.Entity g msg) msg


type alias Type g msg =
    { components : Dict String (Data -> Component g msg)
    }


init : Type g msg
init =
    { components = Dict.empty
    }


registerComponent : String -> (Data -> Component g msg) -> Type g msg -> Type g msg
registerComponent kind initer model =
    case Dict.get kind model.components of
        Nothing ->
            let
                components = model.components
                    |> Dict.insert kind initer
            in
                {model | components = components}
        Just exist ->
            let _ = error6 "registerComponent Failed: Already Exist:" kind ":" exist "->" initer in
            model
