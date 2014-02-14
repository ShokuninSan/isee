"use strict";

if (window.addEventListener) {
  window.addEventListener('load', function () {

    var DOWNSAMPLE_WIDTH = 5;
    var DOWNSAMPLE_HEIGHT = 8;

    var lstLetters, downsampleArea;
    var charData = {};
    var drawingArea;
    var downSampleData = [];

    function init() {

      // Find the canvas element.
      drawingArea = ENCOG.GUI.Drawing.create('drawing-area', 300, 300);
      downsampleArea = ENCOG.GUI.CellGrid.create('downsample-view', DOWNSAMPLE_WIDTH, DOWNSAMPLE_HEIGHT, 110, 120);

      downsampleArea.outline = true;
      downsampleArea.mouseDown = function (x, y) {
      };

      downsampleArea.determineColor = function (row, col) {
        var index = (row * this.gridWidth) + col;
        if (downSampleData[index] < 0) {
          return "white";
        }
        else {
          return "black";
        }
      };

//      lstLetters = document.getElementById('lstLetters');
//
//      lstLetters.addEventListener('change', ev_selectList, true);

      var btnClear = document.getElementById('btnClear');
//      var btnDownsample = document.getElementById('btnDownsample');
      var btnRecognizeAnn = document.getElementById('btnRecognizeAnn');
//      var btnRecognize = document.getElementById('btnRecognize');
//      var btnTeach = document.getElementById('btnTeach');
//      var btnRemove = document.getElementById('btnRemove');

      btnClear.addEventListener('click', ev_clear, false);
//      btnDownsample.addEventListener('click', ev_downSample, false);
//      btnRecognize.addEventListener('click', ev_recognize_euc, false);
      btnRecognizeAnn.addEventListener('click', ev_recognize_ann, false);
//      btnTeach.addEventListener('click', ev_teach, false);
//      btnRemove.addEventListener('click', ev_remove, false);

      downSampleData = drawingArea.performDownSample();
      displaySample(downSampleData);
      preload();
    }

    /////////////////////////////////////////////////////////////////////////////
    // Event functions
    /////////////////////////////////////////////////////////////////////////////

    // Called when the "Teach" button is clicked.
    function ev_teach(ev) {
      var data = drawingArea.performDownSample();
      displaySample(data);

      if (data == null) {
        alert("You must draw something first.");
      }
      else {
        var charEntered = prompt("What did you just draw?", "");

        if (charEntered) {
          if (charEntered in charData) {
            alert("That character is already defined.");
          }
          else if (charEntered.length != 1) {
            alert("Please enter exactly one character.");
          }
          else {
            drawingArea.clear();
            charData[charEntered] = data;
//            lstLetters.add(new Option(charEntered));
            clearDownSample();
          }
        }
      }
    }

    // Called when the "Remove" button is clicked.
    function ev_remove(ev) {
      for (var i = lstLetters.length - 1; i >= 0; i--) {
        if (lstLetters.options[i].selected) {
          lstLetters.remove(i);
        }
      }
      clearDownSample();
    }

    // Called when the "Downsample" button is clicked
    function ev_downSample(ev) {
      downSampleData = drawingArea.performDownSample();
      displaySample();
    }

    // Called when the "Clear" button is clicked
    function ev_clear(ev) {
      drawingArea.clear();
      clearDownSample();
    }

    // Called when the selected letter changes
    function ev_selectList(ev) {
      var c = lstLetters.options[lstLetters.selectedIndex].text;
      downSampleData = charData[c];
      displaySample();
    }

    function convertDSData(data) {
      var newData = [];
      for (var i = 0; i < data.length; i++) {
        if (data[i] == -1)
          newData.push(0);
        else
          newData.push(1);
      }
      return newData;
    }

    function ev_recognize_ann(ev) { _ev_recognize(ev, true); }
    function ev_recognize_euc(ev) { _ev_recognize(ev, false); }

    // Called when the "Recognize" button is clicked
    function _ev_recognize(ev, ann) {

      $('#message').text('thinking...');
      downSampleData = drawingArea.performDownSample();

      console.log("downSampleData = " + downSampleData);

      displaySample();
//      if (lstLetters.length < 1) {
//        alert("Please teach me something first.");
//      }
      if (downSampleData == null) {
        alert("You must draw something to recognize.");
      }
      else {

        if (ann) {

          var json = {
            message: "Downsample has downsampled",
            input: convertDSData(downSampleData)
          }

          ws.send(JSON.stringify(json));

        } else {
          var bestChar = '??';
          var bestScore = 0;

          console.log("charData = ");
          console.log(charData);
          for (var c in charData) {
            var data = charData[c];

            // Now we will actually recognize the letter drawn.
            // To do this, we will use a Euclidean distance
            // http://www.heatonresearch.com/wiki/Euclidean_Distance

            var sum = 0;
            for (var i = 0; i < data.length; i++) {
              var delta = data[i] - downSampleData[i];
              sum = sum + (delta * delta);
            }

            sum = Math.sqrt(sum);

            // Basically we are calculating the Euclidean distance between
            // what was just drawn, and each of the samples we taught
            // the program.  The smallest Euclidean distance is the char.

            if (sum < bestScore || bestChar == '??') {
              bestScore = sum;
              bestChar = c;
            }

          }

          alert('I believe you typed: ' + bestChar);
        }
      }

//      drawingArea.clear();
//      clearDownSample();
    }

    function clearDownSample() {
      downSampleData = ENCOG.ArrayUtil.allocate1D(DOWNSAMPLE_WIDTH * DOWNSAMPLE_HEIGHT);
      ENCOG.ArrayUtil.fillArray(downSampleData, 0, downSampleData.length, -1);
      displaySample();
    }

    // Preload the digits, so that the user can quickly do some OCR if desired.
    function preload() {
      defineChar("0", new Array(-1, 1, 1, 1, -1, 1, 1, -1, 1, 1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, 1, 1, -1, -1, 1, -1, 1, 1, 1, -1));
      defineChar("1", new Array(1, 1, 1, -1, -1, 1, 1, 1, -1, -1, 1, 1, 1, -1, -1, 1, 1, 1, 1, -1, -1, 1, 1, 1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, 1, -1, 1, 1, 1, 1));
      defineChar("2", new Array(1, 1, 1, -1, -1, -1, -1, 1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, 1, 1, 1, 1, -1, 1, -1, 1, 1, -1, 1, 1, 1, 1, 1));
      defineChar("3", new Array(1, 1, 1, 1, -1, -1, -1, -1, 1, 1, -1, -1, -1, 1, 1, -1, -1, 1, 1, -1, -1, 1, 1, 1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, 1, 1, 1, 1, 1));
      defineChar("4", new Array(1, -1, -1, 1, -1, 1, -1, -1, 1, -1, 1, -1, -1, 1, -1, 1, 1, 1, 1, 1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1));
      defineChar("5", new Array(1, 1, 1, 1, 1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, 1, 1, 1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, 1, 1, 1, 1, 1));
      defineChar("6", new Array(-1, 1, 1, 1, -1, 1, 1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, 1, 1, -1, 1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 1, 1, -1, -1, 1, -1, 1, 1, 1, 1));
      defineChar("7", new Array(1, 1, 1, 1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, -1, -1, -1));
      defineChar("8", new Array(1, 1, 1, 1, 1, 1, -1, -1, -1, 1, 1, -1, -1, -1, 1, 1, 1, 1, 1, 1, -1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 1, -1, -1, -1, 1, 1, 1, 1, 1, 1));
      defineChar("9", new Array(1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 1, -1, -1, -1, 1, 1, 1, 1, 1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1));
    }

    // Define a character, add it to the list and to the map.
    function defineChar(charEntered, data) {
      charData[charEntered] = data;
//      lstLetters.add(new Option(charEntered));
    }

    // Display downsampled data to the grid.
    function displaySample() {
      downsampleArea.render();
    }

    // cause the init function to be called.
    init();

  }, false);
}
