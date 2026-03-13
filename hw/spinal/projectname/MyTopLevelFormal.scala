package projectname

import spinal.core._
import spinal.core.formal._

object MyTopLevelFormal extends App {
  FormalConfig
    .withBMC(20)
    .doVerify(new Component {
      val dut = FormalDut(MyTopLevel())

      assumeInitial(clockDomain.isResetActive)
      anyseq(dut.io.cnt_out.ready)

      assert(dut.io.cnt_out.valid === True)
      when(pastValid() && past(dut.io.cnt_out.fire)) {
        assert(dut.io.cnt_out.payload === past(dut.io.cnt_out.payload) + 1)
      }
      when(pastValid() && !past(dut.io.cnt_out.fire)) {
        assert(dut.io.cnt_out.payload === past(dut.io.cnt_out.payload))
      }
    })
}
