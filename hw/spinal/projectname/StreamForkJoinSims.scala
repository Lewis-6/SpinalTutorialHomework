package projectname

import spinal.core.sim._
import spinal.lib.sim._

import scala.collection.mutable

object SimStreamJoinForkTester extends App {
  val transactions = (0 until 64).map { i =>
    val a = BigInt(i + 1)
    val b = BigInt(i * 3 + 5)
    (a, b)
  }

  Config.sim.compile(StreamForkJoin()).doSim { dut =>
    dut.clockDomain.forkStimulus(10)

    val cmdA = mutable.Queue(transactions.map(_._1): _*)
    val cmdB = mutable.Queue(transactions.map(_._2): _*)
    val mulRef = mutable.Queue(transactions.map { case (a, b) => a * b }: _*)
    val xorRef = mutable.Queue(transactions.map { case (a, b) => a ^ b }: _*)

    var mulSeen = 0
    var xorSeen = 0

    StreamDriver(dut.io.cmdA, dut.clockDomain) { payload =>
      if (cmdA.nonEmpty) {
        payload #= cmdA.dequeue()
        true
      } else {
        false
      }
    }

    StreamDriver(dut.io.cmdB, dut.clockDomain) { payload =>
      if (cmdB.nonEmpty) {
        payload #= cmdB.dequeue()
        true
      } else {
        false
      }
    }

    StreamReadyRandomizer(dut.io.rspMul, dut.clockDomain).setFactor(3)
    StreamReadyRandomizer(dut.io.rspXor, dut.clockDomain).setFactor(2)

    StreamMonitor(dut.io.rspMul, dut.clockDomain) { payload =>
      assert(payload.toBigInt == mulRef.dequeue())
      mulSeen += 1
    }
    StreamMonitor(dut.io.rspXor, dut.clockDomain) { payload =>
      assert(payload.toBigInt == xorRef.dequeue())
      xorSeen += 1
    }

    var timeout = 2000
    while ((mulSeen < transactions.length || xorSeen < transactions.length) && timeout > 0) {
      dut.clockDomain.waitSampling()
      timeout -= 1
    }

    assert(timeout > 0)
    assert(mulRef.isEmpty)
    assert(xorRef.isEmpty)

    println("SimStreamJoinForkTester passed.")
  }
}
