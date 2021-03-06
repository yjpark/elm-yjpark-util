module YJPark.Game.Model.Scene exposing (..)
import YJPark.Game.Model.Entity as Entity
import YJPark.Game.Model.Physics as Physics

import YJPark.Util exposing (..)
import YJPark.Data as Data exposing (Data, Value)

import Game.TwoD.Camera as Camera exposing (Camera)
import Keyboard.Extra


type alias Entity g msg = Entity.Type g (Type g msg) msg


type Type g msg = Scene
    { camera : Camera
    , data : Data
    , root : Entity g msg
    , physics : Maybe Physics.Type
    , tickers : List (Ticker g msg)
    }


type alias Ticker g msg = g -> Type g msg -> (Type g msg, List msg)


initWithData : Camera -> Data -> Type g msg
initWithData camera data = Scene
    { camera = camera
    , data = data
    , root = Entity.init "" ""
    , physics = Nothing
    , tickers = []
    }


init : Camera -> Type g msg
init camera =
    initWithData camera Data.empty


null : Type g msg
null =
    init <| Camera.fixedWidth 256 (0, 0)


getData : Type g msg -> Data
getData (Scene scene) =
    scene.data


setData : Data -> Type g msg -> Type g msg
setData data (Scene scene) = Scene
    (Data.setData data scene)


updateData : String -> Value -> Type g msg -> Type g msg
updateData key val (Scene scene) = Scene
    (Data.updateData key val scene)


addTicker : Ticker g msg -> Type g msg -> Type g msg
addTicker ticker (Scene scene) = Scene
    { scene
    | tickers = scene.tickers ++ [ticker]
    }


getRoot : Type g msg -> Entity g msg
getRoot (Scene scene) =
    scene.root


setRoot : Entity g msg -> Type g msg -> Type g msg
setRoot root (Scene scene) = Scene
    { scene
    | root = root
    }


setPhysics : Physics.Type -> Type g msg -> Type g msg
setPhysics physics (Scene scene) = Scene
    { scene
    | physics = Just physics
    }


updatePhysics : (Physics.Type -> Physics.Type) -> Type g msg -> Type g msg
updatePhysics updater (Scene scene) =
    let
        physics = scene.physics
            |> Maybe.map updater
    in Scene
        { scene
        | physics = physics
        }
