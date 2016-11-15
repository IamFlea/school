"""
Project: RC car
File: raspberry.py
Authors: Petr Dvoracek <xdvora0n@stud.fit.vutbr.cz>
         Oliver Lelkes <xlelke00@stud.fit.vutbr.cz>
Description: This file is importatnt


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

"""


import sys
import io
import time
import picamera
import picamera.array
import cv2 
import numpy as np

import RPi.GPIO as GPIO
import sys

print "Modules loaded"
cimport numpy as np




class car:

    def __init__(self):
        self.box_threshold = 64  # 20 x 20  a kolik pixelu je bilych ci cernych.. pak je cely segment cerny nebo bily
        self.black_threshold = 20
        self.white_threshold = 110
        self.flip_pins = False
        self.wheel_control = [ [[20, 7.5], [40, 7.15], [60, 6.875], [80, 6.5], [100, 6.25]] , [[-20, 7.5], [-40, 7.85], [-60, 8.125], [-80, 8.5], [-100, 8.75]] ]
        self.speed = 7.5
        self.weight_matrix = [[0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6,  6,  7,  7],
                              [0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6,  7,  7,  8],
                              [0, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7,  7,  8,  8],
                              [0, 1, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7,  8,  8,  9],
                              [0, 1, 2, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8,  8,  9,  9],
                              [0, 1, 2, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8,  8,  9,  9],
                              [0, 1, 2, 3, 4, 5, 5, 6, 6, 7, 7, 8, 8,  9,  9, 10],
                              [0, 1, 2, 3, 4, 5, 5, 6, 6, 7, 7, 8, 8,  9,  9, 10],
                              [0, 1, 2, 3, 4, 5, 6, 6, 7, 7, 8, 8, 9,  9, 10, 10],
                              [0, 1, 2, 3, 4, 5, 6, 7, 7, 8, 8, 9, 9, 10, 11, 12],
                              [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  0,  0,  0],
                              [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  0,  0,  0]]
        
        

    def run(self):
        # PWM DEFINICE
        ##############
        cdef int FRAME_RATE = 50 # Standard servo frame rate is 50 Hz
        cdef int CHAN_A = 12     # CHAN_A is for control speed of car.
        cdef int CHAN_B = 11     # CHAN_B is used for control turning left or right.
        if self.flip_pins:
            CHAN_A = 11     # CHAN_A is for control speed of car.
            CHAN_B = 12     # CHAN_B is used for control turning left or right.
        # Duty cycle for 'doing nothing' car is in steady state.
        cdef double DC_A_CENTER = 7.5
        cdef double DC_B_CENTER = 7.5
        
        # Duty cycle for min and max speed.
        cdef double DC_A_MIN = 5.0
        cdef double DC_A_MAX = 10.0
        
        # Duty cycle for turning left and right
        cdef double DC_B_MIN = 5.0
        cdef double DC_B_MAX = 10.0
    
        cdef double dc_a 
        cdef double dc_b, score
    
    
        # Camera image
        ##############
        # Getting image from the camera.
        stream = io.BytesIO()  # Using a stream.
        
        cdef unsigned char BLACK_THRESHOLD = <unsigned char> self.black_threshold
        cdef unsigned char WHITE_THRESHOLD = <unsigned char> self.white_threshold
        cdef unsigned int pixel, row, col
        
        cdef int WIDTH = 320
        cdef int HEIGHT = 240
        cdef np.ndarray[unsigned char, ndim=2] image
        
    
        # Image prepocessing
        ####################
        cdef int BOX_SIZE = 20 # 20x20 segment
        cdef int row_filtered 
        cdef int SEGMENT_WIDTH = WIDTH/BOX_SIZE
        cdef int SEGMENT_HEIGHT = HEIGHT/BOX_SIZE
    
        cdef int BOX_THRESHOLD = self.box_threshold
        cdef int x, y
        cdef int box_value 
        cdef np.ndarray[int, ndim=2] segment_box = np.zeros([SEGMENT_HEIGHT, SEGMENT_WIDTH], dtype=np.int)
        if(len(self.weight_matrix) != SEGMENT_HEIGHT) or (len(self.weight_matrix[0]) != SEGMENT_WIDTH):
            print "Wrong weight matrix, please set 16x12 matrix!"
            return
        cdef np.ndarray[int, ndim=2] score_matrix = np.array(self.weight_matrix, dtype=np.int)
        
        cdef int turn_right_score, turn_left_score
    
        
        with picamera.PiCamera() as camera:
            camera.resolution = (320, 240)
            camera.framerate = 20
            stream = io.BytesIO()
            # TODO set car speed here.
    
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
            p1.start(self.speed)  # SET LOWEST SPEED
            p2.start(dc_b)           
                #for i in xrange(20):
	    camera.start_preview()
	    while True:
                try:
                    with Watchdog(1):
                        #print "Now"
                        camera.capture(stream, format="jpeg", use_video_port=True)
                        frame = np.fromstring(stream.getvalue(), dtype=np.uint8)
                        stream.seek(0)
                        frame = cv2.imdecode(frame, 1)
                        image = cv2.cvtColor(frame, cv2.COLOR_RGB2GRAY)
                        """
                        # Previous code in python. It tooked about 20seconds to process 320x240 image! Due to pointers!
                        for row in frame:
                            for pixel in row:
                                if pixel > WHITE_THRESHOLD:
                                    pass
                                elif pixel < BLACK_THRESHOLD:
                                    pass
                        """
                        # Effecient code in Cython
                        segment_box = np.zeros([HEIGHT/BOX_SIZE, WIDTH/BOX_SIZE], dtype=np.int)
                        for row in xrange(HEIGHT):
                            row_filtered = row/BOX_SIZE
                            for col in xrange(WIDTH):
                                pixel = image[row,col]
                                if pixel > WHITE_THRESHOLD:
                                    segment_box[row_filtered, col/BOX_SIZE] += 1
                                elif pixel < BLACK_THRESHOLD:
                                    segment_box[row_filtered, col/BOX_SIZE] += -1
                                else:
                                    segment_box[row_filtered, col/BOX_SIZE] += 0
                        # Now we process segment boxes and get turn scores
                        turn_right_score = 0 
                        turn_left_score = 0 
                        x = 0
                        y = 0
                        for row in xrange(SEGMENT_HEIGHT):
                            for col in xrange(SEGMENT_WIDTH):
                                box_value = segment_box[row, col]
                                if box_value > BOX_THRESHOLD:
                                    turn_left_score += score_matrix[row, 15-col]
                                elif (-box_value) > BOX_THRESHOLD:
                                    turn_right_score += score_matrix[row, col]
            
                        score = turn_right_score - turn_left_score
                        print score
                        if score > 0:
                            # DOPRAVA
                            dc_b = 5.99
                            for i in self.wheel_control[0]:
                                if score < i[0]:
                                   dc_b = i[1] 
                                   break
                        else:
                            # DOLEVA
                            dc_b = 9.01
                            for i in self.wheel_control[1]:
                                if score > i[0]:
                                   dc_b = i[1]
                                   break
                        print dc_b  
                        p2.ChangeDutyCycle(dc_b)
                        print turn_left_score, turn_right_score
                except Watchdog:
                    pass 
                except:
                    camera.stop_preview()
                    p1.stop()
                    p2.stop()
                    GPIO.cleanup()
                    break

    
    
    def testfps(self):
        # PWM DEFINICE
        ##############
        cdef int FRAME_RATE = 50 # Standard servo frame rate is 50 Hz
        cdef int CHAN_A = 12     # CHAN_A is for control speed of car.
        cdef int CHAN_B = 11     # CHAN_B is used for control turning left or right.
        if self.flip_pins:
            CHAN_A = 11     # CHAN_A is for control speed of car.
            CHAN_B = 12     # CHAN_B is used for control turning left or right.
        # Duty cycle for 'doing nothing' car is in steady state.
        cdef double DC_A_CENTER = 7.5
        cdef double DC_B_CENTER = 7.5
        
        # Duty cycle for min and max speed.
        cdef double DC_A_MIN = 5.0
        cdef double DC_A_MAX = 10.0
        
        # Duty cycle for turning left and right
        cdef double DC_B_MIN = 5.0
        cdef double DC_B_MAX = 10.0
    
        cdef double dc_a 
        cdef double dc_b, score
    
    
        # Camera image
        ##############
        # Getting image from the camera.
        stream = io.BytesIO()  # Using a stream.
        
        cdef unsigned char BLACK_THRESHOLD = <unsigned char> self.black_threshold
        cdef unsigned char WHITE_THRESHOLD = <unsigned char> self.white_threshold
        cdef unsigned int pixel, row, col
        
        cdef int WIDTH = 320
        cdef int HEIGHT = 240
        cdef np.ndarray[unsigned char, ndim=2] image
        
    
        # Image prepocessing
        ####################
        cdef int BOX_SIZE = 20 # 20x20 segment
        cdef int row_filtered 
        cdef int SEGMENT_WIDTH = WIDTH/BOX_SIZE
        cdef int SEGMENT_HEIGHT = HEIGHT/BOX_SIZE
    
        cdef int BOX_THRESHOLD = self.box_threshold
        cdef int x, y
        cdef int box_value 
        cdef np.ndarray[int, ndim=2] segment_box = np.zeros([SEGMENT_HEIGHT, SEGMENT_WIDTH], dtype=np.int)
        if(len(self.weight_matrix) != SEGMENT_HEIGHT) or (len(self.weight_matrix[0]) != SEGMENT_WIDTH):
            print "Wrong weight matrix, please set 16x12 matrix!"
            return
        cdef np.ndarray[int, ndim=2] score_matrix = np.array(self.weight_matrix, dtype=np.int)
        
        cdef int turn_right_score, turn_left_score
    
        
        with picamera.PiCamera() as camera:
            camera.resolution = (320, 240)
            camera.framerate = 20
            stream = io.BytesIO()
            # TODO set car speed here.
    
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
            p1.start(self.speed)  # SET LOWEST SPEED
            p2.start(dc_b)
    
            camera.start_preview()
            start = time.clock()
            #while True:
            for i in xrange(20):
                #print "Now"
                camera.capture(stream, format="jpeg", use_video_port=True)
                frame = np.fromstring(stream.getvalue(), dtype=np.uint8)
                stream.seek(0)
                frame = cv2.imdecode(frame, 1)
                image = cv2.cvtColor(frame, cv2.COLOR_RGB2GRAY)
                """
                # Previous code in python. It tooked about 20seconds to process 320x240 image! Due to pointers!
                for row in frame:
                    for pixel in row:
                        if pixel > WHITE_THRESHOLD:
                            pass
                        elif pixel < BLACK_THRESHOLD:
                            pass
                """
                # Effecient code in Cython
                segment_box = np.zeros([HEIGHT/BOX_SIZE, WIDTH/BOX_SIZE], dtype=np.int)
                for row in xrange(HEIGHT):
                    row_filtered = row/BOX_SIZE
                    for col in xrange(WIDTH):
                        pixel = image[row,col]
                        if pixel > WHITE_THRESHOLD:
                            segment_box[row_filtered, col/BOX_SIZE] += 1
                        elif pixel < BLACK_THRESHOLD:
                            segment_box[row_filtered, col/BOX_SIZE] += -1
                        else:
                            segment_box[row_filtered, col/BOX_SIZE] += 0
                # Now we process segment boxes and get turn scores
                turn_right_score = 0 
                turn_left_score = 0 
                x = 0
                y = 0
                for row in xrange(SEGMENT_HEIGHT):
                    for col in xrange(SEGMENT_WIDTH):
                        box_value = segment_box[row, col]
                        if box_value > BOX_THRESHOLD:
                            turn_left_score += score_matrix[row, 15-col]
                        elif (-box_value) > BOX_THRESHOLD:
                            turn_right_score += score_matrix[row, col]
    
                score = turn_right_score - turn_left_score
                print score
                # self.wheel_control = [ [[-20, 7.5], [-40, 7.85], [-60, 8.125], [-80, 8.5], [-100, 8.75]], [[20, 7.5], [40, 7.15], [60, 6.875], [80, 6.5], [100, 6.25]] ]
                if score > 0:
                    # DOPRAVA
                    dc_b = 5.99
                    for i in self.wheel_control[0]:
                        if score < i[0]:
                           dc_b = i[1]
                           break
                else:
                    # DOLEVA
                    dc_b = 9.01
                    for i in self.wheel_control[1]:
                        if score > i[0]:
                           dc_b = i[1]
                           break
                print dc_b  
                p2.ChangeDutyCycle(dc_b)
                print turn_left_score, turn_right_score
            stop = time.clock()
            camera.stop_preview()
            p1.stop()
            p2.stop()
            GPIO.cleanup()
            print "Time spent in (function name) is: ", stop-start
            print "FPS: ", 20.0/(stop-start)
    
    
    def snapshot(self):
        # PWM DEFINICE
        ##############
        cdef int FRAME_RATE = 50 # Standard servo frame rate is 50 Hz
        cdef int CHAN_A = 12     # CHAN_A is for control speed of car.
        cdef int CHAN_B = 11     # CHAN_B is used for control turning left or right.
        if self.flip_pins:
            CHAN_A = 11     # CHAN_A is for control speed of car.
            CHAN_B = 12     # CHAN_B is used for control turning left or right.
        # Duty cycle for 'doing nothing' car is in steady state.
        cdef double DC_A_CENTER = 7.5
        cdef double DC_B_CENTER = 7.5
        
        # Duty cycle for min and max speed.
        cdef double DC_A_MIN = 5.0
        cdef double DC_A_MAX = 10.0
        
        # Duty cycle for turning left and right
        cdef double DC_B_MIN = 5.0
        cdef double DC_B_MAX = 10.0
    
        cdef double dc_a 
        cdef double dc_b, score
    
    
        # Camera image
        ##############
        # Getting image from the camera.
        stream = io.BytesIO()  # Using a stream.
        
        cdef unsigned char BLACK_THRESHOLD = <unsigned char> self.black_threshold
        cdef unsigned char WHITE_THRESHOLD = <unsigned char> self.white_threshold
        cdef unsigned int pixel, row, col
        
        cdef int WIDTH = 320
        cdef int HEIGHT = 240
        cdef np.ndarray[unsigned char, ndim=2] image
        
    
        # Image prepocessing
        ####################
        cdef int BOX_SIZE = 20 # 20x20 segment
        cdef int row_filtered 
        cdef int SEGMENT_WIDTH = WIDTH/BOX_SIZE
        cdef int SEGMENT_HEIGHT = HEIGHT/BOX_SIZE
    
        cdef int BOX_THRESHOLD = self.box_threshold
        cdef int x, y
        cdef int box_value 
        cdef np.ndarray[int, ndim=2] segment_box = np.zeros([SEGMENT_HEIGHT, SEGMENT_WIDTH], dtype=np.int)
        if(len(self.weight_matrix) != SEGMENT_HEIGHT) or (len(self.weight_matrix[0]) != SEGMENT_WIDTH):
            print "Wrong weight matrix, please set 16x12 matrix!"
            return
        cdef np.ndarray[int, ndim=2] score_matrix = np.array(self.weight_matrix, dtype=np.int)
        
        cdef int turn_right_score, turn_left_score
    
        
        with picamera.PiCamera() as camera:
            camera.resolution = (320, 240)
            camera.framerate = 20
            stream = io.BytesIO()
            # TODO set car speed here.
    
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
            p1.start(dc_a)  # SET LOWEST SPEED
            p2.start(dc_b)
            
            camera.start_preview()
            start = time.clock()
            for i in xrange(2):
            #while True:
                #print "Now"
                camera.capture(stream, format="jpeg", use_video_port=True)
                frame = np.fromstring(stream.getvalue(), dtype=np.uint8)
                stream.seek(0)
                frame = cv2.imdecode(frame, 1)
                image = cv2.cvtColor(frame, cv2.COLOR_RGB2GRAY)
                """
                # Previous code in python. It tooked about 20seconds to process 320x240 image! Due to pointers!
                for row in frame:
                    for pixel in row:
                        if pixel > WHITE_THRESHOLD:
                            pass
                        elif pixel < BLACK_THRESHOLD:
                            pass
                """
                # Effecient code in Cython
                segment_box = np.zeros([HEIGHT/BOX_SIZE, WIDTH/BOX_SIZE], dtype=np.int)
                for row in xrange(HEIGHT):
                    row_filtered = row/BOX_SIZE
                    for col in xrange(WIDTH):
                        pixel = image[row,col]
                        if pixel > WHITE_THRESHOLD:
                            segment_box[row_filtered, col/BOX_SIZE] += 1
                        elif pixel < BLACK_THRESHOLD:
                            segment_box[row_filtered, col/BOX_SIZE] += -1
                        else:
                            segment_box[row_filtered, col/BOX_SIZE] += 0
                # Now we process segment boxes and get turn scores
                turn_right_score = 0 
                turn_left_score = 0 
                x = 0
                y = 0
                for row in xrange(SEGMENT_HEIGHT):
                    for col in xrange(SEGMENT_WIDTH):
                        box_value = segment_box[row, col]
                        if box_value > BOX_THRESHOLD:
                            turn_left_score += score_matrix[row, 15-col]
                        elif (-box_value) > BOX_THRESHOLD:
                            turn_right_score += score_matrix[row, col]
    
                score = turn_right_score - turn_left_score
                print score
                if score > 0:
                    # DOPRAVA
                    dc_b = 5.99
                    for i in self.wheel_control[0]:
                        if score < i[0]:
                           dc_b = i[1]
                           break
                else:
                    # DOLEVA
                    dc_b = 9.01
                    for i in self.wheel_control[1]:
                        if score > i[0]:
                           dc_b = i[1]
                           break
                print dc_b  
                p2.ChangeDutyCycle(dc_b)
                print turn_left_score, turn_right_score
            camera.stop_preview()
            p1.stop()
            p2.stop()
            GPIO.cleanup()
            cv2.imwrite("snap_original.jpg", frame)
            print frame[0, 0]
            cv2.imwrite("snap_greyscale.jpg", image)
            for lama in segment_box:
                print lama
            for row in xrange(SEGMENT_HEIGHT):
                string = ""
                for col in xrange(SEGMENT_WIDTH):
                    box_value = segment_box[row, col]
                    if box_value > BOX_THRESHOLD:
                        string += "W"
                    elif (-box_value) > BOX_THRESHOLD:
                        string += "B"
                    else:
                        string += " "
                print string
            print
    
