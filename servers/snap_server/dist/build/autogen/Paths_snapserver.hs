module Paths_snapserver (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch

version :: Version
version = Version [0,1] []
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/agilestyle/.cabal/bin"
libdir     = "/Users/agilestyle/.cabal/lib/x86_64-osx-ghc-7.10.3/snapserver-0.1-Arot7ABaWeUCwQ0oWMDPak"
datadir    = "/Users/agilestyle/.cabal/share/x86_64-osx-ghc-7.10.3/snapserver-0.1"
libexecdir = "/Users/agilestyle/.cabal/libexec"
sysconfdir = "/Users/agilestyle/.cabal/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "snapserver_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "snapserver_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "snapserver_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "snapserver_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "snapserver_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
