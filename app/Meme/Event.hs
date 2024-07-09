module Meme.Event where

import Data.Aeson (Value, decode)
import qualified Data.ByteString.Lazy

data Event = Event
  { category :: Text
  , event :: Text
  , payload :: Value 
  }
  deriving (Show)

decodePayload :: Data.ByteString.Lazy.ByteString -> Maybe Value
decodePayload = decode
