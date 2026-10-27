# STATS 506 F24 Midterm - Questions

## Problem 1

Determine q after each independent code fragment runs. Show intermediate work when useful. Assume required packages are loaded.

### a. 

```r
x <- seq(2, 20, by = 2)
y <- x[x > 10]
q <- sum(y[y %% 4 == 0])
```

q = ____________________

### b. 

```r
x <- list(a = 1:5, b = 6:10, c = 11:15)
y <- sapply(x, function(z) z[1] + z[length(z)])
q <- y * c(1, 10)
```

q = ____________________

### c. 

```r
x <- matrix(c(2, 4, 6, 2, 4, 6), nrow = 2, byrow = FALSE)
q <- apply(x, 1, sum) - apply(x, 2, sum)
```

q = ____________________

---

## Problem 1 (continued)

### d. 

```r
q <- 0
x <- 4
while (x > 0) {
  for (y in 1:x) {
    q <- q + y
  }
  x <- x - 1
}
```

q = ____________________

### e. 

```r
tibble(x = c(2, 4, 6, 8, 10),
       y = c(1, 2, 3, 2, 1)) %>%
  mutate(z = x * y, w = z - x) %>%
  group_by(y) %>%
  summarize(v = sum(w)) %>%
  ungroup() %>%
  arrange(desc(v)) %>%
  filter(v == 0) %>%
  select(y) %>%
  as.numeric -> q
```

q = ____________________

### f. 

```r
f <- function(x, z = 0) {
  if (x <= 1) {
    return(z + x)
  } else {
    return(f(x - 1, z + x))
  }
}
q <- f(5)
```

q = ____________________

---

## Problem 2

mydata is a data.frame with 5,732 rows and the following nine columns. Write R code for each cleaning operation, creating variables inside mydata and accounting for missing values.

| Variable | Type | Example values |
| --- | --- | --- |
| employeeid | int | 1 2 3 4 5 6 7 8 9 10 ... |
| age | int | 34 28 45 NA 38 30 31 27 42 36 ... |
| gender | chr | "Male" "Female" "Male" "" "Male" "Male" ... |
| educationlevel | chr | "Bachelor" "Master" "High School" "" "Bachelor" "PhD" ... |
| yearsatcompany | int | 5 2 10 3 7 15 4 1 8 12 ... |
| department | chr | "Engineering" "HR" "Sales" "Marketing" "Engineering" ... |
| monthlyhours | int | 160 150 170 155 165 175 160 145 168 172 ... |
| annualsalary | num | 55000 48000 62000 50000 58000 67000 54000 ... |
| productivityscore | num | 85 90 NA 88 80 -5 92 87 75 89 ... |

### a. Create a variable containing the log of annual salary.

### b. Create a binary variable female. Gender is Male, Female, or unanswered; handle unanswered values appropriately.

### c. Convert department to a factor.

---

## Problem 2 (continued)

### d. Calculate hourly wage from annual salary and monthly working hours.

### e. Remove employees earning more than $50 per hour, using the variable from part d.

### f. Standardize annual salary to mean 0 and variance 1.

### g. Negative productivity scores identify exemptions. Recode those values as missing.

### h. The minimum hiring age is 18. When the recorded age and years at the company imply an impossible hiring age, set both recorded variables to NA.

---

## Problem 3

For a-d, write one R line fitting the indicated model. The data.frame is dat; all named columns are numeric.

### a. y = β₀ + β₁x + ε

### b. y = β₀ + β₁q + β₂z + β₃(q × z) + ε

### c. y = β₁q + β₂(q × z) + ε

### d. y = β₀ + β₁q + β₂q² + ε

---

## Problem 3 (continued)

For e-g, write the mathematical regression equation represented by each call. Include an intercept when appropriate. z has numeric values 1, 2, and 3.

### e. 

```r
lm(y ~ x + as.factor(z), data = dat)
```

### f. 

```r
lm(y ~ I(x + 2) + I(z^2), data = dat)
```

### g. 

```r
lm(y ~ x:z - x, data = dat)
```

---

## Problem 4

Mark X when the pattern matches a date string; otherwise leave the cell empty. No string has leading or trailing whitespace. Patterns below are R string contents.

```text
a. "^[^0-9]"
b. "(.)0.*\\1"
c. "^[0-9]{4}.?[0-9]{2}.?[0-9]{2}$"
d. "^[0-9]+.?[0-9]+.?[0-9]+$"
```

| String | a | b | c | d |
| --- | --- | --- | --- | --- |
| 2023-10-14 |  |  |  |  |
| 14/10/2023 |  |  |  |  |
| Oct 14, 2023 |  |  |  |  |
| 10-14-2023 |  |  |  |  |
| 2023/10/14 |  |  |  |  |
| 14-Oct-23 |  |  |  |  |
| 20231014 |  |  |  |  |
| 2023.10.14 |  |  |  |  |
| 14 October 2023 |  |  |  |  |
| 14-10-2023 |  |  |  |  |

Scratch work:

<!-- Answer space -->

---

## Problem 5

The tables data and data2 are shown below. For a-e, give each query output, including its column names.

data

| a | b | c | i |
| --- | --- | --- | --- |
| 5 | 4 | 1 | 1 |
| 8 | 4 | 1 | 2 |
| 4 | 4 | 2 | 3 |
| 9 | 4 | 1 | 4 |
| 3 | 8 | 2 | 5 |
| 1 | 5 | 1 | 6 |

data2

| i | n |
| --- | --- |
| 5 | 1 |
| 2 | 8 |
| 7 | 7 |

### a. 

```sql
SELECT *
FROM data
WHERE b == 8
```

### b. 

```sql
SELECT a, b - 1 AS b1
FROM data
ORDER BY -b1
LIMIT 2
```

---

## Problem 5 (continued)

### c. 

```sql
SELECT c, SUM(a) AS aa
FROM data
GROUP BY c
HAVING aa < 15
```

### d. 

```sql
SELECT d1.a, d2.n
FROM data AS d1
INNER JOIN data2 AS d2 ON d1.i = d2.i
```

### e. 

```sql
SELECT d1.a, d2.n
FROM data AS d1
RIGHT JOIN data2 AS d2 ON d1.i = d2.i
```

---

## Problem 5 (continued)

### f. Write one SQL query producing the following result. Pay attention to which table supplies i.

| a | i | n |
| --- | --- | --- |
| 9 | 4 | NA |
| 8 | 2 | 8 |
| 5 | 1 | NA |

<!-- Answer space -->

---

## Problem 6

A roulette wheel has 38 equally likely slots: numbers 1-36, 0, and 00. There are 18 red, 18 black, and 2 green slots. Represent 00 numerically as -1. In 1-10 and 19-28, odd numbers are red and even numbers are black; in 11-18 and 29-36 the parity colors are reversed. Both 0 and 00 are green.

You may use sample(x, size, replace, prob). It returns size draws from x; replace controls replacement and prob supplies optional relative weights. Input checks and function documentation are not required.

### a. Write spin(n, color = FALSE). Return a vector of n spins: numeric slot values when color is FALSE, or character colors when TRUE. Assume n is a positive integer and color is logical.

<!-- Answer space -->

---

## Problem 6 (continued)

### b. Use spin to simulate a fixed number of spins and count all length-three consecutive windows with the same color. Overlaps count: four consecutive reds contain two qualifying windows. Return the count, not a proportion. Your code need not be efficient; use of an efficient method can receive minor extra credit.

<!-- Answer space -->

---
