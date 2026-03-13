package projectname

import spinal.core.sim._

object MyCounterTester extends App {
  val width = 4
  val maxValue = (BigInt(1) << width) - 1

  Config.sim.compile(MyCounter(width)).doSim { dut =>
    dut.clockDomain.forkStimulus(10)
    dut.io.enable #= false
    dut.clockDomain.waitSampling(5)
    sleep(1)
    assert(dut.io.state.toBigInt == 0)
    assert(!dut.io.overflow.toBoolean)

    var model = BigInt(0)
    dut.io.enable #= true
    for (_ <- 0 until 20) {
      val expectedOverflow = model == maxValue
      model = (model + 1) & maxValue
      dut.clockDomain.waitSampling()
      sleep(1)
      assert(dut.io.state.toBigInt == model, s"state=${dut.io.state.toBigInt}, expected=$model")
      assert(
        dut.io.overflow.toBoolean == expectedOverflow,
        s"overflow=${dut.io.overflow.toBoolean}, expected=$expectedOverflow"
      )
    }

    dut.io.enable #= false
    val heldState = dut.io.state.toBigInt
    val heldOverflow = dut.io.overflow.toBoolean
    dut.clockDomain.waitSampling(5)
    sleep(1)
    assert(dut.io.state.toBigInt == heldState)
    assert(dut.io.overflow.toBoolean == heldOverflow)

    println("MyCounterTester passed.")
  }
}
