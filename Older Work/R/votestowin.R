# Import lpSolve package
library(lpSolve)

# Set coefficients of the objective function
f.obj <- c(8, 11, 6, 4)

# Set matrix corresponding to coefficients of constraints by rows
f.con <- matrix(c(5, 7, 10, 3), nrow = 1, byrow = TRUE)

# Set unequality/equality signs
f.dir <- c(">=")

# Set right hand side coefficients
f.rhs <- c(14)

# Final value (z)
lp("min", f.obj, f.con, f.dir, f.rhs, int.vec = 1:4, all.bin = TRUE)