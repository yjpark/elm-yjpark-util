module YJPark.Game.Types exposing (..)
import YJPark.Game.Model.Game as Game exposing (Type(..))
import YJPark.Game.Model.Registry as Registry
import YJPark.Game.Model.Transform as Transform
import YJPark.Game.Model.Entity as Entity
import YJPark.Game.Assets.Mod as Assets

import YJPark.Game.Meta.Scene as SceneMeta
import YJPark.Game.Meta.Camera as CameraMeta
import YJPark.Game.Meta.Entity as EntityMeta
import YJPark.Game.Meta.Transform as TransformMeta

import YJPark.Util exposing (..)


type alias SceneMeta = SceneMeta.Type
type alias CameraMeta = CameraMeta.Type
type alias EntityMeta = EntityMeta.Type
type alias TransformMeta = TransformMeta.Type

type alias EntityPath = Entity.Path

type alias Registry ext = Game.Registry (Msg ext)
type alias Scene ext = Game.Scene (Msg ext)
type alias Entity ext = Game.Entity (Msg ext)
type alias Component ext = Game.Component (Msg ext)


type Msg ext
    = DoLoadResources
    | DoLoadScene SceneMeta
    | AssetsMsg Assets.Msg
    | DoTick Float
    | DoUpdateScene (Scene ext -> Scene ext)
    | DoUpdateEntity EntityPath (Entity ext -> Entity ext)
    | ExtMsg ext


type NoExtMsg
    = NoExtMsg


type alias Model ext = Game.Type (Msg ext)
