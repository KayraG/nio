import asynchttpserver,asyncfutures, asyncdispatch

import router, settings, response, request, utils

type
    NioServer* =ref object
        server:AsyncHttpServer
        settings: NioSettings
        router: NioRouter

proc newServer*(port:int=8080, address:string=""):NioServer=
    let server=newAsyncHttpServer()
    let s=newSettings(Port(port),address)
    let r=newRouter()
    return NioServer(server:server,settings:s,router:r)

proc route*(self: NioServer, path: string, fn: Handler)=
    self.router.route(path,fn)

proc listen*(self: NioServer)=
    let s=self.settings
    let port=s.port
    let address=s.address

    proc handleHttpRequest(req: Request): Future[void] {.async.} =
        let path=req.url.path
        var a=[("","")].newMap
        let nreq=newRequest(req.reqMethod,path,req.body,a)
        var res: NioResponse
        res=self.router.dispatch(path,nreq)
        await req.respond(res.code, res.content, res.headers)

    asyncCheck self.server.serve(port,handleHttpRequest,address)


proc staticDir*(self:NioServer,dir:string="./")=
    self.router.staticDir(dir)

proc `port=`*(self:NioServer,nval:int)=
    self.settings.port=Port(nval)