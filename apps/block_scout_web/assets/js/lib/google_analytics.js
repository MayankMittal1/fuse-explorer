export function loadGtag () {
  const streamID = process.env.GOOGLE_ANALYTICS_MEASUREMENT_ID
  if (!streamID) {
    console.warn('Google Analytics stream ID is not set')
    return
  }
  const scriptEle = document.createElement('script')
  scriptEle.setAttribute(
    'src',
      `https://www.googletagmanager.com/gtag/js?id=${streamID}`
  )
  scriptEle.setAttribute('type', 'text/javascript')
  scriptEle.setAttribute('async', true)

  document.body.appendChild(scriptEle)
  scriptEle.addEventListener('load', () => {
    window.dataLayer = window.dataLayer || []
    function gtag () {
      window.dataLayer.push(arguments)
    }
    gtag('js', new Date())
    gtag('config', streamID)
  })

  scriptEle.addEventListener('error', (ev) => {
    console.warn('Error in Loading Google Analytics ', ev)
  })
}

loadGtag()
