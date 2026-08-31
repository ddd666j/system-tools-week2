from __future__ import print_function

import signal
import time


running = True


def stop(signum, frame):
    del frame
    global running
    print("received_signal={}".format(signum), flush=True)
    running = False


signal.signal(signal.SIGTERM, stop)
value = 0
started = time.time()
while running:
    value = (value * 33 + 17) % 10000019

print("elapsed={:.3f}s final_value={}".format(time.time() - started, value))
