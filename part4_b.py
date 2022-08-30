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
        resultString = ""
        for item in closureOfX:
            resultString += str(item)
        return resultString

    def step1(self):

        # right-hand decomposition
        dict_temp = dict()
        dict_temp = self.getFunctionalDependency().copy()
        for key, values in dict_temp.items():
            dict_temp[key] = list(c for c in values)
        return dict_temp

    def resolve(self):
        F1_temp = self.step1()
        F2_temp = self.getFunctionalDependency()
        for key, value in F1_temp.items():  # S, ['M','R']
            list_temp = value.copy()
            F2_temp.pop(key)
            for item in value:
                list_temp.remove(item)
                F2_temp[key] = list_temp
                if item in self.findClosureAttributeSet(key):
                    continue
                else:
                    F2_temp[key].append(item)
        return F2_temp


relation = Relation()
relation.setAttrSet({'M', 'N', 'O', 'P', 'Q', 'R', 'S'})
relation.setFunctionalDependency(
    {'S': 'MR', 'NS': 'QM', 'PQ': 'RS', 'MO': 'NR', 'N': 'R'})
print(relation.resolve())
