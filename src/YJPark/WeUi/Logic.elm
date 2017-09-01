module YJPark.WeUi.Logic exposing (..)

import YJPark.WeUi.Model as Model
import YJPark.WeUi.Types exposing (..)
import YJPark.WeUi.TabBar as TabBar

import YJPark.Util exposing (..)

import Html exposing (Html)


update : Msg -> Model.Type -> (Model.Type, Cmd Msg)
update msg model =
    case msg of
        DoLoadTabs tabs ->
            ({model | tabs = tabs}, Cmd.none)
        DoSwitchTab tab ->
            ({model | current_tab = tab}, Cmd.none)


view : Model.Type -> Html Msg
view model =
    TabBar.renderTabBar model.tabs
