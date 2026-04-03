package projectname

import spinal.core._
import spinal.lib._

case class StreamForkJoin() extends Component {
  val io = new Bundle {
    val cmdA = slave(Stream(UInt(32 bits)))
    val cmdB = slave(Stream(UInt(32 bits)))
    val rspMul = master(Stream(UInt(64 bits)))
    val rspXor = master(Stream(UInt(32 bits)))
  }

  val aReg = Reg(UInt(32 bits)) init (0)
  val bReg = Reg(UInt(32 bits)) init (0)
  val mulPending = Reg(Bool()) init (False)
  val xorPending = Reg(Bool()) init (False)
  val busy = mulPending || xorPending
  val accept = io.cmdA.valid && io.cmdB.valid && !busy

  io.cmdA.ready := io.cmdB.valid && !busy
  io.cmdB.ready := io.cmdA.valid && !busy

  when(accept) {
    aReg := io.cmdA.payload
    bReg := io.cmdB.payload
    mulPending := True
    xorPending := True
  }

  io.rspMul.valid := mulPending
  io.rspMul.payload := (aReg * bReg).resized
  when(io.rspMul.fire) {
    mulPending := False
  }

  io.rspXor.valid := xorPending
  io.rspXor.payload := aReg ^ bReg
  when(io.rspXor.fire) {
    xorPending := False
  }
}

object StreamForkJoinVerilog extends App {
  Config.spinal.generateVerilog(StreamForkJoin())
}
