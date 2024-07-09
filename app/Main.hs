module Main where

import qualified Config
import qualified Meme.Database
import qualified Meme.Mqtt
import qualified Network.MQTT.Client

main :: IO ()
main = do
  config <- Config.create
  db <- Meme.Database.connect config
  mqtt <- Meme.Mqtt.connect config db
  _ <- Meme.Mqtt.subscribe config mqtt
  Network.MQTT.Client.waitForClient mqtt
