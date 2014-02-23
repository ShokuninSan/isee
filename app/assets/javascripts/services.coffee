'use strict'

define( ->

  angular.module('isee.services', [])

  .service('Voice', ->
    "distracted" : "#{$('#env').data('audio')}/cheer-up_kate.mp3"
    "happy"      : "#{$('#env').data('audio')}/smile_kate.mp3"
    "sad"        : "#{$('#env').data('audio')}/sad_kate.mp3"
    "astonished" : "#{$('#env').data('audio')}/distract_kate.mp3"
    "love"       : "#{$('#env').data('audio')}/love_kate.mp3"
    "death"      : "#{$('#env').data('audio')}/game-over_kate.mp3"
    "skeptical"  : "#{$('#env').data('audio')}/skeptical_kate.mp3"
    "summertime" : "#{$('#env').data('audio')}/summertime_kate.mp3"
    "bigben"     : "#{$('#env').data('audio')}/big-ben_kate.mp3"
    "laughing"   : "#{$('#env').data('audio')}/laughing_kate.mp3")

  .service('Console', ->
    "distracted" : "Cheer up! Everything is gonna be alright!"
    "happy"      : "I love to see you smile"
    "sad"        : "Oh no, why are you sad?"
    "astonished" : "Oops, did I distract you!?"
    "love"       : "I see, I see, you fell in love with me, huh?"
    "death"      : "Oh shit! Game over!"
    "skeptical"  : "No need to be skeptical! I never failed the Turing Test!"
    "summertime" : "I'm looking forward to summertime too! So I can wear sexy microchips for you ;)"
    "bigben"     : "Come on! Are you serious? This is supposed to be Big Ben?"
    "laughing"   : "Come on! Are you laughing at me?")

  .service('Mapping', ->
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
    ])

  .service('Websocket', (Console, Voice, Mapping) ->
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
        $('#output').text(JSON.stringify(parseFloat(d.toFixed(3)) for d in data.result))
        new Audio(Voice[Mapping.symbols[closestIndex]]).play()
      else
        $('#message').text(data.message)
    ws)

)