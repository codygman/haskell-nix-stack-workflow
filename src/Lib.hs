{-# LANGUAGE TypeApplications #-}
module Lib
  ( someFunc
  ) where

import           Data.ByteString               as BS
import           Witch

someFunc :: IO ()
someFunc = do
  -- Try using something from witch 0.3.3.0
  print $ tryFrom @String @ByteString "foo"
