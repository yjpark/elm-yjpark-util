module YJPark.Mdl exposing (..)

import YJPark.Util exposing (..)
import Native.Mdl

import Material

type alias Wrapper msg = Material.Msg msg -> msg


type alias Type msg =
    { mdl : Material.Model
    , wrapper : Wrapper msg
    , hacky_index_ : Int
    }


type alias Model m msg =
    { m | mdl : Type msg }


init : Wrapper msg -> Type msg
init wrapper =
    { mdl = Material.model
    , wrapper = wrapper
    , hacky_index_ = 0
    }


update : Material.Msg msg -> Model m msg  -> (Model m msg, Cmd msg)
update msg model =
    let
        (mdl, cmd) = Material.update model.mdl.wrapper msg model.mdl
    in
        ({model | mdl = mdl}, cmd)


reset_index : Type msg -> Int
reset_index = Native.Mdl.reset_index


new_index : Type msg -> Int
new_index = Native.Mdl.new_index
