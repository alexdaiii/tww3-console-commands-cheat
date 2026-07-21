# CPPD Crystal Structure — Research Notes
## Goal: Peptide binder design with BoltzGen

---

## 1. The Two Disease-Relevant Polymorphs

Calcium pyrophosphate dihydrate (Ca₂P₂O₇·2H₂O) crystallises in two forms found in human joints:

| Polymorph | Space group | System | In vivo role |
|---|---|---|---|
| **t-CPPD** (triclinic) | P1̄ (No. 2) | Triclinic | Chronic, low-grade, more common in asymptomatic deposition |
| **m-CPPD** (monoclinic) | P2₁/n | Monoclinic | Enriched in acute inflammatory flares (pseudogout) |

The monoclinic structure (m-CPPD) was definitively solved only in 2016 — the triclinic form had been known since Mandel 1975. This lateness explains why so much older literature treated CPPD as a single entity.

---

## 2. Crystal Structure Sources — Where to Get CIF Files

### Primary crystallographic references

**m-CPPD (monoclinic, space group P2₁/n)**
- Gras P, Rey C, André G, Charvillat C, Sarda S, Combes C. (2016).
  *Crystal structure of monoclinic calcium pyrophosphate dihydrate (m-CPPD) involved in inflammatory reactions and osteoarthritis.*
  Acta Crystallogr B Struct Sci Cryst Eng Mater. 72(Pt 1):96–101.
  DOI: [10.1107/S2052520615021563](https://doi.org/10.1107/S2052520615021563)
  → **CIF is deposited as IUCr supplementary material; downloadable directly from the journal page above.**

**t-CPPD (triclinic, space group P1̄)**
- Mandel NS. (1975).
  *The crystal structure of calcium pyrophosphate dihydrate.*
  Acta Crystallogr B. 31:1730–1734.
  DOI: [10.1107/S0567740875006176](https://doi.org/10.1107/S0567740875006176)
  → **CIF available via IUCr supplementary or deposited databases.**

### Database search links (free CIF access)

| Database | URL | Notes |
|---|---|---|
| **Crystallography Open Database (COD)** | http://www.crystallography.net/cod/ | Free, open. Search: `calcium pyrophosphate dihydrate` |
| **American Mineralogist Crystal Structure Database** | http://rruff.geo.arizona.edu/AMS/amcsd.php | Free. CPPD is treated as a biomineral here |
| **CCDC CSD** | https://www.ccdc.cam.ac.uk/structures/ | Subscription; Gras 2016 CIF deposited here |
| **ICSD** | https://icsd.fiz-karlsruhe.de/ | Subscription; best for inorganic phases |

> **Practical tip for BoltzGen**: IUCr journals (Acta Crystallographica) make CIF files freely available as supplementary data. The Gras 2016 and Mandel 1975 CIFs should be the most authoritative inputs — download them directly from the DOI links above. The COD is the quickest free option if the IUCr page requires authentication.

---

## 3. Claim Validation

### Claim A: "Two polymorphs in joints — triclinic (P1̄) and monoclinic"
**STATUS: ✅ CONFIRMED**

Both polymorphs are robustly documented in synovial fluid and joint tissue by multiple independent groups. The space groups are confirmed crystallographically:
- t-CPPD P1̄: Mandel 1975
- m-CPPD P2₁/n: Gras et al. 2016

See also: Swan et al. 1995 (clinical XRD from synovial fluid); Campillo-Gimenez et al. 2018 (synthesised pure phases of both for in vitro work).

---

### Claim B: "Monoclinic form is more inflammatory"
**STATUS: ✅ STRONGLY CONFIRMED — direct experimental evidence**

Campillo-Gimenez et al. (2018, *Front Immunol*, PMC6189479) is the definitive paper:
- Tested m-CPPD, t-CPPD, m-CPPTβ (a precursor), and amorphous CPP against THP-1 monocytes and NLRP3 KO mouse macrophages.
- **m-CPPD induced faster and greater IL-1β, IL-6, IL-8 production than t-CPPD, m-CPPTβ, or even monosodium urate (MSU, the gout crystal).**
- m-CPPD also triggered stronger NF-κB, p38, ERK1/2, and JNK MAPK activation.
- In vivo (murine air pouch model): m-CPPD produced more IL-1β, CXCL1, and neutrophil infiltration.

Clinical corroboration: Swan et al. (1995, *Ann Rheum Dis*) aspirated SF during and after acute pseudogout attacks in 9 patients. Acute-attack samples consistently had a **higher monoclinic:triclinic ratio** (by both HRTEM morphology and XRD densitometry).

---

### Claim C: "Attributed to larger reactive surface area for engaging immune mediators (complement, IgG, NLRP3 inflammasome)"
**STATUS: ⚠️ PARTIALLY CORRECT — the NLRP3 part holds; the surface area mechanism does NOT**

**NLRP3 inflammasome** — ✅ CONFIRMED:
- Campillo-Gimenez 2018 directly showed IL-1β production from all crystalline CPP phases (m-CPPD, t-CPPD, m-CPPTβ) is NLRP3-dependent, using NLRP3 KO macrophages (Fig. 5 of that paper). This is a clean genetic knockout experiment.

**Larger reactive surface area as the mechanism** — ❌ NOT SUPPORTED:
- Campillo-Gimenez 2018 explicitly measured specific surface area (BET method, nitrogen adsorption) for all four CPP phases and ran a Spearman correlation against IL-1β/IL-8 production.
- **Result: no correlation between SSA and inflammatory potential** (Fig. 3B of that paper).
- The actual mechanism driver appears to be **polymorph-specific differences in crystal surface chemistry / charge / protein adsorption patterns** that differentially activate the MAPK→NF-κB axis. The molecular basis of this differential activation is described by the authors as "ongoing" investigation.
- Complement and IgG as mediators: referenced in the pseudogout literature generally, but this specific paper does not attribute the monoclinic/triclinic difference to differential complement or IgG engagement. That mechanism is inferred from older literature on crystal-induced inflammation in general.

> **For BoltzGen design**: the relevant surface is the crystal face, not a single molecule. The differential inflammatory behaviour is likely tied to which crystal faces are most exposed and what proteins adsorb. The CIF will give you the unit cell; you'd want to model crystal habit (dominant faces) from the published SEM morphology in Gras 2016 and Swan 1995.

---

### Claim D: "Smaller crystals more readily phagocytosed and trigger acute flare"
**STATUS: ⚠️ MECHANISTICALLY SUPPORTED but in-vivo picture is more complex**

- **In vitro**: Smaller crystals are more efficiently internalized by monocytes/macrophages, and the amount of internalized material correlates with IL-1β production (cited in Campillo-Gimenez 2018). This supports the phagocytosis-NLRP3 axis.
- **In vivo (Swan 1995)**: During actual acute attacks, crystals in SF were **larger** on average than during remission — so in the clinical setting, the acute-flare crystals are not the smaller ones. The key variable in acute flares was the **higher proportion of monoclinic**, not smaller size.
- Interpretation: size and polymorph are somewhat independent variables. Smaller crystals of any polymorph are more efficiently internalised; separately, the monoclinic polymorph is intrinsically more inflammatory regardless of size.

---

## 4. Additional Structural Context

- **Precursor phases** (relevant if modelling crystal nucleation):
  - Amorphous CPP (a-CPP) → precursor to t-CPPD in vitro; not inflammatory (Campillo-Gimenez 2018)
  - m-CPP tetrahydrate β (m-CPPTβ) → precursor to m-CPPD; mildly inflammatory
  - Dehydration pathway: Ca₂P₂O₇·2H₂O → Ca₂P₂O₇·H₂O (monohydrate) → Ca₂P₂O₇. Gras 2014 solved the monohydrate intermediate structure.

- **Raman fingerprinting** (relevant for identifying polymorph in tissue sections):
  - t-CPPD: symmetric P–O stretch at **1049 cm⁻¹**
  - m-CPPD: symmetric P–O stretch at **1045 cm⁻¹**
  - m-CPPTβ: 1036 cm⁻¹
  - (Sirotti 2024, citing Niessink et al.)

---

## 5. Crystal Morphology and Size (from SEM, Campillo-Gimenez 2018)

| Polymorph | Length | Max width | Shape | Notes |
|---|---|---|---|---|
| **m-CPPD** | 1–25 µm | **1 µm** | Needles | Thinnest; most dispersed in fluid; don't clump |
| **t-CPPD** | 1–30 µm | 5 µm | Rectangular rods | Chunkier; tend to form bundles |
| m-CPPTβ | up to 15 µm | — | Faceted plates | Precursor phase |
| a-CPP | — | ~100 nm | Round aggregated microparticles | Amorphous; non-inflammatory |

Reference cell sizes: macrophage ~15–20 µm, neutrophil ~10–12 µm.

**Why m-CPPD is more readily internalised despite similar length**: its 1 µm width makes it a thin needle easy for a cell to engulf. t-CPPD at 5 µm wide is five times broader — harder to wrap a membrane around.

**Why the shape reflects the structure**: on m-CPPD the pyrophosphate groups sit nearly **parallel to the dominant crystal face** (i.e., exposed like flat bristles). This surface arrangement is unique to the monoclinic packing and is the likely reason m-CPPD interacts more aggressively with cell membranes. Shape and inflammatory potency both come from the same underlying crystal geometry — they are not coincidental.

---

## 6. What Happens When a Cell Tries to Digest a Crystal

CPPD crystals are **never degraded** by lysosomes. No enzyme cleaves Ca–P bonds at physiological or lysosomal pH. The crystal enters whole and stays whole.

The sequence from Sirotti 2024:
1. Macrophage/neutrophil engulfs a small/thin enough crystal → phagosome forms
2. Lysosome fuses → attempts digestion → **fails**
3. Crystal physically **ruptures the lysosomal membrane** from inside
4. K⁺ efflux + ATP release + ROS → **NLRP3 inflammasome assembly**
5. Caspase-1 → IL-1β secretion → neutrophil recruitment → acute flare
6. Crystal remains in joint indefinitely — no clearance mechanism

**Critical finding: phagocytosis is not required** (Hari et al., cited in Campillo-Gimenez 2018):
> MSU crystals trapped to the bottom of a culture plate with epoxy still activated macrophage inflammasome and IL-1β production — the crystal never entered the cell.

The crystal triggers MAPK and intracellular Ca²⁺ signalling **within 1 minute** of touching the plasma membrane. Direct membrane contact is enough. The lysosomal rupture mechanism is an additional, downstream amplifier — not the primary trigger.

---

## 7. Protein Coating — Increases or Decreases Inflammation?

The effect of protein coating is **polymorph-specific and protein-specific** — there is no universal answer.

Key finding from Campillo-Gimenez 2018 on IgG coating:

| Crystal | + IgG coating | Effect |
|---|---|---|
| t-CPPD | + IgG | **MORE** inflammatory than bare t-CPPD |
| m-CPPD | + IgG | **LESS** inflammatory than bare m-CPPD |

Also: apolipoprotein B coating on MSU crystals **abolishes** their inflammatory potential entirely.

**Why IgG makes t-CPPD worse**: the Fc tail of IgG is exposed and recruits macrophages via Fc receptors — essentially flagging the crystal as a target.

**Why IgG dampens m-CPPD**: m-CPPD already has exposed pyrophosphates that drive direct membrane disruption. IgG physically occupying that face blocks that interaction. The dampening outweighs the Fc-receptor recruitment effect.

**Implication**: physically occupying the dominant m-CPPD face reduces inflammation. IgG proves the concept but brings immune-activating Fc baggage. A designed peptide could achieve the blocking effect without Fc-mediated recruitment.

**Risk**: if a designed peptide happens to look like an opsonin or has positively charged residues that increase internalisation, it could make inflammation worse. Design must avoid opsonin-like sequences; net charge should be neutral or negative (Campillo-Gimenez 2018 cites evidence that >80% of positively charged particles are internalised within 1 h vs <5% of negatively charged ones).

---

## 8. Dissolving or Shrinking the Crystals — Current State

Crystals persist in cartilage for years; there is **no approved therapy that dissolves CPPD crystals**. Current approaches:

| Approach | Logic | Status |
|---|---|---|
| **Reduce PPi** (probenecid, ANKH inhibition) | Starve the crystal of its building block; stops growth; may allow slow resorption | First clinical trial (Sirotti 2024) — no meaningful clinical impact |
| **Magnesium supplementation** | Mg²⁺ competes with Ca²⁺ in the lattice, destabilises the crystal | Preclinical evidence; no strong RCT |
| **Alkaline phosphatase (TNAP / asfotase alfa)** | Converts PPi → Pi, removing the substrate | Approved for hypophosphatasia; not tested for CPPD dissolution |
| **Extracorporeal shock wave (ESWT)** | Physical fragmentation — like lithotripsy for kidney stones | Established for tendon calcifications (hydroxyapatite); very limited CPPD data |
| **Joint lavage / aspiration** | Flushes free crystals from synovial fluid | Works transiently for acute flares; doesn't reach cartilage deposits |
| **IL-1β blockade (anakinra, canakinumab)** | Mutes the immune response; doesn't touch the crystal | Works clinically for flares but crystals remain; reflare when drug stops |

**Why making crystals smaller is not obviously safer**: the amorphous phase (100 nm) is non-inflammatory only because of its different surface chemistry — not its size. Breaking a 20 µm crystal into 200 nm fragments would massively increase total surface area and potentially increase IL-1β output. Fragment size reduction ≠ reduced danger for CPPD.

---

## 9. BoltzGen Peptide Strategy — Two Distinct Approaches

### Strategy A: Crystal growth inhibitor (preventive)
- Target: the nucleation/growth step, specifically the m-CPPD dominant face
- Analogy: statherin and osteopontin cap hydroxyapatite crystal faces in teeth/bone
- Method: model the m-CPPD surface slab from the Gras 2016 CIF → design peptide to fit the periodic pyrophosphate/Ca²⁺ pattern → BoltzGen
- Goal: cap the growing face, prevent crystals from reaching inflammatory size threshold

### Strategy B: Anti-inflammatory surface coat (therapeutic)
- Target: mature m-CPPD, dominant pyrophosphate-exposed face
- Goal: block direct membrane interaction that fires MAPK within 1 min, without recruiting immune cells
- Must avoid: Fc-like sequences, opsonin motifs, positively charged residues
- IgG proof-of-concept: occupying the m-CPPD face does reduce inflammation — a peptide without Fc baggage should do it cleaner

**Strategy A is probably more tractable for BoltzGen** because it targets a defined crystal surface at the nucleation stage and the periodic surface pattern from the CIF is well-defined. Strategy B requires also reasoning about what is absent from the peptide (no immune-activating signals).

---

## 10. Key Papers Summary

| # | Paper | What it validates |
|---|---|---|
| [1] | Mandel 1975 (Acta Cryst B) | t-CPPD crystal structure, space group P1̄ |
| [2] | Gras 2016 (Acta Cryst B) | m-CPPD crystal structure, space group P2₁/n; CIF source |
| [3] | Ley-Ngardigal 2017 (Cryst Growth Des) | t-CPPD precipitation conditions and ionic additives |
| [4] | Gras 2014 (Acta Cryst C) | Monohydrate intermediate structure |
| [5] | Swan 1995 (Ann Rheum Dis) | Clinical: more m-CPPD in acute flares; crystal size/load |
| [6] | Campillo-Gimenez 2018 (Front Immunol) | m-CPPD most inflammatory; NLRP3 confirmed; surface area NOT the driver |
| [7] | Winternitz 2005 (Rheumatol Int) | m-CPPD interaction with neutrophils specifically |
| [8] | Sirotti 2024 (Curr Rheumatol Rep) | Current review; Raman fingerprinting; clinical context |
