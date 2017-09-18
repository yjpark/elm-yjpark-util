module YJPark.WeUi.Types exposing (..)
import YJPark.Events as Events

import YJPark.WeUi.Model as Model

import YJPark.Util exposing (..)

import Dict

import Html exposing (Html)


type alias DialogMeta = Model.DialogMeta


tab_content_id = "_wxui_tab_content"


type InMsg
    = DoLoadTabs Model.Tabs
    | DoScrollY Float


type OutMsg
    = OnScrollY Float
    | OnSwitchTab


type Msg
    = In InMsg
    | Out OutMsg
    | DoSwitchTab Int
    | OnDialogOk DialogMeta
    | OnDialogCancel DialogMeta
    | Nop


type alias Wrapper msg = Msg -> msg


type alias Type msg =
    { model : Model.Type
    , wrapper : Wrapper msg
    }


type alias Model m msg =
    { m | weui : Type msg }


type alias Events obj msg = Events.Type obj msg


type alias Renderer obj msg = Events.Type obj msg -> Type msg -> obj -> Html msg


updateModel : (Model.Type -> Model.Type) -> Model m msg -> Model m msg
updateModel updator model =
    let
        old = model.weui --need this temp variable, otherwise got compiler error
        weui =
            { old
            | model = updator model.weui.model
            }
    in
        {model | weui = weui}
