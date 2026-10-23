> **Reference hardware.** All examples and tables in this guide are based
> on an [ASUS ExpertBook B9400CEA](https://wiki.archlinux.org/title/ASUS_ExpertBook_B9450CEA):
> Intel Core i7-1165G7 (4 cores / 8 threads, up to 4.7 GHz), 32 GB RAM,
> Intel Iris Xe (no discrete GPU, so CPU-only inference),
> [Arch Linux](https://archlinux.org/).

## What is quantization?

Quantization is the process of reducing the precision of the numbers
(weights) that make up a neural network. By default, each parameter is
stored as a 16-bit or 32-bit floating-point number (FP16 or FP32).
Quantization reduces this to fewer bits — typically 4, 5, or 8 bits
per parameter.

FP16 (16-bit floating-point, i.e. unquantized) is the standard
"full precision" format for local inference. FP32 (32-bit) also exists,
but it is twice as heavy with no practical quality gain for inference,
so FP16 is used as the baseline.

**Analogy:** Quantization is to LLMs what JPEG compression is to images.
A little quality is lost, but the file becomes much smaller and faster
to process. In LLMs, quantization affects three things: **quality**
(the model's ability to reason and generate coherent text), **size**
(the memory it needs), and **speed** (the inference speed it achieves).

For local inference, the trade-off comes down to two things:
**the model's quality** and **the resources it requires** (RAM and speed).

### Table 1: The trade-off (7B model)

| Precision | Size on disk | Quality loss (perplexity Δ) | RAM (min) |
| --------- | ------------ | --------------------------- | --------- |
| FP16 (16-bit, 2 bytes) | ~13 GB | None (baseline) | ~14 GB |
| Q8 (8-bit, 1 byte) | ~6.7 GB | Near-lossless (+0.0004) | ~7.5 GB |
| Q5 (5-bit, 0.625 bytes) | ~4.5 GB | Small (+0.014) | ~5.5 GB |
| Q4 (4-bit, 0.5 bytes) | ~3.8 GB | Noticeable but acceptable (+0.05) | ~5 GB |
| Q3 (3-bit, 0.375 bytes) | ~3.0 GB | Significant (+0.24) | ~4 GB |
| Q2 (2-bit, 0.25 bytes) | ~2.7 GB | Severe (+0.87) | ~3.5 GB |

*B stands for billion parameters: a "7B model" has ~7 billion weights.
Size = the .gguf file on disk. RAM (min) = memory needed to load the
model with a small context window; a larger context requires additional
memory.*

**Key takeaway:** For CPU-only inference on a laptop, **Q4_K_M** is the
sweet spot — it cuts the model size by ~75% with minimal quality loss,
and it decodes faster on CPU than more aggressive formats (like IQ4_XS).

*All calculations and terminology used above are covered in
[the section "How much RAM does a model need?"](#how-much-ram-does-a-model-need).*

## What is GGUF?

GGUF (GPT-Generated Unified Format) is a file format for storing
a quantized model as a single `.gguf` file. It is not a compressor
or an archiver: the weights inside a GGUF file are already stored
in their quantized form (e.g. 4-bit), and the file also carries
the metadata needed to load and run it: the model name, the
quantization type, the context size, and so on — so tools like
llama.cpp and Ollama know how to use it; this is why `ollama pull`
downloads exactly such a file, and `ollama run` starts it.

## Reading quantization names

A quantization name like `Q4_K_M` encodes three things:
the bit width, the quantization method, and the size variant.
The table below decodes each part.

| Part | Meaning | Examples |
| ---- | ------- | -------- |
| `Q2`–`Q8` | Bits per weight (lower = smaller file, more compression) | `Q4` = ~4 bits per weight |
| `K` | K-quant: grouped/blockwise quantization with per-group scales | `Q4_K_M`, `Q5_K_M` |
| `I` / `IQ` | I-quant: vector quantization for aggressive compression | `IQ4_XS`, `IQ3_M` |
| `_0` / `_1` | Legacy ungrouped formats (symmetric/asymmetric) | `Q4_0`, `Q5_1` |
| `_S` / `_M` / `_L` | Small/Medium/Large: precision mix across tensor types | `Q4_K_S`, `Q4_K_M`, `Q4_K_L` |
| `F16` / `FP16` | Full precision (unquantized) | `F16` |

**A closer look at the terms above:**

- **[K-quant](https://github.com/iuliaturc/gguf-docs/blob/main/k-quants.md)
  (grouped/blockwise).** Instead of using one scale for the whole tensor
  (a tensor is a multi-dimensional array of numbers — for LLMs, the weights
  of a layer), the weights are split into small blocks, and each block gets
  its own scale. This keeps more precision where it matters and is why
  K-quants (e.g. `Q4_K_M`) are the default for local inference.
- **[I-quant](https://github.com/iuliaturc/gguf-docs/blob/main/i-quants.md)
  (vector quantization).** A more aggressive method that treats groups of
  weights as vectors and uses a codebook to compress them. It can optionally
  use an [importance matrix](https://github.com/iuliaturc/gguf-docs/blob/main/importance-matrix.md)
  to give more precision to important weights. It saves more memory but
  decodes slower on CPU.
- **[Legacy](https://github.com/iuliaturc/gguf-docs/blob/main/legacy-quants.md)
  `_0`/`_1`.** The old, simple formats: one scale per block. Symmetric (`_0`)
  uses the same scale for positive and negative weights; asymmetric (`_1`)
  uses separate scales. Superseded by K-quants at the same bit width.
- **`_S`/`_M`/`_L` (size variants).** The same bit width, but with a different
  precision mix: `_S` is more aggressive (smaller file), `_M` is balanced
  (better quality, larger), `_L` keeps the highest precision (largest file,
  where available).
- **[Importance matrix](https://github.com/iuliaturc/gguf-docs/blob/main/importance-matrix.md).**
  A calibration-based method that estimates how much each weight affects
  the model's output. Important weights are reconstructed more accurately,
  so the model keeps more quality at the same bit width. It is not
  a quantization type: it can be applied to legacy, K-, and I-quants.

**What to choose:** for CPU-only inference, K-quants (e.g. `Q4_K_M`,
`Q5_K_M`) are the safe default: they decode faster on CPU than I-quants
and keep quality close to the original. I-quants (`IQ4_XS`, `IQ3_M`)
compress more but decode slower, so they are better suited to
memory-constrained setups where speed is less critical.

## How much RAM does a model need?

The RAM needed to load a model can be estimated with a simple formula:

`RAM ≈ params × bytes/param + KV-cache`

where:

- **params** — the number of parameters (e.g. 7B = 7 × 10⁹)
- **bytes/param** — depends on the quantization (see [Table 1](#table-1-the-trade-off-7b-model))
- **KV-cache** — the memory used to store the context (the conversation
  history and the current input). It grows with the context length.

Simplified estimate: it ignores the runtime overhead of the
inference engine (process buffers, memory alignment, etc.).

**KV-cache (context memory).** This is the memory required to store
the conversation history. It grows linearly with the context length.
The standard formula is:

`KV-cache ≈ 2 × layers × KV_heads × head_dim × context_length × bytes_per_value`

where:

- **2** — because both Keys (K) and Values (V) are stored;
- **layers** — the number of transformer layers;
- **KV_heads** — the number of key/value heads (fewer than query heads
  in models with GQA);
- **head_dim** — the size of one head (usually 128);
- **context_length** — the context size in tokens (e.g. 32,768);
- **bytes_per_value** — 2 bytes for FP16 (the default), 1 byte for INT8.

**Example (Llama-3-8B, 32K context).** Llama-3-8B has 32 layers and 8 KV heads
(thanks to GQA), so:

2 × 32 × 8 × 128 × 32,768 × 2 ≈ 4 GB

**Why GQA matters.** In older models without GQA (e.g. Llama-2-7B),
KV heads equal query heads (32 instead of 8), so the same 32K context costs
~16 GB instead of ~4 GB. Always check `n_kv_heads` in the model config —
it is the main factor for memory efficiency at long contexts.

A 32K context is a common upper bound for local use. Why 32K?
It is 2¹⁵ = 32,768 tokens. Context sizes are powers of two
(1024, 2048, 4096, ..., 32768) because GPU tensor sizes are aligned to
powers of two for efficient tensor-core and memory addressing.

**How many pages is 32K?** The arithmetic depends on the language and the
tokenizer:

- **English:** `1 token ≈ 0.75 words` (`1 word ≈ 1.33 tokens`),
  so 32,768 × 0.75 ≈ 24,576 words. At ~500–700 words per A4 page,
  that is **35–49 pages**.
- **Russian:** Russian words are longer and use more tokens per word —
  `1 token ≈ 0.5–0.65 words` (`1 word ≈ 1.5–2.0 tokens`).
  So 32,768 × 0.55 ≈ 18,000 words. At ~400–500 words per A4 page,
  that is **30–45 pages**.
  > Note: older models (GPT-3.5, early Llama) tokenize Cyrillic worse
  > (~3–4 tokens per word), so the same 32K may cover only ~20 pages.
- **Modern tokenizers** (e.g. tiktoken, Llama 3) are more efficient:
  they pack ~4–5 characters into one token. Since an average English
  word is ~5.5 characters long, this means `1 token ≈ 0.8 words`.
  So 32,768 × 0.8 ≈ 26,200 words, and at ~600 words per A4 page
  that is **~43 pages** (a realistic average for modern dense text).

This matters for API cost too: the longer the context, the more tokens are consumed.

**Table 2: What fits in 32 GB of memory (CPU-only)?**

| Model size | Quantization | Size on disk | RAM (min) | Verdict |
| ---------- | ------------ | ------------ | --------- | ------- |
| 7B | Q4_K_M | ~4 GB | ~5 GB | Comfortable |
| 13B | Q4_K_M | ~7 GB | ~8 GB | Works, slightly slower |
| 27B | Q5 | ~17 GB | ~18 GB | Works, slower |
| 30B | Q4_K_M | ~18 GB | ~19 GB | Works, near the edge |
| 70B | Q4_K_M | ~40 GB | ~42 GB | Does not fit |

*For CPU this is system RAM; for GPU this is VRAM (system RAM is only used
if the model overflows from VRAM).*

**Don't forget the KV-cache!** For a 32K context, add ~2–4 GB of RAM
for modern models (Llama-3, Qwen). Example: a 7B model needs
~5 GB for weights + ~3 GB for a 32K context = ~8 GB total.
