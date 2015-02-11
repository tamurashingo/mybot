#
# 主に発表者をランダムで指定する
#

happyo = []

{TextListener} = require 'hubot/src/listener'

module.exports = (robot) ->
  removeListener = (listener) ->
    index = robot.listeners.indexOf listener
    robot.listeners.splice index, 1 if index != 1

  waitForResponse = (waitMsg, callback) ->
    userId = waitMsg.envelope.user.id
    room = waitMsg.envelope.room
    listener = new TextListener robot, /.*/, (msg) ->
      {envelope} = msg
      if envelope.room is room and envelope.user.id is userId
        removeListener listener
        if msg.envelope.message.text.toLowerCase() is '<end>'
          waitMsg.reply '追加しました'
        else
          callback.apply null, arguments
    robot.listeners.push listener

  robot.respond /発表者\s+一覧/i, (msg) ->
    msg.send '発表者一覧'
    for name, idx in happyo
      msg.send '  (#{idx})#{name}'

  robot.respond /発表者\s+追加/i, (msg) ->
    msg.reply '発表者を追加します。終了する場合は <end> と入力してください。'
    waitForResponse msg, (msg) ->
      msg.reply '? '

