(* detailed proof and proof reconstruction *)

signature JEHA_PROOF =
sig
  (* type proof_step *)
  (* val hol_thm_of_clause : Proof.context -> (int -> JClause.T) -> int -> thm *)
  (* elaborates a \<lambda>oSup inference into a series of more smaller proof steps *)
  (* val fun proof_steps_of_inference : Jeha_Log.inference -> proof_step *)
  val reconstruct_with_metis : Proof.context -> (int -> JClause.T) -> int -> thm
  val instantiate : Proof.context -> Envir.env -> thm -> thm
end;

structure Jeha_Proof : JEHA_PROOF = 
struct

(* The primitve building blocks to which all o\<lambda>Sup inferences can be reduced. *)
(* datatype proof_step =
    (* FIXME: does normalization need to be separate? *)
    Instantiation of { premise: int, substitution: Envir.env }
  | Sup of { left_premise: int, right_premise: int, literal: JLit.lpos * JClause_Pos.cpos, subterm: JClause_Pos.full_pos }
  | ERes of { premise: int, literal: JClause_Pos.cpos }
  | EFact of { premise: int, left_literal: JLit.lpos * JClause_Pos.cpos, right_literal: JLit.lpos * JClause_Pos.cpos }
  (* FIXME: can this be meaningfully viewed as a kind of superposition? *)
  | ArgCong 
  |

fun proof_steps_of_inference *)

(* turn jeha clause [A, B, C] into formula \<not>A \<Longrightarrow> \<not>B \<Longrightarrow> \<not>C \<Longrightarrow> False *)
fun hol_of_clause ctxt c =
  let
    val negated_literals = 
      JClause.literals c
      |> map (fn (s, t, b) => (s, t, not b))
      |> map JLit.term_of
      |> map HOLogic.mk_Trueprop
  in
    Logic.list_implies (negated_literals, @{prop "False"})
    |> Thm.cterm_of ctxt
  end

(* with index 2 turn \<not>A \<Longrightarrow> \<not>B \<Longrightarrow> \<not>C \<Longrightarrow> False into \<not>A \<Longrightarrow> \<not>C \<Longrightarrow> B *)
(* fun move_literal_to_conclusion literal_index *)

fun instantiate ctxt env thm =
  (* see metis_reconstruct.ML, flexflex_first_order *)
  let
    val (tyenv, tenv) = (Envir.type_env env, Envir.term_env env)
    fun mkT (v, (S, T)) = ((v, S), Thm.ctyp_of ctxt T)
    fun mk (v, (T, t)) = ((v, Envir.subst_type tyenv T), Thm.cterm_of ctxt t)

    val instsT = Vartab.fold (cons o mkT) tyenv []
    val insts = Vartab.fold (cons o mk) tenv []
  in
    Thm.instantiate (TVars.make instsT, Vars.make insts) thm
  end
  
val excluded_middle =  @{lemma "P \<Longrightarrow> \<not> P \<Longrightarrow> False" by (rule notE)}

(* some inference rules require additional lemmas *)
fun get_lemmas _ = []

fun reconstruct_with_metis ctxt (clause_db : int -> JClause.T) clause_id =
  let
    val conclusion = hol_of_clause ctxt (clause_db clause_id)
    val _ = Jeha_Common.trace_msg ctxt (fn () => "START PROOF")
    val _ = Jeha_Common.trace_msg ctxt (fn () => "clause: " ^ JClause.pretty_clause ctxt (clause_db clause_id))
    val _ = Jeha_Common.trace_msg ctxt (fn () => "origin: " ^ @{make_string} (JClause.origin (clause_db clause_id)))
    val premises =
      clause_id
      |> clause_db
      |> JClause.origin
      |> get_prems_and_lemmas ctxt clause_db
    val _ = Jeha_Common.trace_msg ctxt (fn () => "Premises: " ^ (Jeha_Common.pretty_terms ctxt (map Thm.prop_of premises)))
    val _ = Jeha_Common.trace_msg ctxt (fn () => "Proving: " ^ (Jeha_Common.pretty_term ctxt (Thm.term_of conclusion)))
    val goal = Goal.init conclusion
    (* from metis_tactic.ML *)
    val method = METHOD oo Metis_Tactic.metis_method
    (* FIXME: this returns a new proof context. What to do with it? *)
    val SOME (Seq.Result (_, proved_conclusion), _) =
      method ((NONE, NONE), premises) ctxt premises (ctxt, goal)
      |> Seq.pull
    val _ = Jeha_Common.trace_msg ctxt (fn () => "Proved conclusion: " ^ (Jeha_Common.pretty_term ctxt (Thm.prop_of proved_conclusion)))
  in
    Goal.conclude proved_conclusion
  end
and get_prems_and_lemmas ctxt clause_db origin =
  get_premises ctxt clause_db origin @ get_lemmas origin
and get_premises _ _ (Jeha_Log.Axiom { thm = thm }) = [thm]
  | get_premises ctxt clause_db origin =
      origin |> Jeha_Log.premises |> map (reconstruct_with_metis ctxt clause_db)

(*
fun hol_thm_of_clause ctxt (clause_db : int -> JClause.T) clause_id =
  let
    val clause = (clause_db clause_id)
    val inference = JClause.origin clause
    val hol_clause = hol_of_clause clause
  in
    (* Idea: recurse until initial nodes (axioms, negated conjecture, etc.) have
    been reached. Turn those into theorems and return them. For interior nodes,
    use the theorems corresponding to the premises to reconstruct the conclusion
    in such a way that it's structure matches that of the corresponding clause
    in the database (check this property). *)
    case inference of
    | Sup { left_premise, right_premise, literal, subterm, substitution } =>
        let
          val hol_left_premise = hol_thm_of_clause clause_db left_premise
          val hol_right_premise = hol_thm_of_clause clause_db right_premise
        in
          Clasimp.auto_tac
    | ERes { premise, literal, substitution } =>
        let
          val hol_premise = premise
          val instantiated_premise = instantiate ctxt substitution premise
        in
          reflexive RSN (literal, instantiated_premise)
        end
    | EFact of { premise, left_literal, right_literal, substitution } =>
        let
          val hol_premise = premise
          val instantiated_premise = instantiate ctxt substitution premise
          val goal_with_duplicate_literal = @{thm efact_lemma} RSN (right_literal, instantiated_premise)
        in
        (* after substitution: C' \<or> u = v' \<or> u = v *)
        (* goal              : C' \<or> u = v' \<or> v \<noteq> v' *)

        (* transitivity: v \<noteq> v' \<or> u = v' \<or> u \<noteq> v *)
        (* C' \<or> v \<noteq> v' \<or> u = v' *)


        (* in hol form: C' \<Longrightarrow> u \<noteq> v' \<Longrightarrow> u \<noteq> v \<Longrightarrow> False *)
        (* goal         C' \<Longrightarrow> v = v' \<Longrightarrow> u \<noteq> v' \<Longrightarrow> False *)
        (* transitivity: v = v' \<Longrightarrow> u \<noteq> v' \<Longrightarrow> u \<noteq> v *)
        (* transitivity RSN (i, premise): C' \<Longrightarrow> u \<noteq> v' \<Longrightarrow> v = v' \<Longrightarrow> u \<noteq> v' \<Longrightarrow> False *)
        (* delete duplicate literal *)
    | _ => error "hol_thm_of_clause unimplemented"
*)

end;