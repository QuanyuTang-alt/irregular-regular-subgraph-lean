# P25 — Irregular subgraph in a regular graph
Original article authors: **Tianyue Cao, Quanyu Tang, Hehui Wu** (source order).

**形式化进行中，尚未完成，未达到 Palomar 提交标准。**
**Work in progress: Theorem 2.1, including its balanced-subgraph consequence, is unproved.**

Direction/maintenance: Quanyu Tang. Source authorship is distinct from formalization and review. Code was AI-assisted using Doubao Work and checked with Lean/Lake. No human or independent code review, source-author endorsement, or specific model identifier is claimed.

## Latest source and exact whole target
https://arxiv.org/abs/2607.06465v1 — **v1**, verified as the latest live version and against the unversioned 18-page PDF; full paper/source read.

Theorem 2.1 says: ∀ ε>0, ∃ n₀(ε), ∀ simple d-regular G on n≥n₀ vertices in **2≤d≤n^(1/12−ε)**, ∀ nonnegative integer balanced target q with total n, even weighted sum and |q_i−n/(d+1)|≤1, ∃ spanning H≤G with exact degreeCount(H,i)=q_i for all 0≤i≤d. It also guarantees existence of an error-1 balanced H by constructing a parity-compatible q. n₀ must be uniform in G,d,q. This is not replaced by an asymptotic or fixed-degree specialization.

## Proven progress — concrete graph and lattice, not the main theorem
`IrregularSubgraph/Basic.lean` defines actual mathlib degree histograms, actual threshold spanning graphs, and literal integer edge-move vectors. Ten checked supporting declarations cover:
- thresholdGraph≤G;
- move total sum 0, weighted sum 2, symmetry and paired-difference identity;
- combinations preserve total sum and have even weighted sum;
- degree bound of a spanning subgraph of a regular graph;
- the **actual graph** degree-histogram partition and weighted handshaking identity.

No spectrum/sequence surrogate occurs here. However, move invariants do NOT prove generation with a bounded cost or existence of a graph attaining q. There is no final main export yet.

All current proofs compile and their explicit audit uses only `propext`, `Classical.choice`, `Quot.sound`. Zero unfinished proofs/custom axioms. Saved build and axiom outputs cover only these ten supports.

## Attempts, blockers and next work
Detailed full-chain analysis is in `docs/SOURCE-AND-SEMANTICS.md`: exact uniform threshold degree law; Poisson-binomial local approximation and Le Cam; binomial/convolution lower bounds including boundary variance regimes; near-threshold rectangles; both signed edge-atom estimates; bounded-cost anti-diagonal lattice representation; Efron–Stein discrepancy bound; dependency-graph supply and uniform asymptotics; vertex-disjoint greedy correction and final parity-compatible q.

Concrete definition/proof work repaired several real Lean errors in bundled SimpleGraph symmetry/irreflexivity, neighbor finite instances, Pi.single sums and histogram fiber sums. Named and concept searches were supplemented by external GitHub search. A matching-toolchain TauCeti Efron–Stein source was actually read at immutable commit `5751803d0d3f768fc94c2302ed16587b6965d347`, but is **not imported or counted as validated project proof**: product-coordinate instantiation and its own axiom audit still need work. It supplies only one ingredient, not local estimates or edge supply.

The unresolved probability estimates, bounded-cost lattice generation, greedy matching and final existence are not hidden in assumptions. Current progress is not sufficient to claim a complete proof.

## Reproduce support
Lean `leanprover/lean4:v4.36.0-rc2`; mathlib `9d581dfff2e41de989072ea63abf3daf69311520`; full transitive pins in manifest.
```sh
lake exe cache get
lake build
lake env lean verification/Audit.lean
python3 scripts/check_progress.py
```

Current Palomar policy/Template and applicable LeanAutoformalizationSkills were actually used as workflow and integrity guidance. No fake Challenge/Solution/comparator for the missing main theorem is supplied. Main Comparator and clean-checkout certification: **not done**. No `.github/workflows`; Actions disabled before first push and CI not started. No Palomar submission/registration.

Apache-2.0 applies to the original Lean code, not paper sources. No TeX, paper PDF, CV, credentials or unrelated private files are committed. The semantic record distinguishes missing proof obligations from source errata; no article error is claimed.
