(*  Title:      HOL/Metis_Examples/Proxies.thy
    Author:     Jasmin Blanchette, TU Muenchen

Example that exercises Metis's and Sledgehammer's logical symbol proxies for
rudimentary higher-order reasoning.
*)

section \<open>
Example that Exercises Metis's and Sledgehammer's Logical Symbol Proxies for
Rudimentary Higher-Order Reasoning.
\<close>

theory Proxies
imports Type_Encodings
begin

sledgehammer_params [prover = spass, fact_filter = mepo, slices = 1, timeout = 30,
  preplay_timeout = 0, dont_minimize]

text \<open>Extensionality and set constants\<close>

lemma plus_1_not_0: "n + (1::nat) \<noteq> 0"
by simp

definition inc :: "nat \<Rightarrow> nat" where
"inc x = x + 1"

lemma "inc \<noteq> (\<lambda>y. 0)"
sledgehammer [expect = some] (inc_def plus_1_not_0)
by (jeha_exhaust inc_def plus_1_not_0)

lemma "inc = (\<lambda>y. y + 1)"
sledgehammer [expect = some]
by (jeha_exhaust inc_def)

definition add_swap :: "nat \<Rightarrow> nat \<Rightarrow> nat" where
"add_swap = (\<lambda>x y. y + x)"

lemma "add_swap m n = n + m"
sledgehammer [expect = some] (add_swap_def)
by (jeha_exhaust add_swap_def)

definition "A = {xs::'a list. True}"

lemma "xs \<in> A"
(* The "add:" argument is unfortunate. *)
sledgehammer [expect = some] (add: A_def mem_Collect_eq)
by (jeha_exhaust A_def mem_Collect_eq)

definition "B (y::int) \<equiv> y \<le> 0"
definition "C (y::int) \<equiv> y \<le> 1"

lemma int_le_0_imp_le_1: "x \<le> (0::int) \<Longrightarrow> x \<le> 1"
by linarith

lemma "B \<le> C"
sledgehammer [expect = some]
by (jeha_exhaust B_def C_def int_le_0_imp_le_1 predicate1I)

text \<open>Proxies for logical constants\<close>

lemma "id (=) x x"
sledgehammer [type_enc = erased, expect = none] (id_apply)
sledgehammer [type_enc = poly_tags??, expect = some] (id_apply)
sledgehammer [type_enc = poly_tags, expect = some] (id_apply)
sledgehammer [type_enc = poly_guards??, expect = some] (id_apply)
sledgehammer [type_enc = poly_guards, expect = some] (id_apply)
sledgehammer [type_enc = mono_tags??, expect = some] (id_apply)
sledgehammer [type_enc = mono_tags, expect = some] (id_apply)
sledgehammer [type_enc = mono_guards??, expect = some] (id_apply)
sledgehammer [type_enc = mono_guards, expect = some] (id_apply)
by (jeha (full_types) id_apply)

lemma "id True"
sledgehammer [type_enc = erased, expect = some] (id_apply)
sledgehammer [type_enc = poly_tags??, expect = some] (id_apply)
sledgehammer [type_enc = poly_tags, expect = some] (id_apply)
sledgehammer [type_enc = poly_guards??, expect = some] (id_apply)
sledgehammer [type_enc = poly_guards, expect = some] (id_apply)
sledgehammer [type_enc = mono_tags??, expect = some] (id_apply)
sledgehammer [type_enc = mono_tags, expect = some] (id_apply)
sledgehammer [type_enc = mono_guards??, expect = some] (id_apply)
sledgehammer [type_enc = mono_guards, expect = some] (id_apply)
by (jeha_exhaust id_apply)

lemma "\<not> id False"
sledgehammer [type_enc = erased, expect = some] (id_apply)
sledgehammer [type_enc = poly_tags??, expect = some] (id_apply)
sledgehammer [type_enc = poly_tags, expect = some] (id_apply)
sledgehammer [type_enc = poly_guards??, expect = some] (id_apply)
sledgehammer [type_enc = poly_guards, expect = some] (id_apply)
sledgehammer [type_enc = mono_tags??, expect = some] (id_apply)
sledgehammer [type_enc = mono_tags, expect = some] (id_apply)
sledgehammer [type_enc = mono_guards??, expect = some] (id_apply)
sledgehammer [type_enc = mono_guards, expect = some] (id_apply)
by (jeha_exhaust id_apply)

lemma "x = id True \<or> x = id False"
sledgehammer [type_enc = erased, expect = some] (id_apply)
sledgehammer [type_enc = poly_tags??, expect = some] (id_apply)
sledgehammer [type_enc = poly_tags, expect = some] (id_apply)
sledgehammer [type_enc = poly_guards??, expect = some] (id_apply)
sledgehammer [type_enc = poly_guards, expect = some] (id_apply)
sledgehammer [type_enc = mono_tags??, expect = some] (id_apply)
sledgehammer [type_enc = mono_tags, expect = some] (id_apply)
sledgehammer [type_enc = mono_guards??, expect = some] (id_apply)
sledgehammer [type_enc = mono_guards, expect = some] (id_apply)
by (jeha_exhaust id_apply)

lemma "id x = id True \<or> id x = id False"
sledgehammer [type_enc = erased, expect = some] (id_apply)
sledgehammer [type_enc = poly_tags??, expect = some] (id_apply)
sledgehammer [type_enc = poly_tags, expect = some] (id_apply)
sledgehammer [type_enc = poly_guards??, expect = some] (id_apply)
sledgehammer [type_enc = poly_guards, expect = some] (id_apply)
sledgehammer [type_enc = mono_tags??, expect = some] (id_apply)
sledgehammer [type_enc = mono_tags, expect = some] (id_apply)
sledgehammer [type_enc = mono_guards??, expect = some] (id_apply)
sledgehammer [type_enc = mono_guards, expect = some] (id_apply)
by (jeha_exhaust id_apply)

lemma "P True \<Longrightarrow> P False \<Longrightarrow> P x"
sledgehammer [type_enc = erased, expect = none] ()
sledgehammer [type_enc = poly_args, expect = none] ()
sledgehammer [type_enc = poly_tags??, expect = some] ()
sledgehammer [type_enc = poly_tags, expect = some] ()
sledgehammer [type_enc = poly_guards??, expect = some] (id_apply)
sledgehammer [type_enc = poly_guards, expect = some] ()
sledgehammer [type_enc = mono_tags??, expect = some] ()
sledgehammer [type_enc = mono_tags, expect = some] ()
sledgehammer [type_enc = mono_guards??, expect = some] ()
sledgehammer [type_enc = mono_guards, expect = some] ()
by (jeha (full_types))

lemma "id (\<not> a) \<Longrightarrow> \<not> id a"
sledgehammer [type_enc = erased, expect = some] (id_apply)
sledgehammer [type_enc = poly_tags??, expect = some] (id_apply)
sledgehammer [type_enc = poly_tags, expect = some] (id_apply)
sledgehammer [type_enc = poly_guards??, expect = some] (id_apply)
sledgehammer [type_enc = poly_guards, expect = some] (id_apply)
sledgehammer [type_enc = mono_tags??, expect = some] (id_apply)
sledgehammer [type_enc = mono_tags, expect = some] (id_apply)
sledgehammer [type_enc = mono_guards??, expect = some] (id_apply)
sledgehammer [type_enc = mono_guards, expect = some] (id_apply)
by (jeha_exhaust id_apply)

lemma "id (\<not> \<not> a) \<Longrightarrow> id a"
sledgehammer [type_enc = erased, expect = some] (id_apply)
sledgehammer [type_enc = poly_tags??, expect = some] (id_apply)
sledgehammer [type_enc = poly_tags, expect = some] (id_apply)
sledgehammer [type_enc = poly_guards??, expect = some] (id_apply)
sledgehammer [type_enc = poly_guards, expect = some] (id_apply)
sledgehammer [type_enc = mono_tags??, expect = some] (id_apply)
sledgehammer [type_enc = mono_tags, expect = some] (id_apply)
sledgehammer [type_enc = mono_guards??, expect = some] (id_apply)
sledgehammer [type_enc = mono_guards, expect = some] (id_apply)
by jeha_exhaust

lemma "id (\<not> (id (\<not> a))) \<Longrightarrow> id a"
sledgehammer [type_enc = erased, expect = some] (id_apply)
sledgehammer [type_enc = poly_tags??, expect = some] (id_apply)
sledgehammer [type_enc = poly_tags, expect = some] (id_apply)
sledgehammer [type_enc = poly_guards??, expect = some] (id_apply)
sledgehammer [type_enc = poly_guards, expect = some] (id_apply)
sledgehammer [type_enc = mono_tags??, expect = some] (id_apply)
sledgehammer [type_enc = mono_tags, expect = some] (id_apply)
sledgehammer [type_enc = mono_guards??, expect = some] (id_apply)
sledgehammer [type_enc = mono_guards, expect = some] (id_apply)
by (jeha_exhaust id_apply)

lemma "id (a \<and> b) \<Longrightarrow> id a"
sledgehammer [type_enc = erased, expect = some] (id_apply)
sledgehammer [type_enc = poly_tags??, expect = some] (id_apply)
sledgehammer [type_enc = poly_tags, expect = some] (id_apply)
sledgehammer [type_enc = poly_guards??, expect = some] (id_apply)
sledgehammer [type_enc = poly_guards, expect = some] (id_apply)
sledgehammer [type_enc = mono_tags??, expect = some] (id_apply)
sledgehammer [type_enc = mono_tags, expect = some] (id_apply)
sledgehammer [type_enc = mono_guards??, expect = some] (id_apply)
sledgehammer [type_enc = mono_guards, expect = some] (id_apply)
by (jeha_exhaust id_apply)

lemma "id (a \<and> b) \<Longrightarrow> id b"
sledgehammer [type_enc = erased, expect = some] (id_apply)
sledgehammer [type_enc = poly_tags??, expect = some] (id_apply)
sledgehammer [type_enc = poly_tags, expect = some] (id_apply)
sledgehammer [type_enc = poly_guards??, expect = some] (id_apply)
sledgehammer [type_enc = poly_guards, expect = some] (id_apply)
sledgehammer [type_enc = mono_tags??, expect = some] (id_apply)
sledgehammer [type_enc = mono_tags, expect = some] (id_apply)
sledgehammer [type_enc = mono_guards??, expect = some] (id_apply)
sledgehammer [type_enc = mono_guards, expect = some] (id_apply)
by (jeha_exhaust id_apply)

lemma "id a \<Longrightarrow> id b \<Longrightarrow> id (a \<and> b)"
sledgehammer [type_enc = erased, expect = some] (id_apply)
sledgehammer [type_enc = poly_tags??, expect = some] (id_apply)
sledgehammer [type_enc = poly_tags, expect = some] (id_apply)
sledgehammer [type_enc = poly_guards??, expect = some] (id_apply)
sledgehammer [type_enc = poly_guards, expect = some] (id_apply)
sledgehammer [type_enc = mono_tags??, expect = some] (id_apply)
sledgehammer [type_enc = mono_tags, expect = some] (id_apply)
sledgehammer [type_enc = mono_guards??, expect = some] (id_apply)
sledgehammer [type_enc = mono_guards, expect = some] (id_apply)
by (jeha_exhaust id_apply)

lemma "id a \<Longrightarrow> id (a \<or> b)"
sledgehammer [type_enc = erased, expect = some] (id_apply)
sledgehammer [type_enc = poly_tags??, expect = some] (id_apply)
sledgehammer [type_enc = poly_tags, expect = some] (id_apply)
sledgehammer [type_enc = poly_guards??, expect = some] (id_apply)
sledgehammer [type_enc = poly_guards, expect = some] (id_apply)
sledgehammer [type_enc = mono_tags??, expect = some] (id_apply)
sledgehammer [type_enc = mono_tags, expect = some] (id_apply)
sledgehammer [type_enc = mono_guards??, expect = some] (id_apply)
sledgehammer [type_enc = mono_guards, expect = some] (id_apply)
by (jeha_exhaust id_apply)

lemma "id b \<Longrightarrow> id (a \<or> b)"
sledgehammer [type_enc = erased, expect = some] (id_apply)
sledgehammer [type_enc = poly_tags??, expect = some] (id_apply)
sledgehammer [type_enc = poly_tags, expect = some] (id_apply)
sledgehammer [type_enc = poly_guards??, expect = some] (id_apply)
sledgehammer [type_enc = poly_guards, expect = some] (id_apply)
sledgehammer [type_enc = mono_tags??, expect = some] (id_apply)
sledgehammer [type_enc = mono_tags, expect = some] (id_apply)
sledgehammer [type_enc = mono_guards??, expect = some] (id_apply)
sledgehammer [type_enc = mono_guards, expect = some] (id_apply)
by (jeha_exhaust id_apply)

lemma "id (\<not> a) \<Longrightarrow> id (\<not> b) \<Longrightarrow> id (\<not> (a \<or> b))"
sledgehammer [type_enc = erased, expect = some] (id_apply)
sledgehammer [type_enc = poly_tags??, expect = some] (id_apply)
sledgehammer [type_enc = poly_tags, expect = some] (id_apply)
sledgehammer [type_enc = poly_guards??, expect = some] (id_apply)
sledgehammer [type_enc = poly_guards, expect = some] (id_apply)
sledgehammer [type_enc = mono_tags??, expect = some] (id_apply)
sledgehammer [type_enc = mono_tags, expect = some] (id_apply)
sledgehammer [type_enc = mono_guards??, expect = some] (id_apply)
sledgehammer [type_enc = mono_guards, expect = some] (id_apply)
by (jeha_exhaust id_apply)

lemma "id (\<not> a) \<Longrightarrow> id (a \<longrightarrow> b)"
sledgehammer [type_enc = erased, expect = some] (id_apply)
sledgehammer [type_enc = poly_tags??, expect = some] (id_apply)
sledgehammer [type_enc = poly_tags, expect = some] (id_apply)
sledgehammer [type_enc = poly_guards??, expect = some] (id_apply)
sledgehammer [type_enc = poly_guards, expect = some] (id_apply)
sledgehammer [type_enc = mono_tags??, expect = some] (id_apply)
sledgehammer [type_enc = mono_tags, expect = some] (id_apply)
sledgehammer [type_enc = mono_guards??, expect = some] (id_apply)
sledgehammer [type_enc = mono_guards, expect = some] (id_apply)
by (jeha_exhaust id_apply)

lemma "id (a \<longrightarrow> b) \<longleftrightarrow> id (\<not> a \<or> b)"
sledgehammer [type_enc = erased, expect = some] (id_apply)
sledgehammer [type_enc = poly_tags??, expect = some] (id_apply)
sledgehammer [type_enc = poly_tags, expect = some] (id_apply)
sledgehammer [type_enc = poly_guards??, expect = some] (id_apply)
sledgehammer [type_enc = poly_guards, expect = some] (id_apply)
sledgehammer [type_enc = mono_tags??, expect = some] (id_apply)
sledgehammer [type_enc = mono_tags, expect = some] (id_apply)
sledgehammer [type_enc = mono_guards??, expect = some] (id_apply)
sledgehammer [type_enc = mono_guards, expect = some] (id_apply)
by (jeha_exhaust id_apply)

end
