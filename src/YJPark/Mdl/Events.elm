module YJPark.Mdl.Events exposing (..)

import YJPark.Events exposing (..)
import YJPark.Util exposing (..)

import Material.Options as Options exposing (Property)


onClickOption : Type obj msg -> obj -> Property c msg
onClickOption model obj =
    case model.onClick of
        Nothing ->
            Options.nop
        Just onClick ->
            Options.onClick (onClick obj)


onInputOption : Type obj msg -> obj -> Property c msg
onInputOption model obj =
    case model.onInput of
        Nothing ->
            Options.nop
        Just onInput ->
            Options.onInput (onInput obj)


onFocusOption : Type obj msg -> obj -> Property c msg
onFocusOption model obj =
    case model.onFocus of
        Nothing ->
            Options.nop
        Just onFocus ->
            Options.many
                [ Options.onFocus (onFocus obj True)
                , Options.onBlur (onFocus obj False)
                ]
