# STATS 506 F24 Midterm - Answer Key

## Problem 1

### a. 

q = 48: selected values are 12, 16, and 20.

### b. 

```r
c(a = 6, b = 160, c = 26)
```

Endpoint sums are 6, 16, 26, multiplied by recycled 1, 10, 1. A recycling warning is expected.

### c. 

```r
c(6, 4, 2)
```

Both row sums are 12; column sums are 6, 8, 10. Recycle 12,12 as 12,12,12 and subtract.

### d. 

q = 20: add 10 + 6 + 3 + 1.

### e. 

q = 1: after aggregation, the y=1 group has v=0; the other groups do not.

### f. 

q = 15: accumulate 5+4+3+2+1 in the recursive state z.

---

## Problem 2

One valid base-R approach is below. Other equivalent solutions are possible. Retain unknown hourly wages in e because the request only removes known wages above $50.

### a. 

```r
mydata$logsal <- log(mydata$annualsalary)
```

### b. 

```r
mydata$female <- mydata$gender == "Female"
mydata$female[mydata$gender == ""] <- NA
```

### c. 

```r
mydata$department <- as.factor(mydata$department)
```

### d. 

```r
mydata$hourlywage <- mydata$annualsalary / 12 / mydata$monthlyhours
```

### e. 

```r
keep <- is.na(mydata$hourlywage) | mydata$hourlywage <= 50
mydata <- mydata[keep, , drop = FALSE]
```

### f. 

```r
mydata$annualsalary <-
  (mydata$annualsalary - mean(mydata$annualsalary, na.rm = TRUE)) /
  sd(mydata$annualsalary, na.rm = TRUE)
```

Assume the nonmissing salary values have nonzero standard deviation.

### g. 

```r
mydata$productivityscore[mydata$productivityscore < 0] <- NA
```

### h. 

```r
bad <- which(mydata$age - mydata$yearsatcompany < 18)
mydata$age[bad] <- NA
mydata$yearsatcompany[bad] <- NA
```

Compute the bad-row indicator once, before changing either variable.

---

## Problem 3

### a. 

```r
lm(y ~ x, data = dat)
```

### b. 

```r
lm(y ~ q*z, data = dat)
```

### c. 

```r
lm(y ~ q + q:z - 1, data = dat)
```

### d. 

```r
lm(y ~ q + I(q^2), data = dat)
```

An equivalent call uses poly(q, 2, raw = TRUE). The default orthogonal basis does not give the displayed raw coefficients.

### e. 

y = β₀ + β₁x + β₂I(z=2) + β₃I(z=3) + ε, with z=1 as the reference category.

### f. 

y = β₀ + β₁(x+2) + β₂z² + ε.

### g. 

y = β₀ + β₁(x × z) + ε. x:z does not automatically include x, so subtracting x removes no existing main effect.

---

## Problem 4

Table below follows the ordinary capture-group interpretation, using perl=TRUE for pattern b. See the engine note below.

```text
a. "^[^0-9]"
b. "(.)0.*\\1"
c. "^[0-9]{4}.?[0-9]{2}.?[0-9]{2}$"
d. "^[0-9]+.?[0-9]+.?[0-9]+$"
```

| String | a | b | c | d |
| --- | --- | --- | --- | --- |
| 2023-10-14 |  | X | X | X |
| 14/10/2023 |  | X |  | X |
| Oct 14, 2023 | X | X |  |  |
| 10-14-2023 |  | X |  | X |
| 2023/10/14 |  | X | X | X |
| 14-Oct-23 |  |  |  |  |
| 20231014 |  | X | X | X |
| 2023.10.14 |  | X | X | X |
| 14 October 2023 |  | X |  |  |
| 14-10-2023 |  | X |  | X |

Engine note: for b, the official F24 solution reports FALSE under default R and TRUE under perl=TRUE for 14/10/2023 and 14-10-2023. Both answers were accepted for those two entries in that exam. The remaining entries agree.

c permits an optional arbitrary character between numeric blocks, including no separator. d also accepts compact numeric dates because the digit runs can split one long run. Neither pattern validates calendar dates.

---

## Problem 5

### a

| a | b | c | i |
| --- | --- | --- | --- |
| 3 | 8 | 2 | 5 |

### b

| a | b1 |
| --- | --- |
| 3 | 7 |
| 1 | 4 |

### c

| c | aa |
| --- | --- |
| 2 | 7 |

### d

| a | n |
| --- | --- |
| 8 | 8 |
| 3 | 1 |

### e

| a | n |
| --- | --- |
| 8 | 8 |
| 3 | 1 |
| NA | 7 |

### f. 

```sql
SELECT d1.a, d1.i, d2.n
FROM data AS d1
LEFT JOIN data2 AS d2 ON d1.i = d2.i
ORDER BY d1.a DESC
LIMIT 3
```

Use d1.i. For unmatched left rows d2.i would be NULL, while d1.i remains available.

---

## Problem 6

### a. 

```r
spin <- function(n, color = FALSE) {
  if (color) {
    sample(c("red", "black", "green"), n, replace = TRUE,
           prob = c(18, 18, 2))
  } else {
    sample(-1:36, n, replace = TRUE)
  }
}
```

Sampling colors directly is sufficient when only the marginal color results are requested.

### b. 

```r
set.seed(506)
reps <- 1000
results <- spin(reps, color = TRUE)
count <- 0
for (i in 3:reps) {
  if (results[i-2] == results[i-1] &&
      results[i-1] == results[i]) count <- count + 1
}
count
```

Every ending position from 3 through reps defines a window. Do not skip ahead after a successful window; overlaps must be counted.

---
