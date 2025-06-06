(*  Title:      HOL/Metis_Examples/Clausification.thy
    Author:     Jasmin Blanchette, TU Muenchen

Example that exercises Metis's Clausifier.
*)

section \<open>Example that Exercises Metis's Clausifier\<close>

theory Clausification
imports "../jeha" Complex_Main
begin


text \<open>Definitional CNF for facts\<close>

declare [[meson_max_clauses = 10]]

axiomatization q :: "nat \<Rightarrow> nat \<Rightarrow> bool" where
qax: "\<exists>b. \<forall>a. (q b a \<and> q 0 0 \<and> q 1 a \<and> q a 1) \<or> (q 0 1 \<and> q 1 0 \<and> q a b \<and> q 1 1)"

declare [[metis_new_skolem = false]]

lemma "\<exists>b. \<forall>a. (q b a \<or> q a b)"
by (jeha qax)

lemma "\<exists>b. \<forall>a. (q b a \<or> q a b)"
by (jeha (full_types) qax)

lemma "\<exists>b. \<forall>a. (q b a \<and> q 0 0 \<and> q 1 a \<and> q a 1) \<or> (q 0 1 \<and> q 1 0 \<and> q a b \<and> q 1 1)"
by (jeha qax)

lemma "\<exists>b. \<forall>a. (q b a \<and> q 0 0 \<and> q 1 a \<and> q a 1) \<or> (q 0 1 \<and> q 1 0 \<and> q a b \<and> q 1 1)"
by (jeha (full_types) qax)

declare [[metis_new_skolem]]

lemma "\<exists>b. \<forall>a. (q b a \<or> q a b)"
by (jeha qax)

lemma "\<exists>b. \<forall>a. (q b a \<or> q a b)"
by (jeha (full_types) qax)

lemma "\<exists>b. \<forall>a. (q b a \<and> q 0 0 \<and> q 1 a \<and> q a 1) \<or> (q 0 1 \<and> q 1 0 \<and> q a b \<and> q 1 1)"
by (jeha qax)

lemma "\<exists>b. \<forall>a. (q b a \<and> q 0 0 \<and> q 1 a \<and> q a 1) \<or> (q 0 1 \<and> q 1 0 \<and> q a b \<and> q 1 1)"
by (jeha (full_types) qax)

declare [[meson_max_clauses = 60]]

axiomatization r :: "nat \<Rightarrow> nat \<Rightarrow> bool" where
rax: "(r 0 0 \<and> r 0 1 \<and> r 0 2 \<and> r 0 3) \<or>
      (r 1 0 \<and> r 1 1 \<and> r 1 2 \<and> r 1 3) \<or>
      (r 2 0 \<and> r 2 1 \<and> r 2 2 \<and> r 2 3) \<or>
      (r 3 0 \<and> r 3 1 \<and> r 3 2 \<and> r 3 3)"

declare [[metis_new_skolem = false]]

lemma "r 0 0 \<or> r 1 1 \<or> r 2 2 \<or> r 3 3"
by (jeha rax)

lemma "r 0 0 \<or> r 1 1 \<or> r 2 2 \<or> r 3 3"
by (jeha (full_types) rax)

declare [[metis_new_skolem]]

lemma "r 0 0 \<or> r 1 1 \<or> r 2 2 \<or> r 3 3"
by (jeha rax)

lemma "r 0 0 \<or> r 1 1 \<or> r 2 2 \<or> r 3 3"
by (jeha (full_types) rax)

(* FIXME: full rewrite countdown reached *)
(* lemma "(r 0 0 \<and> r 0 1 \<and> r 0 2 \<and> r 0 3) \<or>
       (r 1 0 \<and> r 1 1 \<and> r 1 2 \<and> r 1 3) \<or>
       (r 2 0 \<and> r 2 1 \<and> r 2 2 \<and> r 2 3) \<or>
       (r 3 0 \<and> r 3 1 \<and> r 3 2 \<and> r 3 3)"
by (jeha rax)

lemma "(r 0 0 \<and> r 0 1 \<and> r 0 2 \<and> r 0 3) \<or>
       (r 1 0 \<and> r 1 1 \<and> r 1 2 \<and> r 1 3) \<or>
       (r 2 0 \<and> r 2 1 \<and> r 2 2 \<and> r 2 3) \<or>
       (r 3 0 \<and> r 3 1 \<and> r 3 2 \<and> r 3 3)"
by (jeha (full_types) rax)


text \<open>Definitional CNF for goal\<close>

axiomatization p :: "nat \<Rightarrow> nat \<Rightarrow> bool" where
pax: "\<exists>b. \<forall>a. (p b a \<and> p 0 0 \<and> p 1 a) \<or> (p 0 1 \<and> p 1 0 \<and> p a b)"

declare [[metis_new_skolem = false]]

lemma "\<exists>b. \<forall>a. \<exists>x. (p b a \<or> x) \<and> (p 0 0 \<or> x) \<and> (p 1 a \<or> x) \<and>
                   (p 0 1 \<or> \<not> x) \<and> (p 1 0 \<or> \<not> x) \<and> (p a b \<or> \<not> x)"
by (jeha pax)

lemma "\<exists>b. \<forall>a. \<exists>x. (p b a \<or> x) \<and> (p 0 0 \<or> x) \<and> (p 1 a \<or> x) \<and>
                   (p 0 1 \<or> \<not> x) \<and> (p 1 0 \<or> \<not> x) \<and> (p a b \<or> \<not> x)"
by (jeha (full_types) pax)

declare [[metis_new_skolem]]

lemma "\<exists>b. \<forall>a. \<exists>x. (p b a \<or> x) \<and> (p 0 0 \<or> x) \<and> (p 1 a \<or> x) \<and>
                   (p 0 1 \<or> \<not> x) \<and> (p 1 0 \<or> \<not> x) \<and> (p a b \<or> \<not> x)"
by (jeha pax)

lemma "\<exists>b. \<forall>a. \<exists>x. (p b a \<or> x) \<and> (p 0 0 \<or> x) \<and> (p 1 a \<or> x) \<and>
                   (p 0 1 \<or> \<not> x) \<and> (p 1 0 \<or> \<not> x) \<and> (p a b \<or> \<not> x)"
by (jeha (full_types) pax)

*)

text \<open>New Skolemizer\<close>

declare [[metis_new_skolem]]

lemma
  fixes x :: real
  assumes fn_le: "!!n. f n \<le> x" and 1: "f \<longlonglongrightarrow> lim f"
  shows "lim f \<le> x"
by (jeha 1 LIMSEQ_le_const2 fn_le)

definition
  bounded :: "'a::metric_space set \<Rightarrow> bool" where
  "bounded S \<longleftrightarrow> (\<exists>x eee. \<forall>y\<in>S. dist x y \<le> eee)"

(* FIXME: incompleteness *)
(* lemma "bounded T \<Longrightarrow> S \<subseteq> T ==> bounded S"
using [[jeha_trace]] by (jeha bounded_def subset_eq)
*)

(* FIXME: pink? *)
(* lemma
  assumes a: "Quotient R Abs Rep T"
  shows "symp R"
using a unfolding Quotient_def using sympI
using [[jeha_trace]] by (jeha (full_types))
*)

(* FIXME: slow
lemma
  "(\<exists>x \<in> set xs. P x) \<longleftrightarrow>
   (\<exists>ys x zs. xs = ys @ x # zs \<and> P x \<and> (\<forall>z \<in> set zs. \<not> P z))"
by (jeha split_list_last_prop[where P = P] in_set_conv_decomp)
*)

lemma ex_tl: "\<exists>ys. tl ys = xs"
using list.sel(3) by fast

lemma "(\<exists>ys::nat list. tl ys = xs) \<and> (\<exists>bs::int list. tl bs = as)"
by (jeha ex_tl)

end
