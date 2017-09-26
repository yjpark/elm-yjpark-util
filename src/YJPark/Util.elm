module YJPark.Util exposing
    ( Guid, now_time, new_guid
    , info1, info2, info3, info4, info5, info6
    , error1, error2, error3, error4, error5, error6
    , debug1, debug2, debug3, debug4, debug5, debug6
    , addCmd, updateModel, noOperation
    , toCmd, toFutureCmd
    , updateObj, addMsg
    , insertCmd, insertMapCmd
    , noReaction, Updater, Wrapper, wrap
    , (===), (/==))

import Native.Util
import Native.Guid

import Update.Extra

import Updater

import Task
import Time
import Process


info1 : a -> String
info1 = Native.Util.info1
info2 : a -> b -> String
info2 = Native.Util.info2
info3 : a -> b -> c -> String
info3 = Native.Util.info3
info4 : a -> b -> c -> d -> String
info4 = Native.Util.info4
info5 : a -> b -> c -> d -> e -> String
info5 = Native.Util.info5
info6 : a -> b -> c -> d -> e -> f -> String
info6 = Native.Util.info6


error1 : a -> String
error1 = Native.Util.error1
error2 : a -> b -> String
error2 = Native.Util.error2
error3 : a -> b -> c -> String
error3 = Native.Util.error3
error4 : a -> b -> c -> d -> String
error4 = Native.Util.error4
error5 : a -> b -> c -> d -> e -> String
error5 = Native.Util.error5
error6 : a -> b -> c -> d -> e -> f -> String
error6 = Native.Util.error6


debug1 : a -> String
debug1 = Native.Util.debug1
debug2 : a -> b -> String
debug2 = Native.Util.debug2
debug3 : a -> b -> c -> String
debug3 = Native.Util.debug3
debug4 : a -> b -> c -> d -> String
debug4 = Native.Util.debug4
debug5 : a -> b -> c -> d -> e -> String
debug5 = Native.Util.debug5
debug6 : a -> b -> c -> d -> e -> f -> String
debug6 = Native.Util.debug6


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


updateObj : (obj -> obj) -> (obj, List msg) -> (obj, List msg)
updateObj updater (obj, msgs) =
    (updater obj, msgs)


addMsg : msg -> (obj, List msg) -> (obj, List msg)
addMsg msg (obj, msgs) =
    (obj, msg :: msgs)


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
