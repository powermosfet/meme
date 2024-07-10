module Meme.Database where

import Config (Config)
import qualified Config
import Database.PostgreSQL.Simple (Connection, connectPostgreSQL, execute)
import qualified Meme.Event

connect :: Config -> IO Connection
connect config =
  connectPostgreSQL (Config.dbConnectionString config)

insert :: Connection -> Meme.Event.Event -> IO ()
insert db event = do
  _ <-
    execute
      db
      "INSERT INTO event (category, event, payload) VALUES (?, ?, ?)"
      ( Meme.Event.category event,
        Meme.Event.event event,
        Meme.Event.payload event
      )
  return ()
