{-# LANGUAGE GADTs #-}

{-@ LIQUID "--no-termination" @-} -- TODO assume
{-@ LIQUID "--no-totality" @-} -- TODO assume
{-@ LIQUID "--reflection"  @-}
{-@ LIQUID "--ple"         @-}
{-@ LIQUID "--short-names" @-}

module Primitives4 where

import Prelude hiding (max)
import Language.Haskell.Liquid.ProofCombinators hiding (withProof)
import qualified Data.Set as S

import Basics
import BasicProps
import STLCLemmas
import STLCSoundness
import Typing
import Entailments
import Primitives
-- import PrimitivesSemantics
--import Primitives3
import TechLemmas
import TechLemmas2
-- import DenotationalSoundness
-- import Substitution

-- force these into scope
semantics = (Step, EvalsTo)
typing = (HasBType, HasType, WFType, WFEnv, Subtype)
denotations = (Entails, Denotes, DenotesEnv, ValueDenoted) --, AugmentedCSubst)

{-@ reflect foo17 @-}
foo17 x = Just x
foo17 :: a -> Maybe a

-- Su   Mo  Su  
-- /-----------------------------------------------------------------\
-- ||===|===|===|===|   |   |   |   |   |   |   |   |   |   |   |   ||  Progress Meter 
-- \-----------------------------------------------------------------/

  -- Lemmas to explicitly characterize the possible closing substitutions of certain environments.

{-@ lem_den_env_bl :: th:CSubst -> ProofOf(DenotesEnv (Cons 1 (TRefn TBool 2 (Bc True)) Empty) th)
        -> { pf:_ | th == CCons 1 (Bc True) CEmpty || th == CCons 1 (Bc False) CEmpty } @-}
lem_den_env_bl :: CSubst -> DenotesEnv -> Proof
lem_den_env_bl th (DExt _ _ _ x t v den_tht_v) = case th of
  (CCons 1 v CEmpty) -> () ? lem_bool_values v pf_v_er_t 
    where
      pf_v_er_t = get_btyp_from_den (ctsubst th t) v den_tht_v ? lem_ctsubst_refn th TBool 2 (Bc True)

{-@ lem_den_env_blbl :: th:CSubst -> ProofOf(DenotesEnv (Cons 3 (TRefn TBool 3 (App (App (Prim Eqv) (BV 3)) (FV 1)))
                                                          (Cons 1 (TRefn TBool 2 (Bc True)) Empty)) th)
        -> { pf:_ | th == CCons 3 (Bc True)  (CCons 1 (Bc True)  CEmpty) ||
                    th == CCons 3 (Bc False) (CCons 1 (Bc False) CEmpty) } @-}
lem_den_env_blbl :: CSubst -> DenotesEnv -> Proof
lem_den_env_blbl = undefined
{-
lem_den_env_blbl th (DExt g' th' den_g'_th' _ _ v3 den_th't3_v3) = case den_th't3_v3 of 
  (DRefn _ _ _ _v3 pf_v_er_t3 ev_th'p3v3_tt) -> case th' of
    (CCons _ v2 CEmpty) -> case (v2 == v3) of 
      True  -> () ? lem_den_env_bl th' den_g'_th' -- bottom value is true or false
      False -> impossible ("by lemma" ? lem_evals_val_det th'p3v3 (Bc True)  ev_th'p3v3_tt 
                                                                  (Bc False) ev_th'p3v3_ff)
        where
          p3      = App (App (Prim Eqv) (BV 3)) (FV 1)
          th'p3v3 = subBV 3 v3 (csubst th' p3)
          (Bc b2) = v2 ? toProof ( ctsubst CEmpty t2 === TRefn TBool 2 (Bc True) )
                       ? toProof ( erase (ctsubst CEmpty t2) === BTBase TBool )
                       ? lem_bool_values v2 (get_btyp_from_den (TRefn TBool 2 (Bc True)) v2 den_t2_v2)
          (Bc b3) = v3 ? lem_bool_values v3 pf_v_er_t3
          (DExt _ th'' _ _ t2 _v2 den_t2_v2) = den_g'_th' 
                       ? toProof ( g' === Cons 1 (TRefn TBool 2 (Bc True)) Empty )
          ev_th'p3v3_1  = reduce_eqv b3 b2 
          ev_th'p3v3_ff = AddStep (App (App (Prim Eqv) v3) v2) (App (delta Eqv v3) v2)
                                  (EApp1 (App (Prim Eqv) v3) (delta Eqv v3) (EPrim Eqv v3) v2)
                                  (Bc (blIff b3 b2)) ev_th'p3v3_1
            ? toProof ( subBV 3 v3 (csubst th' (App (App (Prim Eqv) (BV 3)) (FV 1))) 
                      ? lem_csubst_app th' (App (Prim Eqv) (BV 3)) (FV 1)
                      ? lem_csubst_app th' (Prim Eqv) (BV 3)
                      ? lem_csubst_prim th' Eqv
                      ? lem_csubst_bv th' 3
                    === subBV 3 v3 (App (App (Prim Eqv) (BV 3)) (csubst th' (FV 1)))
                    === subBV 3 v3 (App (App (Prim Eqv) (BV 3)) (csubst CEmpty (subFV 1 v2 (FV 1))))
                    === subBV 3 v3 (App (App (Prim Eqv) (BV 3)) v2)
                    === (App (App (Prim Eqv) v3) v2) )
            ? toProof ( b3 === not b2 )
            ? toProof ( blIff b3 b2 === False )
-}

{-@ lem_den_env_ffbl :: th:CSubst 
        -> ProofOf(DenotesEnv (Cons 3 (TRefn TBool 1 (App (App (Prim Eqv) (BV 1)) (Bc False)))
                                                          (Cons 1 (TRefn TBool 2 (Bc True)) Empty)) th)
        -> { pf:_ | th == CCons 3 (Bc False) (CCons 1 (Bc True)  CEmpty) ||
                    th == CCons 3 (Bc False) (CCons 1 (Bc False) CEmpty) } @-}
lem_den_env_ffbl :: CSubst -> DenotesEnv -> Proof
--lem_den_env_ffbl = undefined
--{-
lem_den_env_ffbl th (DExt g' th' den_g'_th' _ _ v3 den_th't3_v3) = case den_th't3_v3 of 
  (DRefn _ _ _ _v3 pf_v_er_t3 ev_th'p3v3_tt) -> case th' of
    (CCons _ v2 CEmpty) -> case (v3 == False) of 
      True  -> () ? lem_den_env_bl th' den_g'_th' -- bottom value is true or false
      False -> impossible ("by lemma" ? lem_evals_val_det th'p3v3 (Bc True)  ev_th'p3v3_tt 
                                                                  (Bc False) ev_th'p3v3_ff)
        where
          p3      = App (App (Prim Eqv) (BV 1)) (Bc False)
          th'p3v3 = subBV 1 v3 (csubst th' p3)

          (Bc b2) = v2 ? toProof ( ctsubst CEmpty t2 === TRefn TBool 2 (Bc True) )
                       ? toProof ( erase (ctsubst CEmpty t2) === BTBase TBool )
                       ? lem_bool_values v2 (get_btyp_from_den (TRefn TBool 2 (Bc True)) v2 den_t2_v2)
          (Bc b3) = v3 ? lem_bool_values v3 pf_v_er_t3
          (DExt _ th'' _ _ t2 _v2 den_t2_v2) = den_g'_th' 
                       ? toProof ( g' === Cons 1 (TRefn TBool 2 (Bc True)) Empty )
          ev_th'p3v3_1  = reduce_eqv b3 b2 
          ev_th'p3v3_ff = AddStep (App (App (Prim Eqv) v3) v2) (App (delta Eqv v3) v2)
                                  (EApp1 (App (Prim Eqv) v3) (delta Eqv v3) (EPrim Eqv v3) v2)
                                  (Bc (blIff b3 b2)) ev_th'p3v3_1
            ? toProof ( subBV 3 v3 (csubst th' (App (App (Prim Eqv) (BV 3)) (FV 1))) 
                      ? lem_csubst_app th' (App (Prim Eqv) (BV 3)) (FV 1)
                      ? lem_csubst_app th' (Prim Eqv) (BV 3)
                      ? lem_csubst_prim th' Eqv
                      ? lem_csubst_bv th' 3
                    === subBV 3 v3 (App (App (Prim Eqv) (BV 3)) (csubst th' (FV 1)))
                    === subBV 3 v3 (App (App (Prim Eqv) (BV 3)) (csubst CEmpty (subFV 1 v2 (FV 1))))
                    === subBV 3 v3 (App (App (Prim Eqv) (BV 3)) v2)
                    === (App (App (Prim Eqv) v3) v2) )
            ? toProof ( b3 === not b2 )
            ? toProof ( blIff b3 b2 === False )
-}
-- ----------------------------- 16 Step Plan -------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------

-- for reference: ty And      = TFunc 1 (TRefn TBool 1 (Bc True))
--                   (TFunc 2 (TRefn TBool 2 (Bc True))                                                                                          (TRefn TBool 3                                                                                                              (App (App (Prim Eqv) (BV 3))
--                                (App (App (Prim And) (BV 1)) (BV 2)) )))   ...... (Bc True) (FV 1)a
--
--  --i.e.--  (TRefn TBool 3 (App (App (Prim Eqv) (BV 3))
--                                (App (App (Prim And) (Bc True)) (FV 1))))

-- First wave of lemmas:               need change of vars!
-- 1:Bool{2:tt}, 3:Bool{3:(BV3)=(FV1)} |-e (FV 3) `Eqv` (True `And` (FV 1))
{-@ entails_refn_and_true :: ProofOf(Entails (Cons 3 (TRefn TBool 3 (App (App (Prim Eqv) (BV 3)) (FV 1)))
                                               (Cons 1 (TRefn TBool 2 (Bc True)) Empty))
        (App (App (Prim Eqv) (FV 3)) (App (App (Prim And) (Bc True)) (FV 1))) ) @-}
entails_refn_and_true :: Entails
entails_refn_and_true = undefined
{-
entails_refn_and_true = EntPred g refnand ev_func
  where
    {-@ ev_func :: th:CSubst -> ProofOf(DenotesEnv g th)
                             -> ProofOf(EvalsTo (csubst th refnand) (Bc True)) @-}
    ev_func :: CSubst -> DenotesEnv -> EvalsTo
    ev_func th den_g_th = case th of
      (CCons 3 (Bc b)  (CCons 1 (Bc b')  CEmpty)) -> ev_threfn_tt    -- we must have b == b'
           where
             {-@ th_refnand :: { q:Pred | q == csubst th refnand } @-}
             th_refnand   = App (App (Prim Eqv) (Bc b)) (App (App (Prim And) (Bc True)) (Bc b'))
                              ? lem_csubst_app th (App (Prim Eqv) (FV 3)) (App (App (Prim And) (Bc True)) (FV 1))
                              ? lem_csubst_app th (Prim Eqv) (FV 3)
                              ? lem_csubst_prim th Eqv
                              ? lem_csubst_app th (App (Prim And) (Bc True)) (FV 1)
                              ? lem_csubst_app th (Prim And) (Bc True)
                              ? lem_csubst_prim th And
                              ? lem_csubst_bc th True
             --b            = Bc True
             {-@ ev_threfn_tt :: ProofOf(EvalsTo th_refnand (Bc True)) @-}
             ev_threfn_tt = lemma_semantics_refn_and True b b ? lem_den_env_blbl th den_g_th
                                                              ? toProof ( th_refnand === csubst th refnand ) 
      _ -> impossible ("by lemma" ? lem_den_env_blbl th den_g_th)
    g               = Cons 3 (TRefn TBool 3 (App (App (Prim Eqv) (BV 3)) (FV 1))) 
                        (Cons 1 (TRefn TBool 2 (Bc True)) Empty)
    refnand         = App (App (Prim Eqv) (FV 3)) (App (App (Prim And) (Bc True)) (FV 1))
-}
  -- BV nuimnbers???
{-@ entails_refn_and_false :: ProofOf(Entails (Cons 3 (TRefn TBool 3 (App (App (Prim Eqv) (BV 3)) (Bc False)))
                                               (Cons 1 (TRefn TBool 2 (Bc True)) Empty))
        (App (App (Prim Eqv) (FV 3)) (App (App (Prim And) (Bc False)) (FV 1))) ) @-}
entails_refn_and_false :: Entails
entails_refn_and_false = undefined
{-
entails_refn_and_false = EntPred g refnand ev_func -- TODO: haven't done this one yet
  where
    {-@ ev_func :: th:CSubst -> ProofOf(DenotesEnv g th)
                             -> ProofOf(EvalsTo (csubst th refnand) (Bc True)) @-}
    ev_func :: CSubst -> DenotesEnv -> EvalsTo
    ev_func th den_g_th = case th of
      (CCons 3 (Bc b)  (CCons 1 (Bc b')  CEmpty)) -> ev_threfn_tt    -- we must have b == b'
           where
             {-@ th_refnand :: { q:Pred | q == csubst th refnand } @-}
             th_refnand   = App (App (Prim Eqv) (Bc b)) (App (App (Prim And) (Bc True)) (Bc b'))
                              ? lem_csubst_app th (App (Prim Eqv) (FV 3)) (App (App (Prim And) (Bc True)) (FV 1))
                              ? lem_csubst_app th (Prim Eqv) (FV 3)
                              ? lem_csubst_prim th Eqv
                              ? lem_csubst_app th (App (Prim And) (Bc True)) (FV 1)
                              ? lem_csubst_app th (Prim And) (Bc True)
                              ? lem_csubst_prim th And
                              ? lem_csubst_bc th True
             --b            = Bc True
             {-@ ev_threfn_tt :: ProofOf(EvalsTo th_refnand (Bc True)) @-}
             ev_threfn_tt = lemma_semantics_refn_and True b b ? lem_den_env_blbl th den_g_th
                                                              ? toProof ( th_refnand === csubst th refnand ) 
      _ -> impossible ("by lemma" ? lem_den_env_blbl th den_g_th)
    g               = Cons 3 (TRefn TBool 3 (App (App (Prim Eqv) (BV 3)) (FV 1))) 
                        (Cons 1 (TRefn TBool 2 (Bc True)) Empty)
    refnand         = App (App (Prim Eqv) (FV 3)) (App (App (Prim And) (Bc True)) (FV 1))
-}
-- Second show FV 1 is a subtype of sub 1 True (refn_pred And)
{- @ bool_var_typ_refn_and_tt :: ProofOf(HasType (Cons 1 (TRefn TBool 2 (Bc True)) Empty)  (FV 1)
                                                (TRefn TBool 3 (unbind 2 1 (subBV 1 (Bc True) (refn_pred And))))) @-}
{-@ bool_var_typ_refn_and_tt :: ProofOf(HasType (Cons 1 (TRefn TBool 2 (Bc True)) Empty)  (FV 1)
        (TRefn TBool 3 (App (App (Prim Eqv) (BV 3)) (App (App (Prim And) (Bc True)) (FV 1))))) @-}
bool_var_typ_refn_and_tt :: HasType
bool_var_typ_refn_and_tt = undefined
{-
bool_var_typ_refn_and_tt = TSub g (FV 1) type3 p_x_eqlx type4 type4_wf sub_type3_type4
  where
    g               = Cons 1 type2 Empty
    type2           = TRefn TBool 2 (Bc True)  -- Bool{2 : True `And` (} 
    p_x_tt          = TVar1 Empty 1 type2      -- Proof of g |- (FV 1) : self(type2, x)
    pred3           = App (App (Prim Eqv) (BV 3)) (FV 1)
    type3           = TRefn TBool 3 pred3
    type3_wf        = makeWFType g type3
    sub_self2_type3 = lem_self_tt_sub_eql Empty TBool 2 3 1 -- g |- self(type2, x) <: TBool{3 : (BV 3) = (FV 1)}
    {- @ p_x_eqlx :: ProofOf(HasType g (FV 1) (TRefn TBool 3 pred3)) @-}
    p_x_eqlx        = TSub g (FV 1) (self type2 1) p_x_tt type3 type3_wf sub_self2_type3
    
    {- @ pred4 :: { p:Pred | p == App (App (Prim Eqv) (BV 3)) (App (App (Prim And) (Bc True)) (FV 1)) } @-}  
    pred4           = App (App (Prim Eqv) (BV 3)) (App (App (Prim And) (Bc True)) (FV 1))
                      {- unbind 2 1 (subBV 1 (Bc True) (refn_pred And))
                        ? lem_unbind_sub_refn_pred_and True -}
    type4           = TRefn TBool 3 pred4
    type4_wf        = makeWFType g type4
    sub_type3_type4 = SBase g 3 TBool pred3 3 pred4 3 entails_refn_and_true 
-}

-- Then, third, Show using SBase and SFunc to show delta And b has type ty_del(And, b) == tsubFV 1 (Bc b) ty'(c)
-- ?? Emp |- \x. x : (x:Bool -> TRefn TBool 3 (App (App (Prim Eqv) (BV 3)) (FV x)))
-- ?? probably need change of vars here

{- @ id_bool_typ_ty'c_tt :: ProofOf(HasType Empty (Lambda 1 (BV 1)) (TFunc 2 (TRefn TBool 2 (Bc True))
                                     (TRefn TBool 3 (subBV 1 (Bc True) (refn_pred And)))) ) @-}
{-@ id_bool_typ_ty'c_tt :: ProofOf(HasType Empty (Lambda 1 (BV 1)) (TFunc 2 (TRefn TBool 2 (Bc True))
               (TRefn TBool 3 (App (App (Prim Eqv) (BV 3)) (App (App (Prim And) (Bc True)) (BV 2))))) ) @-}
id_bool_typ_ty'c_tt :: HasType
id_bool_typ_ty'c_tt = undefined
{-
id_bool_typ_ty'c_tt = TSub Empty (Lambda 1 (BV 1)) functype_1 p_id_functype_1 
                                                   functype_2 functype_2_wf sub_func1_func2
  where
    type2           = TRefn TBool 2 (Bc True) 
    type2_wf        = makeWFType Empty type2 
    type4           = TRefn TBool 3 (App (App (Prim Eqv) (BV 3)) (App (App (Prim And) (Bc True)) (FV 1)))
--                        ? lem_unbind_sub_refn_pred_and True
    type4_wf        = makeWFType (Cons 1 type2 Empty) type4
    bound_ty1       = TRefn TBool 3 (App (App (Prim Eqv) (BV 3)) (App (App (Prim And) (Bc True)) (BV 1)))
    functype_1      = TFunc 1 type2 bound_ty1
    p_id_functype_1 = TAbs Empty 1 type2 type2_wf (BV 1) bound_ty1 1 bool_var_typ_refn_and_tt
    bound_ty2       = TRefn TBool 3 (App (App (Prim Eqv) (BV 3)) (App (App (Prim And) (Bc True)) (BV 2)))
-- TRefn TBool 3 (subBV 1 (Bc True) (refn_pred And))
    functype_2      = TFunc 2 type2 bound_ty2 -- ? lem_unbind_sub_refn_pred_and True 
    functype_2_wf   = WFFunc Empty 2 type2 type2_wf bound_ty2 1 type4_wf
    sub_func1_func2 = lem_change_bv_sub_func Empty 1 type2 bound_ty1 2 bound_ty2 1 
                        type2_wf type4_wf WFEEmpty
-}

{-    
-- fourth use SBase and SFunc to show delta And b has type ty_del(And, b) == tsubFV 1 (Bc b) ty'(c)
{-@ lem_delta_typ_ty'c :: c:Prim -> v:Value -> ProofOf(HasType Empty v (inType c))
                              -> ProofOf(HasType Empty (delta c v) (tsubBV (firstBV c) v (ty' c))) @-} 
lem_delta_typ_ty'c :: Prim -> Expr -> HasType -> HasType
lem_delta_typ_ty'c And (Bc True) p_v_bl = id_bool_typ_ty'c_tt ? lem_sub_refn_pred_and True
  -}

{-
-- fifth, handle the case of And False

{-@ lem_delta_and_typ :: v:Value -> x:Vname -> t_x:Type -> t':Type
        -> ProofOf(HasType Empty (Prim And) (TFunc t_x t')) -> ProofOf(HasType Empty v t_x)
        -> { pf:_ | propOf pf == HasType Empty (delta And v) (tsubBV x v t') } @-} 
lem_delta_and_typ :: Expr -> Vname -> Type -> Type -> HasType -> HasType -> HasType


lem_delta_and_typ v x t_x t' p_c_txt' p_v_tx = case p_c_txt' of
  (TPrm Empty And) -> case v of
          (Bc True)  -> TAbs Empty 1 (BTBase TBool) (BV 1) (BTBase TBool)
                              1 (BTVar1 BEmpty 1 (BTBase TBool) ) -- ? toProof ( unbind 1 1 (BV 1) === FV 1 ))

{-@ lem_delta_and_false_typ :: ProofOf(HasType (delta And (Bc False)) 
            (TFunc 2 (TRefn TBool 5 (Bc True))
                (TRefn TBool 3 (App (App (Prim Eqv) (BV 3))
                                    (App (App (Prim And) (Bc False)) (BV 2)) ))) ) @-}

          (Bc False) -> BTAbs BEmpty 1 (BTBase TBool) (Bc False) (BTBase TBool)
                              1 (BTBC (BCons 1 (BTBase TBool) BEmpty) False)
          _          -> impossible ("by lemma" ? lem_bool_values v p_v_tx)


-}

-- sixth, copy paste fix for Prim Or

-- seventh, simplify for Prim Not

-- eighth, show
-- x:(TRefn TIntl 1 (Bc True)) |- FV x : TRefn TInt 2 (App (App (Prim Eq) (BV 2)) (FV x))
-- by Entailment, SBase and TSub

-- ninth, show
-- Emp |- \x. x : (x:Int -> TRefn TInt 2 (App (App (Prim Eq) (BV 2)) (FV x)) )
--
-- tenth show the entailment for Leq/Eq
--
-- eleventh so the lemma for LEq/Eq
--
-- twelvth, figure for Leqn/Eqn
--
-- thirteenth, the refinement type for \x. (App (Prim Not) (BV x))
--
-- fourteenth, the delta __ type lemmas for eqv
--
-- fifteenth, prove lem_prim_sub_tyc


{-
-- only true that (ty c) <: t  -- do i ned sub trans too?
{-@ assume lem_prim_tyc_sub :: g:Env -> c:Prim -> t:Type -> ProofOf(HasType g (Prim c) t)
                              -> ProofOf(Subtype g (ty c) t) @-}
lem_prim_tyc_sub :: Env -> Prim -> Type -> HasType -> Subtype
lem_prim_tyc_sub g c t (TPrm _ _)                = lem_subtype_refl g t
lem_prim_tyc_sub g c t (TSub _ _ s p_pc_s _ _ _) = () ? lem_prim_tyc_sub g c s p_pc_s
lem_prim_tyc_sub g c t _                         = impossible "no more matches"
-}


-- sixteenth fill in the deatils here and celebrate!

{-@ assume lem_delta_typ :: c:Prim -> v:Value -> x:Vname -> t_x:Type -> t':Type
        -> ProofOf(HasType Empty (Prim c) (TFunc x t_x t')) -> ProofOf(HasType Empty v t_x)
        -> { pf:_ | propOf pf == HasType Empty (delta c v) (tsubBV x v t') } @-} {-&&
                    not ((delta c v) == Crash) } @-} 
lem_delta_typ :: Prim -> Expr -> Vname -> Type -> Type 
                     -> HasType -> HasType -> HasType
lem_delta_typ c v x t_x t' den_tx_v = undefined

{- @ asm lem_delta_typ1 :: g:Env -> c:Prim -> v:Value -> x:Vname -> t_x:Type 
        -> { t':Type | ty(c) == TFunc x t_x t' } -> ProofOf(Denotes t_x v)
        -> { pf:_ | propOf pf == HasType g (delta c v) (tsubBV x v t') &&
                    not ((delta c v) == Crash) } @-}
--lem_delta_typ1 :: Env -> Prim -> Expr -> Vname -> Type -> Type -> Denotes -> HasType
--lem_delta_typ1 g c v x t_x t' den_tx_v = undefined

-- also Denotes t[v/x] delta(c,v)
