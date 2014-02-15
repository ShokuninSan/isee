'use strict'

utils = angular.module('utils', [])

utils.controller 'utilsCtrl', ($scope, $log) ->
  DOWNSAMPLE_WIDTH = 5
  DOWNSAMPLE_HEIGHT = 8
  $scope.downsampleArea = undefined
  $scope.drawingArea = undefined
  $scope.downSampleData = []
  charData = []
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

  $scope.ev_teach = (ev) ->
    data = $scope.drawingArea.performDownSample()
    $scope.displaySample data
    if (data == null)
      alert("You must draw something first.")
    else
      charEntered = prompt("What did you just draw?", "")
      if (charEntered)
        if (charEntered in charData)
          alert("That character is already defined.")
        else if (charEntered.length != 1)
          alert("Please enter exactly one character.")
        else
          $scope.drawingArea.clear()
          charData[charEntered] = data
#           lstLetters.add(new Option(charEntered))
          $scope.clearDownSample()

  $scope.ev_remove = (ev) ->
    for i  in [lstLetters.length - 1..0]
      if (lstLetters.options[i].selected)
        lstLetters.remove(i)
    $scope.clearDownSample()

  $scope.ev_downSample = (ev) ->
    $scope.downSampleData = $scope.drawingArea.performDownSample()
    $scope.displaySample()

  $scope.ev_clear = (ev) ->
    $scope.drawingArea.clear()
    $scope.clearDownSample()

  $scope.ev_selectList = (ev) ->
    c = lstLetters.options[lstLetters.selectedIndex].text
    $scope.downSampleData = charData[c]
    $scope.displaySample()

  $scope.convertDSData = (data) ->
    newData = []
    for i in [0..data.length - 1]
      if (data[i] == -1) then newData.push(0) else newData.push(1)
    return newData

  $scope.ev_recognize_ann = -> $scope._ev_recognize true
  $scope.ev_recognize_euc = -> $scope._ev_recognize false

  $scope._ev_recognize = (ann) ->
    $('#message').text('thinking...')
    $scope.downSampleData = $scope.drawingArea.performDownSample()
    $scope.displaySample()
#      if (lstLetters.length < 1) {
#        alert("Please teach me something first.");
#      }
    if ($scope.downSampleData == null)
      alert("You must draw something to recognize.")
    else
      if (ann)
        json = {
          message: "Downsample has downsampled"
          input: $scope.convertDSData($scope.downSampleData)
        }
        ws.send(JSON.stringify(json))
      else
        bestChar = '??'
        bestScore = 0
        for c in charData
          data = charData[c]
          sum = 0
          for i in [0..data.length - 1]
            delta = data[i] - $scope.downSampleData[i]
            sum = sum + (delta * delta)
          sum = Math.sqrt(sum)
          if (sum < bestScore || bestChar == '??')
            bestScore = sum
            bestChar = c
        alert('I believe you typed: ' + bestChar)
#      $scope.drawingArea.clear()
#      clearDownSample()

  $scope.clearDownSample = ->
    $scope.downSampleData = ENCOG.ArrayUtil.allocate1D(DOWNSAMPLE_WIDTH * DOWNSAMPLE_HEIGHT)
    ENCOG.ArrayUtil.fillArray($scope.downSampleData, 0, $scope.downSampleData.length, -1)
    $scope.displaySample()

  $scope.preload = ->
    $scope.defineChar("0", new Array(-1, 1, 1, 1, -1, 1, 1, -1, 1, 1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, 1, 1, -1, -1, 1, -1, 1, 1, 1, -1))
    $scope.defineChar("1", new Array(1, 1, 1, -1, -1, 1, 1, 1, -1, -1, 1, 1, 1, -1, -1, 1, 1, 1, 1, -1, -1, 1, 1, 1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, 1, -1, 1, 1, 1, 1))
    $scope.defineChar("2", new Array(1, 1, 1, -1, -1, -1, -1, 1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, 1, 1, 1, 1, -1, 1, -1, 1, 1, -1, 1, 1, 1, 1, 1))
    $scope.defineChar("3", new Array(1, 1, 1, 1, -1, -1, -1, -1, 1, 1, -1, -1, -1, 1, 1, -1, -1, 1, 1, -1, -1, 1, 1, 1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, 1, 1, 1, 1, 1))
    $scope.defineChar("4", new Array(1, -1, -1, 1, -1, 1, -1, -1, 1, -1, 1, -1, -1, 1, -1, 1, 1, 1, 1, 1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1))
    $scope.defineChar("5", new Array(1, 1, 1, 1, 1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, 1, 1, 1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, 1, 1, 1, 1, 1))
    $scope.defineChar("6", new Array(-1, 1, 1, 1, -1, 1, 1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, 1, 1, -1, 1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 1, 1, -1, -1, 1, -1, 1, 1, 1, 1))
    $scope.defineChar("7", new Array(1, 1, 1, 1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, -1, -1, -1))
    $scope.defineChar("8", new Array(1, 1, 1, 1, 1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, 1, 1, 1, 1, 1, -1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 1, -1, -1, -1, 1, 1, 1, 1, 1, 1))
    $scope.defineChar("9", new Array(1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 1, -1, -1, -1, 1, 1, 1, 1, 1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1))

  $scope.defineChar = (charEntered, data) ->
    charData[charEntered] = data
#     lstLetters.add(new Option(charEntered))

  $scope.displaySample = -> $scope.downsampleArea.render()

  $scope.init()

angular.module('isee', ['utils'])