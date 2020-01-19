import httpcore
import utils

type
    NioRequest* = ref object
        reqMethod* : string
        path* : string
        body* : string
        params* : Map
    
proc newRequest*(r:HttpMethod,p:string,b:string,m:openArray[KeyPair]):NioRequest=
    var s=""
    case r:
    of HttpGet:
        s="GET"
    of HttpPost:
        s="POST"
    of HttpPut:
        s="PUT"
    of HttpHead:
        s="HEAD"
    of HttpConnect:
        s="CONNECT"
    of HttpDelete:
        s="DELETE"
    of HttpOptions:
        s="OPTIONS"
    of HttpPatch:
        s="PATCH"
    of HttpTrace:
        s="TRACE"

    return NioRequest(reqMethod:s, path:p, body:b, params:m.newMap())