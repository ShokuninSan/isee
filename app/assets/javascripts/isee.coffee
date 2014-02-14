'use strict'

if window.addEventListener
  window.addEventListener 'load', ->
    DOWNSAMPLE_WIDTH = 5
    DOWNSAMPLE_HEIGHT = 8
    downsampleArea = drawingArea = undefined
    charData = []
    init = ->
      drawingArea = ENCOG.GUI.Drawing.create('drawing-area', 300, 300)
      downsampleArea = ENCOG.GUI.CellGrid.create('downsample-view', DOWNSAMPLE_WIDTH, DOWNSAMPLE_HEIGHT, 110, 120)
      downsampleArea.outline = true
      downsampleArea.mouseDown = (x, y) ->
      downsampleArea.determineColor = (row, col) ->
        index = (row * this.gridWidth) + col
        if (downSampleData[index] < 0) then "white" else "black"
#     lstLetters = document.getElementById('lstLetters')
#     lstLetters.addEventListener('change', ev_selectList, true)
      btnClear = document.getElementById('btnClear')
#     btnDownsample = document.getElementById('btnDownsample')
      btnRecognizeAnn = document.getElementById('btnRecognizeAnn')
#     btnRecognize = document.getElementById('btnRecognize')
#     btnTeach = document.getElementById('btnTeach')
#     btnRemove = document.getElementById('btnRemove')
      btnClear.addEventListener('click', ev_clear, false)
#     btnDownsample.addEventListener('click', ev_downSample, false)
#     btnRecognize.addEventListener('click', ev_recognize_euc, false)
      btnRecognizeAnn.addEventListener('click', ev_recognize_ann, false)
#     btnTeach.addEventListener('click', ev_teach, false)
#     btnRemove.addEventListener('click', ev_remove, false)
      downSampleData = drawingArea.performDownSample()
      displaySample(downSampleData)
      preload()

    ev_teach = (ev) ->
      data = drawingArea.performDownSample()
      displaySample data

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
            drawingArea.clear()
            charData[charEntered] = data
#           lstLetters.add(new Option(charEntered))
            clearDownSample()

    ev_remove = (ev) ->
      for i  in [lstLetters.length - 1..0]
        if (lstLetters.options[i].selected)
          lstLetters.remove(i)
      clearDownSample()

    ev_downSample = (ev) ->
      downSampleData = drawingArea.performDownSample()
      displaySample()

    ev_clear = (ev) ->
      drawingArea.clear()
      clearDownSample()

    ev_selectList = (ev) ->
      c = lstLetters.options[lstLetters.selectedIndex].text
      downSampleData = charData[c]
      displaySample()

    convertDSData = (data) ->
      newData = []
      for i in [0..data.length - 1]
        if (data[i] == -1) then newData.push(0) else newData.push(1)
      return newData

    ev_recognize_ann = (ev) -> _ev_recognize(ev, true)
    ev_recognize_euc = (ev) -> _ev_recognize(ev, false)

    _ev_recognize = (ev, ann) ->

      $('#message').text('thinking...')
      downSampleData = drawingArea.performDownSample()

      console.log("downSampleData = " + downSampleData)

      displaySample()
#      if (lstLetters.length < 1) {
#        alert("Please teach me something first.");
#      }
      if (downSampleData == null)
        alert("You must draw something to recognize.")
      else
        if (ann)
          json = {
            message: "Downsample has downsampled"
            input: convertDSData(downSampleData)
          }
          ws.send(JSON.stringify(json))
        else
          bestChar = '??'
          bestScore = 0
          for c in charData
            data = charData[c]
            # Now we will actually recognize the letter drawn.
            # To do this, we will use a Euclidean distance
            # http://www.heatonresearch.com/wiki/Euclidean_Distance
            sum = 0
            for i in [0..data.length - 1]
              delta = data[i] - downSampleData[i]
              sum = sum + (delta * delta)
            sum = Math.sqrt(sum)
            # Basically we are calculating the Euclidean distance between
            # what was just drawn, and each of the samples we taught
            # the program.  The smallest Euclidean distance is the char.
            if (sum < bestScore || bestChar == '??')
              bestScore = sum
              bestChar = c
          alert('I believe you typed: ' + bestChar)
#      drawingArea.clear()
#      clearDownSample()

    clearDownSample = ->
      downSampleData = ENCOG.ArrayUtil.allocate1D(DOWNSAMPLE_WIDTH * DOWNSAMPLE_HEIGHT)
      ENCOG.ArrayUtil.fillArray(downSampleData, 0, downSampleData.length, -1)
      displaySample()

    preload = () ->
      defineChar("0", new Array(-1, 1, 1, 1, -1, 1, 1, -1, 1, 1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, 1, 1, -1, -1, 1, -1, 1, 1, 1, -1))
      defineChar("1", new Array(1, 1, 1, -1, -1, 1, 1, 1, -1, -1, 1, 1, 1, -1, -1, 1, 1, 1, 1, -1, -1, 1, 1, 1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, 1, -1, 1, 1, 1, 1))
      defineChar("2", new Array(1, 1, 1, -1, -1, -1, -1, 1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, 1, 1, 1, 1, -1, 1, -1, 1, 1, -1, 1, 1, 1, 1, 1))
      defineChar("3", new Array(1, 1, 1, 1, -1, -1, -1, -1, 1, 1, -1, -1, -1, 1, 1, -1, -1, 1, 1, -1, -1, 1, 1, 1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, 1, 1, 1, 1, 1))
      defineChar("4", new Array(1, -1, -1, 1, -1, 1, -1, -1, 1, -1, 1, -1, -1, 1, -1, 1, 1, 1, 1, 1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1))
      defineChar("5", new Array(1, 1, 1, 1, 1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, 1, 1, 1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, 1, 1, 1, 1, 1))
      defineChar("6", new Array(-1, 1, 1, 1, -1, 1, 1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, 1, 1, -1, 1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 1, 1, -1, -1, 1, -1, 1, 1, 1, 1))
      defineChar("7", new Array(1, 1, 1, 1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, -1, -1, -1))
      defineChar("8", new Array(1, 1, 1, 1, 1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, 1, 1, 1, 1, 1, -1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 1, -1, -1, -1, 1, 1, 1, 1, 1, 1))
      defineChar("9", new Array(1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 1, -1, -1, -1, 1, 1, 1, 1, 1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1))

    defineChar = (charEntered, data) ->
      charData[charEntered] = data
#     lstLetters.add(new Option(charEntered))

    displaySample = -> downsampleArea.render()

    init()

  , false
