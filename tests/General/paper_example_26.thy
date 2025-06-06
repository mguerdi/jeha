theory paper_example_26

imports "JEHA.jeha" 

begin

declare [[jeha_trace]]

(* lemma paper_example_26_all_rules:
  shows "(\<exists> y. \<forall> x . y x = (p x \<and> q x))"
  (* sledgehammer *)
  (* by metis (* fails *) *)
  using [[jeha_trace_active]] by (jeha) (* 80_000 ms *) *)

declare [[jeha_disable_all]]

declare [[jeha_rule_forall_rw]]
declare [[jeha_rule_exists_hoist]]
declare [[jeha_rule_bool_rw]]
declare [[jeha_rule_false_elim]]

(* NOTE: Example 26 in the paper doesn't work out of the box: FalseElim doesn't
handle True = False \<or> True = False, because neither literal is strictly maximal.
In Addition EFact and ERes are required (or selection functions). *)
declare [[jeha_rule_e_fact]]
declare [[jeha_rule_e_res]]

(* necessary, because the contradiction is
  False = True \<or> False = True
but FalseElim doesn't apply because of its strict-maximality side condition *)
declare [[jeha_rule_simp_false_elim]]

(* works but takes very long (> 1 min): *)
(* doesn't work in Isabelle2023 FIXME: figure out why (maybe not) *)

lemma paper_example_26_select_none:
  shows "(\<exists> y. \<forall> x . y x = (p x \<and> q x))"
  (* sledgehammer
  by metis *)
  using [[jeha_literal_selection_function="select_none"]] by jeha (* 29500 ms *)

lemma paper_example_26_select_all_neg_lit:
  shows "(\<exists> y. \<forall> x . y x = (p x \<and> q x))"
  (* sledgehammer
  by metis *)
  using [[jeha_literal_selection_function="select_all_neg_lit"]] by jeha (* 29500 ms *)

end