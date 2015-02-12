# 主に発表者をランダムで指定する
# Description:
# 発表者のリストを作成し、その中からランダムで発表者を選ぶ.
#
# Commands:
# presenter show - リストに登録されている発表者を表示する
# presenter add - 発表者をリストに登録する
# presenter del <num>- リストの<num>番目に登録している発表者をリストから削除する
# presenter select - 発表者を選ぶ
# presenter clear - リストを空にする
#

presenterList = []

{TextListener} = require 'hubot/src/listener'

module.exports = (robot) ->
  removeListener = (listener) ->
    index = robot.listeners.indexOf listener
    robot.listeners.splice index, 1 if index != 1

  waitForAnswer = (waitMsg, callback) ->
    userId = waitMsg.envelope.user.id
    room = waitMsg.envelope.room
    listener = new TextListener robot, /.*/, (msg) ->
      {envelope} = msg
      if envelope.room is room and envelope.user.id is userId
        callback.apply null, arguments
        removeListener listener
    robot.listeners.push listener

  waitForResponse = (waitMsg, callback) ->
    userId = waitMsg.envelope.user.id
    room = waitMsg.envelope.room
    listener = new TextListener robot, /.*/, (msg) ->
      {envelope} = msg
      if envelope.room is room and envelope.user.id is userId
        if msg.envelope.message.text.toLowerCase() is '<end>'
          removeListener listener
        else
          callback.apply null, arguments
    robot.listeners.push listener

  robot.respond /presenter\s+show/i, (msg) ->
    msg.send '発表者リスト'
    for name, idx in presenterList
      msg.send " #{idx + 1}:#{name} さん"

  robot.respond /presenter\s+add/i, (msg) ->
    msg.reply '発表者をリストに追加します。終了する場合は <end> と入力してください。'
    waitForResponse msg, (msg) ->
      presenter = msg.envelope.message.text
      presenterList.push(presenter)
      msg.reply "'#{presenter}' さんをリストに追加しました。"
      msg.reply '続けて発表者をリストに追加します。終了する場合は <end> と入力してください。'

  robot.respond /presenter\s+del\s+([0-9]+)/i, (msg) ->
    idx = parseInt(msg.match[1]) - 1
    presenter = presenterList[idx]
    presenterList.splice idx, 1
    msg.reply "'#{presenter}' さんをリストから削除しました。"

  robot.respond /presenter\s+select/i, (msg) ->
    if presenterList.length == 0
      msg.reply "リストが空です"
    else
      idx = Math.floor(Math.random() * presenterList.length)
      presenter = presenterList[idx]
      presenterList.splice idx, 1
      msg.reply "'#{presenter}'さん、お願いします！"

  robot.respond /presenter\s+clear/i, (msg) ->
    msg.reply "リストをクリアしますか？(Y/n)"
    waitForAnswer msg, (msg) ->
      ans = msg.envelope.message.text
      if ans is "Y"
        presenterList = []
        msg.reply "リストをクリアしました"
      else if ans is "y"
        msg.reply "Y を入力してください"


