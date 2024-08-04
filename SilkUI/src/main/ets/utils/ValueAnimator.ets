import { systemDateTime } from '@kit.BasicServicesKit'
import animator, { AnimatorResult } from '@ohos.animator'

export class ValueAnimator {
  _animator: AnimatorResult | null = null
  _bindFrame: boolean = false
  static currentTimeMillsecond () {
    return systemDateTime.getTime(true)
  }

  public startValue: number = 0
  public endValue: number = 0
  public duration: number = 0
  public loops: number = 1
  public fillRule: number = 0
  public FPS: number = 10
  onStart: () => void = () => {}
  onUpdate: (currentValue: number) => void = (currentValue) => {}
  onEnd: () => void = () => {}

  public start(currentValue: number | undefined = undefined) {
    if (this._animator === null) {
      this._animator = animator.create({
        duration: 3000,
        easing: 'ease',
        delay: 0,
        fill: 'forwards',
        direction: 'normal',
        iterations: -1,
        begin: this.startValue,
        end: this.endValue
      })
      let range: ExpectedFrameRateRange = {
        expected: this.FPS,
        min: 0,
        max: 120
      }

      this._animator.play()
    }

    this.doStart(false, currentValue)
    // this.backDisplaySync?.on('frame', (frameInfo) => {
    //   AlertDialog.show({
    //     message: '监听没帧触发'
    //   })
    // })

  }

  public reverse(currentValue: number | undefined = undefined) {
    this.doStart(true, currentValue)
  }

  public stop() {
    this.doStop()
  }

  public get animatedValue(): number {
    return ((this.endValue - this.startValue) * this.mCurrentFrication) + this.startValue
  }

  private mRunning = false
  private mStartTime = 0
  private mCurrentFrication: number = 0.0
  private mReverse = false

  private doStart(reverse: boolean = false, currentValue: number | undefined = undefined) {
    this.mReverse = reverse
    this.mRunning = true
    this.mStartTime = ValueAnimator.currentTimeMillsecond()
    if (currentValue) {
      if (reverse) {
        this.mStartTime -= (1.0 - currentValue / (this.endValue - this.startValue)) * this.duration
      }
      else {
        this.mStartTime -= currentValue / (this.endValue - this.startValue) * this.duration
      }
    }
    this.mCurrentFrication = 0.0
    this.onStart()
    this.doFrame()
  }

  private doStop() {
    this.mRunning = false
  }

  private doFrame(): void {
    if (this.mRunning) {
      this.doDeltaTime(ValueAnimator.currentTimeMillsecond() - this.mStartTime)
      if (this.mRunning) {
        // setTimeout(() => this.doFrame(), 160)
        if (!this._bindFrame && this._animator) {
          this._bindFrame = true
          this._animator.onframe = (value) => {
            console.log('animator-frame' + value)
            this.doFrame()
          }
        }
      }
    }
  }

  private doDeltaTime(deltaTime: number) {
    if (deltaTime >= this.duration * this.loops) {
      this.mCurrentFrication = this.fillRule === 1 ? 0.0 : 1.0
      this.mRunning = false
    }
    else {
      // 纳秒 需要转成毫秒后与duration进行比较
      this.mCurrentFrication = ((deltaTime / 1000000) % this.duration) / this.duration
      if (this.mReverse) {
        this.mCurrentFrication = 1.0 - this.mCurrentFrication
      }
    }
    this.onUpdate(this.animatedValue)
    if (this.mRunning === false) {
      this.onEnd()
    }
  }

}