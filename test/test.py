import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles


outputs = [ 0x41,  0x42, 0x49, 0x99, 0xcc, 0xcc, 0x99, 0x55, 0x55, 0x00,
0x0077, 0x0011, 0x0066, 0x0001, 0x0002, 4, 7, 0x5599, 0x5599, 0x559a, 0, 2, 0, 4, 0, 6, 0, 8, 0, 10, 0, 12, 0xfffe, 0x7ffe, 0xfffa, 24, 0, 0x0001, 0xfffe, 0, 0, 0x15, 0x14, 4, 0, 0x19, 0x4, 0x1a, 0x0, 0x1b, 0x4, 0, 0, 0x3, 0x7, 0x3c7, 0xc, 0xffdf, 0xdf, 16, 8, 0xff00, 0x8000, 0x7f00, 0x65, 0x21, 0x65, 0xffaa]

@cocotb.test()
async def test_vc_cpu(dut):
    dut._log.info("start")
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # reset
    dut._log.info("reset")
    # reset
    dut.rst_n.value = 0
    # set a different compare value
    #dut.ui_in.value = 3
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    # check all values
    for i in range(64):		#  67
        dut._log.info("check output {}".format(i))
        dut._log.info("expected value {}".format(outputs[i]))
        while 1 :
            await ClockCycles(dut.clk, 1)
            if int(dut.uart_done) == 1:
                dut._log.info("read value {}".format(int(dut.c)))
                assert int(dut.c) == outputs[i]
                break
