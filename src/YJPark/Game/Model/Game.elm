module YJPark.Game.Model.Game exposing (..)
import YJPark.Game.Model.Scene as Scene exposing (Type(..), SceneTicker)

import YJPark.Util exposing (..)

import Game.Resources as Resources exposing (Resources)
import Game.TwoD.Camera as Camera exposing (Camera)
import Keyboard.Extra


type Type msg = Game
    { time : Float
    , delta : Float
    , frame : Int
    , resources : Resources
    , scene : Scene.Type (Type msg) msg
    }


init : Camera -> Type msg
init camera = Game
    { time = 0
    , delta = 0
    , frame = 0
    , resources = Resources.init
    , scene = Scene.init camera
    }

