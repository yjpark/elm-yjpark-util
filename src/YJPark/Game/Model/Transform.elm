module YJPark.Game.Model.Transform exposing (..)

import YJPark.Util exposing (..)
import YJPark.Json exposing (..)


type alias Float2 =
    ( Float, Float )


type alias Int2 =
    ( Int, Int )


type alias Float3 =
    ( Float, Float, Float )


type alias Type =
    { local_pos : Float3
    , local_angle : Float
    , pos : Float3
    , angle : Float
    }


null : Type
null =
    { local_pos = (0, 0, 0)
    , local_angle = 0
    , pos = (0, 0, 0)
    , angle = 0
    }
