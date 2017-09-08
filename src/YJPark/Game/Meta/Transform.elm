module YJPark.Game.Meta.Transform exposing (..)
import YJPark.Game.Consts exposing (..)


type alias Type =
    { x : Float
    , y : Float
    , z : Float
    , angle : Float
    }


zero : Type
zero =
    { x = 0
    , y = 0
    , z = 0
    , angle = 0
    }


x : Float -> Type
x v =
    { x = v
    , y = 0
    , z = 0
    , angle = 0
    }


y : Float -> Type
y v =
    { x = 0
    , y = v
    , z = 0
    , angle = 0
    }


z : Float -> Type
z v =
    { x = 0
    , y = 0
    , z = v
    , angle = 0
    }


a : Float -> Type
a v =
    { x = 0
    , y = 0
    , z = 0
    , angle = v
    }


xy : Float -> Float -> Type
xy x y =
    { x = x
    , y = y
    , z = 0
    , angle = 0
    }


xyz : Float -> Float -> Float -> Type
xyz x y z =
    { x = x
    , y = y
    , z = z
    , angle = 0
    }


xya : Float -> Float -> Float -> Type
xya x y a =
    { x = x
    , y = y
    , z = 0
    , angle = a
    }


xyza : Float -> Float -> Float -> Float -> Type
xyza x y z a =
    { x = x
    , y = y
    , z = z
    , angle = a
    }


add : Type -> Type -> Type
add a b =
    { x = a.x + b.x
    , y = a.y + b.y
    , z = a.z + b.z
    , angle = a.angle + b.angle
    }
