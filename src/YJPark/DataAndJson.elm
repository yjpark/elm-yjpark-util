module YJPark.DataAndJson exposing (..)

import YJPark.Util exposing (..)
import YJPark.Data as Data
import YJPark.Json as Json

import Json.Decode as Decode
import Json.Encode as Encode
import Dict


type alias Data = Data.Data
type alias Value = Json.Value
null = Json.null


type alias Type m =
    { m
    | data : Data
    , json : Value
    }


decode : (Value -> val) -> Decode.Decoder val
decode convertor =
    Decode.value
        |> Decode.map convertor


get : Bool -> String -> String -> (Value -> val) -> val -> Type m -> val
get isDebug msg key convertor default model =
    case Dict.get key model.data of
        Nothing ->
            Json.decode isDebug msg (Decode.field key (decode convertor)) default model.json
        Just val ->
            convertor val


getBool : String -> Type m -> Bool
getBool key =
    get False "getBool" key Json.asBool False


getInt : String -> Type m -> Int
getInt key =
    get False "getInt" key Json.asInt 0


getFloat : String -> Type m -> Float
getFloat key =
    get False "getFloat" key Json.asFloat 0


getString : String -> Type m -> String
getString key =
    get False "getString" key Json.asString ""


getValue : String -> Type m -> Value
getValue key =
    get False "getValue" key identity null


getBoolWithDefault : String -> Bool -> Type m -> Bool
getBoolWithDefault key =
    get True "getBoolWithDefault" key Json.asBool


getIntWithDefault : String -> Int -> Type m -> Int
getIntWithDefault key =
    get True "getIntWithDefault" key Json.asInt


getFloatWithDefault : String -> Float -> Type m -> Float
getFloatWithDefault key =
    get True "getFloatWithDefault" key Json.asFloat


getStringWithDefault : String -> String -> Type m -> String
getStringWithDefault key =
    get True "getStringWithDefault" key Json.asString


getValueWithDefault : String -> Value -> Type m -> Value
getValueWithDefault key =
    get True "getValueWithDefault" key identity
