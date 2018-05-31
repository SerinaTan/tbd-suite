# <EcoSys> Added this file.

import numba.cuda as cuda
import tensorflow as tf

class ProfileMonitor(tf.contrib.learn.monitors.EveryN):
	def __init__(self, start, stop):
		super(ProfileMonitor, self).__init__(5)
		self.started = False
		self.ended = False
                self.start = start
                self.stop = stop

	def every_n_step_begin(self, step):

		if self.ended:
			return		

		if (not self.started) and step > self.start:
			print("Profile Start!")
			self.started = True
			cuda.profile_start()
		elif self.started and step > self.stop:
			print("Profile End! Calling profile_stop().")
			self.ended = True
			cuda.profile_stop()
			print("Done calling profile_stop().")
                        exit()

# </EcoSys>
