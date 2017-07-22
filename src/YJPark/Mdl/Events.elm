module YJPark.Mdl.Events exposing (..)

import YJPark.Util exposing (..)


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
