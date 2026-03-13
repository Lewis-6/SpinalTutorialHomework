package projectname

import spinal.core._
import spinal.lib._

case class MyTopLevel(width: Int = 32) extends Component {
  val io = new Bundle {
    val cnt_out = master(Stream(UInt(width bits)))
  }

  val counter = Reg(UInt(width bits)) init (0)

  io.cnt_out.valid := True
  io.cnt_out.payload := counter

  when(io.cnt_out.fire) {
    counter := counter + 1
  }
}

object MyTopLevelVerilog extends App {
  Config.spinal.generateVerilog(MyTopLevel())
}
