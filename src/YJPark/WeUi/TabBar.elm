module YJPark.WeUi.TabBar exposing (..)
import YJPark.WeUi.Types exposing (..)
import YJPark.WeUi.Model as Model
import YJPark.Html.Events as PE

import Html as H exposing (Html)
import Html.Attributes as A
import Html.Events as E

import List


renderTabs : Wrapper msg -> Html msg -> Model.Tabs -> Int -> Html msg
renderTabs wrapper tab_content tabs current_tab =
    H.div [A.class "weui-tab"]
        [ H.div
            [ A.class "weui-tab__panel"
            , A.id tab_content_id
            , PE.onScroll (\evt -> wrapper <| Out <| OnScrollY evt.scrollPos)
            ]
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
        is_current = current_tab == index
        on_class = case is_current of
            True ->
                [A.class " weui-bar__item_on"]
            False ->
                []
        on_click = [E.onClick (wrapper <| DoSwitchTab index)]
        image = case tab.selectedImage of
            Nothing ->
                tab.image
            Just selectedImage ->
                case is_current of
                    True ->
                        selectedImage
                    False ->
                        tab.image
        title = case tab.title of
            Nothing ->
                []
            Just title ->
                [ H.p
                    [ A.class "weui-tabbar__label"
                    , A.style [("margin-bottom", "0px")]
                    ]
                    [ H.text title ]
                ]
    in
        H.div ([A.class "weui-tabbar__item"] ++ on_class ++ on_click)
            ([ H.img
                [ A.class "weui-tabbar__icon"
                , A.src image
                ] []
            ] ++ title)
