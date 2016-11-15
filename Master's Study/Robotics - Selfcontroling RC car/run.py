import raspberry
import RPi.GPIO as GPIO
import sys 
import time




FRAME_RATE = 50 # Standard servo frame rate is 50 Hz
CHAN_A = 12     # CHAN_A is for control speed of car. Red cable.
CHAN_B = 11     # CHAN_B is used for control turning left or right.

# Set the mode
GPIO.setmode(GPIO.BOARD)

# Set the pins
GPIO.setup(CHAN_A, GPIO.OUT)
GPIO.setup(CHAN_B, GPIO.OUT)

# Set pins frame rate
p1 = GPIO.PWM(CHAN_A, FRAME_RATE)
p2 = GPIO.PWM(CHAN_B, FRAME_RATE)

# Start the PWM signal -- car is not moving
p1.start(7.5)
p2.start(7.5)

time.sleep(3)

p1.stop()
p2.stop()
GPIO.cleanup()

#car.speed = 8.0105
car = raspberry.car()
car.black_threshold = 27
car.wheel_control = [ 
   [[20, 7.5], [40, 7.0], [60, 6.5], [80, 6.25]] , 
   [[-20, 7.5], [-40, 8.0], [-60, 8.5], [-80, 8.75]] ]
car.speed = 7.96
#car.speed = 8.11
car.run()
