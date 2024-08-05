import { ValueAnimator } from '../../utils/ValueAnimator';
import { curves } from '@kit.ArkUI';

@Preview
@Component
export struct SilkLoading {
  @State dasharray: number[] = [1 , 200];
  @State dashOffset: number | string = 0
  @State angle: number = 0;
  uiContext: UIContext | undefined = undefined;

  private animator: ValueAnimator | null = null;
  private animatorColumn: ValueAnimator | null = null;
  aboutToAppear() {
    this.uiContext = this.getUIContext?.();
    this.animator = new ValueAnimator()
    this.animator.startValue = 0
    this.animator.endValue = 1
    this.animator.duration = 1500
    this.animator.loops = Infinity
    this.animator.fillRule = 1
    this.animator.onUpdate = (value: number) => this.update(value)
    this.animatorColumn = new ValueAnimator()
    this.animatorColumn.startValue = 0
    this.animatorColumn.endValue = 1
    this.animatorColumn.duration = 2000
    this.animatorColumn.fillRule = 1
    this.animatorColumn.loops = Infinity
    this.animatorColumn.onUpdate = (value: number) => this.updateColumn(value)
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
  aboutToDisappear(): void {
    this.animator?.stop()
    this.animator = null
    this.animatorColumn?.stop()
    this.animatorColumn = null
  }
  build() {
    Column(){
      Column(){
        Circle()
          .width(30)
          .height(30)
          .fill(Color.Transparent)
          .strokeWidth(3)
          .strokeLineCap(LineCapStyle.Round)
          .stroke('#c8c9cc')
          .strokeDashArray(this.dasharray)
          .strokeDashOffset(this.dashOffset)
          .onAppear(() => {
            this.animator?.start()
          })
      }
      .width(30)
      .height(30)
      .rotate({
        angle: this.angle
      })
      // .backgroundColor(Color.Red)
      .onAppear(() => {
        this.animatorColumn?.start()
      })
      Column(){
        Stack({ alignContent: Alignment.Top}){
          ForEach(new Array(12).fill(0), (item: number, index: number) => {
            Row()
              .width(2)
              .height(7.5)
              .rotate({
                angle: index * 30,
                centerX: '50%',
                centerY: 15,
              })
              .backgroundColor('#c8c9cc')
              .opacity(1 - 0.0625 * index)
          })
        }
        .width(30)
        .height(30)
        .rotate({
          angle: this.angle
        })
        // .backgroundColor(Color.Red)
        .onAppear(() => {
          this.animatorColumn?.start()
        })
      }
    }
  }
}