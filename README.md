# Mandelbrot Fractal Set Graphic

### Program Overview:
**Title:** `mandelbrot`  
**Purpose:** Compute the iterative behavior of points under the Mandelbrot set formula to determine boundedness or divergence.  
**Environment:** The program uses assembly language, likely targeting a specific processor or microcontroller.  

---

### Program Components:

1. **Directives and Initialization:**
   - `ORG $1000`: The program begins execution at memory address `$1000`, indicating a fixed starting point for the code.
   - `INCBIN 'N4.BIN'`: Includes binary data from an external file (`N4.BIN`), providing configuration parameters or initial data for the computation.
   - `FP_mul EQU $1088`: Defines the memory address of a fixed-point multiplication subroutine, critical for performing precise arithmetic operations without floating-point hardware.

2. **Subroutine: Iterate**
   - **Purpose:** Implements the iterative algorithm for the Mandelbrot set.  
   - **Setup:** Allocates stack space with `LINK A6,#-12` and preserves registers using `MOVEM.L`.  
   - **Local Variables:**  
     - Stored in offsets from the stack frame pointer `A6`. For example:
       - `-4(A6)` and `-8(A6)` represent the real and imaginary parts of the current point.  

3. **Iterative Loop (Loop Label):**
   - Executes the Mandelbrot iteration formula \( Z_{n+1} = Z_n^2 + C \), where \( Z \) and \( C \) are complex numbers:
     - **Fixed-Point Multiplication (`JSR FP_mul`):** Performs the square of both the real and imaginary components of \( Z \).  
     - **Addition/Subtraction:** Implements the addition of \( C \) to the squared result to compute the next iteration.  
   - **Exit Conditions:**
     - Compares the iteration count to a predefined maximum (`CMP.L #100,D0`).  
     - Checks divergence by comparing the magnitude of \( Z_n \) against a threshold (`CMP.L #$400000,D0`).  

4. **Memory and Stack Management:**
   - **Push/Pop Registers:** Saves and restores registers around subroutine calls to ensure state integrity (`MOVEM.L` and `ADDQ.L`).  
   - **Stack Frame:** Dynamically manages memory for local variables during execution.

5. **Termination:**
   - If either the maximum iteration count is reached or the divergence threshold is exceeded, the program exits the loop (`ExitLoop` label).

---

### Formal Functionality Description:

The program simulates the iterative process of the Mandelbrot set. For a given point \( C \) (complex number), it computes successive values of \( Z_n \), using fixed-point arithmetic, to determine:
1. Whether \( Z_n \) diverges (escapes to infinity).  
2. If \( Z_n \) remains bounded within a pre-defined threshold after a fixed number of iterations.  

Key mathematical operations include:
- Fixed-point multiplication of real and imaginary components.
- Addition and subtraction to simulate complex number arithmetic.
- Magnitude calculation to assess divergence.

---

### Summary of Execution:

1. Input data for the computation is either hardcoded or loaded from `N4.BIN`.  
2. The `Iterate` subroutine performs the Mandelbrot iteration for each point.  
3. The program tracks the number of iterations and checks boundedness or divergence.  
4. If conditions are met (maximum iterations or divergence), the program exits the loop.  


This program is a low-level implementation of the Mandelbrot computation, focusing on precise arithmetic operations and efficient use of processor resources.
