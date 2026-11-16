module
public import Mathlib

/-! Concrete degree counts and edge-move lattice for arXiv:2607.06465v1.
No random-supply theorem or principal graph realization theorem is asserted. -/
@[expose] public section
noncomputable section
attribute [local instance] Classical.propDecidable
namespace IrregularSubgraph
open Finset

/-- The number of vertices of degree i in the ACTUAL finite simple graph H. -/
def degreeCount {V : Type*} [Fintype V] (H : SimpleGraph V) (i : ℕ) : ℕ := by
  classical
  exact #{v : V | H.degree v = i}

/-- The threshold spanning subgraph of G for the given vertex labels. -/
def thresholdGraph {V : Type*} (G : SimpleGraph V) (x : V → ℝ) : SimpleGraph V where
  Adj u v := G.Adj u v ∧ 1 ≤ x u+x v
  symm := ⟨by intro u v h; exact ⟨h.1.symm, by simpa only [add_comm] using h.2⟩⟩
  loopless := ⟨by intro u h; exact G.loopless.irrefl u h.1⟩

/-- Threshold edges really belong to the ambient graph. -/
theorem thresholdGraph_le {V : Type*} (G : SimpleGraph V) (x : V → ℝ) :
    thresholdGraph G x ≤ G := by
  intro u v h
  exact h.1

/-- Literal standard basis vector for the integer degree-count lattice. -/
def basisVector (d : ℕ) (i : Fin (d+1)) : Fin (d+1) → ℤ := Pi.single i 1

/-- Literal edge-addition degree-count change, including multiplicity for a=b. -/
def edgeMove (d : ℕ) (a b : Fin d) : Fin (d+1) → ℤ :=
  -basisVector d a.castSucc - basisVector d b.castSucc +
    basisVector d a.succ + basisVector d b.succ

/-- One edge move preserves the total number of vertices. -/
theorem edgeMove_sum (d : ℕ) (a b : Fin d) : ∑ i, edgeMove d a b i = 0 := by
  simp [edgeMove, basisVector, Finset.sum_add_distrib, Finset.sum_sub_distrib,
    Finset.sum_neg_distrib]

/-- One edge move increases the sum of degrees by exactly two. -/
theorem edgeMove_weighted_sum (d : ℕ) (a b : Fin d) :
    ∑ i : Fin (d+1), (i.val : ℤ) * edgeMove d a b i = 2 := by
  simp [edgeMove, basisVector, mul_add, mul_sub, Finset.sum_add_distrib,
    Finset.sum_sub_distrib, Finset.sum_neg_distrib, mul_neg, Pi.single_apply,
    mul_ite, mul_one, mul_zero]
  omega

/-- The two endpoints can be interchanged without changing the lattice move. -/
theorem edgeMove_comm (d : ℕ) (a b : Fin d) : edgeMove d a b = edgeMove d b a := by
  ext i
  simp only [edgeMove, Pi.add_apply, Pi.sub_apply, Pi.neg_apply]
  ring

/-- The elementary f-coordinate anti-diagonal difference identity, with no index assumptions. -/
theorem paired_difference {V : Type*} (e : V → V → ℤ) (i j k : V) :
    (e i + e j) - (e i + e k) = e j - e k := by
  abel

/-- Every integer linear combination of edge moves preserves total sum. -/
theorem move_combination_sum (d : ℕ) (coefficient : Fin d × Fin d → ℤ) :
    ∑ i, ∑ ab : Fin d × Fin d, coefficient ab * edgeMove d ab.1 ab.2 i = 0 := by
  rw [Finset.sum_comm]
  simp only [← Finset.mul_sum, edgeMove_sum, mul_zero, Finset.sum_const_zero]

/-- The weighted sum of a move combination is even, exactly twice its coefficient sum. -/
theorem move_combination_weighted_sum (d : ℕ) (coefficient : Fin d × Fin d → ℤ) :
    ∑ i : Fin (d+1), (i.val : ℤ) *
      (∑ ab : Fin d × Fin d, coefficient ab * edgeMove d ab.1 ab.2 i) =
      2 * ∑ ab, coefficient ab := by
  simp_rw [Finset.mul_sum]
  rw [Finset.sum_comm]
  simp_rw [← mul_assoc, mul_comm _ (coefficient _), mul_assoc, ← Finset.mul_sum,
    edgeMove_weighted_sum]

/-- A spanning subgraph of a d-regular graph has degree at most d at every vertex. -/
theorem degree_le_regular {V : Type*} [Fintype V] (G H : SimpleGraph V)
    (d : ℕ) (hreg : ∀ v, G.degree v = d) (hHG : H ≤ G) (v : V) : H.degree v ≤ d := by
  classical
  simpa only [hreg v] using H.degree_le_of_le (v := v) hHG

/-- Actual degree classes partition the full vertex set whenever all degrees are ≤ d. -/
theorem degreeCount_sum {V : Type*} [Fintype V] (H : SimpleGraph V)
    (d : ℕ) (hdeg : ∀ v, H.degree v ≤ d) :
    ∑ i ∈ Finset.range (d+1), degreeCount H i = Fintype.card V := by
  classical
  have h := Finset.card_eq_sum_card_fiberwise
    (s := (Finset.univ : Finset V)) (t := Finset.range (d+1)) (f := fun v => H.degree v)
    (by intro v hv; exact Finset.mem_range.mpr (Nat.lt_succ_of_le (hdeg v)))
  simpa only [degreeCount, Finset.card_univ] using h.symm

/-- Weighted actual degree counts give the handshaking sum. -/
theorem degreeCount_weighted_sum {V : Type*} [Fintype V] (H : SimpleGraph V)
    (d : ℕ) (hdeg : ∀ v, H.degree v ≤ d) :
    ∑ i ∈ Finset.range (d+1), i * degreeCount H i = 2 * H.edgeFinset.card := by
  classical
  calc
    _ = ∑ i ∈ Finset.range (d+1), ∑ v : V, if H.degree v = i then i else 0 := by
      apply Finset.sum_congr rfl
      intro i hi
      simp only [degreeCount, Finset.card_eq_sum_ones, Finset.mul_sum,
        Finset.sum_filter, mul_ite, mul_one, mul_zero]
    _ = ∑ v : V, ∑ i ∈ Finset.range (d+1), if H.degree v = i then i else 0 := by
      rw [Finset.sum_comm]
    _ = ∑ v, H.degree v := by
      apply Finset.sum_congr rfl
      intro v hv
      simp only [eq_comm (a := H.degree v)]
      rw [Finset.sum_ite_eq']
      simp only [Finset.mem_range]
      exact ite_eq_left (by have := hdeg v; omega)
    _ = _ := H.sum_degrees_eq_twice_card_edges

end IrregularSubgraph
