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


relation = Relation()
relation.setAttrSet({'A', 'B', 'C'})
relation.setFunctionalDependency(
    {"AB": "C", "C": "A"})
print(relation.findAllKey())
print(relation.findAllSuperKey())
#
# relation = Relation()
# relation.setAttrSet({'M', 'N', 'O', 'P', 'Q', 'R', 'S'})
# relation.setFunctionalDependency(
#     {'S': 'MR', 'NS': 'QM', 'PQ': 'RS', 'MO': 'NR', 'N': 'R'})
# print(relation.findAllKey())
# print(relation.findAllSuperKey())
