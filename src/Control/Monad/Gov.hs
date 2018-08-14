{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Control.Monad.Gov where

import Control.Monad.State
import Control.Monad.Reader
import Control.Monad.Writer

newtype GovT s m a = GovT { unGovT :: StateT s m a }
    deriving (Functor, Applicative, Monad, MonadState s, MonadTrans)

runGovT :: GovT s m a -> s -> m (a, s)
runGovT = runStateT . unGovT

instance (Monad m, Monoid s) => MonadWriter s (GovT s m) where
    tell = GovT . modify . mappend
    listen action = GovT $ StateT $ \s -> do
        (a, s') <- runGovT action s
        pure ((a, s'), s)
    pass action = GovT $ do
        s <- get
        (a, f) <- unGovT action
        modify f
        pure a

instance Monad m => MonadReader r (GovT r m) where
    ask = GovT get
    local f action = GovT $ StateT $ \s -> do
        (a, _) <- runGovT action (f s)
        pure (a, s)
