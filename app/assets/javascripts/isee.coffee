'use strict'

utils = angular.module('utils', [])

utils.controller 'utilsCtrl', ($scope, $log) ->

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
      ws.send(JSON.stringify(json))

  $scope.clearDownSample = ->
    $scope.downSampleData = ENCOG.ArrayUtil.allocate1D(DOWNSAMPLE_WIDTH * DOWNSAMPLE_HEIGHT)
    ENCOG.ArrayUtil.fillArray($scope.downSampleData, 0, $scope.downSampleData.length, -1)
    $scope.displaySample()

  $scope.preload = ->
    # digits
    #$scope.defineChar("0", new Array(-1, 1, 1, 1, -1, 1, 1, -1, 1, 1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, 1, 1, -1, -1, 1, -1, 1, 1, 1, -1))
    #$scope.defineChar("1", new Array(1, 1, 1, -1, -1, 1, 1, 1, -1, -1, 1, 1, 1, -1, -1, 1, 1, 1, 1, -1, -1, 1, 1, 1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, 1, -1, 1, 1, 1, 1))
    #$scope.defineChar("2", new Array(1, 1, 1, -1, -1, -1, -1, 1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, 1, 1, 1, 1, -1, 1, -1, 1, 1, -1, 1, 1, 1, 1, 1))
    #$scope.defineChar("3", new Array(1, 1, 1, 1, -1, -1, -1, -1, 1, 1, -1, -1, -1, 1, 1, -1, -1, 1, 1, -1, -1, 1, 1, 1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, 1, 1, 1, 1, 1))
    #$scope.defineChar("4", new Array(1, -1, -1, 1, -1, 1, -1, -1, 1, -1, 1, -1, -1, 1, -1, 1, 1, 1, 1, 1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1))
    #$scope.defineChar("5", new Array(1, 1, 1, 1, 1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, 1, 1, 1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, 1, 1, 1, 1, 1))
    #$scope.defineChar("6", new Array(-1, 1, 1, 1, -1, 1, 1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, 1, 1, -1, 1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 1, 1, -1, -1, 1, -1, 1, 1, 1, 1))
    #$scope.defineChar("7", new Array(1, 1, 1, 1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, -1, -1, -1))
    #$scope.defineChar("8", new Array(1, 1, 1, 1, 1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, 1, 1, 1, 1, 1, -1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 1, -1, -1, -1, 1, 1, 1, 1, 1, 1))
    #$scope.defineChar("9", new Array(1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 1, -1, -1, -1, 1, 1, 1, 1, 1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1))
    # various symbols
    $scope.defineChar("distracted", new Array(1, 1, -1, 1, 1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, -1, -1, -1, 1, 1, 1, 1, 1))
    $scope.defineChar("happy", new Array(1, 1, -1, 1, 1, 1, 1, -1, 1, 1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, 1, -1, -1, -1, 1, 1, 1, 1, 1, 1))
    $scope.defineChar("sad", new Array(1, -1, -1, -1, 1, -1, -1, -1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, -1, -1, -1, -1, 1, 1, 1, 1, 1, 1, -1, -1, 1))
    $scope.defineChar("astonished", new Array(1, 1, -1, 1, 1, 1, 1, 1, 1, 1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, 1, 1, 1, -1, -1, 1, -1, 1, -1, -1, 1, 1, 1, -1))
    $scope.defineChar("love", new Array(1, 1, 1, 1, 1, 1, -1, 1, -1, 1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, 1, 1, -1, 1, 1, -1, 1, 1, 1, -1, -1, -1, 1, 1, -1))
    $scope.defineChar("death", new Array(1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1, 1, 1, 1, 1, -1, 1, 1, 1, -1, -1, 1, 1, 1, -1))
    $scope.defineChar("skeptical", new Array(1, -1, -1, 1, 1, 1, -1, 1, 1, 1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, 1, 1, -1, -1, 1, 1, -1, -1, 1, 1, -1, -1, 1, 1, -1, -1, -1))
    $scope.defineChar("summertime", new Array(-1, -1, 1, -1, -1, 1, 1, 1, -1, 1, -1, 1, 1, 1, 1, -1, 1, -1, 1, -1, 1, 1, -1, 1, 1, -1, 1, 1, 1, -1, 1, 1, 1, 1, -1, -1, -1, 1, 1, 1))
    $scope.defineChar("bigben", new Array(-1, 1, 1, 1, -1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1))
    $scope.defineChar("laughing", new Array(1, 1, -1, -1, 1, 1, 1, 1, -1, 1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, 1, 1, 1, -1, 1, 1, 1, 1, 1, 1, 1, -1, -1, -1, 1, 1, 1, 1, 1, 1))

  $scope.defineChar = (charEntered, data) ->
    $scope.charData[charEntered] = data

  $scope.displaySample = ->
    $scope.downsampleArea.render()

  $scope.init()

angular.module('isee', ['utils'])