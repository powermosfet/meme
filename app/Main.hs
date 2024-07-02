module Main where

import Network.URI (parseURI)
import Network.MQTT.Client
import qualified Config
import Database.PostgreSQL.Simple

main :: IO ()
main = do
  config <- Config.create
  mc <- connectURI mqttConfig{_msgCB=SimpleCallback msgReceived} (Config.mqttUri config)
  conn <- connectPostgreSQL ""
  [Only (eventId::Int, _, group::Text, event::Text, _)] <- query_ conn "SELECT * FROM event LIMIT 1"
  print (eventId, group, event)
  publish mc "tmp/topic" "hello!" False
  print =<< subscribe mc [("event/+/+", subOptions)] []
  waitForClient mc   -- wait for the the client to disconnect

  where
    msgReceived _ t m p = print (t,m,p)

