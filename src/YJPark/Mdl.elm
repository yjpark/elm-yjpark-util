module YJPark.Mdl exposing (..)
import YJPark.Mdl.Events as Events

import YJPark.Util exposing (..)
import Native.Mdl

import Material
import Html exposing (Html)
import Dict


-- Events
type alias Events obj msg = Events.Type obj msg

noEvent = Events.null

onClick = Events.onClick
onInput = Events.onInput
onFocus = Events.onFocus

onClickOption = Events.onClickOption
onInputOption = Events.onInputOption
onFocusOption = Events.onFocusOption


type alias Renderer obj msg = Events obj msg -> Type msg -> obj -> Html msg

-- Index
type alias Index = List Int
noIndex = []


type alias WithIndex m =
    { m | index : Index }


updateIndex : Index -> WithIndex m -> WithIndex m
updateIndex index model =
    { model
    | index = index
    }


setIndex : Int -> WithIndex m -> WithIndex m
setIndex index model =
    model
        |> updateIndex [index]


setSubIndex : Index -> Int -> WithIndex m -> WithIndex m
setSubIndex parent index model =
    model
        |> updateIndex (parent ++ [index])


setListIndexes : Index -> List (WithIndex m) -> List (WithIndex m)
setListIndexes parent subs =
    subs
        |> List.indexedMap (setSubIndex parent)


setDictIndexes : Index -> Dict.Dict String (WithIndex m) -> Dict.Dict String (WithIndex m)
setDictIndexes parent subs =
    let
        updateSubIndex = \index (key, sub) ->
            (key, setSubIndex parent index sub)
    in
        subs
            |> Dict.toList
            |> List.indexedMap updateSubIndex
            |> Dict.fromList


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
