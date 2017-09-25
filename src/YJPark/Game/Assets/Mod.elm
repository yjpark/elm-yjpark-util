module YJPark.Game.Assets.Mod exposing (..)

import YJPark.Game.Assets.Model.Mod as Model
import YJPark.Game.Assets.Model.Bundle as Bundle

import YJPark.Util exposing (..)

import WebGL.Texture as Texture exposing (Texture)

import Dict exposing (Dict)
import Task


type alias Asset = Model.Asset
type alias Bundle = Bundle.Type
type alias Model = Model.Type


type InMsg
    = DoLoad Bundle


type OutMsg
    = OnLoadSucceed
    | OnLoadFailed


type Msg
    = In InMsg
    | Out OutMsg
    | OnTexture String (Result Texture.Error Texture)


getTexture = Model.getTexture


getDoneCmds : Bundle -> List (Cmd Msg)
getDoneCmds bundle =
    case Dict.isEmpty bundle.loading of
        True ->
            let
                result = case Dict.isEmpty bundle.failed of
                    True ->
                        OnLoadSucceed
                    False ->
                        OnLoadFailed
            in
                [ toCmd <| Out result
                ]
        False ->
            []


getLoadCmd : Model -> (String, Bundle.AssetMeta) -> Cmd Msg
getLoadCmd model (path, meta) =
    let
        url = model.base_url ++ path
    in
        case meta of
            Bundle.Texture _ ->
                Task.attempt (OnTexture path) (Texture.load url)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        In (DoLoad bundle) ->
            let
                cmds = bundle.loading
                    |> Dict.toList
                    |> List.map (getLoadCmd model)
            in
                {model | bundle = bundle} ! cmds
        Out _ ->
            model ! []
        OnTexture path (Ok texture) ->
            let
                --_ = error3 "OnTexture OK" path texture
                assets = model.assets
                    |> Dict.insert path (Model.Texture texture)
                bundle = model.bundle
                    |> Bundle.onTextureSucceed path
                cmds = getDoneCmds model.bundle
            in
                { model
                | assets = assets
                , bundle = bundle
                } ! cmds
        OnTexture path (Err err) ->
            let
                _ = error3 "OnTexture Err" path err
                bundle = model.bundle
                    |> Bundle.onTextureFailed path err
                cmds = getDoneCmds model.bundle
            in
                { model
                | bundle = bundle
                } ! cmds
