module Config where

import Network.URI (URI, parseURI, nullURI)
import Data.Maybe (fromMaybe)
import qualified System.Posix.Env.ByteString as BSEnv
import qualified System.Environment as Env

data Config = Config
  { dbConnectionString :: ByteString
  , mqttUri :: URI
  }

create :: IO (Config)
create = do
  Config <$>
    (fromMaybe "" <$> BSEnv.getEnv "DB_CONNECTION_STRING") <*>
    (fromMaybe nullURI . parseURI <$> Env.getEnv "MQTT_URI")
