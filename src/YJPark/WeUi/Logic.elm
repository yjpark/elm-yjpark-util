module YJPark.WeUi.Logic exposing (..)

import YJPark.WeUi.Model as Model
import YJPark.WeUi.Types exposing (..)

import YJPark.Util exposing (..)

import Html exposing (Html)
import Dom.Scroll as Scroll
import Task


update : Msg -> Model.Type -> (Model.Type, Cmd Msg)
update msg model =
    case msg of
        In (DoLoadTabs tabs) ->
            ({model | tabs = tabs}, Cmd.none)
        In (DoScrollY y) ->
            (model, Task.attempt (always Nop) (Scroll.toY tab_content_id y))
        DoSwitchTab tab ->
            ({model | current_tab = tab}, toCmd <| Out OnSwitchTab)
        OnDialogOk meta ->
            ({model | dialog = Nothing}, Cmd.none)
        OnDialogCancel meta ->
            ({model | dialog = Nothing}, Cmd.none)
        Nop ->
            (model, Cmd.none)
        Out _ ->
            (model, Cmd.none)

