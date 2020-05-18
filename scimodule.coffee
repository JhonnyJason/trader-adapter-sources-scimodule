
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
auth = null
task = null

app = null
#endregion

############################################################
scimodule.initialize = () ->
    log "scimodule.initialize"
    cfg = allModules.configmodule
    auth = allModules.authmodule
    task = allModules.taskmodule

    app = express()
    app.use bodyParser.urlencoded(extended: false)
    app.use bodyParser.json()
    return

############################################################
#region internalFunctions
onCancelOrders = (req, res) ->
    log "onCancelOrders"
    try
        orders = req.body.orders
        message = JSON.stringify(orders)
        signature = req.body.signature
        auth.authenticate(message, signature)

        tasks = orders.map((el) -> {type:"cancelOrder", order:el})
        task.addTasks(tasks)
        
        response = {}
        response.ok = true
        response.message = "You are awesome!"
        res.send(response)
    catch err
        log err
        res.sendStatus(403)
    return

onSetOrders = (req, res) ->
    log "onSetOrders"
    try
        orders = req.body.orders
        message = JSON.stringify(orders)
        signature = req.body.signature
        auth.authenticate(message, signature)

        tasks = orders.map((el) -> {type:"setOrder", order:el})
        task.addTasks(tasks)
        
        response = {}
        response.ok = true
        response.message = "You are awesome!"
        res.send(response)
    catch err
        log err
        res.sendStatus(403)
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


############################################################
#region exposedFunctions
scimodule.prepareAndExpose = ->
    log "scimodule.prepareAndExpose"
    attachSCIFunctions()
    listenForRequests()
    
#endregion exposed functions

export default scimodule