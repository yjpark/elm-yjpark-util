module YJPark.WeUi.Loading exposing (..)

import Html as H exposing (Html)
import Html.Attributes as A
import Html.Events as E


renderLoading : Html msg
renderLoading =
    H.div [A.class "weui-loadmore"]
        [ H.div
            [ A.class "weui-loading" ]
            []
        , H.div
            [ A.class "weui-loadmore__tips" ]
            [ H.text "正在加载" ]
        ]
