module YJPark.Game.Model.Transform exposing (..)

import YJPark.Util exposing (..)
import YJPark.Data exposing (..)


type alias Value =
    { x : Float
    , y : Float
    , z : Float
    , angle : Float
    }


type alias Type =
    { local : Value
    , world : Value
    }


zero : Value
zero =
    { x = 0
    , y = 0
    , z = 0
    , angle = 0
    }


null : Type
null =
    { local = zero
    , world = zero
    }


localToWorld : Type -> Type -> Type
localToWorld parent transform =
    let
        world =
            { x = parent.world.x + transform.local.x
            , y = parent.world.y + transform.local.y
            , z = parent.world.z + transform.local.z
            , angle = parent.world.angle + transform.local.angle
            }
    in
        { transform
        | world = world
        }


worldToLocal : Type -> Type -> Type
worldToLocal parent transform =
    let
        local =
            { x = transform.world.x - parent.world.x
            , y = transform.world.y - parent.world.y
            , z = transform.world.z - parent.world.z
            , angle = transform.world.angle - parent.world.angle
            }
    in
        { transform
        | local = local
        }


getPosition : Type -> (Float, Float, Float)
getPosition transform =
    (transform.world.x, transform.world.y, transform.world.z)


getRotation : Type -> Float
getRotation transform =
    transform.world.angle
