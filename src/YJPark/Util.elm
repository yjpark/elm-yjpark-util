module YJPark.Util exposing
    ( Guid, now_time, new_guid
    , log, log1, log2, log3, log4, log5, log6
    , error, error1, error2, error3, error4, error5, error6
    , addCmd, updateModel, noOperation
    , toCmd, toFutureCmd
    , insertCmd, insertMapCmd
    , noReaction, Updater, Wrapper, wrap
    , (===), (/==))

import Native.YJPark.Util
import Native.YJPark.Guid

import Update.Extra

import Updater

import Task
import Time
import Process


log1 = Native.Util.log1
log2 = Native.Util.log2
log3 = Native.Util.log3
log4 = Native.Util.log4
log5 = Native.Util.log5
log6 = Native.Util.log6


log str a =
    let
        _ = log2 str a
    in
        a


error1 = Native.Util.error1
error2 = Native.Util.error2
error3 = Native.Util.error3
error4 = Native.Util.error4
error5 = Native.Util.error5
error6 = Native.Util.error6


error str a =
    let
        _ = error2 str a
    in
        a


addCmd = Update.Extra.addCmd
updateModel = Update.Extra.updateModel


insertCmd : Cmd msg -> List (Cmd msg) -> List (Cmd msg)
insertCmd cmd cmds =
    if cmd == Cmd.none then
        cmds
    else
        cmd :: cmds


insertMapCmd : (msg1 -> msg2) -> Cmd msg1 -> List (Cmd msg2) -> List (Cmd msg2)
insertMapCmd map cmd cmds =
    if cmd == Cmd.none then
        cmds
    else
        (Cmd.map map cmd) :: cmds


noOperation : (model, Cmd msg) -> (model, Cmd msg)
noOperation (model, cmd) = (model, cmd)


toCmd = Updater.toCmd
noReaction = Updater.noReaction
type alias Updater model msg = Updater.Updater model msg
type alias Wrapper msg targetMsg = Updater.Converter msg targetMsg

wrap = Updater.converter


toFutureCmd : Time.Time -> msg -> Cmd msg
toFutureCmd delay_seconds msg =
    Process.sleep (delay_seconds * Time.second)
        |> Task.andThen (\_ -> Task.succeed msg)
    |> Task.perform identity


type alias Guid = String

-- This is a bit tricky, must declare as function here, and calling with ()
-- not sure there is a better approach or not.
now_time : () -> Time.Time
now_time =
    Native.Util.now_time


new_guid : () -> Guid
new_guid =
    Native.Guid.new_guid


(===) : a -> a -> Bool
(===) =
    Native.Util.strict_equal

(/==) : a -> a -> Bool
(/==) =
    Native.Util.strict_equal
