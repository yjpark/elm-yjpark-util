module YJPark.Mdl.Textfield exposing (..)
import YJPark.Mdl.Types exposing (..)
import YJPark.Mdl.Events as Events

import Html exposing (..)
import Html.Events

import Material
import Material.Textfield as Textfield
import Material.Color as Color
import Material.Icon as Icon
import Material.Button as Button
import Material.List as Lists
import Material.Options as Options exposing (when, css)


-- label, value, icon, disabled, renderer
type alias WithActionMeta = (String, String, String, Bool)


renderTextfieldWithAction : WithActionMeta -> Int -> Renderer (WithIndex obj) msg
renderTextfieldWithAction (label, value, icon, disabled) index events mdl obj =
    -- Need to assign current inputed value with Textfield.value, otherwise the floating label will not
    -- be kept floating when not focused
    -- https://github.com/debois/elm-mdl/issues/278
    -- https://github.com/debois/elm-mdl/issues/333
    Options.div []
        [ Options.span []
            [ Textfield.render mdl.wrapper (obj.index ++ [index, 0])  mdl.mdl
                [ Textfield.label label
                , Textfield.floatingLabel
                , Events.onInputOption events obj
                , Events.onFocusOption events obj
                , Textfield.text_
                , Textfield.value value
                ]
                []
            , Button.render mdl.wrapper (obj.index ++ [index, 1]) mdl.mdl
                [ Button.icon
                , Button.colored
                , Button.disabled |> when (disabled)
                , Events.onClickOption events obj
                ]
                [ Icon.i icon ]
            ]
        ]
