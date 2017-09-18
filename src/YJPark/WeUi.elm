module YJPark.WeUi exposing (..)
import YJPark.Events as Events
import YJPark.WeUi.Types as Types
import YJPark.WeUi.Model as Model
import YJPark.WeUi.Logic as Logic
import YJPark.WeUi.TabBar as TabBar
import YJPark.WeUi.Dialog as Dialog
import YJPark.Util exposing (..)

import Html as H exposing (Html)


-- Types
type alias Tab = Model.Tab
type alias Tabs = Model.Tabs

type alias Msg = Types.Msg

type alias Wrapper msg = Types.Wrapper msg
type alias Type msg = Types.Type msg
type alias Model m msg = Types.Model m msg
type alias Renderer obj msg = Types.Renderer obj msg
type alias Events obj msg = Types.Events obj msg


-- Events
wrapEvents = Events.wrap

noEvent = Events.null

onClick = Events.onClick
onInput = Events.onInput
onFocus = Events.onFocus


init : Wrapper msg -> Type msg
init wrapper =
    { model = Model.null
    , wrapper = wrapper
    }


update : Msg -> Model m msg  -> (Model m msg, Cmd msg)
update msg model =
    let
        (weui_model, cmd) = Logic.update msg model.weui.model
        weui = model.weui
        new_weui = {weui | model = weui_model} --if use model.weui directly here, got compiler problem
    in
        ({model | weui = new_weui}, Cmd.map model.weui.wrapper cmd)


view : Wrapper msg -> Html msg -> Model m msg -> Html msg
view wrapper tab_content model =
    let
        tabs = TabBar.renderTabs wrapper tab_content model.weui.model.tabs model.weui.model.current_tab
    in
        case model.weui.model.dialog of
            Nothing ->
                tabs
            Just dialog ->
                H.div []
                    [ tabs
                    , Dialog.renderDialog wrapper dialog
                    ]
