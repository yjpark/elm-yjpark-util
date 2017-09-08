module YJPark.Game.Builtin exposing (..)
import YJPark.Game.Consts exposing (..)
import YJPark.Game.Types as GameTypes exposing (..)
import YJPark.Game.Model.Game as Game exposing (Type(..))
import YJPark.Game.Model.Registry as Registry

import YJPark.Game.Component.Image as Image

import YJPark.Util exposing (..)


registry : Game.Registry msg
registry =
    Registry.empty
        |> Registry.registerComponent kind_Image Image.setup

