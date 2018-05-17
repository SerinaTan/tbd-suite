import numba.cuda as cuda
import tensorflow as tf
import datetime

class TimeMonitor(tf.contrib.learn.monitors.EveryN):
	def __init__(self):
		super(TimeMonitor, self).__init__(100)
		self.started = False
		self.ended = False

	def every_n_step_begin(self, step):
		tf.logging.info("Time: %s" % datetime.datetime.now().strftime('%Y-%m-%d-%X '))
