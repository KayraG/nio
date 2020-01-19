import nio, asyncdispatch

let server=newServer(8080)

proc index(req:NioRequest):NioResponse=
  return newResponse(200,"Hello World",{"Content-type":"text/html"})

server.route("/",index)
server.staticDir("./public/")

when isMainModule:
  server.listen()
  runForever()
