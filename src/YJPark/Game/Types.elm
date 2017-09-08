module YJPark.Game.Types exposing (..)
import YJPark.Game.Model.Game as Game exposing (Type(..))
import YJPark.Game.Model.Registry as Registry

import YJPark.Game.Meta.Scene as SceneMeta
import YJPark.Game.Meta.Camera as CameraMeta
import YJPark.Game.Meta.Entity as EntityMeta
import YJPark.Game.Meta.Transform as TransformMeta

import YJPark.Util exposing (..)

import Game.Resources as Resources


type alias SceneMeta = SceneMeta.Type
type alias CameraMeta = CameraMeta.Type
type alias EntityMeta = EntityMeta.Type
type alias TransformMeta = TransformMeta.Type

type alias Registry ext = Game.Registry (Msg ext)


type Msg ext
    = DoLoadResources
    | DoLoadScene SceneMeta
    | ResourceMsg Resources.Msg
    | DoTick Float
    | ExtMsg ext


type NoExtMsg
    = NoExtMsg


type alias Model ext = Game.Type (Msg ext)
