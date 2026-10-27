# STATS 506 F23 Midterm - Answer Key

## Problem 1

### a. 

q = 25. The selected odd values are 1, 3, 5, 7, 9.

### b. 

q = 42. The recycled multipliers are 2, 1, 2, 1, 2; the first and fifth products are 2 and 40. A recycling warning does not prevent the calculation.

### c. 

```r
c(-3, 0, -3)
```

Row sums are 3, 5, 3; column sums are 6, 5. Recycle the column-sum vector as 6, 5, 6 before subtraction.

### d. 

q = 1.25. Trace 10 -> 5 -> 2.5 -> 1.25, then return the value at or below 2.

### e. 

q = 3. The variable d equals a. Its means are 2 in group b=1 and 3 in group b=2; descending order selects 3.

### f. 

q = 35. Add successive triangular totals 1 + 3 + 6 + 10 + 15. The next while condition then fails.

---

## Problem 2 - SAS

These questions belong to the F23 scope. SAS is outside the published F26 Lecture 1-9 scope.

### a. 

```sas
proc sort data=work.housing;
    by age;
run;
```

### b. 

```sas
data work.housing;
    set work.housing;
    birthyear = year - age;
run;
```

### c. 

```sas
proc sort data=work.housing;
    by owns_home;
run;
proc means data=work.housing;
    var birthyear;
    by owns_home;
run;
```

Alternatively, use CLASS owns_home with PROC MEANS if no BY processing is required.

---

## Problem 3 - Model translation and Stata

### a. 

```r
lm(y ~ x1 + factor(x2) + x3*x4, data = dat)
```

### b. 

```r
lm(y ~ factor(x1)*factor(x2)*factor(x3) - 1, data = dat)
```

In the Stata interaction specification, the unprefixed x3 is treated as categorical. Remove the intercept.

### c. 

```r
lm(y ~ x1 + x1:x2, data = dat)
```

### d. 

```r
lm(y ~ I(x1^2) + x2 + log(x3), data = dat)
```

### e. 

```stata
foreach var of varlist bin1-bin20 {
    replace `var' = `var' - 1
}
```

Subtract one from each 1/2-coded variable.

### f. 

```stata
margins race, at(age = (20(10)80))
marginsplot
```

### g. 

```stata
generate sd = (x1 - x2)^2
collapse (mean) sd, by(group)
```

### h. 

```mata
Q = max(diagonal(X))
```

Insert this line inside the provided Mata block before st_matrix("q", Q).

---

## Problem 4 - Regex matching

Patterns are shown as R string contents. X means a match; a blank means no match.

```text
a. "[Aa]*[a-zA-Z]+.{2}o$"
b. "^..?...$"
c. "^[^AS]..?[aeiou]"
d. "(.).\\1"
```

| String | a | b | c | d |
| --- | --- | --- | --- | --- |
| Adedayo | X |  |  | X |
| Dinah |  | X | X |  |
| Frida |  | X | X |  |
| Liam |  | X | X |  |
| Marlyn |  |  |  |  |
| Milko | X | X |  |  |
| Mirka |  | X |  |  |
| Rupert |  |  | X |  |
| Rustik |  |  |  |  |
| Sebastian |  |  |  |  |

a: A suffix ending in o with enough preceding characters. The optional [Aa]* can match zero characters; it does not forbid an initial A or a.

b: Exactly four or five characters. c: The first character is neither A nor S, and a vowel occurs in position 3 or 4. d: The same character occurs with exactly one intervening character, as in ded.

---

## Problem 5 - SQL output

### a

| x | y | q | z |
| --- | --- | --- | --- |
| 9 | 8 | 1 | 2 |
| 1 | 8 | 2 | 5 |

### b

| x | x1 |
| --- | --- |
| 2 | 1 |
| 9 | 8 |

### c

| q | xx |
| --- | --- |
| 2 | 11 |

### d

| x | p |
| --- | --- |
| 2 | 4 |
| 9 | NA |
| 7 | NA |
| 3 | NA |
| 1 | NA |
| 6 | NA |

### e

| x | p |
| --- | --- |
| 2 | 4 |
| NA | 8 |

---

## Problem 6 - Von Neumann extractor

### a. 

```r
vonneumann <- function(p) {
  repeat {
    flips <- rbinom(2, size = 1, prob = p)
    if (flips[1] != flips[2]) return(flips[1])
  }
}
```

The actual R function requires size=1 for a Bernoulli flip. Ignore identical pairs and return the first result from a differing pair.

### b. 

```r
set.seed(506)
p <- 0.7
reps <- 10000
out <- sapply(seq_len(reps), function(i) vonneumann(p))
mean(out)
```

The estimate should be near 0.5 and will vary with the random stream. Both HT and TH have probability p(1-p), so conditional on a differing pair the first result is fair.

---
