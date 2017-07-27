module YJPark.Mdl.Events exposing (..)

import YJPark.Util exposing (..)

import Material.Options as Options exposing (Property)


type alias OnClick obj msg = obj -> msg
type alias OnInput obj msg = obj -> String -> msg
type alias OnFocus obj msg = obj -> Bool -> msg


type alias Type obj msg =
    { onClick : Maybe (OnClick obj msg)
    , onInput : Maybe (OnInput obj msg)
    , onFocus : Maybe (OnFocus obj msg)
    }


null : Type obj msg
null =
    { onClick = Nothing
    , onInput = Nothing
    , onFocus = Nothing
    }


wrapEvent : (a -> b) -> (b -> x) -> (a -> x)
wrapEvent converter event =
    \b ->
        event (converter b)



wrap : (a -> b) -> Type b msg -> Type a msg
wrap converter events =
    let
        wrapper = wrapEvent converter
    in
        { onClick = Maybe.map wrapper events.onClick
        , onInput = Maybe.map wrapper events.onInput
        , onFocus = Maybe.map wrapper events.onFocus
        }


onClick : OnClick obj msg -> Type obj msg -> Type obj msg
onClick wrapper model =
    { model
    | onClick = Just wrapper
    }


onInput : OnInput obj msg -> Type obj msg -> Type obj msg
onInput wrapper model =
    { model
    | onInput = Just wrapper
    }


onFocus : OnFocus obj msg -> Type obj msg -> Type obj msg
onFocus wrapper model =
    { model
    | onFocus = Just wrapper
    }


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
