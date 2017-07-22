module YJPark.Mdl exposing (..)
import YJPark.Mdl.Events as Events

import YJPark.Util exposing (..)
import Native.Mdl

import Material
import Html exposing (Html)

-- Events
type alias Events obj msg = Events.Type obj msg

noEvent = Events.null

onClick = Events.onClick
onInput = Events.onInput

onClickOption = Events.onClickOption


type alias Renderer obj msg = Events obj msg -> Type msg -> obj -> Html msg


-- Mdl
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
