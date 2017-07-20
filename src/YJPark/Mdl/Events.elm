module YJPark.Mdl.Events exposing (..)

import YJPark.Util exposing (..)


type alias Wrapper obj msg = obj -> msg -> msg


type alias Type obj msg =
    { onClick : Maybe (Wrapper obj msg)
    , onInput : Maybe (Wrapper obj msg)
    }


null : Type obj msg
null =
    { onClick = Nothing
    , onInput = Nothing
    }


onClick : Wrapper obj msg -> Type obj msg -> Type obj msg
onClick wrapper model =
    { model
    | onClick = Just wrapper
    }


onInput : Wrapper obj msg -> Type obj msg -> Type obj msg
onInput wrapper model =
    { model
    | onInput = Just wrapper
    }
