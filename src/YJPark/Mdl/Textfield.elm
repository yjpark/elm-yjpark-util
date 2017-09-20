module YJPark.Mdl.Textfield exposing (..)
import YJPark.Mdl.Types exposing (..)
import YJPark.Mdl.Action as Action
import YJPark.Mdl.Events as MdlEvents
import YJPark.Events as Events

import Html exposing (..)
import Html.Events

import Material
import Material.Textfield as Textfield
import Material.Color as Color exposing (Color)
import Material.Icon as Icon
import Material.Button as Button
import Material.List as Lists
import Material.Options as Options exposing (when, css)


-- label, value, action, options
type alias Meta msg = (String, String, Maybe (Action.Meta msg), List (Textfield.Property msg))


commonOptions label value events obj =
    [ Textfield.label label
    , Textfield.floatingLabel
    , MdlEvents.onInputOption events obj
    , MdlEvents.onFocusOption events obj
    , Textfield.value value
    ]



renderTextfield : Meta msg -> Int -> Renderer (WithIndex obj) msg
renderTextfield (label, value, action, options) index events mdl obj =
    -- Need to assign current inputed value with Textfield.value, otherwise the floating label will not
    -- be kept floating when not focused
    -- https://github.com/debois/elm-mdl/issues/278
    -- https://github.com/debois/elm-mdl/issues/333
    Options.div []
        [ Options.span []
            ([Textfield.render mdl.wrapper (obj.index ++ [index, 0])  mdl.mdl
                ( Textfield.text_
                :: commonOptions label value events obj
                ++ options)
                []
            ] |> Action.appendAction action [index, 1] events mdl obj)
        ]


renderTextarea : Meta msg -> Int -> Renderer (WithIndex obj) msg
renderTextarea (label, value, action, options) index events mdl obj =
    Options.div []
        [ Options.span []
            ([Textfield.render mdl.wrapper (obj.index ++ [index, 0])  mdl.mdl
                ( Textfield.textarea
                :: commonOptions label value events obj
                ++ options)
                []
            ] |> Action.appendAction action [index, 1] events mdl obj)
        ]


renderTextareaWithDummyAction : (String, String, Color) -> Int -> Renderer (WithIndex obj) msg
renderTextareaWithDummyAction (label, value, color) index events =
    let
        options =
            [ Color.text color ]
    in
        renderTextarea (label, value, Nothing, options) index Events.null
