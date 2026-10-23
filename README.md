# Knowledge base

## Linux

### Specs

- [The Single UNIX Specification (overview)](https://www.unix.org/overview.html)
- [POSIX.1-2024 (SUSv5, Issue 8)](https://pubs.opengroup.org/onlinepubs/9799919799/)

### Kernel

- [Linux kernel source (main repo)](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git)
- [Linux kernel (GitHub mirror)](https://github.com/torvalds/linux)
- [Linux kernel coding style](https://docs.kernel.org/process/coding-style.html)
- [The Linux Kernel documentation](https://docs.kernel.org/)
- [Kernelnewbies](https://kernelnewbies.org/) — Linux kernel for beginners
- [System V AMD64 ABI](https://gitlab.com/x86-psABIs/x86-64-ABI)

### Arch Linux

- [Arch Linux Instruction](docs/archinstr.md)
- [TermuxArch Instruction](docs/termuxarchinstr.md)
- [dots](dots)

---

## C/C++

### Reference

- [cppreference](https://en.cppreference.com)
- [WG14 - C](https://www.open-std.org/JTC1/SC22/WG14/)
- [WG21 - C++](https://www.open-std.org/JTC1/SC22/WG21/)
- [Intel Intrinsics Guide (mirror)](https://www.laruence.com/sse/) — x86
  vector instructions (SIMD: SSE/AVX/AVX-512): many values per instruction,
  for parallel math

### Standard Library

- [C standard library (glibc)](https://sourceware.org/glibc/) — GNU C Library,
  (default C library on Linux)
- [libstdc++ (GCC)](https://gcc.gnu.org/onlinedocs/libstdc++/) — C++ stdlib
  (GCC); headers: `/usr/include/c++/<version>/` (default for gcc/clang)
- [libc++ (LLVM)](https://libcxx.llvm.org/) — C++ stdlib (Clang);
  headers: `/usr/include/c++/v1/` (optional, `-stdlib=libc++`)

### Tools

- [gcc](https://gcc.gnu.org/onlinedocs/) — compiler
- [clang](https://clang.llvm.org/) — compiler
- [ccls](https://github.com/MaskRay/ccls) — language server
- [clangd](https://clangd.llvm.org/) — language server
- [make](https://www.gnu.org/software/make/) — build tool (Makefile)
- [Makefile Tutorial](https://makefiletutorial.com/)
- [CMake](https://cmake.org/) — build system (generates Makefile/Ninja/etc.)
- [gdb](https://sourceware.org/gdb/) — debugger
- [Doxygen](https://www.doxygen.nl/) — documentation generator

### C

#### Learning

- [Beej's Guide to C Programming (modern C)](https://beej.us/guide/bgc/)
- [Modern C (Jens Gustedt)](https://gustedt.gitlabpages.inria.fr/modern-c/)
- [NASA C Style Guide (SEL-94-003, 1994)](https://ntrs.nasa.gov/api/citations/19950022400/downloads/19950022400.pdf)

### C++

#### Learning

- [awesome-cpp](https://github.com/fffaraz/awesome-cpp) — curated C/C++ resources
- [stroustrup.com](https://www.stroustrup.com/)
- [isocpp.org](https://isocpp.org/) — C++ news, status, discussion
- [C++ Core Guidelines](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines)
- [cplusplus](https://cplusplus.com/) — tutorials/reference/articles
- [learncpp](https://www.learncpp.com/) — tutorials
- [CS 61 (Harvard)](https://cs61.seas.harvard.edu/site/2026/) — systems
  programming course (C/C++/asm)

#### Tools

- [Conan](https://conan.io/) — package manager

#### Libraries

- [Boost](https://www.boost.org/) — general-purpose libraries

#### Frameworks

- [userver](https://userver.tech/) — asynchronous framework (microservices)
- [Qt](https://doc.qt.io/) — cross-platform framework (GUI, network, etc.)

#### Testing

- [GoogleTest](https://github.com/google/googletest) — testing framework
- [Catch2](https://github.com/catchorg/Catch2) — testing framework

---

## JS/TS/Node

- [JS tutorial](https://javascript.info/)
- [TS docs](https://www.typescriptlang.org/)
- [MDN Web Docs](https://developer.mozilla.org/) — JS/Web API reference
- [W3C standards](https://www.w3.org/TR/) — web standards
  (HTML, CSS, SVG, WebAPI, XML, etc.)

### JavaScript runtime

- [Node.js](https://nodejs.org/)

### Tools

- [npm](https://www.npmjs.com/) — package registry
- [Webpack](https://webpack.js.org/) — bundler
- [Vite](https://vitejs.dev/) — bundler
- [typescript-language-server](https://github.com/typescript-language-server/typescript-language-server)
- [TypeDoc](https://typedoc.org/) — documentation generator

### Libraries

- [React](https://react.dev/) — UI library (browser)
- [TypeORM](https://typeorm.io/) — ORM for SQL databases (Node.js)

### Frameworks

- [Express](https://expressjs.com/) — minimal Node.js web framework
  (routing, middleware) for REST/HTTP servers
- [Nest](https://nestjs.com/) — structured Node.js framework
  (modules, DI) for server-side apps, built on Express

### Transport

- [ws](https://github.com/websockets/ws) — lightweight WebSocket implementation
  (RFC 6455)
- [socket.io](https://socket.io/) — WebSocket with reconnection, rooms,
  HTTP long-polling fallback
- [@grpc/grpc-js](https://github.com/grpc/grpc-node) — gRPC for Node.js
  (contract-first via .proto)
- `fetch` — built-in HTTP client (Node.js v18+)
- [axios](https://axios-http.com/) — HTTP client library
  (interceptors, cancellation)

---

## Erlang

- [Erlang](https://www.erlang.org/)

### Erlang runtime

- [The BEAM Book: Understanding the Erlang Runtime System](https://blog.stenmans.org/theBeamBook/)

### Tools

- [Hex](https://hex.pm/) — package registry
- [Rebar3](https://rebar3.org) — build tool
- [ELP](https://whatsapp.github.io/erlang-language-platform/) — language server
- [rebar3_ex_doc](https://hex.pm/packages/rebar3_ex_doc) — documentation generator

### Transport

- [cowboy](https://github.com/ninenines/cowboy) — HTTP server
- [gun](https://github.com/ninenines/gun) — HTTP/WebSocket client

---

## DB

- [PostgreSQL](https://www.postgresql.org/docs/)
- [PostgreSQL client driver](https://wiki.postgresql.org/wiki/List_of_drivers)
- [TimescaleDB](https://github.com/timescale/timescaledb) — time-series extension
  for PostgreSQL

---

## Markdown

### Specs

- [Daring Fireball: Markdown](https://daringfireball.net/projects/markdown/) —
  Markdown 1.0.1 (2004) by John Gruber: the spec and first implementation
- [CommonMark](https://commonmark.org/) — community standard (since 2014),
  formal spec with test suite
- [GitHub Flavored Markdown (GFM)](https://github.github.com/gfm/) — GitHub's
  extensions spec

---

## Protocols

### Trading

#### FIX

**Technical Standards (by layer):**

> FIX uses numeric tags. Tag dictionary (formerly FIXimate):
> [Orchimate](https://orchimate.org/fixtrading/fix-latest).

- [FIX Protocol](https://fixtrading.org/standards/fix-protocol/).
  - **7 Application Layer:** choose the version (FIX 4.2/4.4/Latest) and
  the business intent (e.g. "buy 100 AAPL" as `35=D|55=AAPL|38=100`).
- [FIX Encoding Standards](https://fixtrading.org/standards/technical-standards/).
  - **6 Presentation Layer:** how to write it down: TagValue (ISO 3531-1),
  SBE (ISO 25390), FAST, FIXML, JSON, GPB, ASN.1
  (e.g. `35=D|55=AAPL` as text vs the same as SBE binary).
  - **5 Session Layer:** how to maintain the connection: classic (ISO 3531-2),
  FIXP, SOFH, WebSocket. Adds sequence numbers and control messages.
  (e.g. `8=FIX.4.4|35=A|34=1` (Logon), `8=FIX.4.4|35=D|34=2` (order),
  `8=FIX.4.4|35=8|34=3` (execution)).
  > Session flow: `34=1` (Logon) → `34=2` (order) → `34=3` (execution).
  > If a gap occurs (e.g. received `34=3` but expected `34=2`), the receiver
  > sends Resend Request to recover the missing message (seq 2).
  >
  > The same tags change meaning by layer, e.g. `35=MsgType`:
  > `35=D` NewOrder, `35=8` ExecutionReport (app layer);
  > `35=A` Logon (session layer).
  > Fixed tags: `55=Symbol`, `38=OrderQty`, `34=MsgSeqNum`.
  - **4 Transport Layer:** how bytes go over the wire. Usually just a TCP socket.
  **FIXS (FIX over TLS)** is a standard/profile: it specifies *how* to use TLS
  with FIX (cipher suites, certificates, auth) to ensure interoperability and
  a minimum security level. You still use a regular TLS library; FIXS defines
  the rules. Optional FIXA = client auth inside the TLS tunnel at session level.
  UDP/Multicast — only for low-latency market data, not for order entry.

> FIX covers OSI layers 4–7 (Transport, Session, Presentation, Application).
> Layers 1–3 (Physical, Data Link, Network) are handled by the OS and network
> provider, not by FIX standards.

**Machine readable rules of engagement:**

- [FIX Orchestra](https://fixtrading.org/standards/orchestra/) — standard for
  machine-readable rules of engagement: what messages, fields, and workflows a
  venue supports (not limited to FIX). The Orchestra file is metadata (XML)
  that code reads: primarily at design/compile time to generate
  code/configs/tests per venue (one runtime for multiple venues), and also at
  runtime to validate, normalize, and apply conditional logic.

### Networking

- [Beej's Guide to Network Programming](https://beej.us/guide/bgnet/) — sockets,
  TCP/IP

### RFCs

- [RFC Editor](https://www.rfc-editor.org/)
- [IETF standards](https://datatracker.ietf.org/)

### RPC

- [Nelson B.J. Remote procedure call](https://bitsavers.org/pdf/xerox/parc/techReports/CSL-81-9_Remote_Procedure_Call.pdf)
- [Birrell A.D., Nelson B.J. Implementing remote procedure calls](https://dl.acm.org/doi/pdf/10.1145/2080.357392)
- [RFC 5531 — ONC RPC (Sun RPC) v2](https://datatracker.ietf.org/doc/html/rfc5531)
- [gRPC Docs](https://grpc.io/docs/) — Google's RPC framework
- [Protobuf](https://protobuf.dev/) — IDL for gRPC

---

## Tools

### Docker

- [Docker](https://docs.docker.com/)
- [Docker Hub](https://hub.docker.com/)

### Git

- [Git](https://git-scm.com/docs)
- [Visual Git Reference](https://marklodato.github.io/visual-git-guide)
- [Conventional Commits](https://www.conventionalcommits.org/) — commit message
  standard (evolved from Angular)
- [Angular commit style](https://github.com/angular/angular/blob/main/contributing-docs/commit-message-guidelines.md) —
  commit message format (Angular 2+)
- [AngularJS commit style](https://github.com/angular/angular.js/blob/master/DEVELOPERS.md#commit-message-format) —
  commit message format (AngularJS 1.x, legacy)
- [DeepWiki](https://deepwiki.com/) — AI-generated docs for GitHub repos

### Vim

- [Vim Tips Wiki (Fandom)](https://vim.fandom.com/wiki/Vim_Tips_Wiki)
- [ViEmu: Graphical vi-vim Cheat Sheet and Tutorial](https://web.archive.org/web/20191003022409/http://www.viemu.com/a_vi_vim_graphical_cheat_sheet_tutorial.html)
- [coc.nvim](https://cocnvim.com/) — IntelliSense engine (LSP, completion, diagnostics)
- [Vimspector](https://puremourning.github.io/vimspector-web/) — debugger for Vim (DAP)
- [Tmux Cheat Sheet](https://tmuxcheatsheet.com/)

### Misc

- [Mermaid](https://mermaid.ai/open-source/) — diagrams from text (GitHub native)
- [ctags](https://docs.ctags.io/) — code navigation tags
  (check langs: `ctags --list-languages | grep -E 'C\+\+|TypeScript'`;
  check maps: `ctags --list-maps | grep -E '^TypeScript'`;
  verify: `ctags --map-TypeScript=+.tsx --list-maps | grep -E '^TypeScript'`;
  index libstdc++/libc++ headers: `ctags -R /usr/include/c++/`;
  index `.ts`/`.tsx`: `ctags --map-TypeScript=+.tsx -R /path/to/proj`;
  persist (optional): `~/.ctags.d/typescript.ctags`)

---

## AI

### Open Models

- [Ollama](https://ollama.com/)
- [LM Studio](https://lmstudio.ai/)

### Agents

- [OpenCode](https://opencode.ai/)
- [OpenClaw](https://openclaw.ai/)

### MCP

- [Model Context Protocol](https://modelcontextprotocol.io/)

---

## News

- [Hacker News](https://news.ycombinator.com/)
- [Linux Weekly News (LWN)](https://lwn.net/)

---

## Publications

- [arXiv](https://arxiv.org/) — preprints (q-fin, etc.)

### Quantitative Finance (q-fin)

- [Khorkin, D.A. (2023). Technical Analysis of Volatility (working paper). Language: English](docs/papers/khorkin_taov_2023_wp_eng.pdf)
- [Khorkin, D.A. (2023). Technical Analysis of Volatility (working paper). Language: Russian](docs/papers/khorkin_taov_2023_wp_rus.pdf)

### Computer Science (cs)

- [Song J., Alves-Foss J. Performance Review of Zero Copy Techniques. IJCSS, 6(4), 2012](https://www.cscjournals.org/manuscript/Journals/IJCSS/Volume6/Issue4/IJCSS-756.pdf)
- [Streicher M. Speaking UNIX: Interprocess communication with shared memory (2010)](https://public.dhe.ibm.com/software/dw/aix/au-spunix_sharedmemory-pdf.pdf)

---

## Problems

- [Project Euler](https://projecteuler.net/) — math/algorithm problems

---

## Licenses

- [SPDX](https://spdx.org/licenses/) — license identifiers
- [choosealicense](https://choosealicense.com/)
