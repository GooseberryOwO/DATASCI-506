# STATS 506 F26 Midterm 中文复习讲义

整理日期：2026-10-26。依据 F23–F25 期中资料、F26 Lecture 1–9、Quiz 1–3 与 HW1–3。讲解与练习为综合整理；历年题目以文末官方链接为准。

> **本次考试：2026-10-27，10:00–11:15，课堂内闭卷、纸笔作答。带笔与 UMID。正式范围为 F26 Lecture 1–9。** 老师允许逻辑正确的“接近 R 的代码”，但错误的分组、索引、概率或公式不能靠语法近似弥补。来源：[F26 midterm details](https://phuongov.github.io/stats506-f26/midterm/midterm_details.html)。

## 目录

1. [范围与历年题型](#scope)
2. [R 基础：索引、回收、矩阵和缺失值](#base)
3. [apply 家族：输入、切片与输出形状](#apply)
4. [字符串与正则表达式](#regex)
5. [管道与 tidyverse](#tidyverse)
6. [模型公式、系数、预测与矩阵计算](#models)
7. [函数、循环与 Monte Carlo](#simulation)
8. [SQL：查询顺序、分组与连接行数](#sql)
9. [Debugging、Quarto 与 Git](#tools)
10. [把 HW1–3 转成考试能力](#homework)
11. [历年资料中的易误读之处](#pitfalls)
12. [闭卷自测与答案](#practice)
13. [最后一轮复习与来源链接](#sources)

<a id="scope"></a>

## 1. 范围与历年题型

### 1.1 先按 F26 讲义编号复习

| Lecture | 必须能做什么 | 本文位置 |
|---|---|---|
| 1 Introduction to R | 手算向量与矩阵索引；区分 list 与元素；处理 NA；写函数和循环 | 2、7 |
| 2 Quarto | 解释代码块、执行与显示选项、YAML、render | 9 |
| 3 Git | 区分本地与远端、stage/commit/push/pull、冲突 | 9 |
| 4 Vectorization / Monte Carlo | 判断 apply 输出形状；抽样与重复模拟；seed；矩阵按列填充 | 3、7 |
| 5 Debugging | 找逻辑错误；函数调用链；print/traceback/browser | 7、9 |
| 6 Modeling in R | 在模型方程与 R 公式间转换；交互项、多项式、factor、提取结果与预测 | 6 |
| 7 SQL | 手算查询结果；WHERE/HAVING；连接和输出行数 | 8 |
| 8 Strings / Regex | 拆解表达式；捕获与反向引用；判断匹配和提取结果 | 4 |
| 9 tidyverse | 按步骤追踪管道；mutate/summarize；分组状态；tibble 与 data.frame | 5 |

优先多练 **apply、regex、管道**，但不要把这三块当作全部范围。下面的“优先”依据已公开题目的重复主题，不是对今年试题的保证。

### 1.2 三年题型怎么迁移到今年

| 主题 | F23 | F24 | F25 | 与 F26 的关系 |
|---|---|---|---|---|
| 代码追踪 | P1：回收、apply、递归、管道、循环 | P1：list/sapply、矩阵、递归、管道 | P1：矩阵、sapply、函数调用、管道 | 三年都有，优先练手算 |
| 清洗与 NA | 另有 SAS 操作题 | P2：变量生成、空字符串、标准化与异常值 | P2：清洗、缩放、模型与预测 | 连接 HW1、HW2、HW3 |
| 模型公式 | P3 中有 Stata→R 公式转换 | P3：方程↔公式、factor、交互、多项式 | P2(h–i)：模型与预测 | 复习 R 部分，F23 的 Stata 命令不作为今年范围 |
| SQL | P5 | P5 | P4 | 三年都有；F26 Quiz 2 特别考连接行数 |
| Regex | P4：姓名匹配表 | P4：日期匹配表 | P5：邮件匹配表 | 三年都有；F26 Quiz 3 为直接训练材料 |
| 写函数与模拟 | P6：偏硬币公平化 | P6：轮盘与重叠连续事件 | P6：贴纸收集 | 三年都有；连接 HW1 Happy Number 与 HW2 模拟 |
| Debugging / 判断逻辑 | 混合在代码题中 | 混合在代码题中 | P3 单独考 | 重点找“能运行但不符合目标”的错误 |

**范围差异：** F23 当时的范围包含 Stata、SAS，F24 当时覆盖 Lecture 1–10；不能照搬旧年份讲义编号。F26 以自己的 Lecture 1–9 为准，Lecture 10 可视化不在公布范围内。F26 practice PDF 与 F25 试题在题目与解答内容上基本一致，随机输出可能不同，不要把它们当两套独立样卷。

### 1.3 纸笔题的固定解题顺序

1. 标出对象类型与维度：vector / list / matrix / data.frame / grouped tibble。
2. 先执行索引、比较或分组，再做汇总。
3. 遇到不同长度运算，明确写出短向量如何回收。
4. 遇到函数，先确认**实际调用的是哪个函数**及传入的参数。
5. 遇到 regex，分清匹配位置、字符单位、重复次数、捕获组。
6. 输出题写出值以及必要的列名、名称、维度；写中间步骤可帮助获得部分分。

<a id="base"></a>

## 2. R 基础：索引、回收、矩阵和缺失值

### 2.1 `[ ]`、`[[ ]]`、`$` 与逗号

```r
student <- list(grades = c(midterm = 80, final = 92), clubs = 1:4)
length(student[1])    # 1：保留外层 list，里面有一个元素
length(student[[1]])  # 2：取出成绩向量本身
student$grades["final"]  # 一个带名字的数值：final = 92
```

| 对象与写法 | 结果 |
|---|---|
| `x[i]`，x 为普通向量 | 取向量的第 i 项 |
| `li[i]`，li 为 list | 子 list，仍有外层容器 |
| `li[[i]]` | 第 i 个元素内部的对象 |
| `d[c("age", "sex")]` | data.frame 按列选取，不需要逗号 |
| `d[rows, cols]` | 逗号前选行，后选列 |
| `d[, "age"]` | base data.frame 通常降成向量 |
| `d[, "age", drop = FALSE]` | 保留二维 data.frame |
| `length(d)` | 列数；不是行数 |
| `nrow(d)`、`ncol(d)`、`dim(d)` | 行数、列数、两个维度 |

Tibble 的 `d[, "age"]` 默认仍是 tibble；`d[["age"]]` 或 `d$age` 才取出列向量。不要把 data.frame、tibble 的降维规则混为一谈。

### 2.2 向量回收与按位置计算

```r
x <- c(3, 6, 9, 12, 15)
x * c(2, 1)  # 6, 6, 18, 12, 30；长度不整除，会警告
```

实际是 `x * c(2, 1, 2, 1, 2)`。警告不等于停止执行。普通向量运算按位置对齐，不会仅因名字相同就自动按名字匹配。

`%%` 是余数，`%/%` 是整数除法。`x %% 2 == 1` 产生一个“是否奇数”的逻辑向量。

### 2.3 矩阵先写出来，再做题

```r
M <- matrix(1:6, nrow = 2)
M
#      [,1] [,2] [,3]
# [1,]    1    3    5
# [2,]    2    4    6
M[, 2]         # 3, 4
M[1, ]         # 1, 3, 5
M * c(10, 100) # 第1行乘10，第2行乘100：回收沿列向下进行
```

默认 `byrow = FALSE`，所以按列填充。`M * N` 是逐元素乘法；`M %*% N` 才是矩阵乘法。`rbind()` 把对象上下叠成行，`cbind()` 把对象左右并成列。

### 2.4 `&` / `|` 与 `&&` / `||`

- `&`、`|`：逐元素判断，筛选整列或整段数据时用。
- `&&`、`||`：单个条件的短路判断，适合函数输入检查等；不要用来筛选整列。
- `if` 需要一个非缺失的逻辑值。逐元素判断一般用索引或 `ifelse()`。

```r
ages <- c(17, 25, 93, NA)
ages >= 18 & ages <= 90  # FALSE TRUE FALSE NA
which(ages >= 18 & ages <= 90)  # 2；which 只返回 TRUE 的位置
```

例如，删除 age < 18、age > 90 或 Preschool 的人，可保留：

```r
adult_demo <- data.frame(age = c(16, 30, 95, NA),
                         education = c("HS", "College", "HS", "College"))
keep <- !is.na(adult_demo$age) & !is.na(adult_demo$education) &
  adult_demo$age >= 18 & adult_demo$age <= 90 &
  adult_demo$education != "Preschool"
adult_demo[keep, , drop = FALSE]
```

这里选择了排除未知年龄/教育的人；实际答题时应说明你如何处理未知值。若逻辑行索引含 NA，base R 可能返回全 NA 的行；`dplyr::filter()` 通常丢弃条件为 NA 的行。

### 2.5 缺失值与清洗模板

```r
x_na <- c(2, NA, 6)
is.na(x_na)              # FALSE TRUE FALSE
mean(x_na)               # NA
mean(x_na, na.rm = TRUE) # 4
```

`x == NA` 不能判断缺失。`""`、`"?"`、`99` 只有根据文档重编码后才是真正的 NA；不能见到 99 就删。

```r
people <- data.frame(sex = c("Female", "Male", "", NA),
                     score = c(10, -9, 20, NA))
people$female <- people$sex == "Female"
people$female[people$sex == ""] <- NA
people$score[people$score < 0] <- NA
```

空字符串若不重编码，会被 `== "Female"` 判为 FALSE，而原本未知的性别就被误当成非女性。

对混有字符列的数据，不要机械地对整个 data.frame 做 `< 0`。只对指定数值列处理：

```r
numeric_cols <- c("score")
for (nm in numeric_cols) {
  people[[nm]][people[[nm]] < 0] <- NA
}
```

标准化与区间缩放不是一回事：

```r
score <- c(10, 20, 40, NA)
z <- (score - mean(score, na.rm = TRUE)) / sd(score, na.rm = TRUE)
lo <- min(score, na.rm = TRUE)
hi <- max(score, na.rm = TRUE)
scaled01 <- (score - lo) / (hi - lo)
```

z-score 用均值、标准差；min–max 用最小、最大值。若所有有效值相同，分母为 0，需要另行处理。

<a id="apply"></a>

## 3. apply 家族：输入、切片与输出形状【优先】

对应：[Lecture 4](https://phuongov.github.io/stats506-f26/04-vectorization.html)、F23 P1(c)、F24 P1(b–c)、F25 P1(d)/P6、HW2。

### 3.1 每次都回答四个问题

1. 外层对象是什么？
2. 每次送给 `FUN` 的是什么：一行、一列、一个 list 元素、还是一个组？
3. `FUN` 每次返回几个值、什么类型？
4. 收集后是一维向量、list，还是矩阵？

`function(x)` 里的 `x` 是本次送入的数据，名字可以改成 `one_column`。它不自动表示原对象第一项。

| 函数 | 输入被怎样拆开 | 收集规则 |
|---|---|---|
| `apply(X, 1, FUN)` | 对二维矩阵逐行 | 每次返回一个值时，得到长度为行数的向量 |
| `apply(X, 2, FUN)` | 对二维矩阵逐列 | 每次返回一个值时，得到长度为列数的向量 |
| `lapply(X, FUN)` | 每个元素；data.frame 则是每列 | 总是 list，外层长度通常为 `length(X)` |
| `sapply(X, FUN)` | 同 lapply | 尝试简化：标量→向量；等长向量→矩阵；否则可能仍是 list |
| `vapply(X, FUN, FUN.VALUE)` | 同 lapply | 预先约定每次输出的长度与类型 |
| `mapply(FUN, x, y, ...)` | 多个输入按位置一起送入 | 通常简化；注意函数放在第一个参数 |
| `tapply(X, INDEX, FUN)` | 按分组变量拆分数值向量 | 每组一个结果时得到带组标签的数组 |
| `replicate(B, expr)` | 重复求值表达式 B 次 | 每次一个值→向量；每次 k 个值→k×B 矩阵 |

### 3.2 `apply()`：1 是行、2 是列

```r
A <- matrix(1:6, nrow = 2)
apply(A, 1, sum) # 9, 12：两行各返回一个和
apply(A, 2, sum) # 3, 7, 11：三列各返回一个和
apply(A, 2, function(one_col) {
  c(total = sum(one_col), average = mean(one_col))
})
#         [,1] [,2] [,3]
# total    3.0  7.0 11.0
# average  1.5  3.5  5.5
```

每列返回长度 2，三列的结果并成 **2×3** 矩阵。不要把 MARGIN=2 理解成“第二列”，它表示**逐列遍历所有列**。

附加参数传给 `FUN`：

```r
A_na <- matrix(c(1, NA, 3, 4), nrow = 2)
apply(A_na, 2, mean, na.rm = TRUE) # 1, 3.5
```

高维数组中，MARGIN 指定保留并逐项遍历的维度：三维数组的 `apply(X, 3, max)` 给每个第3维切片一个最大值；`apply(X, c(1, 2), max)` 固定前两个坐标、在第3维上求最大值，返回前两维大小的矩阵。

`apply()` 适用于矩阵/数组。混合类型 data.frame 若被强制转换为矩阵，可能整张变成字符；逐列处理 data.frame 时常用 `lapply()`。

### 3.3 `lapply()` 与 `sapply()`：同样计算，容器不同

```r
li <- list(a = 1:3, b = 4:6)
lapply(li, mean) # list：$a 为2，$b 为5
sapply(li, mean) # 命名数值向量：a=2，b=5

sapply(li, function(v) c(low = min(v), high = max(v)))
#      a b
# low  1 4
# high 3 6
```

`lapply(1:3, FUN)` 也可用：普通向量被按元素遍历。`sapply()` 不保证永远返回数值向量；若一个返回值是字符，简化结果也可能被转为字符。输出形状取决于每次返回的内容。

### 3.4 `vapply()` 的第三个参数不是计算数据

```r
vapply(li, mean, numeric(1)) # a=2，b=5
```

`numeric(1)` 意思是“每次应该返回一个 double 数值”。`logical(1)` 意味着一个逻辑值；`numeric(2)` 意味着两个数值。它是**输出原型**。数字本身不会参与求平均，也不是要求函数返回 0。

整数结果可以提升成 double；反过来把一般 double 结果硬塞进 `integer(1)` 通常会报类型错误。

### 3.5 `mapply()` 与 `tapply()`

```r
mapply(function(x, y) x + y, c(1, 2, 3), c(10, 20, 30))
# 11, 22, 33：按位置配对，不是所有组合

values <- c(2, 6, 10, 14)
group <- c("A", "A", "B", "B")
tapply(values, group, mean) # A=4，B=12
```

`tapply()` 的含义与“先 group_by，再 summarize(mean)”相近。HW3 按 store 计算顾客数或 active 比例也可用它。

### 3.6 样卷贴纸题为什么是按列 apply

用三种贴纸、三次抽取的缩小例子：

```r
stickers <- matrix(c("A", "B", "C", "A", "A", "B"), nrow = 3)
#       [,1] [,2]
# [1,]  "A"  "A"
# [2,]  "B"  "A"
# [3,]  "C"  "B"
success <- apply(stickers, 2, function(one_run) {
  length(unique(one_run)) == 3
})
success       # TRUE FALSE：两次实验的结果
mean(success) # 0.5：成功比例
100 * mean(success) # 50：成功百分比
```

- 一列是一次完整实验；行是该次实验抽到的贴纸。
- `unique()` 去掉重复种类，不会统计总抽取次数。
- 匿名函数最后的比较表达式就是返回值，不写 `return()` 也可以。
- `mean()` 把 TRUE 当 1、FALSE 当 0，所以得到成功比例。

### 3.7 返回值与独立性两个陷阱

```r
f_last <- function(x) {
  y <- x + 1
  y * 2
}
f_last(3) # 8，返回最后一个被求值的表达式
```

`return()` 会立刻退出当前函数；要返回多个内容可用 `list()` 或向量。`sapply()` 收集的是**每次函数的返回值**，不是函数里所有中间变量。

apply 家族主要隐藏了循环，不代表天然比 for 循环快，也不代表每次调用在概率意义上独立。HW2 的 walk 内部具有状态依赖；不能因为改用 `sapply()` 就把每一步当独立方向。独立的多条 walk 才适合在外层重复。

<a id="regex"></a>

## 4. 字符串与正则表达式【优先】

对应：[Lecture 8](https://phuongov.github.io/stats506-f26/08-regex.html)、三年 regex 匹配表、F26 Quiz 3、HW3 P3。

### 4.1 正则默认找“某处存在”，不是整串完全相等

```r
grepl("cat", c("cat", "bobcat", "catfish")) # TRUE TRUE TRUE
grepl("^cat$", c("cat", "bobcat", "catfish")) # TRUE FALSE FALSE
```

`grep()` 返回匹配元素的位置；`powers[grep(..., powers)]` 因而返回**整条字符串**。看到输出从 c 开头，并不说明第 1 捕获组匹配了 c。没有 `^` 时可以从中间匹配。

### 4.2 Lecture 8 与 Quiz 覆盖的语法

下表“R 中写法”指引号里面输入的内容。

| R 中写法 | 含义 | 例子 |
|---|---|---|
| `abc` | 连续字面文本 | `abc` 可以出现在更长的字符串里 |
| `.` | 任意一个字符 | `a.b` 可匹配 `a7b` |
| `^a` | a 必须在开头 | `apple` |
| `a$` | a 必须在结尾 | `data` |
| `^a$` | 整串只允许一个 a | `a` |
| `[abc]` | a、b、c 中的任意**一个** | 不要求出现 abc 整段 |
| `[a-z]` / `[A-Z]` | 一个小写/大写英文字母 | 默认区分大小写 |
| `[0-9]` | 一个数字 | 7 |
| `[^abc]` | 一个不属于 a/b/c 的字符 | 数字、空格也可能符合 |
| `[^.]` | 一个不是句点的字符 | 方括号里的点按字面理解 |
| `a*` | 0 个或更多 a | 可匹配空串 |
| `a+` | 1 个或更多 a | 至少一个 a |
| `a?` | 0 个或 1 个 a | a 可有可无 |
| `a{3}` | 恰好 3 个 a | aaa |
| `a{2,4}` | 2 到 4 个 a | aa、aaa、aaaa |
| `a{2,}` | 至少 2 个 a | aa、aaa…… |
| `(ab)` | 把 ab 作为一个单位并捕获 | 可被后面的反向引用使用 |
| `\\.`（在 R 源码中应见两个反斜杠） | 见下一节转义表 | 匹配字面句点 |

OR 写作 `(cat|dog)`，匹配完整的 `cat` 或 `dog`；`[cat|dog]` 只是在 c/a/t/竖线/d/o/g 中选一个字符。**方括号里竖线没有“两个单词二选一”的意义。**

`*`、`+`、`?`、`{}` 都作用于前面紧邻的一个单位：

```r
grepl("^[ab]+$", c("a", "ba", "abab")) # TRUE TRUE TRUE
grepl("^(ab)+$", c("a", "ba", "abab")) # FALSE FALSE TRUE
```

`[ab]+` 每次从 a/b 中选一个字符；`(ab)+` 每次重复完整的 ab。`[0-9]{4}` 是四位数字，绝不是重复四次“0-9”这段文本。

### 4.3 两层转义：R 字符串先处理一次，正则再解释一次

下面代码块中的写法可以直接复制进 R：

```r
grepl("1", "a1b")          # TRUE：数字1本来就不需要转义
grepl("\\.", "a.b")       # TRUE：字面句点
grepl("(a)\\1", "aa")     # TRUE：重复第1组的 a
```

| R 源码中的字符串 | 正则引擎收到 | 意思 |
|---|---|---|
| `"1"` | `1` | 字面数字 1 |
| `"\\."` | `\.` | 字面句点 |
| `"\\1"` | `\1` | 引用第 1 捕获组；前提是有该组 |
| `"\\("` | `\(` | 字面左括号 |

HW3 常用的扩展字符类还有 `[[:alpha:]]`（字母）、`[[:digit:]]`（数字）、`[[:space:]]`（空白）。例如 `[^[:alpha:],[:space:]&]` 寻找“既不是字母、也不是逗号、空白或&”的一个字符。`ignore.case = TRUE` 可忽略大小写；默认则区分。

反斜杠不是“无论跟谁都按字面匹配”的统一开关；后面的字符决定意义。要找数字 1，直接写 `"1"`；要整串只有一个 1，写 `"^1$"`。

### 4.4 `.` 与 `(.)`，以及第 1 / 第 2 组

`.` 匹配一个字符；`(.)` 匹配同样的一个字符，同时把它保存为捕获组。捕获组按**左括号出现的顺序**编号；`[]` 和没有括号的 `.*` 不计入组号。

```r
grepl("a.b", "a7b")        # TRUE
grepl("a(.)b", "a7b")      # TRUE，并且第1组捕获7
sub("a(.)b", "\\1", "a7b") # "7"：替换成捕获内容

grepl("^(.)\\1$", c("aa", "11", "ab")) # TRUE TRUE FALSE
grepl("^(.)0(.)\\2\\1$", "a0bba")        # TRUE
```

最后一行：组 1 捕获 a → 字面 0 → 组 2 捕获 b → `\\2` 要求 b → `\\1` 要求 a。组号引用本次匹配到的内容，不是输入字符串第几个字符，也不会跨不同字符串保存。

嵌套括号也按左括号顺序编号：`((ab)c)` 的组 1 是 abc，组 2 是 ab。

| 表达式（R 字符串写法） | 要求 |
|---|---|
| `"(.)\\1"` | 相同字符必须相邻，例如 oo |
| `"(.).\\1"` | 两个相同字符中间恰好隔一个字符，例如 aba |
| `"(.).*\\1"` | 中间隔 0 个或更多字符，例如 aa、abca |
| `"([^eo])\\1"` | 相邻重复字符不能是 ee/oo；仍可匹配 ll、mm |
| `"(.)\\1.*(.)\\2"` | 至少两对相邻重复字符；两组允许捕获相同字母 |

“不能是 ee/oo”只限制这次用于匹配的那一对；整条字符串即使有 ee，只要另有 ll，仍可能匹配 `([^eo])\\1`。

### 4.5 专门拆解 F24 的两个日期表达式

```text
(.)0.*\1
│  │ │ └──再次出现第1组字符
│  │ └────任意字符，0个或更多
│  └──────数字零，必须紧跟第一次捕获的字符
└─────────捕获一个字符
```

写进 R 时是 `"(.)0.*\\1"`。概念上 a0a、a0xyza 都满足；第一次 a 紧邻 0，第二次 a 可以紧随 0，也可以在更后面。

**引擎差异：** [F24 官方解答 P4](https://dept.stat.lsa.umich.edu/~jerrick/courses/stat506_f24/midtermsolns.html)专门注明：部分日期对这个表达式在 R 默认引擎与 `perl = TRUE` 下结果不同，F24 当时接受两种答案。先按捕获与顺序解释规则；不要把该年特例当作“所有正则输出都随意”。今年评分方式仍以今年说明为准。

```r
date_examples <- c("20261027", "2026-10-27", "2026/10/27",
                   "2026x10y27", "2026-99-99")
grepl("^[0-9]{4}.?[0-9]{2}.?[0-9]{2}$", date_examples)
# 全部 TRUE；它检查形式，不验证日历日期
```

`.?` 是“可有可无的任意一个字符”，分隔符可以不同，甚至可以是数字。若只允许固定短横线：

```r
grepl("^[0-9]{4}-[0-9]{2}-[0-9]{2}$", date_examples)
# FALSE TRUE FALSE FALSE TRUE：仍不验证月份/日期范围
```

若要求同一种必选分隔符，可用捕获：

```r
grepl("^[0-9]{4}([./-])[0-9]{2}\\1[0-9]{2}$",
      c("2026-10-27", "2026/10/27", "2026-10/27"))
# TRUE TRUE FALSE；分隔符是第1捕获组
```

### 4.6 字符串函数：先确认输出类型

| 函数 | 返回什么 | 常见用途 |
|---|---|---|
| `grepl(pattern, x)` | 与 x 对应的逻辑向量 | 筛选条件、计算匹配比例 |
| `grep(pattern, x)` | 匹配元素的位置 | `x[grep(...)]` |
| `sub(pattern, replacement, x)` | 字符向量；每项只替换第一个匹配 | 提取域名、利用捕获组替换 |
| `gsub(...)` | 字符向量；每项替换所有匹配 | 去掉电话号码中的所有非数字 |
| `strsplit(x, split)` | list，每个输入对应一组片段 | 分词，常再配合 sapply |
| `regexpr(pattern, x)` | 首个匹配的起点，带匹配长度属性；没找到为 -1 | 定位 |
| `regmatches(x, locations)` | 提取匹配文本 | 与 regexpr 配合 |
| `paste(..., sep=)` | 合并多个向量的对应项 | 组装姓名 |
| `paste(x, collapse=)` | 把一个向量折成一串 | 组装整段文本 |
| `nchar(x)` | 每条字符串的字符数 | 区别于 `length(x)` 的元素个数 |
| `substr(x, start, stop)` | 指定位置的子串 | 重组电话格式 |

```r
length(c("abc", "de")) # 2：两条字符串
nchar(c("abc", "de"))  # 3, 2：各有多少字符
strsplit(c("red blue", "green"), " ") # 长度2的list
sapply(strsplit(c("red blue", "green"), " "), length) # 2, 1

gsub("[^0-9]", "", "03-1234-5678") # "0312345678"
sub("^.*@", "", "student@umich.edu") # "umich.edu"
grep("([&", "abc([&xyz", fixed = TRUE) # 1：按字面查找，不启用正则
```

`regmatches()` 与 `regexpr()` 搭配时会跳过未匹配项，不自动留一个 NA 占位。`sub()` 若没匹配则保留原字符串，不自动返回空白；提取后要检查失败项。

### 4.7 Quiz 3 应该会解释，而不只记答案

- `^[A-Z][a-z]+s$`：一个大写字母开头，中间至少一个小写字母，最后一个小写 s；FrootLoops 因内部大写 L 失败。
- `[0-9]+`：任意位置至少一位数字；`5 Gum` 也能匹配。
- `(ee|io)`：出现 ee 或 io 这两段之一。
- `(.)\\1`：相邻重复字符，不要求出现在开头。
- 对 4 个表达式做 `sapply(regexes, function(rx) grepl(rx, strings))`，若有 10 个字符串，每次返回长度 10，所以合成 **10×4** 矩阵。

<a id="tidyverse"></a>

## 5. 管道与 tidyverse【优先】

对应：[Lecture 9](https://phuongov.github.io/stats506-f26/09-tidyverse.html)、三年 P1 管道题、F25 P3(d/g)、F26 Quiz 3。

### 5.1 `%>%` 传递左边的结果

`%>%` 来自 magrittr，加载 dplyr/tidyverse 也可用；右边可以是 base R 函数。`|>` 是 R 的原生管道，两者基本的“把左值传到右边”思路相近，但占位符等语法并不完全一致。考试按讲义中的 `%>%` 读题。

```r
library(dplyr)
1:4 %>% sqrt() %>% mean()
mean(sqrt(1:4)) # 同一计算
```

默认 `x %>% f(y)` 相当于 `f(x, y)`。有显式 `.` 时按占位位置放入：

```r
log %>% sapply(1:3, FUN = .)
sapply(1:3, log) # 左边传来的是函数log，不是一串数据

1:4 %>% `+`(2) %>% sum()
sum((1:4) + 2) # 18
```

把长管道转成嵌套函数时，从最后一步往外包。反过来解释执行过程时，从左往右读。注意 `. %>% ...` 还可能构造函数，不能机械地把所有点都理解为输入数据的第一列。

### 5.2 每个动词改变什么

| 动词 | 主要作用 | 行数变化 |
|---|---|---|
| `select()` | 选列 | 通常不改行数 |
| `filter()` | 按条件选行 | 保留 TRUE 的行 |
| `mutate()` | 增加/修改列 | 通常保留原行数 |
| `group_by()` | 设置分组供后续计算使用 | 本身不折叠行 |
| `summarize()` / `summarise()` | 每组求汇总 | 标量汇总时每组一行 |
| `arrange()` | 排序；`desc()` 降序 | 不改行数 |
| `ungroup()` | 去掉分组元数据 | 不改行数 |
| `head(n)` | 取最前面 n 行 | 最多 n 行 |

`select(score)` 得到单列 data.frame/tibble，不自动成为普通向量。分组后的 `mutate()` 使用各组统计量，但保留各人的行；分组后的 `summarize()` 才把人折叠成组。

### 5.3 一段管道逐步追踪

```r
d <- tibble(team = c("A", "A", "B", "B"), score = c(1, 3, 5, 7))
d %>%
  mutate(double = 2 * score) %>%
  group_by(team) %>%
  summarize(avg = mean(double)) %>%
  ungroup() %>%
  arrange(desc(avg))
# B 12
# A  4
```

中间表：先新增 double=2,6,10,14；按 A/B 分组后均值为 4/12；最终按均值降序排列。不要在纸上跳过中间变量。

### 5.4 分组后为什么 summarize“少一层 group”

```r
homes <- tibble(state = c("MI", "MI", "MI", "CA"),
                type = c("house", "house", "flat", "flat"),
                weight = c(2, 3, 4, 8))
by_type <- homes %>%
  group_by(state, type) %>%
  summarize(total = sum(weight))
by_type
# CA flat  8
# MI flat  4
# MI house 5
```

在“每组返回一行”的常见情形，默认去掉最后一层分组元数据，因此结果通常只继续按 state 分组。**type 列没有消失，state×type 的各行也没有合并成一行。** 这是 grouping 状态变化，不是丢失 type 的数据。

若再做 `summarize(sum(total))`，保留的 state 分组会使它按州汇总；先 `ungroup()` 再汇总才是全体总和。要避免意外继承分组，可写 `.groups = "drop"`，或按讲义在汇总后明确 `ungroup()`。

### 5.5 分组 z-score 与“每棵树最大年龄”

```r
Orange %>%
  group_by(age) %>%
  mutate(z = (circumference - mean(circumference)) / sd(circumference)) %>%
  ungroup()

Orange %>%
  mutate(age_years = age / 365) %>%
  group_by(Tree) %>%
  summarize(oldest = max(age_years)) %>%
  ungroup()
```

第一段是在**相同年龄的不同树之间**标准化，不是每棵树内部标准化。第二段必须用 `max()`；未排序时，最后一项不一定最大。

### 5.6 长宽转换与 tibble

```r
long_dat <- tibble(id = c(1, 1, 2, 2),
                   time = c("pre", "post", "pre", "post"),
                   score = c(5, 8, 6, 9))
wide_dat <- tidyr::pivot_wider(long_dat, names_from = time, values_from = score)
wide_dat # 每人一行，pre/post成为列
```

`pivot_longer()` 反过来把多列堆成“变量名列＋数值列”。Tibble 不靠行名识别对象，打印可能截断行列；打印出的几行不代表数据只有几行。

<a id="models"></a>

## 6. 模型公式、系数、预测与矩阵计算

对应：[Lecture 6](https://phuongov.github.io/stats506-f26/06-modeling-in-R.html)、F24 P3、F25 P2(h–i)、HW1 t-test、HW2 回归/矩阵、HW3 Poisson。

### 6.1 公式运算符与普通数值运算不同

| 公式 | 包含的项（数值预测变量情形） |
|---|---|
| `y ~ x + z` | 截距、x、z |
| `y ~ x:z` | 截距、x×z；没有自动加主效应 |
| `y ~ x*z` | 截距、x、z、x×z |
| `y ~ x*z - x` | 截距、z、x×z |
| `y ~ x:z - x` | 仍是截距、x×z；原本没有x主效应可删 |
| `y ~ x - 1` 或 `y ~ x + 0` | x，去掉截距 |
| `y ~ x + I(x^2)` | 截距、x、x² |
| `y ~ I(x + 2)` | 一个预测变量，其数值为x+2 |
| `y ~ (x + z + q)^2`【拓展】 | 主效应与两两交互；F26 Lecture 6 未明确介绍此简写，不列为课件已讲重点 |
| `y ~ factor(g)` | 按类别编码；默认有截距时通常用K−1列表示K类 |

**范围说明：** 上表的括号平方公式是补充的 R 通用语法，并非 F26 Lecture 6 明确展示的写法。课件已明确介绍的重点是 `+`、`:`、`*`、删除项、去截距，以及 `I()` / `poly()` 多项式项。

写出方程时，若公式没有 `-1` / `+0`，别忘了截距。`x*z` 不是只包含乘积；`I()` 才告诉公式系统把里面当普通算术表达式。

### 6.2 `poly()` 与类别编码

- `poly(x, 2)` 默认使用正交多项式基。
- `poly(x, 2, raw = TRUE)` 使用原始 x、x²。
- 两者都可拟合二次曲线，但**系数含义不一样**；要逐项对应 β₁x+β₂x²，使用 `raw = TRUE` 或 `x + I(x^2)`。
- 参数是 `degree`、`raw`，R 参数名区分大小写；不要照抄旧答案中的 `RAW` 或 `degrees` 笔误。
- 数字编码 1/2/3 若代表类别，不能因为存储为 numeric 就自动当成连续变量。

二分类 factor 在有截距的模型里通常贡献一列虚拟变量。参考类别的选择影响系数比较方向；例如 Female vs Male 与 Male vs Female 的 IRR 互为倒数。

### 6.3 输出提取和预测

```r
fit <- lm(mpg ~ wt + hp, data = mtcars)
coef(fit)
summary(fit)$coefficients
summary(fit)$coefficients["wt", "Estimate"]
summary(fit)$coefficients["wt", "Pr(>|t|)"]
mean(predict(fit))
predict(fit, newdata = data.frame(wt = 3, hp = 100))
```

`summary(fit)$coefficients` 是一个矩阵，行是模型项，列是 Estimate、Std. Error、统计量与 p-value。这里不需要额外加 TRUE；只有作为 `vapply()` 的输出原型时，TRUE 才有那种用途。

`coef()` 提取系数；`predict()` 计算预测结果；`residuals()` 是残差；`model.matrix()` 是设计矩阵。GLM 的 `predict()` 默认通常给链接尺度；Poisson 要均值尺度用 `type = "response"`。

`mean(predict(fit))` 是各分析观测的预测均值。把所有协变量先取均值再预测，并不普遍等价：非线性模型、交互或非线性变换都会使这种替代需要额外条件。

### 6.4 OLS 矩阵公式：X 与 y 必须来自同一批行

```r
model_dat <- mtcars[c("mpg", "wt", "hp")]
model_dat <- model_dat[complete.cases(model_dat), ]
X <- model.matrix(~ wt + hp, data = model_dat)
y <- model_dat$mpg
beta_matrix <- solve(t(X) %*% X) %*% t(X) %*% y
beta_lm <- coef(lm(mpg ~ wt + hp, data = model_dat))
all.equal(as.numeric(beta_matrix), as.numeric(beta_lm)) # TRUE
```

X 包含截距列 1。`t()` 转置、`%*%` 矩阵乘法、`solve()` 解方程/求逆。公式要求 X 有足够秩；考试给正常可估计情况时按公式写即可。

不要让 `lm()` 自动删一批缺失行，而手工矩阵仍保留另一批数据；这就是 HW2 要强调统一分析数据的原因。

### 6.5 从 HW2/3 提炼的统计解释

- 线性回归的正态假设主要关乎条件误差/残差，不要求所有原始 x 或 y 都正态。
- `log(1 + count)` 可容纳零，并压缩极大的值；减少右偏不保证变成正态。
- 因变量没有变异时，无法提供通常意义上的回归比较。
- 相关或显著系数不自动代表因果关系。
- t-test：H₀为两组总体均值相等；双侧H₁为不相等。p-value 不是“H₀为真的概率”。
- Poisson：`glm(y ~ x, family = poisson(), data = d)`；系数在 log 均值尺度，`exp(beta)` 是比率。
- IRR=1.02 表示预测均值约为原来的1.02倍，即高约2%，不是高1.02个单位。
- AIC 更低表示在相同可比数据与似然设定下的拟合/复杂度折中较好；不同模型样本量不同，不能仅看 AIC 直接下结论。
- pseudo-R² 有多种定义，必须说明用哪种；deviance-based 与 McFadden 不可混叫一个定义。
- 普通 Poisson 检验依赖均值/方差等模型假设；不要只凭很小的 p-value 就忽略模型适用性。

Lecture 6 也介绍一般 GLM、混合模型与系数假设检验。历年题主要集中在上面部分，但这些仍属于今年公布的讲义范围；有余力再看 `glht()` 如何检验系数组合、随机截距与普通固定效应的区别。

<a id="simulation"></a>

## 7. 函数、循环与 Monte Carlo

### 7.1 函数输入、返回与实际调用

```r
f <- function(x, add = 2) {
  out <- x + add
  out * 3
}
f(4) # 18，默认add=2，最后表达式自动返回

make_summary <- function(x) {
  list(avg = mean(x), n = length(x))
}
make_summary(1:3)
```

`return()` 可在任意位置提前退出；退出的是当前函数。循环里的 `break` 只退出最近一层循环，`next` 跳过当前这一轮。for 循环里的变量名和匿名函数参数名可以自选，不自带特殊意义。

F25 P1(f) 要先看 `q <- bar(5)`：没有调用 foo，就不要替 foo 先加2。追踪方法是给每层参数写具体值，再从最内层往外返回。

```r
f_positive <- function(n) {
  if (!is.numeric(n) || length(n) != 1 || is.na(n) ||
      !is.finite(n) || n < 1 || n != floor(n)) {
    stop("n must be one finite positive integer")
  }
  seq_len(n)
}
f_positive(3)
```

输入检查在 HW 中明确要求，在历年模拟题中有时明确说不要求。按题目做；考试没要求时不要把时间耗在长篇防御代码和 roxygen 上。函数如果要兼容 n=0，`1:n` 会有陷阱，`seq_len(n)` 更可靠。

### 7.2 不用现成 mean / median 的官方示例任务

均值是总和除以个数；中位数先排序，再按奇偶长度选中间位置：

```r
manual_centers <- function(x) {
  x <- sort(x[!is.na(x)])
  n <- length(x)
  if (n == 0) stop("No nonmissing values")
  avg <- sum(x) / n
  if (n %% 2 == 1) {
    med <- x[(n + 1) / 2]
  } else {
    med <- (x[n / 2] + x[n / 2 + 1]) / 2
  }
  c(mean = avg, median = med)
}
manual_centers(c(9, 1, 4, 2)) # mean=4，median=3
```

### 7.3 循环常见逻辑错误

```r
total <- 0
for (i in 1:4) {
  total <- total + i
}
total # 10
```

累积器必须放循环外初始化。若放循环里，每次都会清零。while 循环则必须检查：条件何时更新？第一次是否执行？临界点用 `<` 还是 `<=`？

给每个元素独立加噪声应使用 `x + rnorm(length(x))`。`x + rnorm(1)` 给所有元素加的是**同一个随机值**；它不是固定加1。

替换子集时左右要对齐：`d$target[parttime] <- d$part[parttime]`，不能左边只选兼职者、右边却把全体人的值都放进去。

### 7.4 随机分布函数与 seed

| 前缀/函数 | 作用 |
|---|---|
| `rnorm(n, mean, sd)` | 生成n个正态随机数；第三参数是标准差 |
| `rpois(n, lambda)` | Poisson 抽样，lambda 为均值 |
| `rbinom(n, size, prob)` | n次二项实验；硬币常设 size=1 |
| `runif(n)` | 默认在0到1之间抽样 |
| `sample(x, size, replace, prob)` | 从有限集合抽样，输出长度是size |
| `d...` / `p...` / `q...` | 密度/概率质量；累计概率；分位数 |

```r
set.seed(506)
a_random <- rnorm(4, mean = 0, sd = 3) # 方差为9
set.seed(506)
b_random <- rnorm(4, mean = 0, sd = 3)
identical(a_random, b_random) # TRUE
```

通常在整次模拟开始前设一次 seed。若每个 replication 都重置为同一个 seed，就可能把同一次随机实验复制 B 次。seed 的506只是任意选的整数，与模型或课程号没有数学关系。

`replace = TRUE` 允许重复抽到同一种结果；硬币、贴纸、轮盘反复独立抽取通常需要它。`prob` 按顺序对应 x 的取值；权重不必加总为1，但必须是有效的非负权重。

### 7.5 通用模拟模板：单次实验→重复→汇总

```r
one_trial <- function(n) {
  draws <- sample(c("A", "B", "C"), size = n, replace = TRUE)
  length(unique(draws)) == 3
}
set.seed(506)
B <- 2000
successes <- sapply(seq_len(B), function(i) one_trial(5))
mean(successes)       # 估计成功概率
100 * mean(successes) # 成功百分比
```

要估计均值，就收集数值再 `mean()`；要估计概率，就收集事件是否发生再 `mean()`；要数发生次数用 `sum()`。说“百分比”时乘100，比例0.4与百分数40不要混写。

### 7.6 三年模拟题的三个可迁移结构

**F23：拒绝重复直到满足条件。** 偏硬币连抛两次，结果不同时返回第一次；相同时重新抛。正反与反正概率都是 p(1−p)，条件于两次不同，第一次正面的概率为1/2。

```r
fair_from_biased <- function(p) {
  repeat {
    flips <- rbinom(2, size = 1, prob = p)
    if (flips[1] != flips[2]) return(flips[1])
  }
}
set.seed(506)
mean(sapply(1:2000, function(i) fair_from_biased(0.7))) # 应接近0.5
```

**F24：连续窗口可以重叠。** 四个连续 red 含两个长度3的 red 窗口，不是一个。

```r
colors <- c("red", "red", "red", "red", "black", "black", "black")
n_colors <- length(colors)
sum(colors[1:(n_colors - 2)] == colors[2:(n_colors - 1)] &
      colors[2:(n_colors - 1)] == colors[3:n_colors]) # 3
```

轮盘题若只需要颜色，可直接按18红/18黑/2绿抽颜色；若要求数值则从38个槽位抽值。不要为颜色结果额外写与目标无关的复杂数字映射。

**F25/F26 practice：每次实验买固定数量的包，判断是否集齐。** 先根据预算算可买包数，再判断 `length(unique(draws)) == K`，最后重复 B 次。F25 题解特别说明修正预算为$40；不要记住旧题排版错误的$20。

### 7.7 HW2 两个容易再考的点

**Momentum：** 保持方向的总概率是 `p + (1-p)/4`，因为进入随机重选分支后仍有1/4概率选回原方向。它不等于p。

**Bus：** 每天各时段期望相加为 `3×4 + 45 + 6×15 + 55 + 6×9 = 256`。方差16/25对应 `rnorm()` 的 sd=4/5。

```r
set.seed(506)
B_bus <- 2000
hours_by_day <- rbind(
  matrix(rpois(3 * B_bus, 4), nrow = 3),
  rnorm(B_bus, 45, 4),
  matrix(rpois(6 * B_bus, 15), nrow = 6),
  rnorm(B_bus, 55, 5),
  matrix(rpois(6 * B_bus, 9), nrow = 6)
)
mean(colSums(hours_by_day)) # 每列一天；结果应在256附近
```

`rbind()` 是把各时段按行堆叠，不是把所有日子串成一列。一次随机结果不能证明一般趋势；比较平均最终距离时需要重复整条 walk。

<a id="sql"></a>

## 8. SQL：查询顺序、分组与连接行数

对应：[Lecture 7](https://phuongov.github.io/stats506-f26/07-sql.html)、三年 SQL 大题、F26 Quiz 2、HW3 P2。

### 8.1 书写顺序与思考顺序

```sql
SELECT group_id, SUM(value) AS total
FROM records
WHERE value > 0
GROUP BY group_id
HAVING SUM(value) >= 10
ORDER BY total DESC
LIMIT 2;
```

书写顺序为 SELECT → FROM/JOIN → WHERE → GROUP BY → HAVING → ORDER BY → LIMIT。手算时通常先想 **FROM/JOIN 得到哪些行 → WHERE 筛行 → 分组 → 求汇总 → HAVING 筛组 → 输出列 → 排序 → 取前几行**。这是便于理解的逻辑顺序，不是数据库必须采用的物理执行计划。

- WHERE 处理汇总前的行；HAVING 处理汇总后的组。
- AS 设置输出列名或表的别名。
- `ORDER BY total DESC` 降序，默认 ASC 升序；课件的 `ORDER BY -total` 是数值降序写法。
- 没有 ORDER BY 时不要把偶然返回顺序当作保证；并列排序未加第二排序键时，前几名可能不唯一。
- SQL 的 `LIKE 'A%'` 中 `%` 是任意长度、`_` 是一个字符；它们不是 regex 的 `.*`、`.`。

### 8.2 手算分组

假设输入为：

| g | x |
|---|---:|
| A | 2 |
| A | 7 |
| B | 4 |

`SELECT g, SUM(x) AS total FROM t GROUP BY g HAVING SUM(x)>5` 输出 A/9；B/4 被 HAVING 去掉。列名应写 g 与 total，不能只给一个没有标签的9。

### 8.3 连接先看“保留谁”，再看“每个键有几个匹配”

| 连接 | 保留范围 |
|---|---|
| INNER JOIN | 两侧能匹配的组合 |
| LEFT JOIN | 匹配组合，加上左侧未匹配行 |
| RIGHT JOIN | 匹配组合，加上右侧未匹配行 |
| FULL OUTER JOIN | 匹配组合，加上两侧所有未匹配行 |

同一个键在左边有 a 行、右边有 b 行，若两边都出现该键，通常产生 **a×b 行**。LEFT JOIN 的行数不一定等于左表行数；右侧同键重复会放大左表。

**F26 Quiz 2：** 18位唯一学生，30份提交来自其中12位；每份提交都能匹配一个学生。

| 以 student 为左表、submission 为右表 | 行数 | 为什么 |
|---|---:|---|
| INNER | 30 | 每份提交匹配一次 |
| LEFT | 36 | 30份提交＋6位无提交学生 |
| RIGHT | 30 | 保留所有提交；没有额外未匹配提交 |
| FULL | 36 | 30个匹配行＋6个学生未匹配行 |

注意“只有12位有提交”不表示 INNER JOIN 只有12行；那要另做去重或分组计数。

### 8.4 未匹配行中，哪边的 key 还有值

| left.id | left.x |
|---:|---:|
| 1 | 8 |
| 2 | 9 |

| right.id | right.y |
|---:|---:|
| 2 | 20 |
| 3 | 30 |

LEFT JOIN 后，id=1 的行中 `left.id` 仍是1，`right.id` 是NULL。F24 P5(f) 特别考选哪边的 key。NULL 在 R 输出中通常显示为 NA。

```sql
SELECT l.id, l.x, r.y
FROM left_table AS l
LEFT JOIN right_table AS r ON l.id = r.id;
```

`COUNT(*)` 数行；`COUNT(y)` 数 y 非NULL的行；SUM/AVG 通常跳过NULL。用 `IS NULL` 判断SQL缺失，不能写 `= NULL`。LEFT JOIN 后再用 WHERE 要求右侧值满足条件，可能把未匹配行又筛掉。

### 8.5 与 HW3 对接：R 聚合 vs SQL 聚合

```r
library(DBI)
con <- dbConnect(RSQLite::SQLite(), ":memory:")
customer_demo <- data.frame(store_id = c(1, 1, 2), active = c(1, 0, 1))
dbWriteTable(con, "customer", customer_demo)
dbGetQuery(con, "SELECT store_id, COUNT(*) AS n, AVG(active) AS active_prop
                FROM customer GROUP BY store_id ORDER BY store_id")
tapply(customer_demo$active, customer_demo$store_id, mean)
dbDisconnect(con)
```

active为0/1时，均值就是active比例。比较运行时间时，两种方法都应包含题目指定的数据库读取与运算，不要只测 R 内存中的最后一步，却让 SQL 包含整次查询。

<a id="tools"></a>

## 9. Debugging、Quarto 与 Git

### 9.1 能运行不代表实现了目标

先写“目标应该得到什么”，再核对代码：输出长度是否对？哪层循环更新？分组有没有丢？左右索引是否对应？

| 工具 | 用途 |
|---|---|
| `print()` | 检查中间值、长度、维度、循环位置 |
| `traceback()` | 错误发生后查看调用链 |
| `browser()` | 在函数某行暂停，检查局部环境 |
| `debug(f)` / `undebug(f)` | 进入/取消函数逐步调试 |
| `Rprof()` / `summaryRprof()` | 采样查看程序时间花在哪些调用 |
| `microbenchmark()` | 比较多次运行不同实现的时间分布 |

`browser()` 下可检查变量；常用 n 单步、c 继续、Q 退出。`<<-` 会向外层环境寻找并修改绑定，不是普通局部赋值；调试留下的全局变量可能掩盖函数里的拼写错误。

注意题目中的 `<-` 与 `< -` 不同：后者可能被解析为“小于负数”的比较，代码能运行但没有赋值。

### 9.2 Quarto 与显示/执行分开理解

| 选项 | 做了什么 |
|---|---|
| `echo: false` | 隐藏代码文本，通常仍执行并显示结果 |
| `eval: false` | 不执行该代码块 |
| `include: false` | 执行，但不把代码或结果放进输出 |
| `warning: false` | 隐藏警告显示；不修复错误 |
| `code-fold: true` | HTML中把代码折叠，仍包含代码 |
| `embed-resources: true` | 尽量把资源嵌入HTML，便于单文件分享 |

QMD/Rmd 是源文件，render 后得到 HTML/PDF/Word。文中的代码块通常共享同一次渲染过程的 R 会话，但渲染不能依赖你在交互终端手工创建、却未写进文档的对象。YAML 用缩进表达结构。PDF 是静态页面，没有HTML那样的点击折叠代码。

### 9.3 Git 最小概念集

```text
修改文件 → git add → git commit → git push
          暂存       本地历史       发往远端
```

- Git 是版本控制工具；GitHub 是托管 Git 仓库的平台。
- commit 记录项目状态；diff 用于查看变化。commit 不等于 push。
- clone 第一次复制已有仓库；pull 更新现有本地仓库。
- fetch 获取远端信息；pull 通常还会进行整合，具体方式由配置决定。
- 分支提供不同开发路径；merge 整合路径。
- 同一区域有冲突时应读懂双方修改再解决，不能把一方覆盖当成通用答案。
- `.gitignore` 影响未跟踪文件，不能自动把已经跟踪的文件移出历史。
- Blame 用于追溯哪次提交最后修改了某行；高级 rebase 了解概念即可，不必优先背复杂操作。

Lecture 2/3 没有在近年试题里单独占大题，不代表今年排除；用这两张小表做最后一轮回忆。

<a id="homework"></a>

## 10. 把 HW1–3 转成考试能力

不要背每个数据集的具体结果，能把题目转换成函数、索引、模型或SQL即可。

| 作业部分 | 应提炼的能力 | 复习时给自己的一句话问题 |
|---|---|---|
| HW1 Soybean | 分组相关、最大值索引、比例、均值表、t-test | 最大PH对应的GY，不是最大的GY，如何选？ |
| HW1 Adult | 缺失值编码、逻辑筛选、前后样本量 | 删除多个条件用OR，保留合格样本如何改写？ |
| HW1 Happy Number | 输入检查、数字拆分、while/repeat、循环终止、list返回 | 怎样同时检测到1与重复状态？ |
| HW2 Momentum Walk | 状态更新、抽样分支、坐标累积、重复实验 | “重选”仍可能选回原方向，概率怎么算？ |
| HW2 Reproducibility/Timing | seed、独立重复、比较同样任务 | 为什么不能每轮都设相同seed？ |
| HW2 Bus | 期望相加、方差转sd、矩阵按列一天 | 为什么rbind后对列求和？ |
| HW2 YouTube | 清洗、log变换、summary提取、分析行一致、设计矩阵 | predict与coef有什么区别？ |
| HW3 NHANES | merge、factor、特殊缺失码、Poisson/IRR | 类别编码数字能直接当真实金额吗？ |
| HW3 Sakila | 多次join、分组比例、SQL/R等价、benchmark | 一对多连接后为什么行数会增加？ |
| HW3 Australian | 域名regex、分母、去标点、捕获/提取、首位数字 | 用 `.com` 搜索为什么可能把 `.com.au` 也算进来？ |

可直接复用的模板：

```r
# 找最大值所在的所有位置，保留并列
heights <- c(10, 14, 14)
yields <- c(3, 5, 6)
yields[heights == max(heights)] # 5, 6

# 比例和百分数
mean(yields > mean(yields)) # 比例
100 * mean(yields > mean(yields)) # 百分数

# 按组统计
season <- c("summer", "winter", "winter")
tapply(yields, season, mean)
```

`which.max()` 只返回首次最大值的位置；用等号索引能保留并列。存在缺失时要另外确定 NA 的处理方式和比例分母。

NHANES 的特殊收入类别12/13范围重叠，77/99是非应答；不能把编号大小直接当收入大小。[官方HW3解答](https://phuongov.github.io/stats506-f26/Homework%203/hw03solns.html)采用删除重叠类别并把14/15重新编号11/12的秩分值方法。区间中点法是另一种带假设的数值化，两种模型数值结果可能不同；答案应明确编码假设，不能把它们当同一个自变量。

<a id="pitfalls"></a>

## 11. 历年资料中的易误读之处

以下是根据规则和可运行代码整理的纠正，不意味着旧卷的所有解答都不可靠：

1. **F24 regex P4**：官方列出默认引擎与 `perl=TRUE` 对 `(.)0.*\\1` 的差异；按第4.5节处理。
2. **F24 标准化 / F25 min–max**：真实数据含NA时，mean/sd/min/max需要明确 `na.rm=TRUE`；不能一边说考虑缺失、一边让整个计算变NA。
3. **F24 `poly()` 示例参数**：可运行写法是 `poly(q, degree = 2, raw = TRUE)`。参数名和大小写要正确，不能照搬 `degrees`/`RAW` 笔误。
4. **F24 `sample()` 文字**：输出长度由 `size` 决定，而不是始终等于候选集合 x 的长度。
5. **F25 加噪声解释**：`rnorm(1)` 是一个随机值，不是固定1；错误在于所有元素共享这一随机偏移。
6. **F25 空性别解释**：`"" == "Female"` 是FALSE，不是TRUE；问题在于把未知当成非女性。
7. **F25/F26贴纸函数**：`mean(success)` 返回0到1的比例；若题面要求百分数，要乘100或明确用比例表达。
8. **F26 Lecture 8 注释**：文字提到“中间隔着o”，但代码 `(.)n\\1` 实际匹配中间隔字母n，如 ana。
9. **旧网页转义**：表头里的反斜杠可能被HTML/Markdown多显示一层；先确认是在读R源码字符串，还是已解析的正则模式。
10. **F23范围差异**：SAS与Stata部分不按F26重点复习；其中能转成R公式的问题仍有价值。

### 11.1 历年代码追踪核对表（先自己做，再看）

这张表只提供结果检查点，不复制原题。原代码见文末对应年份解答。

| 年份 | P1(a) | P1(b) | P1(c) | P1(d) | P1(e) | P1(f) |
|---|---|---|---|---|---|---|
| F23 | 25 | 42 | `c(-3,0,-3)` | 1.25 | 3 | 35 |
| F24 | 48 | 命名向量 `a=6,b=160,c=26` | `c(6,4,2)` | 20 | 1 | 15 |
| F25 / F26 practice | 25 | 24 | 4×2矩阵，两列均为`2,12,30,56` | `1,2,3,4,0,1,2,3,4,5` | 2 | 15 |

F23/F24矩阵题都需要：先按列填矩阵→算行汇总和列汇总→对不同长度结果再次回收。F23 P1(b)被乘2的是第1、第3、第5项；不要误读为“前两项都乘2”。

<a id="practice"></a>

## 12. 闭卷自测（先遮住答案）

建议用30–40分钟完成，再定位相应章节。题目为本讲义自编变式，不是今年正式考题。

### Q1 回收

写结果，并判断有无警告：

```r
c(4, 7, 10, 13, 16) * c(1, 2)
```

### Q2 list 与 data.frame

```r
L <- list(a = 1:3, b = 4:7)
c(length(L[1]), length(L[[1]]))
```

若一个data.frame有20行、5列，它的length是多少？

### Q3 矩阵与apply

```r
T <- matrix(1:6, nrow = 2)
apply(T, 1, sum)
apply(T, 2, sum)
```

### Q4 输出形状

```r
sapply(list(a = 1:3, b = 4:6), function(v) c(sum(v), mean(v)))
```

结果是list、向量还是矩阵？维度多少？

### Q5 vapply

`vapply(L, length, numeric(1))` 的第三个参数在干什么？计算过程会把0加进长度吗？

### Q6 字符类与分组

```r
words <- c("a", "ab", "ba", "abab", "abc")
grepl("^[ab]+$", words)
grepl("^(ab)+$", words)
```

### Q7 捕获组

```r
grepl("^(.)(.)\\2\\1$", c("abba", "aaaa", "abab", "a11a"))
```

请对第1项标出两个捕获组的内容。

### Q8 日期形状

`"^[0-9]{4}.?[0-9]{2}.?[0-9]{2}$"` 能否匹配 `"2026x10y27"`、`"20261027"`、`"2026-99-99"`？它是否验证日期真实存在？

### Q9 管道

```r
log %>% sapply(1:3, FUN = .)
```

写成普通R调用，并解释左边传来的对象。

### Q10 分组

```r
tibble(g = c("A", "A", "B", "B"), x = c(1, 3, 5, 7)) %>%
  group_by(g) %>%
  mutate(centered = x - mean(x)) %>%
  summarize(total = sum(centered))
```

输出几行？每行total是多少？若删掉group_by会怎样？

### Q11 模型公式

把 `lm(y ~ x*z - x, data = d)` 展开成数学方程，包括截距。再写只包含截距、x和x²的R公式。

### Q12 缺失值

一个sex列可能有 `"Female"`、`"Male"`、`""`、NA。生成female指示变量，并只保留确定为女性的人。不要让base R筛选产生全NA行。

### Q13 Join行数

左表key为 `1,1,2`，右表key为 `1,1,3`。在只按key等值连接时，INNER、LEFT、RIGHT、FULL各有几行？

### Q14 正态抽样

生成100个均值10、方差9的正态随机数，`rnorm()` 应怎样写？

### Q15 Monte Carlo返回量

B次实验的逻辑向量叫success。分别如何得到：成功次数、成功比例、成功百分数？若在每轮开头设同一个seed，有什么问题？

### Q16 连续窗口

序列 `R R R R B B B` 中，长度3且同色的连续窗口有几个？为什么不是只数两段颜色？

---

### 12.1 自测答案与推导

**A1：** `4,14,10,26,16`。短向量回收成1,2,1,2,1；长度5不是2的倍数，有警告。

**A2：** `1,3`；data.frame的length为5，因为它是按列组成的list。

**A3：** 行和9,12；列和3,7,11。先写矩阵两行分别为1,3,5和2,4,6。

**A4：** 2×2矩阵，两列分别为`6,2`与`15,5`；每次返回两个数，外层有两个输入元素。

**A5：** 输出原型：每次一个数值。0不参与计算，得到a=3、b=4。

**A6：** 第一行`TRUE TRUE TRUE TRUE FALSE`；第二行`FALSE TRUE FALSE TRUE FALSE`。`[ab]`一次选一个字符；`(ab)`一次是一整段。

**A7：** `TRUE TRUE FALSE TRUE`。abba中组1=a、组2=b，后两位要求b、a。允许组1与组2相同，所以aaaa也通过。

**A8：** 三项都能匹配；两个 `.?` 都允许零或一个任意字符。仅验证形状，不验证日历有效性。

**A9：** `sapply(1:3, log)`；传来的是函数log，放在FUN位置。输出0、log(2)、log(3)。

**A10：** 两行，A和B的total都为0，各组减去自身均值后加总为0。删掉group_by则先以全体均值中心化，再汇总成全体一行，total仍是0。

**A11：** `y = β0 + β1*z + β2*(x*z) + error`。第二问：`y ~ x + I(x^2)`，或 `y ~ poly(x, 2, raw = TRUE)`。

**A12：** 下面提供一种完整处理方式：

```r
sex_dat <- data.frame(sex = c("Female", "Male", "", NA))
sex_dat$female <- sex_dat$sex == "Female"
sex_dat$female[sex_dat$sex == ""] <- NA
sex_dat <- sex_dat[which(sex_dat$female), , drop = FALSE]
```

**A13：** INNER=4，LEFT=5，RIGHT=5，FULL=6。key=1有2×2=4个组合；左边key2和右边key3各额外贡献一个未匹配行。

**A14：** `rnorm(100, mean = 10, sd = 3)`。

**A15：** `sum(success)`、`mean(success)`、`100*mean(success)`；每轮同seed可能产生完全相同的重复实验，无法正常估计随机变动。

**A16：** 3个：RRR从位置1、2各起一个，BBB从位置5起一个。窗口可以重叠，不能只数颜色段。

<a id="sources"></a>

## 13. 最后一轮复习与来源

### 13.1 只剩一小时，按这个顺序回忆

1. **15分钟 apply：** 能写MARGIN=1/2；解释lapply/sapply/vapply输出；说明一列一次实验。
2. **15分钟 regex：** `^/$`、`[]/()`、`*+?{}`、`\\.`、`\\1/\\2`；用一个正例和反例证明理解。
3. **10分钟 tidyverse：** 逐步写中间表；mutate不折叠、summarize折叠；grouping状态不等于列是否存在。
4. **10分钟 SQL：** INNER/LEFT/RIGHT/FULL保留谁；一对多/多对多行数；WHERE/HAVING；选哪侧key。
5. **10分钟模型/模拟/工具：** 交互项展开、I(x²)、factor；sd不等于variance；比例乘100；seed；Quarto与Git核心概念。

再自问：我能否不用运行R，手算一个小例子，并说出为什么？若只能“看答案觉得懂”，就换一组数重新做。

### 13.2 历年原始资料

| 年份 | 课程主页 | 期中资料 |
|---|---|---|
| F23 | [主页](https://dept.stat.lsa.umich.edu/~jerrick/courses/stat506_f23/) | [说明](https://dept.stat.lsa.umich.edu/~jerrick/courses/stat506_f23/midterm_details.html) · [试卷PDF](https://dept.stat.lsa.umich.edu/~jerrick/courses/stat506_f23/midterm.pdf) · [解答](https://dept.stat.lsa.umich.edu/~jerrick/courses/stat506_f23/midterm-solns.html) |
| F24 | [主页](https://dept.stat.lsa.umich.edu/~jerrick/courses/stat506_f24/) | [说明](https://dept.stat.lsa.umich.edu/~jerrick/courses/stat506_f24/midterm_details.html) · [解答](https://dept.stat.lsa.umich.edu/~jerrick/courses/stat506_f24/midtermsolns.html) |
| F25 | [主页](https://dept.stat.lsa.umich.edu/~jerrick/courses/stat506_f25/) | [说明](https://dept.stat.lsa.umich.edu/~jerrick/courses/stat506_f25/midterm_details.html) · [解答](https://dept.stat.lsa.umich.edu/~jerrick/courses/stat506_f25/midtermsolns.html) |
| F26 | [主页](https://phuongov.github.io/stats506-f26/) | [本次说明](https://phuongov.github.io/stats506-f26/midterm/midterm_details.html) · [Practice exam PDF，含解答](https://phuongov.github.io/stats506-f26/midterm/midterm_practice_exam.pdf) |

### 13.3 F26 Lecture、Quiz 与 HW

| 内容 | 链接 |
|---|---|
| Lecture 1 | [Introduction to R](https://phuongov.github.io/stats506-f26/01-R-basics.html) |
| Lecture 2 | [Quarto](https://phuongov.github.io/stats506-f26/02-quarto.html) |
| Lecture 3 | [Git](https://phuongov.github.io/stats506-f26/03-git.html) |
| Lecture 4 | [Vectorization and Monte Carlo](https://phuongov.github.io/stats506-f26/04-vectorization.html) |
| Lecture 5 | [Debugging](https://phuongov.github.io/stats506-f26/05-debugging-functions.html) |
| Lecture 6 | [Modeling in R](https://phuongov.github.io/stats506-f26/06-modeling-in-R.html) |
| Lecture 7 | [SQL](https://phuongov.github.io/stats506-f26/07-sql.html) |
| Lecture 8 | [Strings and Regular Expressions](https://phuongov.github.io/stats506-f26/08-regex.html) |
| Lecture 9 | [tidyverse](https://phuongov.github.io/stats506-f26/09-tidyverse.html) |
| Quiz 1 | [索引、回收、list、命名向量](https://phuongov.github.io/stats506-f26/quiz-solutions/q1_sol.html) |
| Quiz 2 | [SQL连接行数，PDF](https://phuongov.github.io/stats506-f26/quizzes%20solutions/q2_sol.pdf) |
| Quiz 3 | [正则与管道](https://phuongov.github.io/stats506-f26/quizzes%20solutions/quiz3solns.html) |
| HW1 | [题目](https://phuongov.github.io/stats506-f26/ps01.html) · [官方解答](https://phuongov.github.io/stats506-f26/hw-solutions/hw1slns.html) |
| HW2 | [题目](https://phuongov.github.io/stats506-f26/Homework%202/hw2.html) · [官方解答](https://phuongov.github.io/stats506-f26/Homework%202/hw2-solution.html) |
| HW3 | [题目](https://phuongov.github.io/stats506-f26/Homework%203/hw03.html) · [官方解答](https://phuongov.github.io/stats506-f26/Homework%203/hw03solns.html) |

本讲义由 OpenAI Codex 辅助整理。代码例子以解释规则与训练纸笔推导为目的；特定作业中自行查找的扩展命令，不据此推定为老师会要求闭卷记忆的内容。范围和评分仍以 F26 老师发布的正式说明为准。
