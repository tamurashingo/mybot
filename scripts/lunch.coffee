client = require('cheerio-httpcli')
url = 'http://www.teraken.co.jp/menu/lunch/'

module.exports = (robot) ->
  robot.respond /hiru/i, (msg) ->
    client.fetch url, {}, (err, $, res) ->
      today = (->
        dt = new Date
        return (dt.getMonth() + 1) + '/' + dt.getDate())()
      week = ['日', '月', '火', '水', '木', '金', '土'][(new Date).getDay()]
      flag = false
      $menu = []

      $('table.menu-table > tbody > tr').each (idx) ->
        if today == $(this).children('.day').text()
          $menu = [$(this).children(':not(.day,.week)')[0].children[0].data,
                   $(this).children(':not(.day,.week)')[0].children[2].data]
          flag = true

      $menu = ['さば味噌煮定食', '刺身定食'] if !flag
      msg.send today + '(' + week + ')のおすすめは「' + $menu[0] + '」または「' + $menu[1] + '」です'


