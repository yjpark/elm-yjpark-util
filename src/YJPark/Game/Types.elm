module YJPark.Game.Types exposing (..)
import YJPark.Game.Model.Game as Game exposing (Type(..))

import YJPark.Util exposing (..)

import Game.Resources as Resources


type Msg ext
    = DoLoadResources
    | ResourceMsg Resources.Msg
    | DoTick Float
    | ExtMsg ext


type NoExtMsg
    = NoExtMsg


type alias Model ext = Game.Type (Msg ext)
