module Meme.Mqtt where

import Control.Monad.Extra (discard)
import Network.MQTT.Client (MQTTClient, MessageCallback(..), mqttConfig, subscribe, subOptions, _msgCB, connectURI)
import qualified Config
import qualified Data.ByteString.Lazy
import qualified Data.Text
import qualified Database.PostgreSQL.Simple as DB
import qualified Meme.Database
import qualified Meme.Event
import qualified Network.MQTT.Topic

connect :: Config.Config -> DB.Connection -> IO MQTTClient
connect config db =
  connectURI mqttConfig{_msgCB=SimpleCallback (handleMessage db)} (Config.mqttUri config)

handleMessage :: DB.Connection -> a -> Network.MQTT.Topic.Topic -> Data.ByteString.Lazy.ByteString -> b -> IO ()
handleMessage db _ topic message _ =
  let
    (category, eventName) = splitTopic topic

    maybeEvent = message
      & Meme.Event.decodePayload
      & fmap (Meme.Event.Event category eventName)
  in
  forM_ maybeEvent (Meme.Database.insert db)

splitTopic :: Network.MQTT.Topic.Topic -> (Text, Text)
splitTopic topic =
  topic
    & Network.MQTT.Topic.unTopic
    & Data.Text.splitOn "/"
    & lastTwo

lastTwo :: [Text] -> (Text, Text)
lastTwo [a, b] = (a, b)
lastTwo (_:rest) = lastTwo rest
lastTwo _ = ("", "")

subscribe :: Config.Config -> MQTTClient -> IO ()
subscribe config mqtt =
  Network.MQTT.Client.subscribe mqtt [(Config.mqttTopic config, subOptions)] [] >>= discard
