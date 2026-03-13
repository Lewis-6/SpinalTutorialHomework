package projectname

import spinal.core._

case class MyCounter(width: Int) extends Component {
  val io = new Bundle {
    val enable = in Bool()
    val state = out UInt (width bits)
    val overflow = out Bool()
  }

  val counter = Reg(UInt(width bits)) init (0)
  val overflow = Reg(Bool()) init (False)
  val maxValue = U((BigInt(1) << width) - 1, width bits)

  when(io.enable) {
    overflow := counter === maxValue
    counter := counter + 1
  }

  io.state := counter
  io.overflow := overflow
}

object MyCounterVerilog extends App {
  Config.spinal.generateVerilog(MyCounter(4))
}
