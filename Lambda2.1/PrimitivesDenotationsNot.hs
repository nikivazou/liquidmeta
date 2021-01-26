{-# LANGUAGE GADTs #-}

{-@ LIQUID "--reflection"  @-}
{-@ LIQUID "--ple"         @-}
{-@ LIQUID "--short-names" @-}

module PrimitivesDenotationsNot where

import Prelude hiding (max)
import Language.Haskell.Liquid.ProofCombinators hiding (withProof)
import qualified Data.Set as S

import Basics
import Semantics
import SystemFWellFormedness
import SystemFTyping
import WellFormedness
import PrimitivesFTyping
import BasicPropsSubstitution
import BasicPropsEnvironments
import BasicPropsWellFormedness
import SystemFLemmasWellFormedness
import SystemFLemmasFTyping
import SystemFLemmasSubstitution
import Typing
import Entailments
import BasicPropsCSubst
import BasicPropsDenotes
import PrimitivesSemantics

{-@ reflect foo53 @-}
foo53 x = Just x
foo53 :: a -> Maybe a

{-@ lem_den_not :: ProofOf(Denotes (ty Not) (Prim Not)) @-}
lem_den_not :: Denotes
lem_den_not = DFunc 2 (TRefn TBool Z (Bc True)) t'
                    (Prim Not) (FTPrm FEmpty Not) val_den_func
  where
    val_den_func :: Expr -> Denotes -> ValueDenoted
    val_den_func v_x den_tx_vx = case v_x of 
      (Bc True)  -> ValDen (App (Prim Not) (Bc True)) (tsubBV 2 (Bc True) t') (Bc False) 
                      (lem_step_evals (App (Prim Not) (Bc True)) (Bc False) (EPrim Not (Bc True))) den_t't
      (Bc False) -> ValDen (App (Prim Not) (Bc False)) (tsubBV 2 (Bc False) t') (Bc True) 
                      (lem_step_evals (App (Prim Not) (Bc False)) (Bc True) (EPrim Not (Bc False))) den_t'f
      _     -> impossible ("by lemma" ? lem_den_bools v_x (TRefn TBool Z (Bc True)) den_tx_vx)
    t'  = TRefn TBool Z (App (App (Prim Eqv) (BV 0)) (App (Prim Not) (BV 2)))
    t't = TRefn TBool Z (App (App (Prim Eqv) (BV 0)) (App (Prim Not) (Bc True)) )
    t'f = TRefn TBool Z (App (App (Prim Eqv) (BV 0)) (App (Prim Not) (Bc False)) )
    den_t't = DRefn TBool Z (App (App (Prim Eqv) (BV 0)) (App (Prim Not) (Bc True)) )
                        (Bc False) (FTBC FEmpty False) ev_prt't
    {-@ ev_prt't :: ProofOf(EvalsTo (App (App (Prim Eqv) (Bc False)) (App (Prim Not) (Bc True)) ) (Bc True)) @-}
    ev_prt't = reduce_not_tt True 
    den_t'f = DRefn TBool Z (App (App (Prim Eqv) (BV 0)) (App (Prim Not) (Bc False)) )
                        (Bc True) (FTBC FEmpty True) ev_prt'f 
    {-@ ev_prt'f :: ProofOf(EvalsTo (App (App (Prim Eqv) (Bc True)) (App (Prim Not) (Bc False)) ) (Bc True)) @-}
    ev_prt'f = reduce_not_tt False
