module YJPark.Game.Logic.Camera exposing (..)
import YJPark.Game.Consts exposing (..)

import YJPark.Game.Meta.Camera as CameraMeta exposing (Kind(..))

import YJPark.Util exposing (..)
import YJPark.Data as Data exposing (Data)

import Game.TwoD.Camera as Camera exposing (Camera)


load : CameraMeta.Type -> Camera
load meta =
    let
        x = Data.getFloat key_x meta.data
        y = Data.getFloat key_y meta.data
    in
        case meta.kind of
            FixedWidth ->
                let
                    width = Data.getFloat key_width meta.data
                in
                    Camera.fixedWidth width (x, y)
            FixedHeight ->
                let
                    height = Data.getFloat key_height meta.data
                in
                    Camera.fixedHeight height (x, y)
