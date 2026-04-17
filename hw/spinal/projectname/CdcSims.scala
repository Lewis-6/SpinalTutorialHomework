package projectname

import spinal.core.ClockDomain
import spinal.core.sim._
import spinal.lib.sim._

import scala.collection.mutable
import scala.util.Random

object StreamForkJoinCcTester extends App {
  val transactions = (0 until 32).map { i =>
    val a = BigInt(i + 7)
    val b = BigInt(i * 5 + 11)
    (a, b)
  }

  Config.sim.compile(StreamForkJoinCcTop()).doSim { dut =>
    dut.clockDomain.forkStimulus(10)
    val clockB = ClockDomain(dut.io.clockB, dut.io.resetB)
    clockB.forkStimulus(11)

    val cmdA = mutable.Queue(transactions.map(_._1): _*)
    val cmdB = mutable.Queue(transactions.map(_._2): _*)
    val mulRef = mutable.Queue(transactions.map { case (a, b) => a * b }: _*)
    val xorRef = mutable.Queue(transactions.map { case (a, b) => a ^ b }: _*)

    var mulSeen = 0
    var xorSeen = 0

    StreamDriver(dut.io.cmdA, dut.clockDomain) { payload =>
      if (cmdA.nonEmpty && Random.nextBoolean()) {
        payload #= cmdA.dequeue()
        true
      } else {
        false
      }
    }
    StreamDriver(dut.io.cmdB, dut.clockDomain) { payload =>
      if (cmdB.nonEmpty && Random.nextBoolean()) {
        payload #= cmdB.dequeue()
        true
      } else {
        false
      }
    }

    StreamReadyRandomizer(dut.io.rspMul, clockB).setFactor(3)
    StreamReadyRandomizer(dut.io.rspXor, clockB).setFactor(2)

    StreamMonitor(dut.io.rspMul, clockB) { payload =>
      assert(payload.toBigInt == mulRef.dequeue())
      mulSeen += 1
    }
    StreamMonitor(dut.io.rspXor, clockB) { payload =>
      assert(payload.toBigInt == xorRef.dequeue())
      xorSeen += 1
    }

    var timeout = 4000
    while ((mulSeen < transactions.length || xorSeen < transactions.length) && timeout > 0) {
      dut.clockDomain.waitSampling()
      timeout -= 1
    }

    assert(timeout > 0)
    assert(mulRef.isEmpty)
    assert(xorRef.isEmpty)

    println("StreamForkJoinCcTester passed.")
  }
}
