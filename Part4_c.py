import itertools
# this class will used to store relation: their attr, functionalDepend


class Relation:
    def __init__(self):
        self.attr_set = set()  # store attr set
        self.functional_dependency = dict()  # store functional dependency

    def setAttrSet(self, attribute):
        self.attr_set = attribute

    def getAttrSet(self):
        return self.attr_set

    def setFunctionalDependency(self, x):
        self.functional_dependency = x

    def getFunctionalDependency(self):
        return self.functional_dependency

    def findClosureAttributeSet(self, attrX):
        attrX_set = set(attrX)
        functionalDependencies = self.getFunctionalDependency()
        # Left is the side of Left of functional dependency
        Left = list()
        for item in functionalDependencies.keys():
            Left.append(set(item))
        # Right is the side of Right of functional dependency
        Right = list()
        for item in functionalDependencies.values():
            Right.append(set(item))
        # Find Closesure OF X
        closureOfX = attrX_set
        numIndex = 0
        while True:
            numIndex = 0
            for item in Left:
                if item.issubset(closureOfX):
                    break
                else:
                    numIndex += 1
            if numIndex != len(Left):
                closureOfX = closureOfX.union(Right[numIndex])
                Left.remove(Left[numIndex])
                Right.remove(Right[numIndex])
            else:
                break
        return closureOfX

    def findAllSubsetOfX(self, Xi):
        AllSubsetOfX = list()
        for i in range(0, len(Xi)+1):
            for sub in itertools.combinations(Xi, i):
                AllSubsetOfX.append(sub)
        return AllSubsetOfX

    def findAllKey(self):
        Relational_set = self.getAttrSet()
        # Left is the side of Left of functional dependency
        Left = list()
        functionalDependencies = self.getFunctionalDependency()
        for item in functionalDependencies.keys():
            Left.append(item)
        temp = list()
        for item in Left:
            for attr in item:
                temp.append(attr)
        # Left_2 will be stored every item in Left
        Left_2 = set(temp)
        # Right is the side of Right of functional dependency
        Right = list()
        for item in functionalDependencies.values():
            Right.append(set(item))
        temp = list()
        for item in Right:
            for attr in item:
                temp.append(attr)
        # Right_2 will be stored every item in Right
        Right_2 = set(temp)
        # SourceSet
        SourceSet = Relational_set.difference(Right_2)
        # IntermediateSet
        IntermediateSet = Left_2.intersection(Right_2)
        # superKeyList store list of super key set
        superKeyList = list()
        for subset in self.findAllSubsetOfX(IntermediateSet):
            if self.findClosureAttributeSet(SourceSet.union(subset)) == self.getAttrSet():
                superKeyList.append(SourceSet.union(subset))
        # notKey will be store super key and not key
        notKey = list()
        for i in range(0, len(superKeyList) - 1):
            for j in range(i + 1, len(superKeyList)):
                if superKeyList[i].issubset(superKeyList[j]):
                    notKey.append(superKeyList[j])
        # KeyList is solution
        KeyList = list()
        for superKey in superKeyList:
            if superKey not in notKey:
                KeyList.append(superKey)
        return KeyList

    def findAllSuperKey(self):
        Relational_set = self.getAttrSet()
        # Left is the side of Left of functional dependency
        Left = list()
        functionalDependencies = self.getFunctionalDependency()
        for item in functionalDependencies.keys():
            Left.append(item)
        temp = list()
        for item in Left:
            for attr in item:
                temp.append(attr)
        # Left_2 will be stored every item in Left
        Left_2 = set(temp)
        # Right is the side of Right of functional dependency
        Right = list()
        for item in functionalDependencies.values():
            Right.append(set(item))
        temp = list()
        for item in Right:
            for attr in item:
                temp.append(attr)
        # Right_2 will be stored every item in Right
        Right_2 = set(temp)
        # SourceSet
        SourceSet = Relational_set.difference(Right_2)
        # IntermediateSet
        IntermediateSet = Left_2.intersection(Right_2)
        # superKeyList store list of super key set
        superKeyList = list()
        for subset in self.findAllSubsetOfX(IntermediateSet):
            if self.findClosureAttributeSet(SourceSet.union(subset)) == self.getAttrSet():
                superKeyList.append(SourceSet.union(subset))
        return superKeyList

    def findNormalization(self):
        keyList = self.findAllKey()
        functionalDependency = self.getFunctionalDependency()
        # KeyAttrSet
        keyAttrSet = set().union(*keyList)
        KeyNotAttrSet = self.getAttrSet().difference(keyAttrSet)
        print("Attr key: ", keyAttrSet)
        print("Attr not key: ", KeyNotAttrSet)
        # 2NF Non-key attributes must be fully functionally dependent on the primary key
        # Method:
        # - Check each functional dependency X -> A:
        # - if X is subset of key and A is in attribute not key then isn't 2NF.
        # - else is 2NF
        # Notes: if X has fully key of key set then continue
        # End.
        flag = bool()  # to check 2NF
        LeftOfFD = list()
        RightOfFD = list()
        for key, value in functionalDependency.items():
            LeftOfFD.append(set(key))
            RightOfFD.append(set(value))
        for itemL, itemR in zip(LeftOfFD, RightOfFD):
            if (itemL.issubset(keyAttrSet)) and (itemR.issubset(KeyNotAttrSet)):
                if len(itemL) == len(keyAttrSet):
                    flag = True
                    continue
                flag = False
                break
            else:
                flag = True
        # 3NF Non-key attributes must directly depend on the primary key
        # Method:
        # - Find key
        # - Check: Relation is 2NF?;
        # - Check each functional dependency of F if exist X -> A:
        # -     X is not key and A is attribute non-key
        # -         => not is 3NF
        # - else 3NF
        # End.
        flag_2 = bool()  # to check#3NF
        if (flag):
            LeftOfFD = list()
            RightOfFD = list()
            for key, value in functionalDependency.items():
                LeftOfFD.append(set(key))
                RightOfFD.append(set(value))
            for itemL, itemR in zip(LeftOfFD, RightOfFD):
                if itemL.issubset(KeyNotAttrSet) and itemR.issubset(KeyNotAttrSet):
                    flag_2 = False
                    break
                else:
                    flag_2 = True

        # BCNF There is no key attribute but a functional dependency on a non-key attribute.
        flag_3 = bool()  # to check BCNF
        if (flag == True and flag_2 == True):
            LeftOfFD = list()
            RightOfFD = list()
            for key, value in functionalDependency.items():
                LeftOfFD.append(set(key))
                RightOfFD.append(set(value))
            for itemL, itemR in zip(LeftOfFD, RightOfFD):
                if not (itemL in self.findAllSuperKey()):
                    flag_3 = False
                    break
                else:
                    flag_3 = True
        # conclusion
        if (flag):
            print(
                "2NF is the highest standard form because Non-key attributes is fully functionally dependent on the primary key")
        if (flag_2):
            print(
                "3NF is the highest standard form because Non-key attributes directly depend on the primary key")
        if (flag_3):
            print('BCNF is the highest standard form because There is no key attribute but a functional dependency on a non-key attribute.')
        if (flag == False and flag_2 == False and flag_3 == False):
            print('1NF is the highest standard form because it isn\'t 2NF, 3NF or BCNF')
        return

# 1NF
# relation = Relation()
# relation.setAttrSet({'M', 'N', 'O', 'P', 'Q', 'R', 'S'})
# relation.setFunctionalDependency(
#     {'S': 'MR', 'NS': 'QM', 'PQ': 'RS', 'MO': 'NR', 'N': 'R'})
# relation.findNormalization()
# 1NF
# relation = Relation()
# relation.setAttrSet({'A', 'S', 'P', 'I'})
# relation.setFunctionalDependency(
#     {'SI': 'P', 'S': 'A'})
# relation.findNormalization()
# 2NF
# relation = Relation()
# relation.setAttrSet({'A', 'B', 'C', 'D'})
# relation.setFunctionalDependency(
#     {'A': 'BC', 'B': 'D'})
# relation.findNormalization()
# 3NF
# relation = Relation()
# relation.setAttrSet({'C', 'S', 'Z'})
# relation.setFunctionalDependency(
#     {'CS': 'Z', 'Z': 'C'})
# relation.findNormalization()
# BCNF
# relation = Relation()
# relation.setAttrSet({'C', 'S', 'Z'})
# relation.setFunctionalDependency(
#     {'CS': 'Z'})
# relation.findNormalization()
