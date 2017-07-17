module YJPark.Mdl exposing (..)

import YJPark.Util exposing (..)

import Material


type alias Wrapper msg = Material.Msg msg -> msg


type alias Type msg =
    { mdl : Material.Model
    , wrapper : Wrapper msg
    }


init : Wrapper msg -> Type msg
init wrapper =
    { mdl = Material.model
    , wrapper = wrapper
    }
