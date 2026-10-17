# L1 Cache Model - 1 - version1.0

## 1. Introduction

This project implements a small, educational Level-1 (L1) cache using Verilog. An L1 cache keeps copies of recently accessed memory data close to the processor so that repeated reads can be served without accessing the backing memory every time.

The model is intentionally small: four cache lines, one byte per line, and a four-bit address. The purpose is to understand the architecture and the relationship between an address, its tag, its index, the valid bit, a hit, and a miss before moving to a more realistic cache.

## 2. Problem Statement

A processor needs data stored in main memory. Reading the backing memory on every request can take more time than reading a small cache. Build a model that:

- accepts a read request containing a 4-bit address;
- checks whether the selected cache line contains data for that address;
- returns the cached byte on a hit;
- fetches the byte from main memory and fills the cache line on a miss;
- uses a valid bit to distinguish an empty line from a line containing usable data.

This is a read-only teaching model. It does not implement processor writes, dirty bits, write-through/write-back policies, or multiple cache levels.

## 3. Design Specification

| Parameter | Specification |
|---|---|
| Address width | 4 bits |
| Main-memory depth | 16 byte locations |
| Main-memory capacity | 16 × 8 = 128 bits (16 bytes) |
| Data width | 8 bits (1 byte) |
| Cache organization | Direct-mapped |
| Number of cache lines | 4 |
| Bytes per cache line | 1 |
| Cache data capacity | 4 × 8 = 32 bits (4 bytes) |
| Tag width | 2 bits |
| Index width | 2 bits |
| Offset width | 0 bits |
| Cache metadata | One 2-bit tag and one valid bit per line |
| Request type | Read only |
| Backing-memory model | Initialized Verilog array with asynchronous read access |
| Controller | Four-state FSM: IDLE, LOOKUP, REFILL, RESP |

### Why are there no offset bits?

Each cache line stores exactly one byte, and each address identifies one byte. There is no choice of byte inside a line, so the offset field has zero bits.

## 4. Address Breakdown

The 4-bit address is divided into a 2-bit tag and a 2-bit index:

```text
  3       2 1       0
 +---------+---------+
 |   TAG   |  INDEX  |
 +---------+---------+
    2 bits   2 bits
```

- **Index (`address[1:0]`)** selects one of the four cache lines.
- **Tag (`address[3:2]`)** identifies which of the four possible memory addresses sharing that index is currently stored there.
- **Valid bit** tells us whether the cache line contains usable data.
- **Data** is the actual byte stored in that line.

Example:

| Address | Binary | Tag | Index |
|---:|---|---|---|
| 2 | `0010` | `00` | `10` (line 2) |
| 6 | `0110` | `01` | `10` (line 2) |

Addresses 2 and 6 map to the same cache line. The index selects the line, but the tag distinguishes the addresses.

A hit occurs only when both conditions are true:

```text
cache_valid[index] == 1
AND
cache_tag[index] == requested_tag
```

If either condition is false, the request is a miss.

## 5. Methodology

1. **Accept request:** In `IDLE`, the controller captures the address when `req_valid` is high.
2. **Look up:** In `LOOKUP`, use the saved address's index to select a cache line.
3. **Compare metadata:** Check the selected line's valid bit and stored tag.
4. **Hit path:** If valid and tag match, copy the cache data to the response register.
5. **Miss path:** If not, enter `REFILL`; read the requested byte from the modeled main memory and store the byte, tag, and valid bit in the selected cache line.
6. **Respond:** In `RESP`, assert `resp_valid` for a cycle and return to `IDLE`.

The cache line is updated only on a miss. On a miss, another address with the same index may replace the old line; this is the expected behavior of a direct-mapped cache.

## 6. Why This Method? (Beginner Perspective)

A direct-mapped cache is the simplest useful cache organization to learn because every memory address has exactly one possible cache line. There is no need to search multiple lines.

The address is split into an index and a tag because these fields answer two different questions:

- **Index:** Where should I look?
- **Tag:** Is the data in that location actually for my requested address?

The valid bit is needed because the tag and data arrays may contain arbitrary or reset values before a line has been filled. A matching tag alone must not be treated as a hit when the valid bit is zero.

The FSM makes the sequence visible in simulation: accept request → look up → refill if needed → respond. This is easier to debug than trying to combine every operation into one large block of logic.

## 7. Architecture and Signal Interface

### Inputs

- `clk`: rising-edge clock.
- `rst`: synchronous, active-high reset.
- `req_valid`: the requester presents a read request.
- `req_addr[3:0]`: byte address.

### Outputs

- `req_ready`: high while the cache is in `IDLE` and can accept a request.
- `resp_valid`: indicates that `resp_data` contains the completed response.
- `resp_data[7:0]`: returned byte.
- `hit`: one-cycle event indicator when a lookup hits.
- `miss`: one-cycle event indicator when a lookup misses.

The requester should present `req_valid` while `req_ready` is high and then wait for `resp_valid`. This simple interface handles one outstanding request at a time.

## 8. Files

- `beginner_l1_cache.v` — cache RTL and the initialized backing-memory model.
- `tb_beginner_l1_cache.v` — self-checking testbench.
- `README.md` — this documentation.

## 9. How to Simulate

### Using Icarus Verilog

Run these commands from the project directory:

```bash
iverilog -g2012 -o simv beginner_l1_cache.v tb_beginner_l1_cache.v
vvp simv
```

To inspect the waveform, open `beginner_l1_cache.vcd` with GTKWave:

```bash
gtkwave beginner_l1_cache.vcd
```

The testbench uses `$dumpfile` and `$dumpvars` to generate the waveform.

### Using QuestaSim

```tcl
vlog beginner_l1_cache.v tb_beginner_l1_cache.v
vsim -voptargs=+acc work.tb_beginner_l1_cache
run -all
```

## 10. Expected Test Sequence

The initialized backing memory contains `main_mem[2] = 8'hF0` and `main_mem[6] = 8'h77`.

1. Read address 2 (`0010`): miss, fetch `F0`, fill line 2 with tag `00`.
2. Read address 2 again: hit, return `F0`.
3. Read address 6 (`0110`): miss because it shares line 2 but has tag `01`; return `77` and replace line 2.
4. Read address 2 again: miss because address 6 replaced its line; return `F0` and refill it.

The testbench prints `PASS` for each returned data value and prints the final hit/miss event counts. Exact timestamps depend on simulator scheduling.

## 11. Limitations and Important Notes

- This is a functional learning model, not a timing-accurate model of a physical L1 cache or SRAM macro.
- The backing memory is an initialized Verilog array and is read asynchronously in the `REFILL` state. Real SRAMs commonly have different read timing and may require additional wait states.
- Main-memory initialization is for simulation. A real implementation needs a defined memory initialization or loading strategy.
- The model is read-only. Stores, byte enables, dirty bits, write policies, burst fills, replacement policies for set-associative caches, and CPU pipeline integration are not included.
- There is one outstanding request at a time. It does not model multiple outstanding misses, coherence, or virtual-to-physical address translation.
- `hit` and `miss` are one-cycle lookup-event indicators; `resp_valid` marks the response cycle. The first access after reset is expected to miss because all valid bits are cleared.

## 12. Future Work

- Extend each cache line to a multi-byte block and add offset bits, then implement burst refill from main memory.
- Add processor writes with a clearly defined write-through or write-back policy, and verify the behavior with a larger testbench.
