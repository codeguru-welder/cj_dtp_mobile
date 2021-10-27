'use strict'

// Global Variable
var glMsg = ''
var glEvent = null

var miapsModal = {
  /**
   * Append miapsModal layout in body
   */
  appendForm: function () {
    $('body').append(
        '<div class="miaps-modal-wrap" data-popup="alert-msg">'
        + '<div class="miaps-modal">'
        + '  <div class="miaps-modal-msg" id="alert-text"></div>'
        + '  <div class="miaps-modal-btn">'
        + '    <button class="type-confirm btn-cancel" onclick="miapsModal.onCancel()">Cancel</button>'
        + '    <button class="type-confirm btn-confirm" onclick="miapsModal.onConfirm()">Confirm</button>'
        + '    <button class="type-ok btn-ok" onclick="miapsModal.onOk()">OK</button>'
        + '  </div>'
        + '  </div>'
        + '</div>')
  },
  /**
   * hide Modal
   */
  hideModal: function () {
    /* Enable scroll */
    $('body').css({'overflow': 'visible'}).unbind('touchmove')
    $('.miaps-modal-wrap[data-popup=alert-msg]').fadeOut(150)
  },
  /**
   * Set miapsModal button type
   * @param {string} type [ok], [other(confirm)]
   */
  typeTrigger: function (type) {
    if (type.toUpperCase() === 'OK') {
      $('.type-confirm').hide()
      $('.type-ok').show()
    } else {
      $('.type-confirm').show()
      $('.type-ok').hide()
    }
  },
  /**
   * miapsModal cancel button event
   */
  onCancel: function () {
    this.hideModal()
  },
  /**
   * miapsModal confirm button event
   */
  onConfirm: function () {
    if (glEvent) {
      glEvent()
    }
    this.hideModal()
  },
  /**
   * miapsModal ok button event
   */
  onOk: function () {
    if (glEvent != null) {
      glEvent()
    }
    this.hideModal()
  }
}

/**
 * show miapsModal function
 *
 * @param {string} msg miapsModal message
 * @param {string} type miapsModal type : [ok], [confirm], [button text]
 * @param {function} event after miapsModal event
 */
function showModal(msg, type, event) {
  var alertText = $('#alert-text')
  if (!alertText.hasClass('miaps-modal-msg')) {
    miapsModal.appendForm()
  }
  if (type === '' || type == null || type.toUpperCase() === 'OK') {
    miapsModal.typeTrigger('ok')
  } else if (type.toUpperCase() === 'CONFIRM') {
    miapsModal.typeTrigger(type)
  } else {
    miapsModal.typeTrigger('ok')
    $('.type-ok').text(type)
  }
  if (msg !== '' && msg != null) {
    glMsg = msg
    // Not use jQuery
    if (msg.startsWith('<img')) {
      document.getElementById('alert-text').innerHTML = msg
    } else {
      document.getElementById('alert-text').innerText = msg
    }
  } else {
    document.getElementById('alert-text').innerText = 'No Message'
    miapsModal.typeTrigger('ok')
  }
  glEvent = null
  if (event != null) {
    glEvent = event
  }

  /* Disable scroll */
  $('body').css({overflow: 'hidden'}).bind('touchmove')
  $('.miaps-modal-wrap[data-popup=alert-msg]').fadeIn(150);
}