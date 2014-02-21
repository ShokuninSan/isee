'use strict'

utils = angular.module('utils', [])

utils.controller 'utilsCtrl', ($scope, $log, Patterns, Websocket) ->

  $scope.websocket = Websocket

  DOWNSAMPLE_WIDTH = 5
  DOWNSAMPLE_HEIGHT = 8
  $scope.downsampleArea = undefined
  $scope.drawingArea = undefined
  $scope.downSampleData = []
  $scope.charData = {}

  $scope.init = ->
    $scope.drawingArea = ENCOG.GUI.Drawing.create('drawing-area', 300, 300)
    $scope.downsampleArea = ENCOG.GUI.CellGrid.create('downsample-view', DOWNSAMPLE_WIDTH, DOWNSAMPLE_HEIGHT, 110, 120)
    $scope.downsampleArea.outline = true
    $scope.downsampleArea.mouseDown = (x, y) ->
    $scope.downsampleArea.determineColor = (row, col) ->
      index = (row * this.gridWidth) + col
      if ($scope.downSampleData[index] < 0) then "white" else "black"
    $scope.downSampleData = $scope.drawingArea.performDownSample()
    $scope.displaySample($scope.downSampleData)
    $scope.preload()

  $scope.clear = ->
    $scope.drawingArea.clear()
    $scope.clearDownSample()

  $scope.convertDSData = (data) ->
    newData = []
    for i in [0..data.length - 1]
      if (data[i] == -1) then newData.push(0) else newData.push(1)
    return newData

  $scope.recognize = ->
    $('#message').text('thinking...')
    $scope.downSampleData = $scope.drawingArea.performDownSample()
    $scope.displaySample()
    if ($scope.downSampleData == null)
      $('#message').text("You must draw something to recognize.")
    else
      json = {
        message: "Downsample has downsampled"
        input: $scope.convertDSData($scope.downSampleData)
      }
      $scope.websocket.send(JSON.stringify(json))

  $scope.clearDownSample = ->
    $scope.downSampleData = ENCOG.ArrayUtil.allocate1D(DOWNSAMPLE_WIDTH * DOWNSAMPLE_HEIGHT)
    ENCOG.ArrayUtil.fillArray($scope.downSampleData, 0, $scope.downSampleData.length, -1)
    $scope.displaySample()

  $scope.preload = ->
    $scope.defineChar(key, value) for key, value of Patterns.symbols

  $scope.defineChar = (charEntered, data) ->
    $scope.charData[charEntered] = data

  $scope.displaySample = ->
    $scope.downsampleArea.render()

  $scope.init()

utils.factory 'Patterns', ->
  symbols:
    "distracted": new Array(1, 1, -1, 1, 1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, -1, -1, -1, 1, 1, 1, 1, 1)
    "happy"     : new Array(1, 1, -1, 1, 1, 1, 1, -1, 1, 1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, 1, -1, -1, -1, 1, 1, 1, 1, 1, 1)
    "sad"       : new Array(1, -1, -1, -1, 1, -1, -1, -1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, -1, -1, -1, -1, 1, 1, 1, 1, 1, 1, -1, -1, 1)
    "astonished": new Array(1, 1, -1, 1, 1, 1, 1, 1, 1, 1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, 1, 1, 1, -1, -1, 1, -1, 1, -1, -1, 1, 1, 1, -1)
    "love"      : new Array(1, 1, 1, 1, 1, 1, -1, 1, -1, 1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, 1, 1, -1, 1, 1, -1, 1, 1, 1, -1, -1, -1, 1, 1, -1)
    "death"     : new Array(1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1, 1, 1, 1, 1, -1, 1, 1, 1, -1, -1, 1, 1, 1, -1)
    "skeptical" : new Array(1, -1, -1, 1, 1, 1, -1, 1, 1, 1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, 1, 1, -1, -1, 1, 1, -1, -1, 1, 1, -1, -1, 1, 1, -1, -1, -1)
    "summertime": new Array(-1, -1, 1, -1, -1, 1, 1, 1, -1, 1, -1, 1, 1, 1, 1, -1, 1, -1, 1, -1, 1, 1, -1, 1, 1, -1, 1, 1, 1, -1, 1, 1, 1, 1, -1, -1, -1, 1, 1, 1)
    "bigben"    : new Array(-1, 1, 1, 1, -1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1)
    "laughing"  : new Array(1, 1, -1, -1, 1, 1, 1, 1, -1, 1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, 1, 1, 1, -1, 1, 1, 1, 1, 1, 1, 1, -1, -1, -1, 1, 1, 1, 1, 1, 1)
  digits:
    "0": new Array(-1, 1, 1, 1, -1, 1, 1, -1, 1, 1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, 1, 1, -1, -1, 1, -1, 1, 1, 1, -1)
    "1": new Array(1, 1, 1, -1, -1, 1, 1, 1, -1, -1, 1, 1, 1, -1, -1, 1, 1, 1, 1, -1, -1, 1, 1, 1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, 1, -1, 1, 1, 1, 1)
    "2": new Array(1, 1, 1, -1, -1, -1, -1, 1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, 1, 1, 1, 1, -1, 1, -1, 1, 1, -1, 1, 1, 1, 1, 1)
    "3": new Array(1, 1, 1, 1, -1, -1, -1, -1, 1, 1, -1, -1, -1, 1, 1, -1, -1, 1, 1, -1, -1, 1, 1, 1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, 1, 1, 1, 1, 1)
    "4": new Array(1, -1, -1, 1, -1, 1, -1, -1, 1, -1, 1, -1, -1, 1, -1, 1, 1, 1, 1, 1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1)
    "5": new Array(1, 1, 1, 1, 1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, 1, 1, 1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, 1, 1, 1, 1, 1)
    "6": new Array(-1, 1, 1, 1, -1, 1, 1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, 1, 1, -1, 1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 1, 1, -1, -1, 1, -1, 1, 1, 1, 1)
    "7": new Array(1, 1, 1, 1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, -1, -1, -1)
    "8": new Array(1, 1, 1, 1, 1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, 1, 1, 1, 1, 1, -1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 1, -1, -1, -1, 1, 1, 1, 1, 1, 1)
    "9": new Array(1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 1, -1, -1, -1, 1, 1, 1, 1, 1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1)

utils.service 'Voice', ->
  "distracted" : "#{$('#env').data('audio')}/cheer-up_kate.mp3"
  "happy"      : "#{$('#env').data('audio')}/smile_kate.mp3"
  "sad"        : "#{$('#env').data('audio')}/sad_kate.mp3"
  "astonished" : "#{$('#env').data('audio')}/distract_kate.mp3"
  "love"       : "#{$('#env').data('audio')}/love_kate.mp3"
  "death"      : "#{$('#env').data('audio')}/game-over_kate.mp3"
  "skeptical"  : "#{$('#env').data('audio')}/skeptical_kate.mp3"
  "summertime" : "#{$('#env').data('audio')}/summertime_kate.mp3"
  "bigben"     : "#{$('#env').data('audio')}/big-ben_kate.mp3"
  "laughing"   : "#{$('#env').data('audio')}/laughing_kate.mp3"

utils.service 'Console', ->
  "distracted" : "Cheer up! Everything is gonna be alright!"
  "happy"      : "I love to see you smile"
  "sad"        : "Oh no, why are you sad?"
  "astonished" : "Oops, did I distract you!?"
  "love"       : "I see, I see, now you fell in love with me, huh?"
  "death"      : "Oh shit! Game over!"
  "skeptical"  : "No need to be skeptical! I never failed the Turing Test!"
  "summertime" : "I'm looking forward to summertime too! So I can get naked for you ;)"
  "bigben"     : "Come on! are you serious? This should be Big Ben?"
  "laughing"   : "Come on! Are you laughing at me?"
  
utils.service 'Mapping', ->
  symbols: [
    "distracted",
    "happy",
    "sad",
    "astonished",
    "love",
    "death",
    "skeptical",
    "summertime",
    "bigben",
    "laughing"
  ]

utils.service 'Websocket', (Console, Voice, Mapping) ->
  ws = new WebSocket($('#env').data('websockets'))
  ws.onmessage = (msg) ->
    data = JSON.parse(msg.data)
    if data.result
      minDiff = 1.0
      closestIndex = 0
      for i in [0..data.result.length]
        diff = 1.0 - data.result[i]
        if (diff < minDiff)
          minDiff = diff
          closestIndex = i
      $('#message').text(Console[Mapping.symbols[closestIndex]])
      new Audio(Voice[Mapping.symbols[closestIndex]]).play()
    else
      $('#message').text(data.message)
  ws

angular.module('isee', ['utils'])