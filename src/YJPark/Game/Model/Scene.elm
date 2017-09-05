module YJPark.Game.Model.Scene exposing (..)
import YJPark.Game.Model.Entity as Entity

import YJPark.Util exposing (..)
import YJPark.Json exposing (..)

import Game.TwoD.Camera as Camera exposing (Camera)
import Keyboard.Extra


type alias Entity g msg = Entity.Type g (Type g msg) msg


type Type g msg = Scene
    { root : Entity g msg
    , camera : Camera
    , tickers : List (g -> Type g msg -> (Type g msg, Cmd msg))
    }


type alias SceneTicker g msg = g -> Type g msg -> (Type g msg, Cmd msg)


init : Camera -> Type g msg
init camera = Scene
    { root = Entity.init Nothing ""
    , camera = camera
    , tickers = []
    }


addTicker : SceneTicker g msg -> Type g msg -> Type g msg
addTicker ticker (Scene scene) = Scene
    { scene
    | tickers = scene.tickers ++ [ticker]
    }
