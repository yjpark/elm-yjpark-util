module YJPark.Json exposing (..)

import YJPark.Util exposing (..)

import Json.Decode as Decode
import Json.Encode as Encode
import Dict


type alias Value = Encode.Value
null = Encode.null


boolToValue : Bool -> Value
boolToValue val =
    Encode.bool val


intToValue : Int -> Value
intToValue val =
    Encode.int val


floatToValue : Float -> Value
floatToValue val =
    Encode.float val


stringToValue : String -> Value
stringToValue str =
    Encode.string str


listToValue : List Value -> Value
listToValue list =
    list
        |> Encode.list


decode : Bool -> String -> Decode.Decoder val -> val -> Value -> val
decode isDebug msg decoder default val =
    case (Decode.decodeValue decoder val) of
        Ok val ->
            val
        Err err ->
            let
                _ = case isDebug of
                    True ->
                        debug5 "[Json] Decode Failed:" msg val err default
                    False ->
                        error5 "[Json] Decode Failed:" msg val err default
            in
                default


asBool : Value -> Bool
asBool =
    decode False "asBool" Decode.bool False


asInt : Value -> Int
asInt =
    decode False "asInt" Decode.int 0


asFloat : Value -> Float
asFloat =
    decode False "asFloat" Decode.float 0


asString : Value -> String
asString =
    decode False "asString" Decode.string ""


asBoolWithDefault : Bool -> Value -> Bool
asBoolWithDefault =
    decode True "asBoolWithDefault" Decode.bool


asIntWithDefault : Int -> Value -> Int
asIntWithDefault =
    decode True "asBoolWithDefault" Decode.int


asFloatWithDefault : Float -> Value -> Float
asFloatWithDefault =
    decode True "asBoolWithDefault" Decode.float


asStringWithDefault : String -> Value -> String
asStringWithDefault =
    decode True "asBoolWithDefault" Decode.string


getBool : String -> Value -> Bool
getBool key =
    decode False "getBool" (Decode.field key Decode.bool) False


getInt : String -> Value -> Int
getInt key =
    decode False "getInt" (Decode.field key Decode.int) 0


getFloat : String -> Value -> Float
getFloat key =
    decode False "getFloat" (Decode.field key Decode.float) 0


getString : String -> Value -> String
getString key =
    decode False "getString" (Decode.field key Decode.string) ""


getValue : String -> Value -> Value
getValue key =
    decode False "getValue" (Decode.field key Decode.value) null


getBoolWithDefault : String -> Bool -> Value -> Bool
getBoolWithDefault key =
    decode True "getBoolWithDefault" (Decode.field key Decode.bool)


getIntWithDefault : String -> Int -> Value -> Int
getIntWithDefault key =
    decode True "getIntWithDefault" (Decode.field key Decode.int)


getFloatWithDefault : String -> Float -> Value -> Float
getFloatWithDefault key =
    decode True "getFloatWithDefault" (Decode.field key Decode.float)


getStringWithDefault : String -> String -> Value -> String
getStringWithDefault key =
    decode True "getStringWithDefault" (Decode.field key Decode.string)


getValueWithDefault : String -> Value -> Value -> Value
getValueWithDefault key =
    decode True "getValueWithDefault" (Decode.field key Decode.value)


