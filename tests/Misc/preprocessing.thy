theory preprocessing

imports "JEHA_TEST_BASE.test_base"

begin

(* from: HOL/ex/SAT_Examples.thy *)

(* FIXME *)
lemma "(\<forall>x. P x) \<or> \<not> All P"
by jeha

end
