module YJPark.Game.Meta.Scene exposing (..)
import YJPark.Game.Consts exposing (..)
import YJPark.Game.Meta.Physics as Physics
import YJPark.Game.Meta.Entity as Entity
import YJPark.Game.Meta.Camera as Camera

import YJPark.Data as Data exposing (Data)


type alias Type =
    { camera : Camera.Type
    , physics : Maybe Physics.Type
    , data : Data
    , root : Entity.Type
    }
