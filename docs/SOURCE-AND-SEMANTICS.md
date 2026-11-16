# P25 — Full source target and current boundaries

Source **arXiv:2607.06465v1**, latest version checked live against the unversioned PDF. Full 18-page paper and 1,710-line source read, including every estimate and final parity construction. Authors in order: **Tianyue Cao, Quanyu Tang, Hehui Wu**.

## Complete principal theorem: Theorem 2.1
For every real ε>0 there exists n₀=n₀(ε), chosen **before** n, d, G and q, such that: every finite simple d-regular graph G on n≥n₀ vertices with **2≤d≤n^(1/12−ε)** and every vector q:Fin(d+1)→ℕ satisfying

- ∑q_i=n;
- ∑i q_i is even;
- |q_i−n/(d+1)|≤1 for every 0≤i≤d,

has a spanning subgraph H≤G on the **same vertex type** with degreeCount(H,i)=q_i for all i. It also asserts existence of a balanced spanning subgraph with error ≤1, including a proof that a nonnegative parity-compatible balanced q always exists for large n in the same range.

Not merely fixed d, not all d without the polynomial range, not approximate degree counts, not an arbitrary realization unrelated to edges of G. ε≥1/12 has an eventually empty d-range and must be included as such, not replaced by an extra ε<1/12 hypothesis.

## Binder/definition check
ε and positivity — SOURCE. Existential n₀ before all graph data — SOURCE. Finite simple graph on V with cardinal n, d-regular and given range — SOURCE/TYPING. q∈ℕ^(d+1), exact total/parity/error — SOURCE. Every local-limit estimate, edge-supply event, refined lattice representation/cost, bounded-differences estimate, matching/greedy ability and positive-probability realization — PROOF OBLIGATIONS, forbidden as extra premises in a main export.

`degreeCount` literally counts vertices of each degree of a mathlib SimpleGraph. `thresholdGraph` literally retains ambient edges whose endpoint labels sum to ≥1, proved ≤G. `edgeMove` is exactly −e_a−e_b+e_{a+1}+e_{b+1}, with repeated endpoints' degree classes counted twice if a=b. Index carrier Fin(d+1) prevents an endpoint outside 0…d. No principal theorem is manufactured from these supporting pieces.

## Complete proof chain examined
- Independent uniform labels and exact mixed binomial degree law 1/(d+1).
- Lemma 3.1: Poisson-binomial local approximation for ALL integer k plus Le Cam coupling/TV normalization. Paper's necessary literature estimate is an obligation, not a hypothesis.
- Lemma 3.2: uniform binomial/threshold-convolution point lower bounds including bounded-variance boundary regimes; hypergeometric mode/support/probability.
- Lemma 3.3: six explicit near-threshold rectangles, including a=0, b=s, s=1 endpoints.
- Lemma 3.4: ordered edge-atom probability ≥c_at d^(-4), both signs, conditioning on shared-neighbor identities.
- Lemma 4.1: exact anti-diagonal lattice generation WITH uniform coefficient-cost bound on twofold prefix norm. Basic move parity is not the whole lemma.
- Lemma 5.1: refined discrepancy first moment via Efron–Stein and 1-Lipschitz prefix weights.
- Lemma 5.2: dependencies via closed neighborhoods, variance O(d³ expectation), simultaneous supply failure O(d⁷/n), uniform in G,d.
- Section 6: positive-probability intersection, lattice shopping list, pair-combination costs, vertex-disjoint greedy moves, actual degree histogram update and final q parity construction.

## Attempts and remaining gaps
Actual graph definitions, histogram partition/handshaking bridges and integer move invariants have been implemented rather than assumed. API errors with SimpleGraph's bundled symmetry/irreflexivity, finite neighborhood instances, Pi.single summation and histogram fiber sums were repaired with kernel testing.

Pinned mathlib was searched for graph, distribution, coupling/local-limit and Efron–Stein ingredients. External **TauCeti EfronStein.lean @5751803d0d3f768fc94c2302ed16587b6965d347** was fully read; toolchain matches v4.36.0-rc2. It is a plausible proved ingredient for a later probability setup, not incorporated or asserted as an already validated dependency of this project. Its exact coordinate-product requirements still need to be instantiated and its transitive axioms audited. Code search for Le Cam did not produce the required specific coupling theorem.

Still unproved: uniform Poisson-binomial/local-bound route, all conditional threshold distributions/atoms, bounded-cost anti-diagonal generation, independent-product law and discrepancy/supply bounds, greedy vertex-disjoint realization, parity-compatible q construction and hence **Theorem 2.1 including its consequence**. The existing move invariants do not construct coefficients or a graph with the desired counts. Current Lean code is an honestly limited foundation, not an unconditional theorem completion.
