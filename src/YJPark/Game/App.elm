module YJPark.Game.App exposing (..)
import YJPark.Game.Types as GameTypes exposing (..)
import YJPark.Game.Builtin as Builtin
import YJPark.Game.Model.Game as Game exposing (Type(..))
import YJPark.Game.Model.Scene as Scene exposing (Type(..))

import YJPark.Game.Logic.Game as GameLogic
import YJPark.Game.Logic.Scene as SceneLogic
import YJPark.Game.Component.Image as Image

import YJPark.Game.Meta.Scene as SceneMeta

import YJPark.Util exposing (..)

import Game.TwoD as TwoDGame
import Game.TwoD.Camera as Camera exposing (Camera)
import Keyboard.Extra

import Game.Resources as Resources
import Html exposing (Html)


type alias Model ext = GameTypes.Model ext


type alias Msg ext = GameTypes.Msg ext


init : String -> Camera -> Model ext
init base_url camera =
    Game.init base_url camera
        |> Builtin.register


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


loadScene : SceneMeta.Type -> Model ext -> (Model ext, Cmd (Msg ext))
loadScene meta (Game game) =
    let
        scene = SceneLogic.load game.registry meta
    in
        (Game {game | scene = scene}) ! [toCmd <| DoLoadResources]


update : Msg ext -> Model ext -> (Model ext, Cmd (Msg ext))
update msg (Game game) =
    case msg of
        DoTick delta ->
            tick delta (Game game)
        DoLoadResources ->
            let
                textures = Image.gatherTextures game.scene
                    |> List.map (\u -> game.base_url ++ u)
            in
                (Game game) !
                    [ Resources.loadTextures textures
                        |> Cmd.map ResourceMsg
                    ]
        DoLoadScene meta ->
            loadScene meta (Game game)
        ResourceMsg msg_ ->
            (Game {game | resources = Resources.update msg_ game.resources}) ! []
        ExtMsg _ ->
            (Game game) ! []


renderScene : (Int, Int) -> Model ext -> Game.Scene (Msg ext) -> Html (Msg ext)
renderScene size (Game game) (Scene scene) =
    SceneLogic.render (Game game) (Scene scene)
        |> TwoDGame.render
            { size = size
            , time = game.time
            , camera = scene.camera
            }


render : (Int, Int) -> Model ext -> Html (Msg ext)
render size (Game game) =
    renderScene size (Game game) game.scene
