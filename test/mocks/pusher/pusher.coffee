class Pusher
  constructor: ->

  subscribe:  ->
    new ChannelMock

class ChannelMock
  bind: ->
    ''
