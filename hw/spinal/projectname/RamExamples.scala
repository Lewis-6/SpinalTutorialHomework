package projectname

import spinal.core._
import spinal.lib._

case class RamWriteCmd(addressWidth: Int, dataWidth: Int) extends Bundle {
  val address = UInt(addressWidth bits)
  val data = UInt(dataWidth bits)
}

case class SimpleRam(addressWidth: Int = 8, dataWidth: Int = 32) extends Component {
  val io = new Bundle {
    val writeValid = in Bool()
    val writeAddress = in UInt (addressWidth bits)
    val writeData = in UInt (dataWidth bits)
    val readValid = in Bool()
    val readAddress = in UInt (addressWidth bits)
    val readData = out UInt (dataWidth bits)
  }

  val mem = Mem(UInt(dataWidth bits), wordCount = 1 << addressWidth)

  mem.write(
    enable = io.writeValid,
    address = io.writeAddress,
    data = io.writeData
  )
  io.readData := mem.readSync(
    enable = io.readValid,
    address = io.readAddress
  )
}

case class StreamRam(addressWidth: Int = 8, dataWidth: Int = 32) extends Component {
  val io = new Bundle {
    val write = slave(Stream(RamWriteCmd(addressWidth, dataWidth)))
    val readCmd = slave(Stream(UInt(addressWidth bits)))
    val readRsp = master(Stream(UInt(dataWidth bits)))
  }

  val mem = Mem(UInt(dataWidth bits), wordCount = 1 << addressWidth)
  val readInFlight = Reg(Bool()) init (False)
  val readValid = Reg(Bool()) init (False)
  val readData = Reg(UInt(dataWidth bits)) init (0)

  io.write.ready := True
  mem.write(
    enable = io.write.fire,
    address = io.write.payload.address,
    data = io.write.payload.data
  )

  io.readCmd.ready := !readInFlight && (!readValid || io.readRsp.ready)
  val memReadData = mem.readSync(
    enable = io.readCmd.fire,
    address = io.readCmd.payload
  )

  when(io.readCmd.fire) {
    readInFlight := True
  }

  when(readInFlight) {
    readData := memReadData
    readValid := True
    readInFlight := False
  }

  when(io.readRsp.fire) {
    readValid := False
  }

  io.readRsp.valid := readValid
  io.readRsp.payload := readData
}

case class StreamToRamRecorder(addressWidth: Int = 8, dataWidth: Int = 32)
    extends Component {
  val io = new Bundle {
    val input = slave(Stream(UInt(dataWidth bits)))
    val readValid = in Bool()
    val readAddress = in UInt (addressWidth bits)
    val readData = out UInt (dataWidth bits)
    val writtenCount = out UInt ((addressWidth + 1) bits)
    val full = out Bool()
  }

  val mem = Mem(UInt(dataWidth bits), wordCount = 1 << addressWidth)
  val writeCount = Reg(UInt((addressWidth + 1) bits)) init (0)
  val full = writeCount === (1 << addressWidth)

  io.input.ready := !full
  when(io.input.fire) {
    mem.write(
      address = writeCount.resized,
      data = io.input.payload,
      enable = True
    )
    writeCount := writeCount + 1
  }

  io.readData := mem.readSync(
    enable = io.readValid,
    address = io.readAddress
  )
  io.writtenCount := writeCount
  io.full := full
}

object SimpleRamVerilog extends App {
  Config.spinal.generateVerilog(SimpleRam())
}

object StreamRamVerilog extends App {
  Config.spinal.generateVerilog(StreamRam())
}

object StreamToRamRecorderVerilog extends App {
  Config.spinal.generateVerilog(StreamToRamRecorder())
}
