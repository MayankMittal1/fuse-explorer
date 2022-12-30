import * as Pikaday from 'pikaday'
import moment from 'moment'
import $ from 'jquery'
import Cookies from 'js-cookie'

const DATE_FORMAT = 'YYYY-MM-DD'

const $dateButton = $('#export-csv-button-date')
const $blockButton = $('#export-csv-button-block')
const $byDateToggle = $('#by-date')
const $byDateContainer = $('.dates-container')
const $byBlockToggle = $('#by-block')
const $byBlockContainer = $('.blocks-container')
const $blockNumberFrom = $('#block-from')
const $blockNumberTo = $('#block-to')

// eslint-disable-next-line
const _instance1 = new Pikaday({
  field: $('.js-datepicker-from')[0],
  onSelect: (date) => onSelect(date, 'from_period'),
  defaultDate: moment().add(-1, 'months').toDate(),
  setDefaultDate: true,
  maxDate: new Date(),
  format: DATE_FORMAT
})

// eslint-disable-next-line
const _instance2 = new Pikaday({
  field: $('.js-datepicker-to')[0],
  onSelect: (date) => onSelect(date, 'to_period'),
  defaultDate: new Date(),
  setDefaultDate: true,
  maxDate: new Date(),
  format: DATE_FORMAT
})

$dateButton.on('click', () => {
  // eslint-disable-next-line
  const recaptchaResponse = grecaptcha.getResponse()
  if (recaptchaResponse) {
    $dateButton.addClass('spinner')
    $dateButton.prop('disabled', true)
    const downloadUrl = `${$dateButton.data('link')}&recaptcha_response=${recaptchaResponse}`

    $('body').append($('<iframe id="csv-iframe" style="display: none;"></iframe>'))
    $('#csv-iframe').attr('src', downloadUrl)

    const interval = setInterval(handleCSVDownloaded, 1000)
    setTimeout(resetDownload, 60000)

    function handleCSVDownloaded () {
      if (Cookies.get('csv-downloaded') === 'true') {
        resetDownload()
      }
    }

    function resetDownload () {
      $dateButton.removeClass('spinner')
      $dateButton.prop('disabled', false)
      clearInterval(interval)
      Cookies.remove('csv-downloaded')
      // eslint-disable-next-line
      grecaptcha.reset()
    }
  }
})

$blockButton.on('click', () => {
  // eslint-disable-next-line
  const recaptchaResponse = grecaptcha.getResponse()
  if (recaptchaResponse) {
    $blockButton.addClass('spinner')
    $blockButton.prop('disabled', true)
    const downloadUrl = `${$blockButton.data('link')}&recaptcha_response=${recaptchaResponse}`

    $('body').append($('<iframe id="csv-iframe" style="display: none;"></iframe>'))
    $('#csv-iframe').attr('src', downloadUrl)

    const interval = setInterval(handleCSVDownloaded, 1000)
    setTimeout(resetDownload, 60000)

    function handleCSVDownloaded () {
      if (Cookies.get('csv-downloaded') === 'true') {
        resetDownload()
      }
    }

    function resetDownload () {
      $blockButton.removeClass('spinner')
      $blockButton.prop('disabled', false)
      clearInterval(interval)
      Cookies.remove('csv-downloaded')
      // eslint-disable-next-line
      grecaptcha.reset()
    }
  }
})

$byDateToggle.on('click', () => {
  $byDateContainer.show()
  $byBlockContainer.hide()
  $dateButton.show()
  $blockButton.hide()
})

$byBlockToggle.on('click', () => {
  $byDateContainer.hide()
  $byBlockContainer.show()
  $dateButton.hide()
  $blockButton.show()
})

$blockNumberFrom.on('change', () => {
  const blockNumberFrom = $blockNumberFrom.val()
  const csvExportPath = $blockButton.data('link')

  const updatedCsvExportUrl = replaceUrlParam(csvExportPath, 'from_block', blockNumberFrom)
  $blockButton.data('link', updatedCsvExportUrl)
})

$blockNumberTo.on('change', () => {
  const blockNumberTo = $blockNumberTo.val()
  const csvExportPath = $blockButton.data('link')

  const updatedCsvExportUrl = replaceUrlParam(csvExportPath, 'to_block', blockNumberTo)
  $blockButton.data('link', updatedCsvExportUrl)
})

function onSelect (date, paramToReplace) {
  const formattedDate = moment(date).format(DATE_FORMAT)

  if (date) {
    const csvExportPath = $dateButton.data('link')

    const updatedCsvExportUrl = replaceUrlParam(csvExportPath, paramToReplace, formattedDate)
    $dateButton.data('link', updatedCsvExportUrl)
  }
}

function replaceUrlParam (url, paramName, paramValue) {
  if (paramValue == null) {
    paramValue = ''
  }
  const pattern = new RegExp('\\b(' + paramName + '=).*?(&|#|$)')
  if (url.search(pattern) >= 0) {
    return url.replace(pattern, '$1' + paramValue + '$2')
  }
  url = url.replace(/[?#]$/, '')
  return url + (url.indexOf('?') > 0 ? '&' : '?') + paramName + '=' + paramValue
}

$byDateToggle.trigger('click')
