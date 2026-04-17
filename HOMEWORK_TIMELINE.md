# 作业时间线

本文件用于说明每次上课日期、PPT 内容、对应 Git 标签和验证命令。Git 提交信息已经按课程节点命名，便于老师检查每次作业内容。

| 上课日期 | PPT | Tag | 作业内容 | 验证命令 |
| --- | --- | --- | --- | --- |
| 2026-03-13 | PPT2 | `ppt2-2026-03-13` | 可配置计数器、`enable/state/overflow`、基础顶层反压仿真 | `sbt "runMain projectname.MyCounterTester"` |
| 2026-03-20 | PPT3 | `ppt3-2026-03-20` | `FlowCounter`、带 ready/valid 反压的 `StreamCounter` | `sbt "runMain projectname.FlowCounterTester"` 和 `sbt "runMain projectname.StreamCounterTester"` |
| 2026-04-03 | PPT3 | `ppt3-2026-04-03` | 双命令流 `StreamForkJoin`，输出乘法流和异或流 | `sbt "runMain projectname.SimStreamJoinForkTester"` |
| 2026-04-10 | PPT4 | `ppt4-2026-04-10` | 同步 RAM、流式 RAM、输出流写入 RAM | `sbt "runMain projectname.StreamRamTester"` 和 `sbt "runMain projectname.StreamToRamRecorderTester"` |
| 2026-04-17 | PPT4 | `ppt4-2026-04-17` | 跨时钟域 `StreamForkJoinCcTop`，使用 `StreamFifoCC` | `sbt "runMain projectname.StreamForkJoinCcTester"` |

## 查看方式

查看完整提交：

```powershell
git log --oneline --reverse
```

查看标签：

```powershell
git tag --list
```

查看某次课对应的代码变化：

```powershell
git show ppt3-2026-04-03
```

生成全部 Verilog：

```powershell
sbt "runMain projectname.HomeworkVerilog"
```
