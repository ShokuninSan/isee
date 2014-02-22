'use strict'

define( ->

  angular.module('isee.controllers', [])

  .controller('canvasCtrl', ($scope, $log, Patterns, Websocket) ->

    $scope.websocket = Websocket

    $scope.DOWNSAMPLE_WIDTH = 5
    $scope.DOWNSAMPLE_HEIGHT = 8
    $scope.downSampleData = []
    $scope.charData = {}
    $scope.downsampleArea = {}
    $scope.drawingArea = {}

    $scope.init = ->
      $scope.drawingArea = ENCOG.GUI.Drawing.create('drawing-area', 900, 600)
      $scope.downsampleArea = ENCOG.GUI.CellGrid.create('downsample-view', $scope.DOWNSAMPLE_WIDTH, $scope.DOWNSAMPLE_HEIGHT, 110, 120)
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
      $scope.downSampleData = ENCOG.ArrayUtil.allocate1D($scope.DOWNSAMPLE_WIDTH * $scope.DOWNSAMPLE_HEIGHT)
      ENCOG.ArrayUtil.fillArray($scope.downSampleData, 0, $scope.downSampleData.length, -1)
      $scope.displaySample()

    $scope.preload = ->
      $scope.defineChar(key, value) for key, value of Patterns.symbols

    $scope.defineChar = (charEntered, data) ->
      $scope.charData[charEntered] = data

    $scope.displaySample = ->
      $scope.downsampleArea.render()

    $scope.init()
  )
)