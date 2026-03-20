package projectname

import spinal.core.sim._
import spinal.lib.sim._

import scala.collection.mutable

object FlowCounterTester extends App {
  val width = 8
  val validEvery = 4

  Config.sim.compile(FlowCounter(width, validEvery)).doSim { dut =>
    dut.clockDomain.forkStimulus(10)
    dut.io.enable #= false
    dut.clockDomain.waitSampling(2)
    sleep(1)
    assert(dut.io.state.payload.toBigInt == 0)
    assert(dut.io.state.valid.toBoolean)

    dut.io.enable #= true
    var model = BigInt(0)
    for (_ <- 0 until 32) {
      model = (model + 1) & ((BigInt(1) << width) - 1)
      dut.clockDomain.waitSampling()
      sleep(1)
      assert(dut.io.state.payload.toBigInt == model)
      assert(dut.io.state.valid.toBoolean == (model % validEvery == 0))
    }

    println("FlowCounterTester passed.")
  }
}

object StreamCounterTester extends App {
  Config.sim.compile(StreamCounter(width = 8, emitEvery = 4)).doSim { dut =>
    dut.clockDomain.forkStimulus(10)
    dut.io.enable #= true

    val seen = mutable.ArrayBuffer[BigInt]()
    StreamMonitor(dut.io.state, dut.clockDomain) { payload =>
      seen += payload.toBigInt
    }
    StreamReadyRandomizer(dut.io.state, dut.clockDomain).setFactor(3)

    dut.clockDomain.waitSampling(300)
    val expected = (0 until seen.length).map(i => BigInt((i * 4) & 0xff))
    assert(seen.nonEmpty)
    assert(seen.toSeq == expected, s"seen=${seen.mkString(",")}, expected=${expected.mkString(",")}")

    println("StreamCounterTester passed.")
  }
}
