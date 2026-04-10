package projectname

import spinal.core.sim._

object StreamRamTester extends App {
  Config.sim.compile(StreamRam(addressWidth = 4, dataWidth = 16)).doSim { dut =>
    dut.clockDomain.forkStimulus(10)
    dut.io.write.valid #= false
    dut.io.readCmd.valid #= false
    dut.io.readRsp.ready #= true
    dut.clockDomain.waitSampling(2)

    def write(address: Int, data: Int): Unit = {
      dut.io.write.valid #= true
      dut.io.write.payload.address #= address
      dut.io.write.payload.data #= data
      dut.clockDomain.waitSampling()
      dut.io.write.valid #= false
    }

    def read(address: Int): BigInt = {
      dut.io.readCmd.valid #= true
      dut.io.readCmd.payload #= address
      dut.clockDomain.waitSampling()
      dut.io.readCmd.valid #= false

      var timeout = 20
      while (!dut.io.readRsp.valid.toBoolean && timeout > 0) {
        dut.clockDomain.waitSampling()
        timeout -= 1
      }
      assert(timeout > 0)
      val value = dut.io.readRsp.payload.toBigInt
      dut.clockDomain.waitSampling()
      value
    }

    write(1, 0x1234)
    write(2, 0x4567)
    write(3, 0xabcd)

    assert(read(1) == 0x1234)
    assert(read(2) == 0x4567)
    assert(read(3) == 0xabcd)

    println("StreamRamTester passed.")
  }
}

object StreamToRamRecorderTester extends App {
  Config.sim.compile(StreamToRamRecorder(addressWidth = 4, dataWidth = 16)).doSim { dut =>
    dut.clockDomain.forkStimulus(10)
    dut.io.input.valid #= false
    dut.io.readValid #= false
    dut.clockDomain.waitSampling(2)

    val values = (0 until 16).map(i => 0x1000 + i)
    for ((value, index) <- values.zipWithIndex) {
      dut.io.input.valid #= true
      dut.io.input.payload #= value
      dut.clockDomain.waitSampling()
      sleep(1)
      assert(dut.io.writtenCount.toInt == index + 1)
    }
    assert(dut.io.full.toBoolean)
    dut.io.input.valid #= false

    for ((value, address) <- values.zipWithIndex) {
      dut.io.readValid #= true
      dut.io.readAddress #= address
      dut.clockDomain.waitSampling()
      sleep(1)
      assert(dut.io.readData.toBigInt == value)
    }
    dut.io.readValid #= false

    println("StreamToRamRecorderTester passed.")
  }
}
