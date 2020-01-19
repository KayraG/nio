let os ="<"
let cs =">"

proc tmpl*(tmp:string): seq[string]=
    var
        i=0
        c=""
        o=false
        p:seq[string]

    while i<tmp.len:
        c=tmp.substr(i,i)
        if c==os:
            p.add ""
            o=true

        elif c==cs:
            o=false

        elif o:
            p[p.len-1] &= c
        
        i+=1
        c=""

    return p
