import nativesockets

type NioSettings* = ref object
    port* : Port
    address* : string

proc newSettings*(port:Port,address:string):NioSettings=
    return NioSettings(port:port,address:address)
