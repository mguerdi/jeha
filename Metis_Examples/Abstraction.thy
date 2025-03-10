(*  Title:      HOL/Metis_Examples/Abstraction.thy
    Author:     Lawrence C. Paulson, Cambridge University Computer Laboratory
    Author:     Jasmin Blanchette, TU Muenchen

Example featuring Metis's support for lambda-abstractions.
*)

section \<open>Example Featuring Metis's Support for Lambda-Abstractions\<close>

theory Abstraction
  imports "JEHA.jeha" "HOL-Library.FuncSet"
begin

declare [[jeha_trace]]

(* For Christoph Benzmüller *)
lemma "x < 1 \<and> ((=) = (=)) \<Longrightarrow> ((=) = (=)) \<and> x < (2::nat)"
by (jeha nat_1_add_1 trans_less_add2)

(* find_theorems " *)

lemma epsilon_characterization:
  shows "\<And>y x. y x = False \<or> y (SOME z. y z) = True"
  by (metis someI_ex)

lemma better_ext:
  shows "\<And>f g. f = g \<or> f (SOME z. f z \<noteq> g z) \<noteq> g (SOME z. f z \<noteq> g z)"
  sorry

lemma simpler:
  shows "\<And>f. (\<And>x y. f x y = f y x) \<Longrightarrow> f = (\<lambda> x y. f y x)"
  using [[jeha_max_number_of_steps = 100
        , unify_search_bound = 5
        , jeha_disable_all
        , jeha_rule_arg_cong 
        , jeha_rule_sup
        , jeha_rule_e_res
        , jeha_rule_e_fact
        , jeha_rule_clause_subsumption
        ]]
  (* by (jeha better_ext) *)
  oops
  

(* FIXME: might require better boolean simplification *)
lemma "(=) = (\<lambda>x y. y = x)"
  using [[unify_search_bound = 15
        , jeha_disable_all
        , jeha_rule_sup
        , jeha_rule_e_fact
        , jeha_rule_e_res
        , jeha_rule_arg_cong
        (* , jeha_rule_bool_rw
        , jeha_rule_forall_rw
        , jeha_rule_simp_outer_claus *)
        , jeha_rule_clause_subsumption
        , jeha_max_number_of_steps = 200
        ]]
        (* by (jeha better_ext) (* ext epsilon_characterization) *) *)
  oops

consts
  monotone :: "['a => 'a, 'a set, ('a *'a)set] => bool"
  pset  :: "'a set => 'a set"
  order :: "'a set => ('a * 'a) set"

lemma "a \<in> {x. P x} \<Longrightarrow> P a"
proof -
  assume "a \<in> {x. P x}"
  thus "P a" by (jeha mem_Collect_eq)
qed

lemma Collect_triv: "a \<in> {x. P x} \<Longrightarrow> P a"
by (jeha mem_Collect_eq)

lemma "a \<in> {x. P x --> Q x} \<Longrightarrow> a \<in> {x. P x} \<Longrightarrow> a \<in> {x. Q x}"
by (jeha Collect_imp_eq ComplD UnE)

lemma "(a, b) \<in> Sigma A B \<Longrightarrow> a \<in> A \<and> b \<in> B a"
proof -
  assume A1: "(a, b) \<in> Sigma A B"
  hence F1: "b \<in> B a" by (jeha mem_Sigma_iff)
  have F2: "a \<in> A" by (jeha A1 mem_Sigma_iff)
  have "b \<in> B a" by (jeha F1)
  thus "a \<in> A \<and> b \<in> B a" by (jeha F2)
qed

lemma Sigma_triv: "(a, b) \<in> Sigma A B \<Longrightarrow> a \<in> A & b \<in> B a"
by (jeha SigmaD1 SigmaD2)

lemma "(a, b) \<in> (SIGMA x:A. {y. x = f y}) \<Longrightarrow> a \<in> A \<and> a = f b"
by (jeha (full_types, lifting) CollectD SigmaD1 SigmaD2)

lemma "(a, b) \<in> (SIGMA x:A. {y. x = f y}) \<Longrightarrow> a \<in> A \<and> a = f b"
proof -
  assume A1: "(a, b) \<in> (SIGMA x:A. {y. x = f y})"
  hence F1: "a \<in> A" by (jeha mem_Sigma_iff)
  have "b \<in> {R. a = f R}" by (jeha A1 mem_Sigma_iff)
  hence "a = f b" by (jeha (full_types) mem_Collect_eq)
  thus "a \<in> A \<and> a = f b" by (jeha F1)
qed

lemma "(cl, f) \<in> CLF \<Longrightarrow> CLF = (SIGMA cl: CL.{f. f \<in> pset cl}) \<Longrightarrow> f \<in> pset cl"
by (jeha Collect_mem_eq SigmaD2)

lemma "(cl, f) \<in> CLF \<Longrightarrow> CLF = (SIGMA cl: CL.{f. f \<in> pset cl}) \<Longrightarrow> f \<in> pset cl"
proof -
  assume A1: "(cl, f) \<in> CLF"
  assume A2: "CLF = (SIGMA cl:CL. {f. f \<in> pset cl})"
  have "\<forall>v u. (u, v) \<in> CLF \<longrightarrow> v \<in> {R. R \<in> pset u}" by (jeha A2 mem_Sigma_iff)
  hence "\<forall>v u. (u, v) \<in> CLF \<longrightarrow> v \<in> pset u" by (jeha mem_Collect_eq)
  thus "f \<in> pset cl" by (jeha A1)
qed

lemma
  "(cl, f) \<in> (SIGMA cl: CL. {f. f \<in> pset cl \<rightarrow> pset cl}) \<Longrightarrow>
   f \<in> pset cl \<rightarrow> pset cl"
by (jeha (no_types) Collect_mem_eq Sigma_triv)

lemma
  "(cl, f) \<in> (SIGMA cl: CL. {f. f \<in> pset cl \<rightarrow> pset cl}) \<Longrightarrow>
   f \<in> pset cl \<rightarrow> pset cl"
proof -
  assume A1: "(cl, f) \<in> (SIGMA cl:CL. {f. f \<in> pset cl \<rightarrow> pset cl})"
  have "f \<in> {R. R \<in> pset cl \<rightarrow> pset cl}" using A1 by simp
  thus "f \<in> pset cl \<rightarrow> pset cl" by (jeha mem_Collect_eq)
qed

(* Takes too long.
lemma
  "(cl, f) \<in> (SIGMA cl: CL. {f. f \<in> pset cl \<inter> cl}) \<Longrightarrow>
   f \<in> pset cl \<inter> cl"
by (jeha (no_types) Collect_conj_eq Int_def Sigma_triv inf_idem)
*)

lemma
  "(cl, f) \<in> (SIGMA cl: CL. {f. f \<in> pset cl \<inter> cl}) \<Longrightarrow>
   f \<in> pset cl \<inter> cl"
proof -
  assume A1: "(cl, f) \<in> (SIGMA cl:CL. {f. f \<in> pset cl \<inter> cl})"
  have "f \<in> {R. R \<in> pset cl \<inter> cl}" using A1 by simp
  hence "f \<in> Id_on cl `` pset cl" by (jeha Int_commute Image_Id_on mem_Collect_eq)
  hence "f \<in> cl \<inter> pset cl" by (jeha Image_Id_on)
  thus "f \<in> pset cl \<inter> cl" by (jeha Int_commute)
qed

lemma
  "(cl, f) \<in> (SIGMA cl: CL. {f. f \<in> pset cl \<rightarrow> pset cl & monotone f (pset cl) (order cl)}) \<Longrightarrow>
   (f \<in> pset cl \<rightarrow> pset cl)  &  (monotone f (pset cl) (order cl))"
by auto

lemma
  "(cl, f) \<in> CLF \<Longrightarrow>
   CLF \<subseteq> (SIGMA cl: CL. {f. f \<in> pset cl \<inter> cl}) \<Longrightarrow>
   f \<in> pset cl \<inter> cl"
by (jeha (lifting) CollectD Sigma_triv subsetD)

lemma
  "(cl, f) \<in> CLF \<Longrightarrow>
   CLF = (SIGMA cl: CL. {f. f \<in> pset cl \<inter> cl}) \<Longrightarrow>
   f \<in> pset cl \<inter> cl"
by (jeha (lifting) CollectD Sigma_triv)

lemma
  "(cl, f) \<in> CLF \<Longrightarrow>
   CLF \<subseteq> (SIGMA cl': CL. {f. f \<in> pset cl' \<rightarrow> pset cl'}) \<Longrightarrow>
   f \<in> pset cl \<rightarrow> pset cl"
by (jeha (lifting) CollectD Sigma_triv subsetD)

lemma
  "(cl, f) \<in> CLF \<Longrightarrow>
   CLF = (SIGMA cl: CL. {f. f \<in> pset cl \<rightarrow> pset cl}) \<Longrightarrow>
   f \<in> pset cl \<rightarrow> pset cl"
by (jeha (lifting) CollectD Sigma_triv)

lemma
  "(cl, f) \<in> CLF \<Longrightarrow>
   CLF = (SIGMA cl: CL. {f. f \<in> pset cl \<rightarrow> pset cl & monotone f (pset cl) (order cl)}) \<Longrightarrow>
   (f \<in> pset cl \<rightarrow> pset cl) & (monotone f (pset cl) (order cl))"
by auto

lemma "map (\<lambda>x. (f x, g x)) xs = zip (map f xs) (map g xs)"
apply (induct xs)
 apply (jeha list.map(1) zip_Nil)
by auto

lemma
  "map (\<lambda>w. (w \<rightarrow> w, w \<times> w)) xs =
   zip (map (\<lambda>w. w \<rightarrow> w) xs) (map (\<lambda>w. w \<times> w) xs)"
apply (induct xs)
 apply (jeha list.map(1) zip_Nil)
by auto

lemma "(\<lambda>x. Suc (f x)) ` {x. even x} \<subseteq> A \<Longrightarrow> \<forall>x. even x --> Suc (f x) \<in> A"
by (jeha mem_Collect_eq image_eqI subsetD)

lemma
  "(\<lambda>x. f (f x)) ` ((\<lambda>x. Suc(f x)) ` {x. even x}) \<subseteq> A \<Longrightarrow>
   (\<forall>x. even x --> f (f (Suc(f x))) \<in> A)"
by (jeha mem_Collect_eq imageI rev_subsetD)

lemma "f \<in> (\<lambda>u v. b \<times> u \<times> v) ` A \<Longrightarrow> \<forall>u v. P (b \<times> u \<times> v) \<Longrightarrow> P(f y)"
by (jeha (lifting) imageE)

lemma image_TimesA: "(\<lambda>(x, y). (f x, g y)) ` (A \<times> B) = (f ` A) \<times> (g ` B)"
by (jeha map_prod_def map_prod_surj_on)

lemma image_TimesB:
    "(\<lambda>(x, y, z). (f x, g y, h z)) ` (A \<times> B \<times> C) = (f ` A) \<times> (g ` B) \<times> (h ` C)"
by force

lemma image_TimesC:
  "(\<lambda>(x, y). (x \<rightarrow> x, y \<times> y)) ` (A \<times> B) =
   ((\<lambda>x. x \<rightarrow> x) ` A) \<times> ((\<lambda>y. y \<times> y) ` B)"
by (jeha image_TimesA)

end
