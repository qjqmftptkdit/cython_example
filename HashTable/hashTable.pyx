import random

cdef class HashTable :
    cdef object hashTable
    cdef int maxCrashNumber
    cdef int hashTableSize

    def __init__(self) :
        self.hashTable = {}
        self.maxCrashNumber = 0
        self.hashTableSize = 71

        self.try0()
        self.try1()
        self.try2()
        self.try3()

    cdef int _createRandomNumber(self) :
        return random.randint(1, 150)

    cdef void initHashTable(self, int createNum) :
        for i in range(createNum) :
            self.putNumber(self._createRandomNumber())

    cdef void putNumber(self, int number) :
        if self.searchNumber(number) != -1 :
            return 

        key = self._hashFunction(number)
        if (key not in self.hashTable) or (key in self.hashTable and self.hashTable[key] == -1) : # If hash table's value is empty,
            self.hashTable[key] = number
        else : # If hash table's value is already exists.
            crashNumber = 1
            while True :
                key = self._hashCrashFunction(number, crashNumber)
                if (key not in self.hashTable) or (key in self.hashTable and self.hashTable[key] == -1) : # Check if sub hash key is usable
                    self.hashTable[key] = number
                    break
                else :
                    crashNumber += 1
            if self.maxCrashNumber < crashNumber : # Update maxCrashNumber
                self.maxCrashNumber = crashNumber

    cdef int searchNumber(self, int number) :
        key = self._hashFunction(number)
        if (key in self.hashTable) and (self.hashTable[key] == number) :
            return key
        else : 
            for crashNumber in range(1, self.maxCrashNumber + 1) :
                key = self._hashCrashFunction(number, crashNumber)
                if (key in self.hashTable) and (self.hashTable[key] == number) :
                    return key
                elif key not in self.hashTable :
                    return -1
        return -1 # Given number is not exists in dictionary

    cdef int deleteNumber(self, int number) :
        key = self.searchNumber(number)
        if key != -1 :
            self.hashTable[key] = -1
            return True
        else :
            return False
        
    cdef int _hashFunction(self, int number) :
        return number % self.hashTableSize

    cdef int _hashCrashFunction(self, int number, int crashNumber) :
        return (self._hashFunction(number) + crashNumber) % self.hashTableSize

    cdef void printHashTable(self) :
        for key, value in self.hashTable.items() :
            print(key, " -> ", value)

    cdef void try0(self) :
        print("* HashTable before #1")
        self.initHashTable(30)
        self.printHashTable()
    
    cdef void try1(self) : 
        print("* The result of #1")
        for i in range(10) :
            randNum = self._createRandomNumber()
            result = self.searchNumber(randNum)
            if result != -1 :
                print("{} is existed ! -> key : {}".format(randNum, result))
            else :
                print("{} is not existed...".format(randNum))

    cdef void try2(self) :
        print("* The result of #2")
        for i in range(10) :
            randNum = self._createRandomNumber()
            if self.deleteNumber(randNum) :
                print("{} is founded and deleted !".format(randNum))
            else :
                print("{} is not exsited...".format(randNum))
        self.printHashTable()

    cdef void try3(self) :
        print("* The result of #3")
        self.initHashTable(10)
        self.printHashTable()

    cdef void try4(self) :
        print("* The result of #4")
        for i in range(10) :
            randNum = self._createRandomNumber()
            result = self.searchNumber(randNum)
            if result != -1 :
                print("{} is existed ! -> key : {}".format(randNum, result))
            else :
                print("{} is not existed...".format(randNum))

cpdef void main () :
    HashTable()