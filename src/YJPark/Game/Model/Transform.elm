module YJPark.Game.Model.Transform exposing (..)
import YJPark.Game.Meta.Transform as TransformMeta

import YJPark.Util exposing (..)


type alias Value = TransformMeta.Type

zero = TransformMeta.zero


type alias Type =
    { parent : Value
    , local : Value
    , world : Value
    }


null : Type
null =
    { parent = zero
    , local = zero
    , world = zero
    }


setParent : Value -> Type -> Type
setParent parent transform =
    let
        world =
            { x = parent.x + transform.local.x
            , y = parent.y + transform.local.y
            , z = parent.z + transform.local.z
            , angle = parent.angle + transform.local.angle
            }
    in
        { transform
        | parent = parent
        , world = world
        }


setLocal : Value -> Type -> Type
setLocal local transform =
    let
        world =
            { x = transform.parent.x + local.x
            , y = transform.parent.y + local.y
            , z = transform.parent.z + local.z
            , angle = transform.parent.angle + local.angle
            }
    in
        { transform
        | local = local
        , world = world
        }


setWorld : Value -> Type -> Type
setWorld world transform =
    let
        local =
            { x = world.x - transform.parent.x
            , y = world.y - transform.parent.y
            , z = world.z - transform.parent.z
            , angle = world.angle - transform.parent.angle
            }
    in
        { transform
        | local = local
        , world = world
        }


getPosition : Type -> (Float, Float, Float)
getPosition transform =
    (transform.world.x, transform.world.y, transform.world.z)


getRotation : Type -> Float
getRotation transform =
    transform.world.angle
