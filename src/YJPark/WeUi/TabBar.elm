module YJPark.WeUi.TabBar exposing (..)
import YJPark.WeUi.Types exposing (..)
import YJPark.WeUi.Model as Model

import Html as H exposing (Html)
import Html.Attributes as A
import Html.Events as E

import List


renderTabs : Wrapper msg -> Html msg -> Model.Tabs -> Int -> Html msg
renderTabs wrapper tab_content tabs current_tab =
    H.div [A.class "weui-tab"]
        [ H.div [A.class "weui-tab__panel"]
            [ tab_content
            ]
        , renderTabBar wrapper tabs current_tab
        ]


renderTabBar : Wrapper msg -> Model.Tabs -> Int -> Html msg
renderTabBar wrapper tabs current_tab =
    H.div [A.class "weui-tabbar"]
    (tabs
        |> List.indexedMap (renderTabItem wrapper current_tab))


renderTabItem : Wrapper msg -> Int -> Int -> Model.Tab -> Html msg
renderTabItem wrapper current_tab index tab =
    let
        on_class = if current_tab == index
            then
                [A.class " weui-bar__item_on"]
            else
                []
        on_click = [E.onClick (wrapper <| DoSwitchTab index)]
    in
        H.div ([A.class "weui-tabbar__item"] ++ on_class ++ on_click)
            [ H.img
                [ A.class "weui-tabbar__icon"
                , A.src tab.image
                ] []
            , H.p [ A.class "weui-tabbar__label"]
                [ H.text tab.title ]
            ]
