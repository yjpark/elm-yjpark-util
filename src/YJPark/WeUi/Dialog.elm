module YJPark.WeUi.Dialog exposing (..)
import YJPark.WeUi.Types exposing (..)

import Html as H exposing (Html, text)
import Html.Attributes as A
import Html.Events as E

import List


type alias Meta = DialogMeta


alert : String -> String -> String -> String -> Meta
alert id title content ok =
    { id = id
    , title = title
    , content = content
    , ok = ok
    , cancel = Nothing
    }


confirm : String -> String -> String -> String -> String -> Meta
confirm id title content ok cancel =
    { id = id
    , title = title
    , content = content
    , ok = ok
    , cancel = Just cancel
    }


renderDialog : Wrapper msg -> Meta -> Html msg
renderDialog wrapper meta =
    let
        cancel = case meta.cancel of
            Nothing ->
                []
            Just cancel ->
                [ H.div
                    [ A.class "weui-dialog__btn weui-dialog__btn_default"
                    , E.onClick (wrapper <| OnDialogCancel meta)
                    ]
                    [ text cancel ]
                ]
    in
        H.div [ A.style [("display", "block")] ]
            [ H.div [ A.class "weui-mask" ] []
            , H.div [ A.class "weui-dialog" ]
                [ H.div [ A.class "weui-dialog__hd" ]
                    [ H.strong [ A.class "weui-dialog__title" ]
                        [ text meta.title ]
                    ]
                , H.div [ A.class "weui-dialog__bd" ]
                    [ text meta.content ]
                , H.div [ A.class "weui-dialog__ft" ]
                    (cancel ++
                    [ H.div
                        [ A.class "weui-dialog__btn weui-dialog__btn_primary"
                        , E.onClick (wrapper <| OnDialogOk meta)
                        ]
                        [ text meta.ok ]
                    ])
                ]
            ]
