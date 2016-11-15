# Filename: test.py
# Author: Petr Dvoracek <xdvora0n@stud.fit.vutbr.cz>
# This script controls the RC car using raspberry PI. 
# Character 'x' was pressed - exit program. 
# Character 'j' was pressed - CHAN_A  +0.1 Duty cycle
# Character 'k' was pressed - CHAN_A  -0.1 Duty cycle
# Character 'h' was pressed - CHAN_B  +0.1 Duty cycle
# Character 'l' was pressed - CHAN_B  -0.1 Duty cycle
import RPi.GPIO as GPIO
import sys 


FRAME_RATE = 50 # Standard servo frame rate is 50 Hz
CHAN_A = 12     # CHAN_A is for control speed of car. Red cable.
CHAN_B = 11     # CHAN_B is used for control turning left or right.

# Duty cycle for 'doing nothing' car is in steady state.
DC_A_CENTER = 7.5
DC_B_CENTER = 7.5

# Duty cycle for min and max speed.
DC_A_MIN = 5.0
DC_A_MAX = 10.0

# Duty cycle for turning left and right
DC_B_MIN = 5.0
DC_B_MAX = 10.0

# Set the mode
GPIO.setmode(GPIO.BOARD)

# Set the pins
GPIO.setup(CHAN_A, GPIO.OUT)
GPIO.setup(CHAN_B, GPIO.OUT)

# Set pins frame rate
p1 = GPIO.PWM(CHAN_A, FRAME_RATE)
p2 = GPIO.PWM(CHAN_B, FRAME_RATE)

# Start the PWM signal -- car is not moving
dc_a = DC_A_CENTER
dc_b = DC_B_CENTER
p1.start(dc_a)
p2.start(dc_b)

# FSM for control 
while True:
	x = sys.stdin.read(1)
	if x == 'x':
		break;
	elif x == 'j':
		if dc_a >= DC_A_MAX:
			continue
		dc_a += 0.1
		print "Setting duty cycle on pin"+str(CHAN_A)+": " + str(dc_a)
		p1.ChangeDutyCycle(dc_a)
	elif x == 'k':
		if dc_a <= DC_A_MIN:
			continue
		dc_a -= 0.1
		print "Setting duty cycle on pin"+str(CHAN_A)+": " + str(dc_a)
		p1.ChangeDutyCycle(dc_a)
	elif x == 'u':
		if dc_a >= DC_A_MAX:
			continue
		dc_a += 0.01
		print "Setting duty cycle on pin"+str(CHAN_A)+": " + str(dc_a)
		p1.ChangeDutyCycle(dc_a)
	elif x == 'i':
		if dc_a <= DC_A_MIN:
			continue
		dc_a -= 0.01
		print "Setting duty cycle on pin"+str(CHAN_A)+": " + str(dc_a)
		p1.ChangeDutyCycle(dc_a)
	elif x == 'h':
		if dc_b >= DC_B_MAX:
			continue
		dc_b += 0.1
		print "Setting duty cycle on pin"+str(CHAN_B)+": " + str(dc_b)
		p2.ChangeDutyCycle(dc_b)
	elif x == 'l':
		if dc_b <= DC_B_MIN:
			continue
		dc_b -= 0.1
		print "Setting duty cycle on pin"+str(CHAN_B)+": " + str(dc_b)
		p2.ChangeDutyCycle(dc_b)
	elif x == 'c':
		dc_b = DC_B_CENTER
		print "Setting duty cycle on pin"+str(CHAN_B)+": " + str(dc_b)
		p2.ChangeDutyCycle(dc_b)
		
# Now we stop the PWM object and cleanup
p1.stop()
p2.stop()
GPIO.cleanup()
