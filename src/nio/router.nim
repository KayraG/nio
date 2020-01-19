import response, request, utils
import os, mimetypes

type
    Handler* =proc(req:NioRequest):NioResponse

    NioRouter* =ref object
        routes: seq[string]
        handlers: seq[Handler]
        isStatic: bool
        staticDir: string

proc newRouter*():NioRouter=
    let r:seq[string]= @[]
    let h:seq[Handler]= @[]
    return NioRouter(routes:r,handlers:h,isStatic:false, staticDir:"")

proc isRoute*(self:NioRouter,path:string):bool=
    var c=self.routes.find(path)
    return c > -1

proc route*(self: NioRouter, path: string, handler: Handler)=
    self.routes.add(path)
    self.handlers.add(handler)

proc staticDir*(self: NioRouter, path:string)=
    self.isStatic=true
    self.staticDir=path

proc dispatch*(self: NioRouter, path:string, req: NioRequest):NioResponse{.gcsafe.}=
    var c=self.routes.find(path)
    if c == -1:
        if self.isStatic:
            let dir= self.staticDir
            let fp=dir & path
            if fp.existsFile:
                let sp= fp.splitFile
                var mms=newMimetypes()
                mms.register("html","text/html")
                mms.register("css","text/css")
                let mtype=mms.getExt(sp.ext)
                echo sp.ext
                let content:string =fp.readFile
                let headers={"Content-type":mtype}
                return newResponse(200,content,headers)

        let content="<h1>Page Not Found</h1>"
        let headers={"Content-type":"text/html"}.newMap
        return newResponse(404,content,headers)
    var fn=self.handlers[c]
    return fn(req)