module YJPark.Game.Model.Game exposing (..)
import YJPark.Game.Model.Registry as Registry
import YJPark.Game.Model.Scene as Scene exposing (Type(..))
import YJPark.Game.Model.Entity as Entity exposing (Type(..))
import YJPark.Game.Model.Component as Component exposing (Type(..))

import YJPark.Util exposing (..)

import Game.Resources as Resources exposing (Resources)
import Game.TwoD.Camera as Camera exposing (Camera)
import Keyboard.Extra


type alias Game msg = Type msg
type alias Scene msg = Scene.Type (Type msg) msg
type alias SceneTicker msg = Scene.Ticker (Type msg) msg

type alias Entity msg = Entity.Type (Type msg) (Scene msg) msg
type alias EntityTicker msg = Entity.Ticker (Type msg) (Scene msg) msg

type alias Component msg = Component.Type (Type msg) (Scene msg) (Entity msg) msg
type alias ComponentTicker msg = Component.Ticker (Type msg) (Scene msg) (Entity msg) msg
type alias ComponentRenderer msg = Component.Renderer (Type msg) (Scene msg) (Entity msg) msg

type alias Registry msg = Registry.Type (Type msg) msg


type Type msg = Game
    { time : Float
    , delta : Float
    , frame : Int
    , registry : Registry msg
    , resources : Resources
    , scene : Scene msg
    }


init : Camera -> Type msg
init camera = Game
    { time = 0
    , delta = 0
    , frame = 0
    , registry = Registry.init
    , resources = Resources.init
    , scene = Scene.init camera
    }


setScene : Scene msg  -> Type msg -> Type msg
setScene scene (Game game) = Game
    { game
    | scene = scene
    }


setSceneRoot : Entity msg  -> Type msg -> Type msg
setSceneRoot root (Game game) = Game
    { game
    | scene = Scene.setRoot root game.scene
    }


