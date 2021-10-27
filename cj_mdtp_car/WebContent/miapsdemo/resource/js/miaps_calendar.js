var miaps_calendar = {
  /**
   * @param {HTMLElement} selector html엘리먼트 input / button
   * @param {string} defDate 기본값 ex)2019.10.01
   * @param {string} beginDate 선택가능 시작일 빈값이면 1900.01.01
   * @param {string} endDate 선태가능 종료일 빈값이면 9999.12.31
   * @param {function} callback
   * @returns {HTMLElement} 액션 시트 블록을 감싸는 HTML 개체. 이 개체에 setContent, show, hide 함수가 붙어 있다.
   */
  showCalender: function (selector, defDate, beginDate, endDate, callback) {

    var _obj = $(selector)

    if (_obj[0] && _obj[0].tagName === 'INPUT') {
      beginDate = beginDate || _obj.attr('min')
      endDate = endDate || _obj.attr('max')
      defDate = defDate || _obj.val()
    }

    beginDate = beginDate || '1900.01.01'
    endDate = endDate || '9999.12.31'

    // 달력 기본정보
    var today = new Date()
    var weekLength = 7
    var disLength = 42
    //var koDay = ['일','월','화','수','목','금','토']
    //var enDay = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat']
    var monthLen = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

    var defYear, defMonth
    if (defDate && defDate !== '') {
      var tmpDate = defDate.replace(/[.-]/gi, "")
      defYear = tmpDate.substr(0, 4)
      defMonth = tmpDate.substr(4, 2)
    } else {
      defYear = today.getFullYear()
      defMonth = (today.getMonth() + 1 > 9 ? (today.getMonth() + 1 + '') : ("0"
          + (today.getMonth() + 1)))

      defDate = defYear + '.' + defMonth + '.' + (today.getDate() > 9
          ? today.getDate() : '0' + today.getDate())
    }

    var calender
    var resultHtml = $.ajax({
      type: "GET",
      url: "/miapsdemo/resource/js/calendar_template.html",
      async: false
    }).responseText
    var _layerTemp = Template7.compile(resultHtml)

    var _html = _layerTemp({year: defYear, month: defMonth})
    var calender, $calender = $(_html)

    $calender.find('.btn-close span').text('Close') // 닫기

    var calender = $calender[0]
    if ($calender.parent().length === 0) {
      $calender.appendTo(document.body)
    }

    calender.show = function () {
      asFn.disableScroll()

      var el = this

      asFn.showActionSheet(el)
    }

    calender.hide = function () {
      asFn.enableScroll()

      var el = this
      asFn.hideActionSheet(el)

    }

    var yearEl = $calender.find('.calendar-year .txt-current')
    var monthEl = $calender.find('.calendar-month .txt-current')

    $calender.find('.btn-close').on('click', function () {
      $(this).closest('.bottom-sheet')[0].hide()
    })

    $calender.find('.btn-xs-line.round').off('click').on('click', function (e) {

      var years = today.getFullYear()
      var month = (today.getMonth() + 1 > 9 ? (today.getMonth() + 1 + '') : ("0"
          + (today.getMonth() + 1)))
      var date = (today.getDate() > 9 ? today.getDate() : '0' + today.getDate())

      yearEl.attr('data-value', years).text(years + '년')
      monthEl.attr('data-value', month).text(month + '월')

      calender.setCalender(
          years + '.' + (+month > 9 ? month : '0' + (+month)) + '.' + date)
    })

    $calender.find('.calendar-year .btn-prev,.calendar-year .btn-next').off(
        'click').on('click', function (e) {
      var years = yearEl.attr('data-value')
      var month = monthEl.attr('data-value')

      var numYear
      if ($(this).hasClass('btn-prev')) {
        numYear = parseInt(years) - 1
      } else {
        numYear = parseInt(years) + 1
      }

      yearEl.attr('data-value', numYear).text(numYear + '년')

      calender.setCalender(
          numYear + '.' + (+month > 9 ? month : '0' + (+month)) + '.01')
    })

    $calender.find('.calendar-month .btn-prev,.calendar-month .btn-next').off(
        'click').on('click', function (e) {

      var month = monthEl.attr('data-value')
      var years = yearEl.attr('data-value')

      var numMonth, numYear = +years
      if ($(this).hasClass('btn-prev')) {
        numMonth = parseInt(month) - 1
        if (numMonth === 0) {
          numMonth = 12
          numYear = numYear - 1
        }
      } else {
        numMonth = parseInt(month) + 1
        if (numMonth === 13) {
          numMonth = 1
          numYear = numYear + 1
        }
      }

      yearEl.attr('data-value', numYear).text(numYear + '년')
      monthEl.attr('data-value', numMonth).text(numMonth + '월')
      var years = yearEl.attr('data-value')

      calender.setCalender(
          years + '.' + (numMonth > 9 ? numMonth : '0' + numMonth) + '.01')
    })

    calender.setCalender = function (dt) {
      console.log("date ", dt)
      var converDt = dt.replace(/[.-]/gi, "-")

      var itemTemplet = ''
          + '{{#each this}}'
          + '{{#js_if "@index == 0 || @index % 7 == 0"}}'
          + '<tr>'
          + '{{/js_if}}'
          + ' <td role="gridcell">'
          + '   <button data-value="{{strDate}}" aria-selected="{{selected}}" {{#if disabled}}disabled{{/if}}>'
          + '     {{disDate}}'
          + '   </button>'
          + ' </td>'
          + '{{#js_if "@index != 0 && @index+1 % 7 == 0"}}'
          + '</tr>'
          + '{{/js_if}}'
          + ' {{/each}}'

      /** 달력정보 생성 시작 */

      var dtDay = new Date(converDt)
      var year = dtDay.getFullYear()
      var month = dtDay.getMonth()

      /** 윤달 체크 */
      if (((year % 4) === 0 && (year % 100) !== 0) || (year % 400) === 0) {
        monthLen[2] = 29
      } else {
        monthLen[2] = 28
      }

      var firstDay = new Date(year, (month), 1)
      var firstIdx = firstDay.getDay()

      var bmLastDay = new Date(year, (month), 0)
      var nmFirstDay = new Date(year, (month + 1), 1)

      var calArray = []
      var strDate = ''
      var disDate = ''
      for (var i = (firstIdx - 1); i >= 0; i--) {
        disDate = (bmLastDay.getDate() - i > 9 ? bmLastDay.getDate() - i : ("0"
            + (bmLastDay.getDate() - i)))
        strDate = bmLastDay.getFullYear() + '.'
            + (bmLastDay.getMonth() + 1 > 9 ? bmLastDay.getMonth() + 1 : ("0"
                + (bmLastDay.getMonth() + 1))) + '.'
            + disDate

        calArray.push({
          disabled: true,
          strDate: strDate,
          disDate: +disDate,
          selected: (dt === strDate ? true : false)
        })
      }
      for (var i = 1; i <= monthLen[month]; i++) {
        disDate = (i > 9 ? i : ('0' + i))
        strDate = year + '.'
            + ((month + 1) > 9 ? (month + 1) : ('0' + (month + 1))) + '.'
            + disDate

        calArray.push({
          disabled: ((!(beginDate <= strDate && endDate >= strDate))),
          strDate: strDate,
          disDate: +disDate,
          selected: (dt === strDate)
        })
      }
      var compLength = calArray.length
      for (var i = 0; i < (disLength - compLength); i++) {
        disDate = (nmFirstDay.getDate() + i > 9 ? nmFirstDay.getDate() + i
            : ("0" + (nmFirstDay.getDate() + i)))
        strDate = nmFirstDay.getFullYear() + '.'
            + (nmFirstDay.getMonth() + 1 > 9 ? nmFirstDay.getMonth() + 1 : ("0"
                + (nmFirstDay.getMonth() + 1))) + '.'
            + disDate

        calArray.push({
          disabled: true,
          strDate: strDate,
          disDate: +disDate,
          selected: (dt === strDate)
        })
      }

      _layerTemp = Template7.compile(itemTemplet)
      var _html = _layerTemp(calArray)
      $calender.find('table tbody').html(_html)
      /** 달력정보 생성 종료 */

      $calender.find('table tbody tr td button').off('click').on('click',
          function (e) {
            calender.hide()
            var selValue = $(this).data('value')
            if (_obj[0] && _obj[0].tagName === 'INPUT') {
              $(_obj[0]).val(selValue)
            }
            if (callback) {
              callback({
                ymd: selValue,
                year: selValue.split('.')[0],
                month: selValue.split('.')[1],
                date: selValue.split('.')[2]
              })
            }

          })
    }

    calender.setCalender(defDate)
    calender.show()

    return calender
  }
}
