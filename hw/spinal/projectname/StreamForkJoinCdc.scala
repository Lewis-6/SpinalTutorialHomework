package projectname

import spinal.core._
import spinal.lib._

case class StreamForkJoinCc(receiveClock: ClockDomain, fifoDepth: Int = 16)
    extends Component {
  val io = new Bundle {
    val cmdA = slave(Stream(UInt(32 bits)))
    val cmdB = slave(Stream(UInt(32 bits)))
    val rspMul = master(Stream(UInt(64 bits)))
    val rspXor = master(Stream(UInt(32 bits)))
  }

  val core = StreamForkJoin()
  core.io.cmdA << io.cmdA
  core.io.cmdB << io.cmdB

  val mulFifo = StreamFifoCC(
    dataType = UInt(64 bits),
    depth = fifoDepth,
    pushClock = ClockDomain.current,
    popClock = receiveClock
  )
  val xorFifo = StreamFifoCC(
    dataType = UInt(32 bits),
    depth = fifoDepth,
    pushClock = ClockDomain.current,
    popClock = receiveClock
  )

  mulFifo.io.push << core.io.rspMul
  xorFifo.io.push << core.io.rspXor

  io.rspMul << mulFifo.io.pop
  io.rspXor << xorFifo.io.pop
}

case class StreamForkJoinCcTop() extends Component {
  val io = new Bundle {
    val clockB = in Bool()
    val resetB = in Bool()
    val cmdA = slave(Stream(UInt(32 bits)))
    val cmdB = slave(Stream(UInt(32 bits)))
    val rspMul = master(Stream(UInt(64 bits)))
    val rspXor = master(Stream(UInt(32 bits)))
  }

  val receiveClock = ClockDomain(
    clock = io.clockB,
    reset = io.resetB,
    config = ClockDomain.current.config
  )
  val core = StreamForkJoinCc(receiveClock)

  core.io.cmdA << io.cmdA
  core.io.cmdB << io.cmdB
  io.rspMul << core.io.rspMul
  io.rspXor << core.io.rspXor
}

object StreamForkJoinCcVerilog extends App {
  Config.spinal.generateVerilog(StreamForkJoinCcTop())
}
