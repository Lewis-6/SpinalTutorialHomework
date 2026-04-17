package projectname

object HomeworkVerilog extends App {
  Config.spinal.generateVerilog(MyCounter(4))
  Config.spinal.generateVerilog(FlowCounter(width = 8, validEvery = 4))
  Config.spinal.generateVerilog(StreamCounter(width = 8, emitEvery = 4))
  Config.spinal.generateVerilog(StreamForkJoin())
  Config.spinal.generateVerilog(StreamForkJoinCcTop())
  Config.spinal.generateVerilog(StreamRam())
  Config.spinal.generateVerilog(StreamToRamRecorder())
  Config.spinal.generateVerilog(MyTopLevel())
}
