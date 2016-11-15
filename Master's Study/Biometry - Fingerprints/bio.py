#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Project: biometric system 
# Course: BIO
# Student: me <xdvora0n@stud.fit.vutbr.cz>
# GL HF in reading this code.
import random
import pylab
import PIL.Image as Image
import PIL.ImageDraw as ImageDraw
import numpy as np
import scipy as sp
import scipy.ndimage as spim
from sklearn import svm
import copy 
import math

import time
#import antigravity  # At to nepada.. schvalne to spustte v interpretru.. 


global profile
global filename
global done
done = 1
filename = [1,1]
profile = []

class Finger:
    LENGTH_BETWEEN_TWO_MARKANTS = 6
    MARKANTS_PERCENTAGE_IN_BLOCK = 0.02 
    BLOCK_SIZE = 32 # Segmentation..
    #FREQ_TRESHOLD = 120 # Pri urcovani frekvence jsem se s tim neparal. (funguje na pricncipu thresholdu)
    FREQ_BLUR = 2 # Rozmazani thresholdu.. 
    THINNING_THRESHOLD = 10
    SOBEL_VERTICAL = [[-1, 0, 1], [-2, 0, 2], [-1, 0, 1]]
    SOBEL_HORIZONTAL = [[-1, -2, -1], [0, 0, 0], [1, 2, 1]]
    
    
    def __init__(self, pImage):
        self.originImage = pImage
        self.originImage = self.originImage.convert("L")
        self.image = self.originImage.load()

    def __sobel(self, x, y, vertical):
        """
        Filtrace obrazku pomoci sobelova filtru.
        """
        sobel = Finger.SOBEL_VERTICAL if vertical else Finger.SOBEL_HORIZONTAL
        result = 0
        for i in xrange(0, 3):
            for j in xrange(0, 3):
                try:    result += self.image[x+i-1, y+j-1]*sobel[j][i]
                except: result += 0
        return result

    def __orientation(self):
        """
        Vypocet orientace kazdeho bloku + jejich vyhlazeni.
        """
        for i in xrange(0, self.originImage.size[0], Finger.BLOCK_SIZE):     # osa x
            for j in xrange(0, self.originImage.size[1], Finger.BLOCK_SIZE): # osa y
                # Vypocteme gradient pixelu
                Gxy = 0
                Gxxyy = 0
                for k in xrange(i, min(i + Finger.BLOCK_SIZE, self.originImage.size[0] - 1)):
                    for l in xrange(j, min(j + Finger.BLOCK_SIZE, self.originImage.size[1] - 1)):
                        Gx = self.__sobel(k, l, True)
                        Gy = self.__sobel(k, l, False)
                        Gxy   += 2 * Gx * Gy
                        Gxxyy += Gx * Gx - Gy * Gy
                # Ulozime
                self.blockOrientation[j/Finger.BLOCK_SIZE][i/Finger.BLOCK_SIZE] = (math.pi + math.atan2(Gxy, Gxxyy))/2


    def __segmentation(self): # seg falut v pythonu stoji za to! (mam s tim zkusenosti ^.^ )
        """
        Rozreze obrazek na bloky. 
        """
        c = []
        y = []
        m = []
        row_len = self.originImage.size[0]
        col_len = self.originImage.size[1]
        for i in xrange(0, col_len, Finger.BLOCK_SIZE):
            d = []
            x = []
            n = []
            for j in xrange(0, row_len, Finger.BLOCK_SIZE):
                #x.append(copy.deepcopy(self.image[i:i+Finger.BLOCK_SIZE,j:j+Finger.BLOCK_SIZE]))
                x.append(self.originImage.crop((j,i,j+Finger.BLOCK_SIZE, i+Finger.BLOCK_SIZE)))
                d.append(0)
                n.append([])
            y.append(x)
            c.append(d)
            m.append(n)
        self.blockImage = y
        self.blockOrientation = c
        self.blockFreq = copy.deepcopy(c)
        self.blockMarkants = m

    def __getRotatedSegment(self, x, y):
        """
        Zrotuje segment...  Zda se to byt smesne, ale stravil jsem nad tim jeden cely den!
        @param self Object pointer.
        @param x Souradnice segmentu
        @param y Souradnice segmentu
        @return  Zrotovany segment
        """
        segment = self.blockImage[x][y]
        angle   = float(self.blockOrientation[x][y])
        segment = np.array(segment).tolist() # black magic of types, at ulozim zapornou hodnotu...
        result  = spim.interpolation.rotate(segment, (math.degrees(angle)+90), cval=-1, mode='constant')
        return result.tolist()

        
    def __getFreqSegment(self, x, y):
        """
        Vypocte frekvenci v danem segmentu (bloku)
        Snazil jsem se o FFT.. Nakonec nefungovalo... 
        @param x Souradnice segmentu
        @param y Souradnice segmentu
        """
        # Otocim segment
        segment   = self.__getRotatedSegment(x,y)
        blur      = Finger.FREQ_BLUR

        # Zjistim maximalni a minimalni hodnotu pixelu v obrazku, abych zjistil threshold
        maximal = 0
        minimal = 255
        for row in segment:
            if minimal > min(row): minimal = min(row)
            if maximal < max(row): maximal = max(row)
        threshold = abs(maximal - minimal) 
        threshold /= 2

        # Zjisteni poctu papilarnich linii via vazeny prumer, threshold a neco co mi tu lajnu "rozmaze" -- blur
        freqSum = 0.0
        weightSum = 0.0
        for row in segment:
            blured = 0
            unusedRowCnt = 0
            ridgesRowCnt  = 0
            for pixel in row:
                if pixel == -1:
                    unusedRowCnt += 1
                elif pixel < threshold:
                    ridgesRowCnt += 1 if blured == 0 else 0
                    blured = blur
                elif blured > 0:
                    blured -= 1
            weight = (len(segment)-unusedRowCnt) / float(len(segment))
            freqSum += ridgesRowCnt * weight
            weightSum += float(weight)
        try: self.blockFreq[x][y] = 1/((freqSum / weightSum)*math.pi) 
        except: self.blockFreq[x][y] = 0
        #print x, y, self.blockFreq[x][y]
                

    def __getFreq(self):
        """
        Vypocte frekvenci ve vsech segmentech
        """
        for i in xrange(len(self.blockFreq)):
            for j in xrange(len(self.blockFreq[i])):
                self.__getFreqSegment(i, j)
        #exit()


    def __getGaborFilter(self, i, j):
        """
        Vytvorime gaboruv filtrik.
        """
        angle = self.blockOrientation[i][j]
        freq  = self.blockFreq[i][j]
        block_size  = Finger.BLOCK_SIZE
        cos = math.cos(angle)
        sin = math.sin(angle)
        yangle = lambda x, y: x * cos + y * sin
        xangle = lambda x, y: -x * sin + y * cos
        ysigma = 4
        xsigma = 4
        kernf = lambda x, y: math.exp(-((xangle(x, y) ** 2) / (xsigma ** 2) + (yangle(x, y) ** 2) / (ysigma ** 2)) / 2) * math.cos(2 * math.pi * freq * xangle(x, y))
        result = [[] for i in range(0, block_size)]
        for i in xrange(block_size):
            for j in xrange(block_size):
                result[i].append(kernf(i - block_size / 2, j - block_size / 2))
        return result
        #r = []
        #for ri in result:
            #r += ri
        #i = Image.new('L', (32, 32))
        #i.putdata(r)
        #i.show()
        #print len(result)
        
        return result
    
    def __fitlerViaGabor(self, gabor, x, y):
        result = 0.0
        for k in xrange(Finger.BLOCK_SIZE):
            for l in xrange(Finger.BLOCK_SIZE):
                try: result += self.image[x + k - Finger.BLOCK_SIZE / 2, y + l - Finger.BLOCK_SIZE / 2] * gabor[k][l]
                except: result += 0.0
        return result

    def __applyGabor(self):
        """
        Aplikace Gaborovych filtru na puvodni orbazek. 
        frekvence a orientace segmentu musi byti zadana
        """
        self.image = self.originImage.load()
        ni = Image.new('L', (self.originImage.size[0], self.originImage.size[1]))
        newImage = ni.load()

        # Pro kazdy segment
        for i in xrange(len(self.blockOrientation)):
            for j in xrange(len(self.blockOrientation[0])):
                #print i, j
                gabor = self.__getGaborFilter(i, j)
                for k in xrange(Finger.BLOCK_SIZE):
                    for l in xrange(Finger.BLOCK_SIZE):
                        tmp = self.__fitlerViaGabor(gabor, j*Finger.BLOCK_SIZE+l, i*Finger.BLOCK_SIZE+k)
                        try: newImage[j * Finger.BLOCK_SIZE + l, i * Finger.BLOCK_SIZE + k] = tmp
                        except: pass
        #ni.show()
        self.gaborFilteredImage = ni

    def __binarize(self, size, image):
        result = []
        for i in xrange(size[0]):
            row = []
            for j in xrange(size[1]):
                row.append(0.0 if image[i,j] > Finger.THINNING_THRESHOLD else 1.0)
            result.append(row)
        return result

    def __thinRidges(self):
        """
        Zuzeni papilarnich linii. Obrazek musi byti prefiltrovan gaborovymi filtry.
        http://fourier.eng.hmc.edu/e161/lectures/morphology/node4.html
        """
        image = self.gaborFilteredImage.load()
        # Binarizuji
        binarized = self.__binarize(self.gaborFilteredImage.size, image)
        # Ty filtry
        filters = [[[1, 1, 1], [0, 1, 0], [0.1, 0.1, 0.1]],  # 0 dont care, 0,1 = zero
                   [[1, 0, 0.1], [1, 1, 0.1], [1, 0, 0.1]], 
                   [[0.1, 0.1, 0.1], [0, 1, 0], [1, 1, 1]], 
                   [[0.1, 0, 1], [0.1, 1, 1], [0.1, 0, 1]], 
                   [[0, 1, 0], [0.1, 1, 1], [0.1, 0.1, 0]], 
                   [[0, 1, 0], [1, 1, 0.1], [0, 0.1, 0.1]], 
                   [[0, 0.1, 0.1], [1, 1, 0.1], [0, 1, 0]],
                   [[0.1, 0.1, 0], [0.1, 1, 1], [0, 1, 0]]
                   ]

        # Ztencujeme, dokad mame co. Tudiz aplikujeme...
        usage = True
        while(usage):
            #print "."
            usage = False
            # ...aplikujeme vsechny filtry na....
            for n in xrange(len(filters)):
                if n < 4: cnt = 4
                else: cnt = 3
                # ...na obrazek, ve kterem...
                for i in xrange(1, len(binarized) - 1 ):
                    for j in xrange(1, len(binarized[i]) - 1):
                        # if binarized[i][j] == 0: continue
                        result = 0
                        # ..filtrujeme danny pixel.
                        for k in xrange(3):
                            for l in xrange(3):
                                result += binarized[i+k-1][j+l-1] * filters[n][k][l]
                        if result == cnt:
                            # Pokud bylo neco nalezeno filtrem, pak je hodnota pixelu 0...
                            usage = True
                            binarized[i][j] = 0.0
                        else:
                            # ...jinak je 1.
                            binarized[i][j] = binarized[i][j]
        #print ".done"
        
        for i in xrange(self.gaborFilteredImage.size[0]):
            for j in xrange(self.gaborFilteredImage.size[1]):
                #image[i, j] = binarized[i][j] * 255
                image[i, j] = 0 if binarized[i][j] == 1 else 255
        #self.gaborFilteredImage.show()
        self.skeleton = self.gaborFilteredImage

    def __getMarkants(self):
        self.skeleton = self.gaborFilteredImage
        image = self.gaborFilteredImage.load()
        binarized = self.__binarize(self.gaborFilteredImage.size, image)
        size = len(binarized), len(binarized[0])
        markants = []
        for i in xrange(1, size[0]-1):
            for j in xrange(1, size[1]-1):
                # je tam neco
                if binarized[i][j] == 1:
                    result = 0
                    for k in xrange(3):
                        for l in xrange(3):
                            result += 1 if binarized[i+k-1][j+l-1] == 1 else 0
                    if result == 2:
                        markants.append([1, i, j])
                        #print "KONEC", i, j
                    if result == 4:
                        markants.append([2, i, j])
                        #print "VYDLE", i, j
        #print len(markants)
        # Zahodi markanty na debilnich segmentech, ktere vznikly blbou aplikaci gaborovy fce. 
        for m in markants: 
            i = m[1]/Finger.BLOCK_SIZE
            j = m[2]/Finger.BLOCK_SIZE
            self.blockMarkants[j][i].append(m)

        markants = []
        for i in xrange(1, len(self.blockMarkants) - 1):
            string = ""
            for j in xrange(1, len(self.blockMarkants[i]) - 1):
                area = self.blockImage[i][j].size[0] * self.blockImage[i][j].size[1]
                if len(self.blockMarkants[i][j])/1024.0 > Finger.MARKANTS_PERCENTAGE_IN_BLOCK:
                    self.blockMarkants[i][j] = []
                else: markants += self.blockMarkants[i][j]

        # dva markanty blizko sebe == jeden markant
        for a in markants:
            for b in markants:
                if a == b: continue
                vect = b[1] - a[1], b[2] - a[2]
                length = math.sqrt(vect[0]**2+vect[1]**2)
                if length < Finger.LENGTH_BETWEEN_TWO_MARKANTS:
                    if a==1 or b == 1:
                        markants.remove(a)
                        markants.remove(b)
                        break
                    else:
                        markants.remove(b)

        #print len(markants)
        for a in markants:
            if a[0] == 1: continue # je to konec
            i = a[1]
            j = a[2]
            result = 0
            for k in xrange(7):
                 for l in xrange(7):
                     result += 1 if binarized[i+k-3][j+l-3] == 1 else 0
            if result < 10 :
                markants.remove(a)
        #print len(markants)
        self.markants = markants

        self.skeleton = self.skeleton.convert("RGB")
        draw = ImageDraw.Draw(self.skeleton)
        for markant in markants: 
            if markant[0] == 1: color = (255,0,0) # je to konec
            else: color = (0,0,255)
            ellipse_size = 2
            i = markant[1]
            j = markant[2]
            draw.ellipse([(i - ellipse_size, j - ellipse_size), (i + ellipse_size, j + ellipse_size)], outline = color)
        #self.skeleton.show()

    def getMarkants(self):
        """
        Provede segmentaci, ze segmentu zisa orientaci a freq. Na segmenty aplikuje gaboruv filtr.
        Ziska kostru, cili ztenci linie. Sebere markanty.. Rovnez zde probiha profilovani... 
        """
        self.skeleton = self.originImage
        self.gaborFilteredImage = self.originImage
        start = time.clock()
        print "Segmentation"
        self.__segmentation()
        print "Finding orientation"
        self.__orientation()
        print "Finding frequency"
        self.__getFreq()
        print "Applying gabor filters "
        prelude = time.clock()
        self.__applyGabor()
        gabors = time.clock()
        print "Thinning"
        self.__thinRidges()
        thinning = time.clock()
        global done
        #self.skeleton.save("kostry/"+str(done)+".png")
        done+=1
        print "Getting markants"
        self.__getMarkants()
        print "DONE"
        print
        elapsed = time.clock() - start
        profile.append([prelude-start,gabors-prelude,thinning-gabors,elapsed-thinning])
        markants = self.markants
        newMarkants=[]
        segmentsVidle = [[0]*len(self.blockMarkants)]*len(self.blockMarkants[0])
        segmentsKonec = [[0]*len(self.blockMarkants)]*len(self.blockMarkants[0])
        for m in markants:
            if m[0] == 1: 
                i = m[1]/Finger.BLOCK_SIZE
                j = m[2]/Finger.BLOCK_SIZE
                segmentsKonec[i][j] +=1
            if m[0] == 2: 
                i = m[1]/Finger.BLOCK_SIZE
                j = m[2]/Finger.BLOCK_SIZE
                segmentsVidle[i][j] +=1

        r = lambda x, y: x + y
        return reduce(r, segmentsVidle) + reduce(r, segmentsKonec)
    
    def getMarkantsOrientation(self):
        self.__segmentation()
        self.__orientation()
        result = []
        for m in self.blockOrientation:
            result += m
        return result

class Bio:
    def __init__(self):
        self.records = []
        self.classes = []
        self.clf = svm.SVC()
        self.clf.probability = True
        # Load DB.
    
    def enroll(self, pImgList, newid=-1):
        """
        Register user
        @param self        Object pointer.
        @param pImgList List of strings
        """
        if len(pImgList) == 0: 
            raise Exception("First param 'pImgStr' list is empty!")
        x = 1
        for img in pImgList:
            filename[1] = x
            finger = Finger(img)
            markants = finger.getMarkantsOrientation()
            #markants = finger.getMarkants()
            self.records.append(markants)
            self.classes.append(newid)
            x+=1


    def identify(self, img):
        finger = Finger(img)
        #markants = finger.getMarkants()
        markants = finger.getMarkantsOrientation()

        #print self.clf.predict_proba([markants])
        return self.clf.predict([markants])


    
    def updateClassifier(self):
        print len(self.records), len(self.classes)
        for i in xrange(len(self.records)):
            #print self.classes[i], len(self.records[i])
            print self.classes[i], self.records[i][:3], self.records[i][-3:]
        self.clf.fit(self.records, self.classes)

    def verify(self, pImgStr, ids):
        finger = Finger(pImgStr)
        markants = finger.getMarkantsOrientation()
        return self.clf.predict_proba([markants])[0][ids]

        
if __name__ == "__main__":
    print "CLASSIFING VIA ORIENTATION OF PAPILAR LINES"
    print
    print "Preparing image db."
    bio = Bio()
    for i in xrange(1,16):
        img = [] 
        for j in xrange(1,6):
            ii = Image.open("db/"+str(i)+"_"+str(j)+".png")
            img.append(ii)
        bio.enroll(img, i)
        print str(i) + "/15"
        filename[0]=i

    print "Preparing done."
    print
    print "Training classifier"
    bio.updateClassifier()
    print "Training classifier done"
    """
    success = 0
    for i in xrange(1,16):
        a = bio.identify(Image.open("db/"+str(i)+"_7.png"))
        b = bio.identify(Image.open("db/"+str(i)+"_8.png"))
        print "Testing identify for class: "+ str(i)
        print "First image was classified as: " + str(a)
        print "Second image was classified as: " + str(b)
        print 
        if a == i: 
            success += 1
        if b == i: 
            success += 1
    print "Successfull of classfication: " + str((success/30.0)*100) + "%"
    print 
    #"""


    # ORIENTACE
    #"""
    accept = []
    for i in xrange(1,16):
        a = bio.verify(Image.open("db/"+str(i)+"_7.png"), i-1)
        b = bio.verify(Image.open("db/"+str(i)+"_8.png"), i-1)
        accept.append(a)
        accept.append(b)
        print "Testing verify for class: "+ str(i)
        print "First image should be in this class with " + str(a) +"% probability. "
        print "Second image should be in this class with " + str(b) +"% probability."
        print 
    #"""
    
    falseAccept = [] 
    random.seed()
    for i in xrange(1,16):
        rnd = random.randint(1,15)
        while rnd == i:
            rnd = random.randint(1,15)
        print rnd-1
        a = bio.verify(Image.open("db/"+str(i)+"_7.png"), rnd-1)
        b = bio.verify(Image.open("db/"+str(i)+"_8.png"), rnd-1)
        falseAccept.append(a)
        falseAccept.append(b)
        print "Testing verify for class: "+ str(i)
        print "First image (from class "+str(rnd)+") should be in here with " + str(a) +"% probability." 
        print "Second image (from class "+str(rnd)+") should be in here with " + str(b) +"% probability."
        print 

    # POCET MARKATNU V BLOKU
    """
    accept = []
    for i in xrange(1,16):
        a = bio.verify(Image.open("kostry/"+str(i)+"_7.png"), i-1)
        b = bio.verify(Image.open("kostry/"+str(i)+"_8.png"), i-1)
        accept.append(a)
        accept.append(b)
        print "Testing verify for class: "+ str(i)
        print "First image should be in this class with " + str(a) +"% probability. "
        print "Second image should be in this class with " + str(b) +"% probability."
        print 
    
    falseAccept = [] 
    random.seed()
    for i in xrange(1,16):
        rnd = random.randint(1,16)
        while rnd == i:
            rnd = random.randint(1,16)
        a = bio.verify(Image.open("kostry/"+str(i)+"_7.png"), rnd-1)
        b = bio.verify(Image.open("kostry/"+str(i)+"_8.png"), rnd-1)
        falseAccept.append(a)
        falseAccept.append(b)
        print "Testing verify for class: "+ str(i)
        print "First image should be in this class with " + str(a) +"% probability. "
        print "Second image should be in this class with " + str(b) +"% probability."
        print 
    """
    
    axis_x = map(lambda x: x/100.0, range(0,101))  # range != xrange, range robi list, xrange robi iterator
    hist = [0]*101
    far = [0]*101

    for i in falseAccept:
        for j in xrange(len(axis_x)):
            if axis_x[j] < i: continue
            hist[j]+=1
            break
    celk = reduce(lambda x,y: x+y, hist)
    done = celk
    for i in xrange(len(hist)):
        done -= hist[i]
        far[i] = done/float(celk)
    
    axis_x = map(lambda x: x/100.0, range(0,101))  # range != xrange, range robi list, xrange robi iterator
    hist = [0]*101
    frr = [0]*101

    for i in accept:
        for j in xrange(len(axis_x)):
            if axis_x[j] < i: continue
            hist[j]+=1
            break
    celk = reduce(lambda x,y: x+y, hist)
    done = 0
    for i in xrange(len(hist)):
        done += hist[i]
        frr[i] = done/float(celk)

    
    pylab.plot(axis_x, far, color='r')
    pylab.plot(axis_x, frr, color='b')
    pylab.show()
    #print profile
    """
    a = profile
    for i in xrange(1, len(a)):
        for j in xrange(len(a[0])):
            a[0][j] += a[i][j]
    p = a[0]
    for i in xrange(len(p)):
        print p[i]/len(a)
    """
    #print img.size
    #f1 = 
    #bio.printMe()
            
