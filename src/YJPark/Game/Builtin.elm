module YJPark.Game.Builtin exposing (..)
import YJPark.Game.Consts exposing (..)
import YJPark.Game.Types as Types exposing (..)
import YJPark.Game.Model.Game as Game exposing (Type(..))
import YJPark.Game.Model.Registry as Registry

import YJPark.Game.Component.Image as Image
import YJPark.Game.Component.Rigidbody as Rigidbody

import YJPark.Util exposing (..)


registry : Game.Registry (Msg ext)
registry =
    Registry.empty
        |> Registry.registerComponent kind_Image Image.setup
        |> Registry.registerComponent kind_Rigidbody Rigidbody.setup

