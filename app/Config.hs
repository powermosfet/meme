module Config where

import Network.MQTT.Topic (Filter, mkFilter)
import Network.URI (URI, parseURI, nullURI)
import qualified Data.Text
import qualified System.Environment as Env
import qualified System.Posix.Env.ByteString as BSEnv

data Config = Config
  { dbConnectionString :: ByteString
  , mqttUri :: URI
  , mqttTopic :: Filter
  }

create :: IO Config
create = do
  Config <$>
    (fromMaybe "" <$> BSEnv.getEnv "DB_CONNECTION_STRING") <*>
    (fromMaybe nullURI . parseURI <$> Env.getEnv "MQTT_URI") <*>
    (fromMaybe "#" . mkFilter . Data.Text.pack <$> Env.getEnv "MQTT_TOPIC")


  
