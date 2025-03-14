theory unification

imports "JEHA_TEST_BASE.test_base"

begin

ML_val \<open>
  val pattern = @{term_pat "?x"};
  val term = @{term "c"};
  val ctxt = Context.Proof @{context};
  (* matching *)
  \<^assert> (is_some (Seq.pull
    (Jeha_Unify.matchers ctxt ~1 [(pattern, term)])));
  \<^assert> (not (is_some (Seq.pull
    (Jeha_Unify.matchers ctxt ~1 [(term, pattern)]))));
  (* unification *)
  \<^assert> (is_some (Seq.pull
    (Jeha_Unify.smash_unifiers ctxt [(term, pattern)] Envir.init)));
  \<^assert> (is_some (Seq.pull
    (Jeha_Unify.smash_unifiers ctxt [(pattern, term)] Envir.init)));
\<close>

(* Isabelles Unify.matchers doesn't handle maxidx corretly when only types are unified *) 
(* I think this matters because because Unify.matchers calls smash_unifiers which generates fresh
variables (including fresh type variables) and this breaks when Unify.matchers didn't pass the
correct maxidx to smash_unifiers. But I'm not sure if I ever had a clean reproduction of this. *)
(* Q: What is the FIXME in more_unify.ML:64? *)
ML_val \<open>
  val ctxt = Context.Proof @{context};
  val pattern = @{term_schem "(x :: ?'a)"};
  val term = @{term_schem "(x :: 'a)"};
  val maxidx = fold (maxidx_of_term #> curry Int.max) [pattern, term] ~1;
  val SOME (wrong_matcher, _) = Seq.pull (Unify.matchers ctxt [(pattern, term)]);
  \<^assert> (not (maxidx <= Envir.maxidx_of wrong_matcher));
  val SOME (right_matcher, _) = Seq.pull (Jeha_Unify.matchers ctxt maxidx [(pattern, term)]);
  \<^assert> (maxidx <= Envir.maxidx_of right_matcher);
\<close>

ML_val \<open>
  val x = @{term_schem "?x :: ?'a"};
  val y = @{term_schem "?y :: ?'b"};
  val SOME (matcher, _) = Unify.matchers (Context.Proof @{context}) [(x, y)] |> Seq.pull;
  (* This is wrong (or at least unexpected) *)
  (* Relevant (?) discussion:
    https://mailman46.in.tum.de/pipermail/isabelle-dev/2010-November/001177.html
  *)
  \<^assert> (Vartab.is_empty (Envir.type_env matcher));
  val x_unified = Envir.subst_term (Envir.type_env matcher, Envir.term_env matcher) x;
  val x_unified = Envir.norm_term matcher x;
  val first_order_matcher = Pattern.first_order_match @{theory} (x, y) (Vartab.empty, Vartab.empty);
  (* *)
  (* \<^assert> (Envir.typ_env *)
\<close>

end