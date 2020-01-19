type
    KeyPair* = (string,string)
    Map* = seq[KeyPair]

proc newMap*(a:openArray[KeyPair]):Map=
    for t in a:
        result.add t


proc hasKey*(self:Map,key:string):bool=
    for t in self:
        if t[0]==key:
            return true

    return false

proc hasValue*(self:Map,key:string):bool=
    for t in self:
        if t[1]==key:
            return true
    
    return false
