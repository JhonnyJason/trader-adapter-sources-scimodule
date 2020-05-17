
scimodule = {name: "scimodule"}
############################################################
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["scimodule"]?  then console.log "[scimodule]: " + arg
    return

############################################################
#region node_modules
require('systemd')
express = require('express')
bodyParser = require('body-parser')
#endregion

############################################################
#region internalProperties
cfg = null

app = null
#endregion

scimodule.initialize = () ->
    log "scimodule.initialize"
    cfg = allModules.configmodule
    
    app = express()
    app.use bodyParser.urlencoded(extended: false)
    app.use bodyParser.json()

#region internal functions
onCancelOrders = (req, res) ->
    log "onCancelOrders"
    log "onCancelOrders - TODO implement!"
    res.send("Not implemented yet!")
    return

onSetOrders = (req, res) ->
    log "onSetOrders"
    log "onSetOrders - TODO implement!"
    res.send("Not implemented yet!")
    return

#################################################################
attachSCIFunctions = ->
    log "attachSCIFunctions"

    app.post "/cancelOrders", onCancelOrders
    app.post "/setOrders", onSetOrders

listenForRequests = ->
    log "listenForRequests"
    if process.env.SOCKETMODE
        app.listen "systemd"
        log "listening on systemd"
    else
        port = process.env.PORT || cfg.defaultPort
        app.listen port
        log "listening on port: " + port
#endregion


#region exposed functions
scimodule.prepareAndExpose = ->
    log "scimodule.prepareAndExpose"
    attachSCIFunctions()
    listenForRequests()
    
#endregion exposed functions

export default scimodule