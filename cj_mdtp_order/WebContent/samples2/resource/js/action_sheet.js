(function (global, $) {
  'use strict'

  /**
   * action sheet Function
   * @namespace
   * @exports
   */
  var asFn = global.asFn = {
    /**
     * Create Transparent Dimmed
     * ***
     * @return {void}
     */
    dimmedOpen: function () {
      var dimmed =
          '<div class="dimmed white" style="display:block">'
          + '<span style="position: absolute;top:30%;right:0;">'
          + 'Develop Test'
          + '</span>'
          + '</div>'
      if ($('body').find('.dimmed.white').length < 1) {
        $('.mh-container').append(dimmed)
      } else {
        $('.dimmed.white').show()
      }

      $('body, html').addClass('open-pop')
    },

    /**
     * Remove Transparent Dimmed
     * ***
     * @return {void}
     */
    dimmedClose: function () {
      $('.dimmed.white').hide()
      $('body, html').removeClass('open-pop')
    },

    /**
     * Disable Body Scroll(.mh-container)
     * ***
     * @return {void}
     */
    disableScroll: function () {
      var documentScroll = $(document).scrollTop()
      var s_body = $('body')
      if (s_body.find('.layer.on').length === 1 || s_body.find(
          '.popup.on').length === 1) {
        $('.mh-container').css({
          'position': 'fixed',
          'top': -documentScroll,
          'left': 0,
          'width': '100%'
        })
      }
    },

    /**
     * Enable Body Scroll(.mh-container)
     * ***
     * @return {void}
     */
    enableScroll: function () {
      var scrollPosition = Math.abs($('.mh-container').css('top').split('px')[0])
      $('body, html').removeClass('open-pop').find('.mh-container').removeAttr(
          'style')
      $(document).scrollTop(scrollPosition)
    },

    /**
     * Show ActionSheet
     * ***
     * - ActionSheet show from bottom to top using TweenMax
     * @param {HTMLElement} el HTMLElements made of dom function
     * @return {void}
     */
    showActionSheet: function (el) {

      // init dimmed
      var s_dimmed = $('.dimmed')
      var $dimmed = s_dimmed.length ? s_dimmed : $(
          '<div class="dimmed" style="display:block"></div>').appendTo(
          $('.mh-container'))

      $(el).addClass('on').show()
      if ($(el).find('.bottom-sheet-inner').outerHeight() > $(
          window).outerHeight() * 75 / 100) {
        if ($(el).find('.bottom-btn-set').length > 0) {
          $(el).find('.bottom-sheet-inner').css('height',
              $(window).outerHeight() * 75 / 100 - $(el).find(
              '.bottom-btn-set').outerHeight())
        } else {
          $(el).find('.bottom-sheet-inner').css('height',
              $(window).outerHeight() * 75 / 100)
        }
      }
      if ($(el).find('.bottom-btn-set').length > 0) {
        $(el).css('height',
            $(el).find('.bottom-sheet-inner').outerHeight() + $(el).find(
            '.bottom-btn-set').outerHeight())
      } else {
        $(el).css('height', $(el).find('.bottom-sheet-inner').outerHeight())
      }

      var popHeight = $(el).outerHeight()
      // TweenMax.fromTo(element, second, goal position, from position)
      TweenMax.fromTo(el, 1, {y: popHeight + 'px'},
          {y: 0, ease: Quart.easeOut})

      if ($(el).find('.layer-header').length > 0) {
        $(el).find('.layer-header').attr('tabindex', '-1').trigger(
            'click').focus()
      } else {
        $(el).find('.layer-contents').attr('tabindex', '-1').trigger(
            'click').focus()
      }
      asFn.disableScroll()
    },

    /**
     * Hide ActionSheet
     * ***
     * - Hide to bottom after the required action is completed in ActionSheet
     * - Remove the HTMLElements generated in the ActionSheet and make them hide
     * @param {HTMLElement} el HTMLElements generated above the ActionSheet
     * @return {void}
     */
    hideActionSheet: function (el) {

      var popHeight = $(el).outerHeight()
      $(el).removeClass('on')

      if ($('body').find('.layer.on').length < 1) {
        asFn.enableScroll()
      }

      TweenMax.to(el, 0.5, {
        y: popHeight + 'px', ease: Quart.easeIn, onComplete: function () {
          $(el).hide()
        }
      })
      if ($('.layer.on').not('.depth2').length === 0) {
        $('.dimmed').remove()
      }
    },

    /**
     * Dynamically create and return DOM objects
     * ***
     * @param {any} parent Parent Object or Selector. If null, the DOM is not attached yet and the object does not appear on the screen
     * @param {string} tag
     * @param {object} attrs
     * @param {string} text Text to be placed inside the object
     * @returns {HTMLElement} el
     */
    dom: function (parent, tag, attrs, text) {
      var el = document.createElement(tag)
      if (attrs) {
        for (var key in attrs) {
          var val = attrs[key]
          if (typeof val === 'object') {
            var x = el[key]
            for (var k in val) {
              x[k] = val[k]
            }
          } else {
            el[key] = val
          }
        }
      }

      if (text) {
        el.appendChild(document.createTextNode(text))
      }

      if (typeof parent === 'string') {
        parent = document.querySelector(parent)
      }
      if (parent) {
        parent.append(el)
      }

      return el
    },

    /**
     * Create ActionSheet
     * ***
     * - ActionSheet is item selection UI that rise from the bottom of the screen
     * - This function is not called directly and requires a "asFn.attachActionSheet()" call
     * - If actionSheet is already attached to the select, update it without creating a new one
     * - ActionSheet has setContent, show, and hide functions
     * - Within all callback functions, "this" is the object returned by 'actionSheet'
     * ***
     * <strong>Options Reference</strong>
     * - title: Title Text
     * - close: Add Close Button
     * - search: Add Search Button and Function to execute
     * - no: Add No Button and Function to execute
     * - yes: Add Yes Button and Function to execute
     * - ok: Add Confirm Button and Function to execute
     * @param {array} content One of the following: html, dom, or select that representing the body area
     * @param {object} options See Reference
     * @returns {HTMLElement} actionSheet HTMLElements that Surrounding ActionSheet Block
     */
    actionSheet: function (content, options) {
      if (!options || typeof options === 'string') {
        options = {title: options}
      }

      var title = options.title
      var hasButtons = options.no || options.yes || options.ok

      var $items = $(content)
      // Check Contents 'Select'
      var select = $items.length === 1 && $items.prop('tagName') === 'SELECT'
          && $items[0]
      var $actionSheet

      // Make actionSheet layer start
      var actionSheet
      if (select && select._actionSheet) {
        $actionSheet = $(select._actionSheet)
        actionSheet = $actionSheet[0]
      } else {
        // make actionSheet Start
        var html =
            '<div class="layer bottom-sheet'
            + (hasButtons ? ' has_bottom_btn">' : '">')
            + '<div class="bottom-sheet-inner"'
            + (title ? '' : ' style="padding-top: 45px"') + '>'

        // top button setting
        if (title) {
          html += '<div class="layer-header"><h1></h1>'
          if (options.search) {
            // TODO: svg icon change
            html +=
                '<button type="button" class="btn-search">'
                + '<svg class="bi bi-search" width="1em" height="1em" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">\n'
                + '<path fill-rule="evenodd" d="M10.442 10.442a1 1 0 011.415 0l3.85 3.85a1 1 0 01-1.414 1.415l-3.85-3.85a1 1 0 010-1.415z" clip-rule="evenodd"/>\n'
                + '<path fill-rule="evenodd" d="M6.5 12a5.5 5.5 0 100-11 5.5 5.5 0 000 11zM13 6.5a6.5 6.5 0 11-13 0 6.5 6.5 0 0113 0z" clip-rule="evenodd"/>\n'
                + '</svg>'
                + '<span class="sr-only">'
                + '</span>'
                + '</button>'
          }
          if (options.close) {
            html +=
                '<button type="button" class="btn-close">'
                + '<i class="ico-close"></i>'
                + '<span class="sr-only"></span>'
                + '</button>'
          }
          html += '</div>'
        }

        html +=
            '<div class="layer-contents"'
            + (title ? '' : ' style="height:100%;"') + '></div>'
            + '<span class="pop-handle"></span></div>'

        // bottom button setting
        if (hasButtons) {
          html += '<div class="bottom-btn-set">'
          if (options.no) {
            html +=
                '<span class="neg">'
                + '<button type="button" class="btn-lg-secondary"></button>'
                + '</span>'
          }
          if (options.yes || options.ok) {
            html +=
                '<span>'
                + '<button type="button" class="btn-lg-primary"></button>'
                + '</span>'
          }
          html += '</div>'
        }

        html += '</div>'
        // make actionSheet End
        $actionSheet = $(html)

        actionSheet = $actionSheet[0]
        if (select) {
          select._actionSheet = actionSheet
        }

        // Control's Text and Callback Setting(Button Click Event Setting)
        if (title) {
          $actionSheet.find('.layer-header h1').text(title)
          if (options.search) {
            $actionSheet.find('.btn-search').click(function (e) {
              options.search.call(actionSheet, e)
            }).find('span').text(title + ' ' + 'Search')
          } // Search Option
          if (options.close) {
            $actionSheet.find('.btn-close').click(function (e) {
              options.close.call(actionSheet, e)
            }).find('span').text(title + ' ' + 'Close')
          } // Close Option
        }
        if (options.no) {
          $actionSheet.find('span.neg button').click(function (e) {
            options.no.call(actionSheet, e)
          }).text('No')
        } // No Option
        if (options.yes || options.ok) {
          $actionSheet.find('span button.btn-lg-primary')
          .click(function (e) {
            // If Button Clicked, Display Transparent Dimmed and Close
            asFn.dimmedOpen()
            setTimeout(function () {
              asFn.dimmedClose()
            }, 500);

            (options.yes || options.ok).call(actionSheet, e)
          }).text(options.yes ? 'Yes' : 'Confirm')
        } // Confirm Option

        $actionSheet.find('.btn-search, .btn-close, .btn-lg-secondary').on(
            'click', function () {
              $(this).closest('.bottom-sheet')[0].hide()
            })

        $actionSheet.click(function (e) {
          if (!$(this).find('.bottom-sheet-inner').is(e.target)
              && $(this).find('.bottom-sheet-inner').has(e.target).length === 0
              && !$(this).find('.bottom-btn-set').is(e.target)
              && $(this).find('.bottom-btn-set').has(e.target).length === 0) {
            this.hide()
          }
        })
        // Button Click Event Setting End
      }
      // Make actionSheet layer End

      /**
       * Set Contents area in ActionSheet
       * - If Content is HTML Select, Use select's option for select elements
       * - If actionSheet is already attached to the select, update it without creating a new one
       * @param content content One of the following: html, dom, or select that representing the body area
       */
      actionSheet.setContent = function (content) {
        var $items = $(content)
        var select =
            $items.length === 1 && $items.prop('tagName') === 'SELECT'
            && $items[0]

        if (select) {
          if (hasButtons) {
            content = ['<ul class="pd-h15 select-list">']
          } else {
            content = ['<ul class="pd-h15 select-list chk-none">']
          }

          // set select type
          var type = select.multiple ? 'checkbox' : 'radio'
          // set name random id(ex -> __[select.name/id][random 6 number]_)
          var name = '__' + (select.name || select.id)
              + Math.floor(Math.random() * 100000) + '_'
          var options = select.options

          // set actionSheet content list(checkbox or radio)
          for (var i = 0, count = options.length; i < count; ++i) {
            content.push(
                '<li><span class="form-check"><input type="'
                + type + '" id="' + name + i
                + '" name="' + name + '" value="' + options[i].value + '" '
                + (options[i].selected ? 'checked' : '')
                + '><label for="' + name + i + '"><span class="select-name">'
                + options[i].text.replace(/</g, '&lt;')
                + '</span></label></span></li>')
          }
          content = content.join('') + '</ul>'

          $(this).find('.layer-contents').html(content)
        } else {
          $(this).find('.layer-contents').empty().append($items)
        }
      }

      /**
       * If there is a value passed to param, select the item and call the callback function.
       * @param {string} selItem Selected item
       */
      actionSheet.get = function (selItem) {
        var type = select.multiple ? 'checkbox' : 'radio'

        var items = $(this).find('.select-list input[type=' + type + ']')
        if (!items) {
          return
        }
        var t, f = false
        $.each(items, function (idx, elem) {
          var parseData
          if ($(elem).data('result-object')) {
            parseData = $(elem).data('result-object')
          } else {
            parseData = $(elem).val()
          }
          if (idx === 0) {
            t = parseData
          }
          if ((!selItem && idx === 0) || (typeof (parseData) == 'object'
              && (selItem === parseData.ACT_NO || selItem
                  === parseData.DIS_ACT_NO_R)) || selItem === parseData) {
            $(this).prop('checked', true)
            if (options.yes || options.ok) {
              (options.yes || options.ok).call(actionSheet, parseData)
            }
            f = true
            return false
          }
        })
        if (!f) {
          $(items[0]).prop('checked', true)
          if (options.yes || options.ok) {
            (options.yes || options.ok).call(actionSheet, t)
          }
        }
      }

      /**
       * If there is a value passed by param, select the item and return the value.
       * @param {string} selItem Selected item
       * @return {string} parseData
       */
      actionSheet.selectItem = function (selItem) {
        var type = select.multiple ? 'checkbox' : 'radio'
        var parseData = ""
        var items = $(this).find('.select-list input[type=' + type + ']')
        if (!items) {
          return
        }
        var t, f = false
        $.each(items, function (idx, elem) {

          parseData = $(elem).val()

          if (idx === 0) {
            t = parseData
          }
          if ((!selItem && idx === 0) || selItem === parseData) {
            $(this).prop('checked', true)
            f = true
            return false
          }
        })
        if (!f) {
          $(items[0]).prop('checked', true)
          parseData = $(items[0]).val()
        }
        return parseData
      }

      /**
       * Event function that ActionSheet to appear
       * ***
       * @return {void}
       */
      actionSheet.show = function () {
        asFn.disableScroll()

        var el = this
        asFn.showActionSheet(el)
      }

      /**
       * Event function that ActionSheet to hide
       * ***
       * @return {void}
       */
      actionSheet.hide = function () {
        asFn.enableScroll()

        var el = this
        asFn.hideActionSheet(el)
      }

      if ($actionSheet.parent().length === 0) {
        $actionSheet.appendTo($('.mh-container'))
      }

      if (content) {
        actionSheet.setContent(content)
      }

      return actionSheet
    },

    /**
     * Attach ActionSheet
     * ***
     * - Create and paste an action sheet that allows you to select items on behalf of the HTML select object.
     * - The button is inserted instead of the select object, and the action sheet is displayed when the user presses the button.
     * - If actionSheet is already attached to the select, update it without creating a new one
     * ***
     * <strong>Options Reference</strong>
     * - title: Title Text
     * - close: Add Close Button
     * - search: Add Search Button and Function to execute
     * - no: Add No Button and Function to execute
     * - yes: Add Yes Button and Function to execute
     * - ok: Add Confirm Button and Function to execute
     * @param {array} content One of the following: html, dom, or select that representing the body area
     * @param {object} options See Reference
     * @returns {HTMLElement} actionSheet HTMLElements that Surrounding ActionSheet Block
     */
    attachActionSheet: function (content, options) {
      if (!options || typeof options === 'string') {
        options = {title: options}
      }

      var title = options.title
      var sheet = asFn.actionSheet(content, options)

      var updateSelect = function () {
        // Select Change Event
        asFn.dimmedOpen()
        setTimeout(function () {
          asFn.dimmedClose()
        }, 500)

        var text = []
        var selected = []
        $('.select-list input:checked', sheet).each(function (idx, el) {
          selected.push(el.value)
        })
        $('option', sheet._select).each(function () {
          if (selected.indexOf(this.value) >= 0) {
            this.selected = true
            text.push(this.text)
          } else {
            this.selected = false
          }
        })

        if (sheet._span) {
          $(sheet._span).text(text.join(', '))
        } else {
          $(sheet._btn).text(text.join(', '))
        }

        $(sheet._select).trigger('change')

        if (!$(content).prop('multiple') || options.autoClose) {
          sheet.hide()
        }
      }

      if (options.ok) {
        var oldOk = options.ok
        options.ok = function (e) {
          updateSelect()
          oldOk.call(sheet, e)
        }
      } else {
        $(sheet).find('.select-list input').click(updateSelect)
      }

      sheet._select = content
      if (!sheet._btn) {
        sheet._btn = asFn.dom(null, 'button', {
          title: title || '',
          type: 'button',
          onclick: function () {
            sheet.show()
            $(sheet).find('.layer-header').focus()
          }
        })
      }
      sheet.oldHide = sheet.hide
      sheet.hide = function () {
        sheet.oldHide()
        setTimeout(function () {
          sheet._btn.focus()
        })
      }

      // Combine selections into text
      var text = []
      $('option:selected', content).each(function () {
        if (this.value) {
          text.push(this.text)
        }
      })
      if (text.length) {
        // Add text to button if selected value
        if (options.spanClass) {
          sheet._btn.innerHTML = ''
          sheet._span = asFn.dom(sheet._btn, 'span',
              {className: options.spanClass}, text.join(', '))
        } else {
          $(sheet._btn).text(text.join(', '))
        }
      } else {
        // Add first select option text to button if no selected value
        text = title || $('option:selected', content).eq(0).text()
        sheet._btn.innerHTML = ''
        asFn.dom(sheet._btn, 'span', {className: 'placeholder'}, text)
      }

      $(content).hide().after(sheet._btn)

      return sheet
    }
  }
})(window, jQuery)