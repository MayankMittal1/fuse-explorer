import { of } from 'rxjs'
import { delay, tap, mergeMap, repeat } from 'rxjs/operators'
import 'jquery-circle-progress'

export function secondsToDhms (seconds) {
  seconds = Number(seconds)
  const floor = Math.floor

  const d = floor(seconds / (3600 * 24))
  const h = floor(seconds % (3600 * 24) / 3600)
  const m = floor(seconds % 3600 / 60)
  const s = Math.floor(seconds % 60)

  const dDisplay = d > 0 ? d + 'd ' : ''
  const hDisplay = h > 0 ? h + 'h ' : ''
  const mDisplay = m > 0 ? m + 'm ' : ''
  const sDisplay = s > 0 ? s + 's' : ''
  return dDisplay + hDisplay + mDisplay + sDisplay
}

export function poll (fn, ms, cb) {
  return of({}).pipe(
    mergeMap(_ => fn()),
    tap(cb),
    delay(ms),
    repeat()
  )
}

export function calcCycleLength (cycleStartBlock, cycleEndBlock) {
  return (cycleEndBlock - cycleStartBlock) * 5
}

export function calcCycleEndPercent (cycleEnd, cycleLength) {
  return 1 - (cycleEnd / cycleLength)
}
