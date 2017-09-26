module YJPark.Game.Model.Physics exposing (..)
import YJPark.Game.Model.Entity as Entity

import YJPark.Util exposing (..)
import YJPark.Data as Data exposing (Data, Value)

import BoxesAndBubbles.Math2D as Math2D exposing (Vec2)
import BoxesAndBubbles.Bodies as Bodies

import Dict exposing (Dict)


type alias Body = Bodies.Body Entity.Path


type alias Type =
    { debug : Bool
    , gravity : Vec2
    , ambient : Vec2
    , bodies : Dict Entity.Path Body
    }


initWithAmbient : Bool -> Vec2 -> Vec2 -> Type
initWithAmbient debug gravity ambient =
    { debug = debug
    , gravity = gravity
    , ambient = ambient
    , bodies = Dict.empty
    }


init : Bool -> Vec2 -> Type
init debug gravity =
    initWithAmbient debug gravity (0, 0)


getBody : Entity.Path -> Type -> Maybe Body
getBody path model =
    model.bodies
        |> Dict.get path


setBody : Body -> Type -> Type
setBody body model =
    let
        bodies = model.bodies
            |> Dict.insert body.meta body
    in
        { model
        | bodies = bodies
        }
