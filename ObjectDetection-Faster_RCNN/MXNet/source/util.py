# <EcoSys> callback functions for nvprof start/stop
import mxnet as mx

class cudaProfilerStart(object):
    """Start nvprof at certain iteration

    Parameters
    ----------
    nbatch: int
        The batch number where nvprof begins.
    nepoch: int
        The epoch number where nvprof begins.
    ----------

    """

    def __init__(self, nbatch, nepoch = 0):
        self.nbatch = nbatch
        self.nepoch = nepoch

    def __call__(self, param):
        import numba.cuda as cuda
        print("try start", param.nbatch)
        if self.nbatch == param.nbatch and self.nepoch == param.epoch:
            cuda.profile_start()
            mx.profiler.profiler_set_state('run')

class cudaProfilerStop(object):
    """Start nvprof at certain iteration

    Parameters
    ----------
    nbatch: int
        The batch number where nvprof ends.
    nepoch: int
        The epoch number where nvprof ends.
    ----------

    """

    def __init__(self, nbatch, nepoch = 0):
        self.nbatch = nbatch
        self.nepoch = nepoch

    def __call__(self, param):
        import numba.cuda as cuda
        if self.nbatch == param.nbatch and self.nepoch == param.epoch:
            mx.profiler.profiler_set_state('stop')
            mx.profiler.dump_profile()
            cuda.profile_stop()
            exit()

# </EcoSys>
