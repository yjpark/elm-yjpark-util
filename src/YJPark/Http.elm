module YJPark.Http exposing (..)

import YJPark.Util exposing (..)

import YJPark.Json as Json

import Json.Decode exposing (Decoder, decodeValue, value)
import Json.Encode exposing (Value)

import Http


type alias Request a = Http.Request a
type alias Error = Http.Error


logSucceed : Request a -> a -> a
logSucceed req res =
    let
        _ = info4 "[Http]" req "-> Succeed:" res
    in
        res


logFailed : Request a -> Error -> Error
logFailed req err =
    let
        _ = case err of
            Http.BadUrl url ->
                error4 "[Http]" req "-> Failed: BadUrl:" url
            Http.Timeout ->
                error3 "[Http]" req "-> Failed: Timeout"
            Http.NetworkError ->
                error3 "[Http]" req "-> Failed: NetworkError"
            Http.BadStatus res ->
                error4 "[Http]" req "-> Failed: BadStatus:" res
            Http.BadPayload err res ->
                error6 "[Http]" req "-> Failed: BadPayload:" err "Response:" res
    in
        err


onResponse : Request val -> Result Error val -> Result Error val
onResponse req res =
    res
        |> Result.map (logSucceed req)
        |> Result.mapError (logFailed req)


cmd : (Result Error val -> msg) -> Request val -> Cmd msg
cmd wrapper req =
    Http.send (onResponse req) req
        |> Cmd.map wrapper


get : (Result Error val -> msg) -> String -> Decoder val -> Cmd msg
get wrapper url decoder =
    Http.get url decoder
        |> cmd wrapper


getString : (Result Error String -> msg) -> String -> Cmd msg
getString wrapper url =
    Http.getString url
        |> cmd wrapper


post : (Result Error val -> msg) -> String -> Json.Value -> Decoder val -> Cmd msg
post wrapper url data decoder =
    Http.post url (Http.jsonBody data) decoder
        |> cmd wrapper
