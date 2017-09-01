module YJPark.WeUi.Types exposing (..)
import YJPark.Events as Events

import YJPark.WeUi.Model as Model

import YJPark.Util exposing (..)

import Dict

import Html exposing (Html)


type Msg
    = DoLoadTabs Model.Tabs
    | DoSwitchTab Int


type alias Wrapper msg = Msg -> msg


type alias Type msg =
    { model : Model.Type
    , wrapper : Wrapper msg
    }


type alias Model m msg =
    { m | weui : Type msg }


type alias Events obj msg = Events.Type obj msg


type alias Renderer obj msg = Events.Type obj msg -> Type msg -> obj -> Html msg

