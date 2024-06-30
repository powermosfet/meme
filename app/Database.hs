module Database where 

import qualified Config

connect :: IO Connection
connect config =
  connectPostgreSQL (Config.dbConnectionString config)

