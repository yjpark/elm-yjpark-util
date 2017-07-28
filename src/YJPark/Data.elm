module YJPark.Data exposing (..)

import YJPark.Util exposing (..)
import YJPark.Json as Json

import Json.Decode as Decode
import Json.Encode as Encode
import Dict


type alias Data = (Dict.Dict String Encode.Value)

type alias WithData m =
    { m
    | data : Data
    }


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


toValue : Data -> Value
toValue data =
    Dict.toList data
        |> Encode.object


fromValue : Value -> Data
fromValue val =
    if val == null then
        empty
    else
        case Decode.decodeValue (Decode.dict Decode.value) val of
            Ok result ->
                result
            Err err ->
                let _ = error3 "[Json] valueToData: Decode Failed: " err val in
                empty


get : Bool -> String -> String -> (Value -> val) -> val -> Data -> val
get isDebug msg key convertor default data =
    case Dict.get key data of
        Nothing ->
            let
                _ = case isDebug of
                    True ->
                        debug4 "[Data] Value Not Found:" msg key default
                    False ->
                        error4 "[Data] Value Not Found:" msg key default
            in
                default
        Just val ->
            convertor val


getBool : String -> Data -> Bool
getBool key =
    get False "getBool" key Json.asBool False


getInt : String -> Data -> Int
getInt key =
    get False "getInt" key Json.asInt 0


getFloat : String -> Data -> Float
getFloat key =
    get False "getFloat" key Json.asFloat 0


getString : String -> Data -> String
getString key =
    get False "getString" key Json.asString ""


getValue : String -> Data -> Value
getValue key =
    get False "getValue" key identity null


getBoolWithDefault : String -> Bool -> Data -> Bool
getBoolWithDefault key =
    get True "getBoolWithDefault" key Json.asBool


getIntWithDefault : String -> Int -> Data -> Int
getIntWithDefault key =
    get True "getIntWithDefault" key Json.asInt


getFloatWithDefault : String -> Float -> Data -> Float
getFloatWithDefault key =
    get True "getFloatWithDefault" key Json.asFloat


getStringWithDefault : String -> String -> Data -> String
getStringWithDefault key =
    get True "getStringWithDefault" key Json.asString


getValueWithDefault : String -> Value -> Data -> Value
getValueWithDefault key =
    get True "getValueWithDefault" key identity


updateData : Data -> WithData m -> WithData m
updateData data model =
    { model
    | data = data
    }


setData : String -> Value -> WithData m -> WithData m
setData key val model =
    let
        new_data = model.data
            |> Dict.insert key val
        _ = debug5 "Data.setData" model (toValue model.data) "->" (toValue new_data)
    in
        model
            |> updateData new_data

