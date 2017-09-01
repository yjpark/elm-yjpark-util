module YJPark.Mdl.Types exposing (..)
import YJPark.Events as Events
import YJPark.Mdl.Events as MdlEvents

import YJPark.Util exposing (..)

import Material
import Html exposing (Html)
import Dict


-- Mdl
type alias Wrapper msg = Material.Msg msg -> msg


type alias Type msg =
    { mdl : Material.Model
    , wrapper : Wrapper msg
    , hacky_index_ : Int
    }


type alias Model m msg =
    { m | mdl : Type msg }


type alias Events obj msg = Events.Type obj msg


type alias Renderer obj msg = Events obj msg -> Type msg -> obj -> Html msg


type alias Index = List Int


type alias WithIndex m =
    { m | index : Index }


