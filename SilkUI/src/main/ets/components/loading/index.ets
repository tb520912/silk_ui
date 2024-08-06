import { ValueAnimator } from '../../utils/ValueAnimator';
import { curves } from '@kit.ArkUI';

@Preview
@Component
export struct SilkLoading {
  type: 'circular' | 'spinner' = 'circular'
  color: ResourceColor = '#c8c9cc'
  icon: ResourceStr = ''
  sizeValue: Length = 30
  textSize: Length = $r('app.float.font_size_md')
  text: ResourceStr = ''
  textColor?: ResourceColor = undefined
  vertical: boolean = false
  private fontColorValue: ResourceColor = ''
  @State dasharray: number[] = [1 , 200];
  @State dashOffset: number | string = 0
  @State angle: number = 0;
  @State angleSpinner: number = 0;
  @State private loadWidth: number = 0
  uiContext: UIContext | undefined = undefined;
  private animator: ValueAnimator | null = null;
  private animatorCircle: ValueAnimator | null = null;
  private animatorSpinner: ValueAnimator | null = null;
  aboutToAppear() {
    if (this.color !== '#c8c9cc') {
      this.fontColorValue = this.color
    } else if (this.textColor) {
      this.fontColorValue = this.textColor
    } else {
      this.fontColorValue = $r('app.color.text_color_2')
    }
    if (this.type === 'circular') {
      this.uiContext = this.getUIContext?.();
      this.animator = new ValueAnimator()
      this.animator.startValue = 0
      this.animator.endValue = 1
      this.animator.duration = 1500
      this.animator.loops = Infinity
      this.animator.fillRule = 1
      this.animator.onUpdate = (value: number) => this.update(value)
      this.animatorCircle = new ValueAnimator()
      this.animatorCircle.startValue = 0
      this.animatorCircle.endValue = 1
      this.animatorCircle.duration = 2000
      this.animatorCircle.fillRule = 1
      this.animatorCircle.loops = Infinity
      this.animatorCircle.onUpdate = (value: number) => this.updateColumn(value)
    } else {
      this.animatorSpinner = new ValueAnimator()
      this.animatorSpinner.startValue = 0
      this.animatorSpinner.endValue = 12
      this.animatorSpinner.duration = 800
      this.animatorSpinner.fillRule = 1
      this.animatorSpinner.loops = Infinity
      this.animatorSpinner.easing = 'steps(12, end)'
      this.animatorSpinner.onUpdate = (value: number) => this.updateSpinner(value)
    }
  }
  private icu: ICurve = curves.initCurve(Curve.EaseInOut)
  private update (value: number): void {
    if (value * 1500 < 750) {
      this.dasharray = [this.icu.interpolate(value) * 89 * 2 + 1, 200 - this.icu.interpolate(value) * 50 * 2]
      this.dashOffset = - this.icu.interpolate(value * 2) * 40
    } else if (value * 1500 < 1500) {
      this.dasharray = [90, 150]
      this.dashOffset = -40 - this.icu.interpolate(value - 1/2) * 80 * 2
    } else {
      this.dasharray = [1, 200]
      this.dashOffset = 0
    }
  }
  private updateColumn (value: number): void {
    this.angle = value * 360
  }
  private updateSpinner (value: number): void {
    this.angleSpinner = Math.ceil(value) * 30
  }
  aboutToDisappear(): void {
    this.animator?.stop()
    this.animator = null
    this.animatorCircle?.stop()
    this.animatorCircle = null
    this.animatorSpinner?.stop()
    this.animatorSpinner = null
  }
  build() {
    if (this.vertical) {
      Column(){
        if (this.type === 'circular') {
          Column(){
            if (this.icon) {
              Image(this.icon)
                .width('100%')
                .height('100%')
                .fillColor(this.color)
            } else {
              Circle()
                .width('100%')
                .height('100%')
                .fill(Color.Transparent)
                .strokeWidth(3)
                .strokeLineCap(LineCapStyle.Round)
                .stroke(this.color)
                .strokeDashArray(this.dasharray)
                .strokeDashOffset(this.dashOffset)
                .onAppear(() => {
                  this.animator?.start()
                })
            }
          }
          .width(this.sizeValue)
          .aspectRatio(1)
          .rotate({
            angle: this.angle
          })
          .onAppear(() => {
            this.animatorCircle?.start()
          })
        } else {
          Stack({ alignContent: Alignment.Top}){
            if (this.icon) {
              Image(this.icon)
                .width('100%')
                .height('100%')
                .fillColor(this.color)

            } else {
              ForEach(new Array(12).fill(0), (_: number, index: number) => {
                Row()
                  .width(2)
                  .height('25%')
                  .rotate({
                    angle: index * 30,
                    centerX: '50%',
                    centerY: this.loadWidth / 2,
                  })
                  .backgroundColor(this.color)
                  .opacity(1 - 0.0625 * index)
              })
            }
          }
          .onAreaChange((_: Area, area: Area) => {
            this.loadWidth = area.width as number
          })
          .width(this.sizeValue)
          .aspectRatio(1)
          .rotate({
            angle: this.angleSpinner
          })
          .onAppear(() => {
            this.animatorSpinner?.start()
          })
        }
        // 加载文案
        if (this.text) {
          Text(this.text)
            .fontSize(this.textSize)
            .fontColor(this.fontColorValue)
            .margin({
              left: this.vertical ? 0 : 8,
              top: this.vertical ? 8 : 0
            })
        }
      }
    } else {
      Row(){
        if (this.type === 'circular') {
          Column(){
            if (this.icon) {
              Image(this.icon)
                .width('100%')
                .height('100%')
            } else {
              Circle()
                .width('100%')
                .height('100%')
                .fill(Color.Transparent)
                .strokeWidth(3)
                .strokeLineCap(LineCapStyle.Round)
                .stroke(this.color)
                .strokeDashArray(this.dasharray)
                .strokeDashOffset(this.dashOffset)
                .onAppear(() => {
                  this.animator?.start()
                })
            }
          }
          .width(this.sizeValue)
          .aspectRatio(1)
          .rotate({
            angle: this.angle
          })
          .onAppear(() => {
            this.animatorCircle?.start()
          })
        } else {
          Stack({ alignContent: Alignment.Top}){
            if (this.icon) {
              Image(this.icon)
                .width('100%')
                .height('100%')
            } else {
              ForEach(new Array(12).fill(0), (_: number, index: number) => {
                Row()
                  .width(2)
                  .height('25%')
                  .rotate({
                    angle: index * 30,
                    centerX: '50%',
                    centerY: this.loadWidth / 2,
                  })
                  .backgroundColor(this.color)
                  .opacity(1 - 0.0625 * index)
              })
            }
          }
          .onAreaChange((_: Area, area: Area) => {
            this.loadWidth = area.width as number
          })
          .width(this.sizeValue)
          .aspectRatio(1)
          .rotate({
            angle: this.angleSpinner
          })
          .onAppear(() => {
            this.animatorSpinner?.start()
          })
        }
        // 加载文案
        if (this.text) {
          Text(this.text)
            .fontSize(this.textSize)
            .fontColor(this.fontColorValue)
            .margin({
              left: this.vertical ? 0 : 8,
              top: this.vertical ? 8 : 0
            })
        }
      }
    }
  }
}
