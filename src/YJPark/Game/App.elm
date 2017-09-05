module YJPark.Game.App exposing (..)
import YJPark.Game.Types as GameTypes exposing (..)
import YJPark.Game.Model.Game as Game exposing (Type(..))

import YJPark.Game.Logic.Scene as SceneLogic
import YJPark.Game.Types exposing (..)

import YJPark.Util exposing (..)

import Game.TwoD.Camera as Camera exposing (Camera)
import Keyboard.Extra

import Game.Resources as Resources


type alias Model ext = GameTypes.Model ext


type alias Msg ext = GameTypes.Msg ext


init : Camera -> Model ext
init camera =
    Game.init camera


tick : Float -> Model ext -> (Model ext, Cmd (Msg ext))
tick delta (Game game) =
    let
        result =
            { game
            | time = game.time + delta
            , delta = delta
            , frame = game.frame + 1
            }
        (scene, cmd) = SceneLogic.tick (Game result) result.scene
    in
        (Game {result | scene = scene}) ! [cmd]


update : Msg ext -> Model ext -> (Model ext, Cmd (Msg ext))
update msg (Game game) =
    case msg of
        DoTick delta ->
            tick delta (Game game)
        DoLoadTextures urls ->
            (Game game) ! []
        ResourceMsg msg_ ->
            (Game {game | resources = Resources.update msg_ game.resources}) ! []
        ExtMsg _ ->
            (Game game) ! []

