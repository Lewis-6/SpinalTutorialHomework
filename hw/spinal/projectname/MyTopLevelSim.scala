package projectname

import spinal.core.sim._

object MyTopLevelSim extends App {
  Config.sim.compile(MyTopLevel()).doSim { dut =>
    dut.clockDomain.forkStimulus(period = 10)

    println("=== Stream counter backpressure simulation ===")

    dut.io.cnt_out.ready #= true
    dut.clockDomain.waitSampling(5)
    sleep(1)
    val valueBeforeStall = dut.io.cnt_out.payload.toBigInt

    dut.io.cnt_out.ready #= false
    dut.clockDomain.waitSampling(5)
    sleep(1)
    assert(dut.io.cnt_out.payload.toBigInt == valueBeforeStall)

    dut.io.cnt_out.ready #= true
    dut.clockDomain.waitSampling(5)
    sleep(1)
    assert(dut.io.cnt_out.payload.toBigInt > valueBeforeStall)

    println("Backpressure check passed.")
  }
}
