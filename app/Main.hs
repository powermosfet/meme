module Main where

import Network.URI (parseURI)
import Network.MQTT.Client
import qualified Config
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.Time

data Event = Event
  { eventId :: Int
  , eventTimestamp :: LocalTimestamp
  , eventCategory :: Text
  , eventName :: Text
  , eventPayload :: Text
  }
  deriving (Show)

main :: IO ()
main = do
  config <- Config.create
  mc <- connectURI mqttConfig{_msgCB=SimpleCallback msgReceived} (Config.mqttUri config)
  conn <- connectPostgreSQL ""
  [(rowId, rowTimestamp, rowCategory, rowEvent, rowPayload)] <- query_ conn "SELECT * FROM event LIMIT 1"
  let event = Event rowId rowTimestamp rowCategory rowEvent rowPayload
  print event
  print =<< subscribe mc [("event/+/+", subOptions)] []
  waitForClient mc   -- wait for the the client to disconnect

  where
    msgReceived _ t m p = print (t,m,p)

