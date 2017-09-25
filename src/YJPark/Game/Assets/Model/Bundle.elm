module YJPark.Game.Assets.Model.Bundle exposing (..)

import YJPark.Util exposing (..)

import WebGL.Texture as Texture exposing (Texture)

import Dict exposing (Dict)
import Task


type AssetMeta
    = Texture Int


type AssetError
    = TextureError Int Texture.Error


type alias Type =
    { failed : Dict String AssetError
    , loaded : Dict String AssetMeta
    , loading : Dict String AssetMeta
    , total_size : Int
    , left_size : Int
    }


init : List (String, Int) -> Type
init textures =
    let
        loading = textures
            |> List.map (\(path, size) -> (path, (Texture size)))
            |> Dict.fromList
    in
        { failed = Dict.empty
        , loaded = Dict.empty
        , loading = loading
        , total_size = 0
        , left_size = 0
        } |> calcSizes


onTextureSucceed : String -> Type -> Type
onTextureSucceed path model =
    case Dict.get path model.loading of
        Nothing ->
            let _ = error3 "onTextureSucceed Failed: meta not found" path model in
            model
        Just meta ->
            let
                loading = model.loading
                    |> Dict.remove path
                loaded = model.loaded
                    |> Dict.insert path meta
            in
                { model
                | loading = loading
                , loaded = loaded
                }


onTextureFailed : String -> Texture.Error -> Type -> Type
onTextureFailed path err model =
    case Dict.get path model.loading of
        Nothing ->
            let _ = error4 "onTextureFailed Failed: meta not found" path err model in
            model
        Just meta ->
            let
                loading = model.loading
                    |> Dict.remove path
                failed = model.failed
                    |> Dict.insert path (TextureError (calcAssetSize meta) err)
            in
                { model
                | loading = loading
                , failed = failed
                }


getProgress : Type -> Float
getProgress model =
    case model.total_size <= 0 of
        True ->
            1
        False ->
            (toFloat (model.total_size - model.left_size)) / (toFloat model.total_size)


isLoading : Type -> Bool
isLoading model =
    not (Dict.isEmpty model.loading)


isFailed : Type -> Bool
isFailed model =
    not (Dict.isEmpty model.failed)


isLoadingOrFailed : Type -> Bool
isLoadingOrFailed model =
    (isLoading model) || (isFailed model)


calcAssetSize : AssetMeta -> Int
calcAssetSize meta =
    case meta of
        Texture size ->
            size


calcDictSize : Dict String AssetMeta -> Int
calcDictSize dict =
    dict
        |> Dict.values
        |> List.map calcAssetSize
        |> List.sum



calcSizes : Type -> Type
calcSizes model =
    let
        left_size = calcDictSize model.loading
        loaded_size = calcDictSize model.loaded
    in
        { model
        | total_size = loaded_size + left_size
        , left_size = left_size
        }
