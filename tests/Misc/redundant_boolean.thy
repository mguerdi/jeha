theory redundant_boolean

imports "JEHA.jeha"

begin

ML_val \<open>
  val t =
    JClause.of_term
      @{context}
      (@{term "True \<noteq> False \<or> (False \<longrightarrow> True) = True \<or> (True \<longrightarrow> False) = True"}, 0);
  (* FIXME: assertion *)
\<close>

end