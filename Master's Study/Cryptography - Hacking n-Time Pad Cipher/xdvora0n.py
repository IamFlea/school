################################################################################
#                   Kostra k 2. projektu do predmetu KRY                       #
#                                  xdvora0n                                    #
################################################################################
# lepsi byly pohadky od bratri grimmu :P jjjj
import sys
from OracleModule import paddingOracle
from OracleModule import genNewKey
from OracleModule import setKey
from OracleModule import encrypt


blocksize = 16
getBlocks = lambda string : [string[i:i+blocksize] for i in range(0, len(string), blocksize)]
getCipher = lambda blocks : "".join(blocks)
newBlock  = lambda block, char, i: block[:i] + char + block[i+1:]
xor = lambda a, b: chr(ord(a) ^ ord(b) if type(a) == str and type(b) == str else  (a ^ ord(b) if type(b) == str else (ord(a) ^ b if type(a) == str else a ^ b)))
# priserka na predchozim radku je zjevne operace xor, ktera disponuje dynamickym typovanim

def decodeCiphertext(ciphertext):
    plaintextWithoutPadding = ""
    blocks = getBlocks(ciphertext.decode("hex"))    # sifru rozsekam na bloky
    for i in xrange(len(blocks)-1):                 # pak projizidim blok po bloku
        previous = blocks[i]                        # ulozim si predchozi blok
        current  = blocks[i+1]                      # blok na ktery provadim utok
        cipher   = getCipher(blocks[:i])            # ciphertext, ktery uz mame rozlusteny (konkatenace)
        blockText = ""                              # pomocny text
        for j in xrange(blocksize):                 # ctu blok znak po znaku
            idx = blocksize-j-1                     # idx znaku ktery hodlame menit
            for x in xrange(256):                                           # HLEDAME znak
                newBlck = str(previous)                                     # docasna promenna
                for k in xrange(j):                                                     # projedu jiz rozsifrovana pismena
                    newChar = xor(xor(previous[blocksize - k - 1], blockText[k]), j+1)  # vyxoruju ZNAMY ZNAK
                    newBlck = newBlock(newBlck, newChar, blocksize - k -1)              # UPRAVIM blok
                newChar = xor(xor(previous[idx], x), j+1)                   # vyxoruju HLEDANY blok
                newBlck = newBlock(newBlck, newChar, idx)                   # UPRAVIM blok
                if paddingOracle((cipher+newBlck+current).encode("hex")):   # Zeptam se oracula
                    char = x                                                # pokud neco naslo ulozim
            blockText += chr(char)                                          # ulozim do retzce
        plaintextWithoutPadding += blockText[::-1]                          # ktery pak reverzuju a konkatenuju
    val = ord(plaintextWithoutPadding[-1])                                  # zjistim jaky je padding
    return plaintextWithoutPadding[:-val]                                   # posledni uprava, useknu padding

def test():
    ciphertext = "fa485ab028cb239a39a9e52df1ebf4c30911b25d73f8906cc45b6bf87f7a693f" +\
                 "47609094ccca42050ad609bb3cf979ac"
    print "SKOLNI TEST 1"
    print decodeCiphertext(ciphertext)
    print

    ciphertext = "92fd508cadb2bef14554d43a79394332ff00adebd197025f980f829c95f57305"
    print "SKOLNI TEST 2"
    print decodeCiphertext(ciphertext)
    print
    
    ciphertext = "19e27c9b5411608f9a8909c21eee2a61198b124de41f6e8d41ff1f22b3c60e78" +\
                 "9cd370bf2e2c88ad08643a5769e99264a5659ee34fe4dc03c269bd2af255edcf"
    print "SKOLNI TEST 3"
    print decodeCiphertext(ciphertext)
    print
    
    setKey("sixteen_byte_key")
    ciphertext = "5a36670ff5cb94ba2509e3f0ae74db879e239644b5e7a924f4c9fff6368500c3" +\
                 "d84e9aa2f84a80d33ee7f2a18d4f4c5f65214fcf4f42dba2f5da24d7eb19e0b1" +\
                 "cfca111cc6e4f7ef88e745f91c4632a54764090361083afc90deefef42737984" +\
                 "a3461033d448fa012a979a2984b4c43640fb1e77bbf23890e45c0a69c92273c8" +\
                 "dd23e58ceb1015c51a90b40a594aedc553e54b9452b735c8c8b677a37ac2d396" +\
                 "2c75c1c2adb3b45698583da8c5a58d22dde58bb5ed7f66bb6874d305822ac0e6"
    print "SKOLNI TEST 4"
    print decodeCiphertext(ciphertext)
    print

    ciphertext = "a1372965b3a651999c1ef019fef1402c32f7847fdd0f2b29a0d3135dc4dd54c9" +\
                 "507c91f2f1a7fc863a572db4bab0d64e13d5469a2e31f2d8c2ada6f4cca72f46" +\
                 "23cd39bc7f4cb16df995392c98b785512058c27fb543ac15d6aad12942f87d33" +\
                 "6e27216fd0ab7839fe64ead0b6e20fbf23e5b5ca8c4fd074772bb3eb9a8efbd6" +\
                 "5be42c0ead9a4a20ff057b0e615d932cc80fe7e886e96cd46adef0edaf634221" +\
                 "53f973399a70751c89e766ffa360be7cc3d707018195cf19244bae6258abcc6a"
    print "SKOLNI TEST 5"
    print decodeCiphertext(ciphertext)
    print

    
    for i in xrange(17):
        plaintext = ("1234567890abcdef"*5)[:-i]
        if i == 0:
            plaintext = ("1234567890abcdef"*5)
        ciphertext = encrypt(plaintext).encode("hex")
        print "PADDING TEST " + str(i)
        print "plaintext:   " + plaintext
        decoded = decodeCiphertext(ciphertext)
        print "desfirovany: " + decoded
        if plaintext == decoded:
            print "SUCCESS"
        else:
            print "FAIL"

    import random #muhahahah
    for i in xrange(200):
        print "RANDOM TEST " + str(i)
        string = ""
        for i in xrange(random.randint(20,100)):
            string += chr(random.randint(0,255))
        opentext = string.encode("hex")
        decoded = decodeCiphertext(encrypt(string).encode("hex")).encode("hex")
        print opentext
        print decoded
        if decoded == opentext:
            print "SUCCESS"
            print
        else:
            print "FAIL" # shhhh, it happens
            print
            break
    
    decoded = decodeCiphertext(encrypt("").encode("hex")).encode("hex")
    print "Empty string test: ", decoded == ""




    # You shall not ...
    pass 

if __name__ == "__main__":
    if len(sys.argv) > 1:
        ciphertext = sys.argv[1]
        if ciphertext == "TEST":
            test()
            sys.exit(1)
        if ciphertext == "FAIL":
            setKey("sixteen_byte_key")
            plain = "02d177394562be27bf356ee31e420260128cd550c5e7b1f0c9e1114df96d2862ae21f4c9bbcf704f01730c4eebe441ab3b01f5cdf677f27e3febfe3f913234f888f859346f3ae0d93b019e14ab37976f161d72855f410df6eae2460cb19ab97d40bf".decode("hex")
            cipher = encrypt(plain).encode("hex")
            print "plain: " + plain.encode("hex")
            print "weget: "+ decodeCiphertext(cipher).encode("hex")
            print decodeCiphertext(cipher)==plain
            """
            Jeden blok to proste nerozsifrovalo.. 
            0123456789abcdef0123456789abcdef
            ffffffffffffffffffffffffffffff63128cd550c5e7b1f0c9e1114df96d2862ae21f4c9bbcf704f01730c4eebe441ab3b01f5cdf677f27e3febfe3f913234f888f859346f3ae0d93b019e14ab37976f161d72855f410df6eae2460cb19ab97d40bf
            02d177394562be27bf356ee31e420260128cd550c5e7b1f0c9e1114df96d2862ae21f4c9bbcf704f01730c4eebe441ab3b01f5cdf677f27e3febfe3f913234f888f859346f3ae0d93b019e14ab37976f161d72855f410df6eae2460cb19ab97d40bf
            """
            sys.exit(1)


    else:
        ciphertext = "fa485ab028cb239a39a9e52df1ebf4c30911b25d73f8906cc45b6bf87f7a693f47609094ccca42050ad609bb3cf979ac"
    
    
    
    # Lepsi byly ty pohadky od bratri Grimmu!
    # vypis desifrovaneho textu provedte nasledujicim zpusobem: 
    print decodeCiphertext(ciphertext)
    sys.exit(0)
    
'''
Utok budete provadet na funkci paddingOracle():
    
paddingOracle(ciphertext):
  Funkce "zjisti" zda je zasifrovany plaintext korektne zarovnan podle PKCS#7
  a vrati tuto informaci v podobe True/False.
  Parametr ciphertext je retezec zasifrovaneho textu prevedeny do hexa formatu!



Pro jistotu upozorneni:
  Nezapomente, ze zasifrovany text je v rezimu "CBC s nahodnym IV" ve formatu:
      IV | CT

  IV - inicializacni vektor (16 bajtu)
  |  - kontatenace
  CT - zasifrovany text rezimem CBC (nasobek 16 bajtu)



Pro testovani muzete pouzit funkce genNewKey(), setKey(key) a encrypt(plaintext).
---------------------
genNewKey():
  Provede vygenerovani noveho klice, ktery zaroven nastavi jako aktualni sifrovaci
  klic pro padding orakulum. Rovnez vrati vygenerovany klic (ascii, nikoli hexa).

setKey(key):
  Provede nastaveni sifrovaciho klice pro padding orakulum. Argument key ocekava
  sifrovaci klic v ascii, nikoli jako hexa retezec.
  
encrypt(plaintext):
  Provede zarovnani PKCS#7 ascii plaintextu a nasledne jeho zasifrovani 
  s vyuzitim aktualne nastaveneho sifrovaciho klice, ktery sdili s padding 
  orakulem. Sifrovani probiha algoritmem AES-CBC (128b varianta). 
'''
