module YJPark.WeUi exposing (..)
import YJPark.Events as Events
import YJPark.WeUi.Types as Types
import YJPark.WeUi.Model as Model
import YJPark.WeUi.Logic as Logic
import YJPark.Util exposing (..)

import Html exposing (Html)


-- Types
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
    { weui = Model.null
    , wrapper = wrapper
    }


update : Types.Msg -> Model m msg  -> (Model m msg, Cmd msg)
update msg model =
    let
        (weui, cmd) = Logic.update msg model.weui
    in
        ({model | weui = weui}, Cmd.map model.weui.wrapper cmd)
