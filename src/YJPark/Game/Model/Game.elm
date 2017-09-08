module YJPark.Game.Model.Game exposing (..)
import YJPark.Game.Model.Registry as Registry
import YJPark.Game.Model.Scene as Scene exposing (Type(..))
import YJPark.Game.Model.Entity as Entity exposing (Type(..))
import YJPark.Game.Model.Component as Component exposing (Type(..))

import YJPark.Util exposing (..)
import YJPark.Data as Data exposing (Data)

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
type alias EntitySetup msg = Registry.EntitySetup (Type msg) msg
type alias ComponentSetup msg = Registry.ComponentSetup (Type msg) msg


type Type msg = Game
    { time : Float
    , delta : Float
    , frame : Int
    , registry : Registry msg
    , base_url : String
    , resources : Resources
    , data : Data
    , scene : Scene msg
    }


initWithData : String -> Data -> Type msg
initWithData base_url data = Game
    { time = 0
    , delta = 0
    , frame = 0
    , registry = Registry.empty
    , base_url = base_url
    , resources = Resources.init
    , data = data
    , scene = Scene.null
    }


init : String -> Type msg
init base_url =
    initWithData base_url Data.empty


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


