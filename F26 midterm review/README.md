# F26 midterm review

所有复习材料统一放在这个文件夹。先做 `Questions` 中的试卷，完成后再打开 `Answers` 对照。

## 复习讲义

- [STATS506_Midterm_Review.md](STATS506_Midterm_Review.md)：结合 F23–F25 与 F26 Lecture 1–9、Quiz、HW1–3 的中文复习讲义，含 apply、regex、管道详解及16道自测。

## 三套无答案练习卷

| 年份 | 无答案 PDF | 版本说明 |
|---|---|---|
| 2023 | [F23 Questions](Questions/STATS506_F23_Midterm_Questions.pdf) | 老师公开的原始试卷，原文件保留，包含当年全部题目 |
| 2024 | [F24 Questions](Questions/STATS506_F24_Midterm_Questions.pdf) | 从官方解答页重建，只保留题目、输入数据、代码和待填写表格 |
| 2025 | [F25 Questions](Questions/STATS506_F25_Midterm_Questions.pdf) | 从官方解答页重建，无答案；使用官方勘误后的40美元预算 |

F24、F25 按 F23 原卷的纸笔练习方式排版：姓名/UMID、计分栏、按题号分节、作答空白、页码。公开解答页没有给出原始分值，因此没有杜撰分值。可按 F26 的75分钟限时练习；F23 原卷注明的80分钟仍保留。

**范围提醒：** F23 的 SAS、Stata 属于当年范围，不在 F26 当前 Lecture 1–9 的公布范围内。需要模拟今年考试时，可跳过这些软件的专门命令题；其中的 R 模型公式仍有练习价值。F25 与 F26 官方 practice exam 的内容基本一致，不是两套独立样卷。

## 对照答案（练习后再打开）

| 年份 | PDF | 可编辑 Markdown |
|---|---|---|
| 2023 | [F23 Answers](Answers/STATS506_F23_Midterm_Answers.pdf) | [F23 Answers.md](Answers/STATS506_F23_Midterm_Answers.md) |
| 2024 | [F24 Answers](Answers/STATS506_F24_Midterm_Answers.pdf) | [F24 Answers.md](Answers/STATS506_F24_Midterm_Answers.md) |
| 2025 | [F25 Answers](Answers/STATS506_F25_Midterm_Answers.pdf) | [F25 Answers.md](Answers/STATS506_F25_Midterm_Answers.md) |

答案根据官方解答整理，并对可确认的笔误或缺失处理作了说明，未要求只有这一种写法。模拟结果随随机流变化，不必与某个固定输出一致；未指定 ORDER BY 的 SQL 查询，行顺序也不应被当作保证。

## 重建与勘误说明

- F24：保留原来的题号、模型方程、日期、SQL数据和模拟任务。数据结构例值在表格里精简显示，但列名、类型和题意不变。
- F24：答案补上 NA 处理；`poly()` 可运行参数为 `degree`、`raw`；`sample()` 输出长度是 `size`。
- F24：正则 `(.)0.*\\1` 的两项引擎差异按官方说明标注，未强行只保留一种答案。
- F25：原页面把数据称为 clinical、随后又称 mydata，并写9个变量但实际列出10个；练习版统一为 mydata、10列。
- F25：保留原题需要找错的代码，未提前修复；答案指出 `rnorm(1)` 是共享的一个随机偏移，而非固定加1。
- F25：按官方勘误使用40美元预算；答案函数返回百分数，因此显式乘100，而不是把比例当作百分比。
- 邮件地址按原网页的邮箱保护编码核对恢复，没有保留网页中显示的 `[email protected]` 占位文本。

## 可编辑源文件与原始留档

`Editable sources` 中有 F24/F25 题目 Markdown、结构化排版数据 `papers.json` 和 PDF 构建脚本。修改 Markdown 可用于记笔记；若要重建 PDF，应修改 `papers.json` 后运行脚本（需要 Python 与 reportlab）。F23 无答案 PDF 是原件，不由该脚本重新排版。

`Official sources` 保留三年的官方解答网页，供核对；它们是原始资料留档，与 `Questions` 分开，避免练习时看到答案。

原始链接：

- [F23 原始试卷](https://dept.stat.lsa.umich.edu/~jerrick/courses/stat506_f23/midterm.pdf)
- [F23 官方解答](https://dept.stat.lsa.umich.edu/~jerrick/courses/stat506_f23/midterm-solns.html)
- [F24 官方解答](https://dept.stat.lsa.umich.edu/~jerrick/courses/stat506_f24/midtermsolns.html)
- [F25 官方解答](https://dept.stat.lsa.umich.edu/~jerrick/courses/stat506_f25/midtermsolns.html)
- [F26 考试说明](https://phuongov.github.io/stats506-f26/midterm/midterm_details.html)

整理日期：2026-10-26。由 OpenAI Codex 辅助制作并核对。重建练习卷属于复习排版版本，不能当作老师另行发布的原始 PDF。
