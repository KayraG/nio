import httpcore, utils

type NioResponse* = tuple
    code: HttpCode
    content: string
    headers: HttpHeaders

proc newResponse*(c:int,t:string,h:openArray[KeyPair]):NioResponse=
    let code=HttpCode(c)
    let headers=h.newHttpHeaders()
    return (code:code,content:t,headers:headers)
