module YJPark.Game.Model.Scene exposing (..)
import YJPark.Game.Model.Entity as Entity

import YJPark.Util exposing (..)
import YJPark.Json exposing (..)

import Game.TwoD.Camera as Camera exposing (Camera)
import Keyboard.Extra


type Type msg = Scene
    { time : Float
    , delta : Float
    , frame : Int
    , root : Entity.Type (Type msg) msg
    , camera : Camera
    }


init : Camera -> Type msg
init camera =
    { time = 0
    , delta = 0
    , frame = 0
    , root = Entity.new Nothing
    , camera = Nothing --Camera.fixedWidth 8 ( 0, 0 )
    }



tickTime : Float -> Type msg -> Type msg
tickTime delta (Scene scene) = Scene
    { scene
    | time = scene.time + delta
    , delta = delta
    , frame = scene.frame + 1
    }

