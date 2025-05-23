theory forall_hoist

imports JEHA_TEST_BASE.test_base

begin

ML \<open>
  val mk = Skip_Proof.make_thm @{theory}
  val mkc = Thm.cterm_of @{context} 
\<close>

ML_val \<open>
  val premise = mk @{prop "A \<Longrightarrow> B (\<forall>x. (f :: 'a \<Rightarrow> 'b \<Rightarrow> bool) x c) = B' \<Longrightarrow> D \<Longrightarrow> False"}
  val expected = mk @{term_schem
    "A \<Longrightarrow> B False = B' \<Longrightarrow> D \<Longrightarrow> (f :: 'a \<Rightarrow> 'b \<Rightarrow> bool) ?fresh_x c \<noteq> True \<Longrightarrow> False"}
  val conclusion =
    Jeha_Proof.reconstruct_forall_hoist
      @{context}
      { premise = premise
      , subterm = ([1], JLit.Left, 1)
      , fresh_x = mkc @{term_schem "?fresh_x :: 'a"}
      , predicate = @{cterm "\<lambda>x. (f :: 'a \<Rightarrow> 'b \<Rightarrow> bool) x c"} }
  val () = \<^assert> (Thm.eq_thm_prop (expected, conclusion))
\<close>

(* Other schematic variables are present. *)
ML_val \<open>
  val premise = mk @{term_schem "A ?y \<Longrightarrow> B (\<forall>x. (f :: 'a \<Rightarrow> 'b \<Rightarrow> bool) x c) = B' \<Longrightarrow> False"}
  val expected = mk @{term_schem
    "A ?y \<Longrightarrow> B False = B' \<Longrightarrow> (f :: 'a \<Rightarrow> 'b \<Rightarrow> bool) ?fresh_x c \<noteq> True \<Longrightarrow> False"}
  val conclusion =
    Jeha_Proof.reconstruct_forall_hoist
      @{context}
      { premise = premise
      , subterm = ([1], JLit.Left, 1)
      , fresh_x = mkc @{term_schem "?fresh_x"}
      , predicate = @{cterm "\<lambda>x. (f :: 'a \<Rightarrow> 'b \<Rightarrow> bool) x c"} }
  val () = \<^assert> (Thm.eq_thm_prop (expected, conclusion) )
\<close>

(* Expected failure if variable is not fresh. *)
ML_val \<open>
  val premise = mk @{term_schem "A ?fresh_x \<Longrightarrow> B (\<forall>x. (f :: 'a \<Rightarrow> 'b \<Rightarrow> bool) x c) = B' \<Longrightarrow> False"}
  val expected = mk @{term_schem
    "A \<Longrightarrow> B False = B' \<Longrightarrow> (f :: 'a \<Rightarrow> 'b \<Rightarrow> bool) ?fresh_x c \<noteq> True \<Longrightarrow> False"}
  val conclusion =
    Jeha_Proof.reconstruct_forall_hoist
      @{context}
      { premise = premise
      , subterm = ([1], JLit.Left, 1)
      , fresh_x = @{cterm "fresh_x"}
      , predicate = @{cterm "\<lambda>x. (f :: 'a \<Rightarrow> 'b \<Rightarrow> bool) x c"} }
  val () = \<^assert> (not (Thm.eq_thm_prop (expected, conclusion)))
\<close>

(* Type is also a schematic var. *)
ML_val \<open>
  val premise = mk @{term_schem "B (\<forall>x. (f :: ?'a \<Rightarrow> 'b \<Rightarrow> bool) x c) = B' \<Longrightarrow> False"}
  val expected = mk @{term_schem
    "B False = B' \<Longrightarrow> (f :: ?'a \<Rightarrow> 'b \<Rightarrow> bool) ?fresh_x c \<noteq> True \<Longrightarrow> False"}
  val conclusion =
    Jeha_Proof.reconstruct_forall_hoist
      @{context}
      { premise = premise
      , subterm = ([1], JLit.Left, 0)
      , fresh_x = mkc @{term_schem "?fresh_x :: ?'a"}
      , predicate = Thm.cterm_of @{context} @{term_schem "\<lambda>x. (f :: ?'a \<Rightarrow> 'b \<Rightarrow> bool) x c"} }
  val () = \<^assert> (Thm.eq_thm_prop (expected, conclusion))
\<close>

end