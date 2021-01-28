{-# LANGUAGE GADTs #-}

{-@ LIQUID "--reflection"  @-}
{-@ LIQUID "--ple"         @-}
{-@ LIQUID "--short-names" @-}

module PrimitivesDenotationsAnd where

import Prelude hiding (max)
import Language.Haskell.Liquid.ProofCombinators hiding (withProof)
import qualified Data.Set as S

import Basics
import Semantics
import SystemFWellFormedness
import SystemFTyping
import WellFormedness
import BasicPropsSubstitution
import BasicPropsEnvironments
import BasicPropsWellFormedness
import SystemFLemmasWellFormedness
import SystemFLemmasFTyping
import SystemFLemmasSubstitution
import Typing
import BasicPropsCSubst
import BasicPropsDenotes
import PrimitivesSemantics

{-@ reflect foo51 @-}
foo51 x = Just x
foo51 :: a -> Maybe a
 
{-@ lem_den_and :: ProofOf(Denotes (ty And) (Prim And)) @-}
lem_den_and :: Denotes
lem_den_and = DFunc 1 (TRefn TBool Z (Bc True)) t' (Prim And) (FTPrm FEmpty And) val_den_func
  where
    {-@ val_den_func :: v_x:Value -> ProofOf(Denotes (TRefn TBool Z (Bc True)) v_x) 
                                  -> ProofOf(ValueDenoted (App (Prim And) v_x) (tsubBV 1 v_x t')) @-}
    val_den_func :: Expr -> Denotes -> ValueDenoted
    val_den_func v_x den_tx_vx = case v_x of 
      (Bc True)  -> ValDen (App (Prim And) (Bc True)) (tsubBV 1 (Bc True) t') (Lambda 1 (BV 1)) 
                      (lem_step_evals (App (Prim And) (Bc True)) (Lambda 1 (BV 1)) 
                                      (EPrim And (Bc True))) den_t't_id
      (Bc False) -> ValDen (App (Prim And) (Bc False)) (tsubBV 1 (Bc False) t') (Lambda 1 (Bc False)) 
                      (lem_step_evals (App (Prim And) (Bc False)) (Lambda 1 (Bc False)) 
                                      (EPrim And (Bc False))) den_t'f_lamff
      _     -> impossible ("by lemma" ? lem_den_bools v_x (TRefn TBool Z (Bc True)) den_tx_vx)
    t' = ty' And
--    t' = TFunc 2 (TRefn TBool Z (Bc True)) (TRefn TBool Z (App (App (Prim Eqv) (BV 0)) 
--                                                               (App (App (Prim And) (BV 1)) (BV 2)) ))

{-@ den_t't_id :: ProofOf(Denotes (tsubBV 1 (Bc True) (ty' And)) (Lambda 1 (BV 1))) @-}
den_t't_id :: Denotes
den_t't_id = DFunc 2 (TRefn TBool Z (Bc True)) t't (Lambda 1 (BV 1)) 
                   (FTAbs FEmpty 1 (FTBasic TBool) Base (WFFTBasic FEmpty TBool) (BV 1) 
                          (FTBasic TBool) 1 (FTVar1 FEmpty 1 (FTBasic TBool))) val_den_func2
  where
    --t't = TRefn TBool Z (App (App (Prim Eqv) (BV 0)) (App (App (Prim And) (Bc True)) (BV 2)) )
    {-@ val_den_func2 :: v_x:Value -> ProofOf(Denotes (TRefn TBool Z (Bc True)) v_x)
                                   -> ProofOf(ValueDenoted (App (Lambda 1 (BV 1)) v_x) (tsubBV 2 v_x t't)) @-}
    val_den_func2 :: Expr -> Denotes -> ValueDenoted
    val_den_func2 v_x den_tx_vx = case v_x of 
      (Bc True)  -> ValDen (App (Lambda 1 (BV 1)) (Bc True)) (tsubBV 2 (Bc True) t't) (Bc True)
                      (lem_step_evals (App (Lambda 1 (BV 1)) (Bc True)) (Bc True) 
                                      (EAppAbs 1 (BV 1) (Bc True))) den_t''t_tt
      (Bc False) -> ValDen (App (Lambda 1 (BV 1)) (Bc False)) (tsubBV 2 (Bc False) t't) (Bc False)
                      (lem_step_evals (App (Lambda 1 (BV 1)) (Bc False)) (Bc False) 
                                      (EAppAbs 1 (BV 1) (Bc False))) den_t''f_ff
      _          -> impossible ("by lemma" ? lem_den_bools v_x (TRefn TBool Z (Bc True)) den_tx_vx)
    t't = tsubBV 1 (Bc True) (TRefn TBool Z (refn_pred And))
--    t''t = TRefn TBool Z (App (App (Prim Eqv) (BV 0)) (App (App (Prim And) (Bc True)) (Bc True)) )
--    t''f = TRefn TBool Z (App (App (Prim Eqv) (BV 0)) (App (App (Prim And) (Bc True)) (Bc False)) )
    den_t''t_tt = DRefn TBool Z p''t --(App (App (Prim Eqv) (BV 0)) (App (App (Prim And) (Bc True)) (Bc True)) )
                        (Bc True) (FTBC FEmpty True) ev_prt''t_tt
    {- @ ev_prt''t_tt :: ProofOf(EvalsTo (App (App (Prim Eqv) (Bc True)) (App (App (Prim And) (Bc True)) (Bc True))) (Bc True)) @-}
    {-@ ev_prt''t_tt :: ProofOf(EvalsTo (subBV 0 (Bc True) p''t) (Bc True)) @-}
    ev_prt''t_tt = reduce_and_tt True True
    den_t''f_ff = DRefn TBool Z p''f --(App (App (Prim Eqv) (BV 0)) (App (App (Prim And) (Bc True)) (Bc False)) )
                        (Bc False) (FTBC FEmpty False) ev_prt''f_ff
    {- @ ev_prt''f_ff :: ProofOf(EvalsTo (App (App (Prim Eqv) (Bc False)) (App (App (Prim And) (Bc True)) (Bc False))) (Bc True)) @-}
    {-@ ev_prt''f_ff :: ProofOf(EvalsTo (subBV 0 (Bc False) p''f) (Bc True)) @-}
    ev_prt''f_ff = reduce_and_tt True False
    p''t = subBV 2 (Bc True)  (subBV 1 (Bc True) (refn_pred And))
    p''f = subBV 2 (Bc False) (subBV 1 (Bc True) (refn_pred And))

{-@ den_t'f_lamff :: ProofOf(Denotes (tsubBV 1 (Bc False) (ty' And)) (Lambda 1 (Bc False))) @-}
den_t'f_lamff :: Denotes
den_t'f_lamff = DFunc 2 (TRefn TBool Z (Bc True)) t'f (Lambda 1 (Bc False))
                      (FTAbs FEmpty 1 (FTBasic TBool) Base (WFFTBasic FEmpty TBool) (Bc False) 
                             (FTBasic TBool) 1 (FTBC (FCons 1 (FTBasic TBool) FEmpty) False)) 
                      val_den_func3
  where
    {-@ val_den_func3 :: v_x:Value -> ProofOf(Denotes (TRefn TBool Z (Bc True)) v_x)
                                   -> ProofOf(ValueDenoted (App (Lambda 1 (Bc False)) v_x) (tsubBV 2 v_x t'f)) @-}
    val_den_func3 :: Expr -> Denotes -> ValueDenoted
    val_den_func3 v_x den_tx_vx = case v_x of
      (Bc True)  -> ValDen (App (Lambda 1 (Bc False)) (Bc True)) (tsubBV 2 (Bc True) t'f) (Bc False)
                      (lem_step_evals (App (Lambda 1 (Bc False)) (Bc True)) (Bc False) 
                                      (EAppAbs 1 (Bc False) (Bc True))) den_t'''t_ff
      (Bc False) -> ValDen (App (Lambda 1 (Bc False)) (Bc False)) (tsubBV 2 (Bc False) t'f) (Bc False)
                      (lem_step_evals (App (Lambda 1 (Bc False)) (Bc False)) (Bc False) 
                                      (EAppAbs 1 (Bc False) (Bc False))) den_t'''f_ff
      _          -> impossible ("by lemma" ? lem_den_bools v_x (TRefn TBool Z (Bc True)) den_tx_vx)
    t'f = tsubBV 1 (Bc False) (TRefn TBool Z (refn_pred And))
--    t'''t = TRefn TBool Z (App (App (Prim Eqv) (BV 0)) (App (App (Prim And) (Bc False)) (Bc True)) )
--    t'''f = TRefn TBool Z (App (App (Prim Eqv) (BV 0)) (App (App (Prim And) (Bc False)) (Bc False)) )
    den_t'''t_ff = DRefn TBool Z p'''t --(App (App (Prim Eqv) (BV 0)) (App (App (Prim And) (Bc False)) (Bc True)) )
                         (Bc False) (FTBC FEmpty False) ev_prt'''t_ff
    {-@ ev_prt'''t_ff :: ProofOf(EvalsTo (subBV 0 (Bc False) p'''t) (Bc True)) @-}
    ev_prt'''t_ff = reduce_and_tt False True
    den_t'''f_ff = DRefn TBool Z p'''f --(App (App (Prim Eqv) (BV 0)) (App (App (Prim And) (Bc False)) (Bc False)) )
                         (Bc False) (FTBC FEmpty False) ev_prt'''f_ff
    {-@ ev_prt'''f_ff :: ProofOf(EvalsTo (subBV 0 (Bc False) p'''f) (Bc True)) @-}
    ev_prt'''f_ff = reduce_and_tt False False
    p'''t = subBV 2 (Bc True)  (subBV 1 (Bc False) (refn_pred And))
    p'''f = subBV 2 (Bc False) (subBV 1 (Bc False) (refn_pred And))
