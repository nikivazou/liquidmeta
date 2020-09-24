{-# LANGUAGE GADTs #-}

{-@ LIQUID "--reflection"  @-}
{-@ LIQUID "--ple"         @-}
{-@ LIQUID "--short-names" @-}

module PrimitivesWFTypeAnd where

import Prelude hiding (max)
import Language.Haskell.Liquid.ProofCombinators hiding (withProof)
import qualified Data.Set as S

import Basics
import Semantics
import SystemFWellFormedness
import SystemFTyping
import WellFormedness

{-@ reflect foo07 @-}
foo07 :: a -> Maybe a
foo07 x = Just x

-----------------------------------------------------------------------------
-- | Properties of BUILT-IN PRIMITIVES
-----------------------------------------------------------------------------

{-@ lem_wf_intype_and :: () -> { pf:_ | noDefnsInRefns Empty (inType And) && isWellFormed Empty (inType And) Base } @-}
lem_wf_intype_and :: () -> Proof
lem_wf_intype_and _ = ()

{-@ lem_wf_ty'_and :: () -> { pf:_ | noDefnsInRefns (Cons (firstBV And) (inType And) Empty) 
                                              (unbindT (firstBV And) (firstBV And) (ty' And))
                                 && isWellFormed (Cons (firstBV And) (inType And) Empty) 
                                                 (unbindT (firstBV And) (firstBV And) (ty' And)) Star } @-}
lem_wf_ty'_and :: () -> Proof
lem_wf_ty'_and _ = ()

{-@ lem_wf_ty_and :: () -> { pf:_ | noDefnsInRefns Empty (ty And) && isWellFormed Empty (ty And) Star } @-}
lem_wf_ty_and :: () -> Proof
lem_wf_ty_and _ = () ? lem_wf_intype_and () ? lem_wf_ty'_and ()
