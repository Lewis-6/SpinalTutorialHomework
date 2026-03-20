package projectname

import spinal.core._
import spinal.lib._

case class FlowCounter(width: Int, validEvery: Int = 4) extends Component {
  require(validEvery > 0, "validEvery must be positive")

  val io = new Bundle {
    val enable = in Bool()
    val state = master(Flow(UInt(width bits)))
  }

  val counter = Reg(UInt(width bits)) init (0)
  val phaseWidth = log2Up(validEvery max 2)
  val phase = Reg(UInt(phaseWidth bits)) init (0)

  io.state.payload := counter
  io.state.valid := phase === 0

  when(io.enable) {
    counter := counter + 1
    when(phase === validEvery - 1) {
      phase := 0
    } otherwise {
      phase := phase + 1
    }
  }
}

case class StreamCounter(width: Int, emitEvery: Int = 1) extends Component {
  require(emitEvery > 0, "emitEvery must be positive")

  val io = new Bundle {
    val enable = in Bool()
    val state = master(Stream(UInt(width bits)))
  }

  val nextValue = Reg(UInt(width bits)) init (0)
  val payload = Reg(UInt(width bits)) init (0)
  val valid = Reg(Bool()) init (False)
  val phaseWidth = log2Up(emitEvery max 2)
  val phase = Reg(UInt(phaseWidth bits)) init (0)

  io.state.valid := valid
  io.state.payload := payload

  when(io.state.fire) {
    valid := False
  }

  when(io.enable && !io.state.isStall) {
    payload := nextValue
    nextValue := nextValue + 1

    valid := phase === 0
    when(phase === emitEvery - 1) {
      phase := 0
    } otherwise {
      phase := phase + 1
    }
  }
}

object FlowCounterVerilog extends App {
  Config.spinal.generateVerilog(FlowCounter(width = 8, validEvery = 4))
}

object StreamCounterVerilog extends App {
  Config.spinal.generateVerilog(StreamCounter(width = 8, emitEvery = 4))
}
