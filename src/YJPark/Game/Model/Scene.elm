module YJPark.Game.Model.Scene exposing (..)
import YJPark.Game.Model.Entity as Entity

import YJPark.Util exposing (..)
import YJPark.Data exposing (..)

import Game.TwoD.Camera as Camera exposing (Camera)
import Keyboard.Extra


type alias Entity g msg = Entity.Type g (Type g msg) msg


type Type g msg = Scene
    { root : Entity g msg
    , camera : Camera
    , tickers : List (Ticker g msg)
    }


type alias Ticker g msg = g -> Type g msg -> (Type g msg, Cmd msg)


init : Camera -> Type g msg
init camera = Scene
    { root = Entity.init Nothing ""
    , camera = camera
    , tickers = []
    }


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
