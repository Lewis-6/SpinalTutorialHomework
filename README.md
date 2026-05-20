# SpinalHDL 课程作业

这个仓库用于提交 SpinalHDL 课程作业。作业按上课日期整理成 5 次 Git commit，老师可以直接通过提交历史查看每次课对应的代码变化。

## 作业对应关系

| 上课日期 | 内容 | 主要文件 | 运行入口 |
| --- | --- | --- | --- |
| 2026-03-13 | 可配置计数器、顶层反压测试 | `MyCounter.scala`, `CounterSims.scala`, `MyTopLevel.scala` | `MyCounterTester`, `MyTopLevelSim` |
| 2026-03-20 | `FlowCounter` 和 `StreamCounter` | `FlowStreamCounters.scala`, `FlowStreamCounterSims.scala` | `FlowCounterTester`, `StreamCounterTester` |
| 2026-04-03 | `Stream` 的 join / fork 练习 | `StreamForkJoin.scala`, `StreamForkJoinSims.scala` | `SimStreamJoinForkTester` |
| 2026-04-10 | RAM、流式 RAM、写入记录 | `RamExamples.scala`, `RamSims.scala` | `StreamRamTester`, `StreamToRamRecorderTester` |
| 2026-04-17 | 跨时钟域通信，使用 `StreamFifoCC` | `StreamForkJoinCdc.scala`, `CdcSims.scala` | `StreamForkJoinCcTester` |

## 运行方式

进入仓库目录：

```powershell
cd F:\CXSJKC\SpinalTutorial
```

编译：

```powershell
sbt compile
```

生成 Verilog：

```powershell
sbt "runMain projectname.HomeworkVerilog"
```

运行仿真：

```powershell
sbt "runMain projectname.MyCounterTester"
sbt "runMain projectname.FlowCounterTester"
sbt "runMain projectname.StreamCounterTester"
sbt "runMain projectname.SimStreamJoinForkTester"
sbt "runMain projectname.StreamRamTester"
sbt "runMain projectname.StreamToRamRecorderTester"
sbt "runMain projectname.StreamForkJoinCcTester"
sbt "runMain projectname.MyTopLevelSim"
```

仿真波形会生成在 `simWorkspace/` 下，可以用 VaporView 或 GTKWave 查看。

