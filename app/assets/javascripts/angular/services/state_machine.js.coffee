StateMachine = (Session) ->

  class StateMachine
    constructor: (@primaryKey, @defaults) ->

    getDefaults: ->
      angular.copy(@defaults)

    getKey: (key) ->
      @primaryKey + '.' + key

    get: (attr) ->
      key = @getKey(attr)
      val = Session.get(key)
      return val if val?
      Session.put(key, @getDefaults()[attr])
      Session.get(key)

    setAttrs: (attrs) ->
      @set(key, val) for key, val of attrs

    set: (attr, val) ->
      return unless @defaults.hasOwnProperty(attr)
      Session.put(@getKey(attr), val)

    update: (attr, updateCB) ->
      val = @get(attr)
      val = updateCB(val)
      @set(attr, val)

  create = (primaryKey, defaults) ->
    new StateMachine(primaryKey, defaults)

  destroyAll = ->
    Session.kill()

  create: create
  destroyAll: destroyAll

StateMachine.$inject = ['Session']
angular.module('pandify').factory('StateMachine', StateMachine)
