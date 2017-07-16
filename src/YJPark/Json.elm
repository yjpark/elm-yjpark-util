module YJPark.Json exposing (..)

import YJPark.Util exposing (..)

import Json.Decode as Decode
import Json.Encode as Encode
import Dict


type alias Data = (Dict.Dict String Encode.Value)


empty : Data
empty =
    Dict.empty


type alias Value = Encode.Value
null = Encode.null


insertBool : String -> Bool -> Data -> Data
insertBool key val =
    Dict.insert key (Encode.bool val)


insertInt : String -> Int -> Data -> Data
insertInt key val =
    Dict.insert key (Encode.int val)


insertFloat : String -> Float -> Data -> Data
insertFloat key val =
    Dict.insert key (Encode.float val)


insertString : String -> String -> Data -> Data
insertString key str =
    Dict.insert key (Encode.string str)


insertValue : String -> Value -> Data -> Data
insertValue key val =
    Dict.insert key val


insertOptionalString : String -> String -> Data -> Data
insertOptionalString key str =
    if (str /= "") then
        insertString key str
    else
        identity


insertOptionalValue : String -> Value -> Data -> Data
insertOptionalValue key val =
    if (val /= null) then
        insertValue key val
    else
        identity


{--
insert : String -> (WxDataType, a) -> Data -> Data
insert key (type_, value) =
    case type_ of
        WxBool ->
            insertBool key value
        WxInt ->
            insertInt key value
        WxFloat ->
            insertFloat key value
        WxString ->
            insertString key value
        WxData ->
            insertData key value
--}


dataToValue : Data -> Value
dataToValue data =
    Dict.toList data
        |> Encode.object


valueToData : Value -> Data
valueToData val =
    if val == null then
        empty
    else
        case Decode.decodeValue (Decode.dict Decode.value) val of
            Ok result ->
                result
            Err err ->
                let _ = error3 "[Json] valueToData: Decode Failed: " err val in
                empty


stringToValue : String -> Value
stringToValue str =
    Encode.string str


listToValue : List Value -> Value
listToValue list =
    list
        |> Encode.list


asString : Value -> String
asString val =
    case (Decode.decodeValue Decode.string val) of
        Ok val ->
            val
        Err err ->
            let _ = error3 "[Json] asString: Decode Failed: " err val in
            err


getStringWithDefault : String -> String -> Value -> String
getStringWithDefault key default val =
    case (Decode.decodeValue (Decode.field key Decode.string) val) of
        Ok val ->
            val
        Err err ->
            let _ = error3 "[Json] getStringWithDefault: Decode Failed: " err val in
            default


getString : String -> Value -> String
getString key val =
    getStringWithDefault key "" val


getIntWithDefault : String -> Int -> Value -> Int
getIntWithDefault key default val =
    case (Decode.decodeValue (Decode.field key Decode.int) val) of
        Ok val ->
            val
        Err err ->
            let _ = error3 "[Json] getIntWithDefault: Decode Failed: " err val in
            default


getInt : String -> Value -> Int
getInt key val =
    getIntWithDefault key 0 val


getFloatWithDefault : String -> Float -> Value -> Float
getFloatWithDefault key default val =
    case (Decode.decodeValue (Decode.field key Decode.float) val) of
        Ok val ->
            val
        Err err ->
            let _ = error3 "[Json] getFloatWithDefault: Decode Failed: " err val in
            default


getFloat : String -> Value -> Float
getFloat key val =
    getFloatWithDefault key 0 val


getBoolWithDefault : String -> Bool -> Value -> Bool
getBoolWithDefault key default val =
    case (Decode.decodeValue (Decode.field key Decode.bool) val) of
        Ok val ->
            val
        Err err ->
            let _ = error3 "[Json] getBoolWithDefault: Decode Failed: " err val in
            default


getBool : String -> Value -> Bool
getBool key val =
    getBoolWithDefault key False val


getValueWithDefault : String -> Value -> Value -> Value
getValueWithDefault key default val =
    case (Decode.decodeValue (Decode.field key Decode.value) val) of
        Ok val ->
            val
        Err err ->
            let _ = error3 "[Json] getValueWithDefault: Decode Failed: " err val in
            default


getValue : String -> Value -> Value
getValue key val =
    getValueWithDefault key null val

