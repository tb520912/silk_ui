import CropObserved from '../../utils/CropObserved'
import { image } from '@kit.ImageKit'

@Preview
@Component
export struct SilkImageCrop {
  @Link
  status: boolean
  @Prop
  uri: string = ''
  proportion: number = 1
  // 裁剪形状 圆形还是矩形
  type: 'circle' | 'rectangle' = 'rectangle'
  @State observed: CropObserved = new CropObserved()

  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  callback: (filename: string) => void = (_filename) => {}

  onToolbar(action: number): void {
    if (action == 0) {
      this.status = false
    } else {
      this.observed.crop(filename => {
        this.callback(filename)
        this.status = false
      })
    }
  }

  build() {
      Stack({ alignContent: Alignment.Bottom }) {
        Stack() {
          CropImageView({ observed: this.observed, uri: this.uri })
          // .id('image')
          // .alignRules({
          //   center: { anchor: '__container__', align: VerticalAlign.Center },
          //   middle: { anchor: '__container__', align: HorizontalAlign.Center }
          // })
          RoundHoleView({
            context: this.context,
            proportion: this.proportion,
            type: this.type,
            observed: this.observed
          })
            .width('100%')
            .height('100%')
          // .id('image_crop')
          // .alignRules({
          //   center: { anchor: '__container__', align: VerticalAlign.Center },
          //   middle: { anchor: '__container__', align: HorizontalAlign.Center }
          // })
        }
        .padding({
          bottom: 48
        })

        MiniToolbarView({ observed: this.observed })
          .id('image_crop_mini')
          .alignRules({
            bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
        CropToolbarView({ cropLoading: this.observed.cropLoading, action: (action: number) => this.onToolbar(action) })
          .id('image_crop_btn')
          .alignRules({
            bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })

      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.Black)
    // 手指捏合 缩放图片
  }
}

@Component
struct CropImageView {
  @ObjectLink observed: CropObserved
  @Prop
  uri: string = ''

  build() {
    Stack() {
      Image(this.observed.pixelMap ? this.observed.pixelMap : '')
        .width(this.observed.canvasImage.width)
        .height(this.observed.canvasImage.height)
        .scale({
          x: this.observed.scale,
          y: this.observed.scale
        })
        .translate({ x: this.observed.offsetX, y: this.observed.offsetY })

    }
    .width('100%')
    .height('100%')
    .onAreaChange((_: Area, area: Area) => {
      this.observed.getPixel(this.uri, area)
    })

  }
}


@Component
struct MiniToolbarView {
  @ObjectLink observed: CropObserved

  build() {
    Row({ space: 32 }) {
      Button() {
        Image($r('app.media.vertical_flip'))
          .size({ width: 24, height: 24 })
      }
      .padding(16)
      .backgroundColor(this.observed.verticalFlip ? $r('app.color.primary') : $r('app.color.darkGray'))
      .onClick(async () => this.onButton(0))

      Button() {
        Image($r('app.media.horizontal_flip'))
          .size({ width: 24, height: 24 })
      }
      .padding(16)
      .backgroundColor(this.observed.horizontalFlip ? $r('app.color.primary') : $r('app.color.darkGray'))
      .onClick(async () => this.onButton(1))

      Button() {
        Image($r('app.media.rotate_right'))
          .size({ width: 32, height: 32 })
      }
      .padding(12)
      .backgroundColor(this.observed.rotationAngle % 360 == 0 ? $r('app.color.darkGray') : $r('app.color.primary'))
      .onClick(async () => this.onButton(2))

    }
    .margin({ bottom: 96 })
  }

  onButton(action: number) {
    this.observed.onMiniToolbar(action)

  }
}

@Component
struct CropToolbarView {
  @Prop cropLoading: boolean
  action: (action: number) => void = (_action) => {
  }

  build() {
    Row() {
      Button() {
        Text('取消')
          .fontSize(14)
          .fontColor(Color.White)
      }
      .height(32)
      .padding({ left: 16, right: 16 })
      .backgroundColor(Color.Transparent)
      .onClick(() => this.action(0))

      Blank()

      if (this.cropLoading) {
        // LoadingButton(32, 32)
      } else {
        Button() {
          Text('完成')
            .fontSize(14)
            .fontColor(Color.White)
        }
        .height(32)
        .padding({ left: 16, right: 16 })
        .backgroundColor($r('app.color.primary'))
        .onClick(() => this.action(1))
      }
    }
    .padding({ left: 16, right: 16 })
    .width('100%')
    .height(48)
    .backgroundBlurStyle(BlurStyle.Thin)
  }
}

@Component
struct RoundHoleView {
  @ObjectLink
  observed: CropObserved
  context: CanvasRenderingContext2D | null = null
  proportion: number = 1
  type: 'circle' | 'rectangle' = 'circle'
  private num: number = 1

  build() {
    Canvas(this.context)
      .width('100%')
      .height('100%')
      .backgroundColor(Color.Transparent)
      .onReady(() => {

        if (this.context == null) {
          return
        }

        let height = this.context.height
        let width = this.context.width

        this.context.fillStyle = '#6b000000'
        this.context.fillRect(0, 0, width, height)

        this.context.globalCompositeOperation = 'destination-out'

        this.context.fillStyle = 'white'
        this.context.beginPath();
        if (this.type === 'circle') {
          let radius = (width - 64) / 2
          this.observed.cropSize = {
            width: radius * 2,
            height: radius * 2
          }
          this.context.arc(32 + radius, height / 2, radius, 0, Math.PI * 2)
          this.observed.holeWidth = width - 64

        } else {
          let heightValue = width / (this.proportion || 1)
          this.observed.cropSize = {
            width: width,
            height: heightValue
          }
          this.context.rect(0, height / 2 - (heightValue / 2), width, heightValue)
          this.observed.holeWidth = width

        }
        this.context.closePath();
        this.context.fill();

        this.context.globalCompositeOperation = 'source-over';
      })
      .gesture(
        GestureGroup(GestureMode.Parallel,
          // 拖拽
          PanGesture()
            .onActionStart((event: GestureEvent | undefined) => {
              console.info('Pan start');
            })
            .onActionUpdate((event: GestureEvent | undefined) => {
              if (event) {
                let offsetX = this.observed.positionX + event.offsetX
                let offsetY = this.observed.positionY + event.offsetY
                // 建立临界点 不允许裁剪区空白
                const minX =
                  -Math.abs(this.observed.canvasImage.width * this.observed.scale - this.observed.cropSize.width) / 2
                const maxX =
                  Math.abs(this.observed.canvasImage.width * this.observed.scale - this.observed.cropSize.width) / 2
                const minY =
                  -Math.abs(this.observed.canvasImage.height * this.observed.scale - this.observed.cropSize.height) / 2
                const maxY =
                  Math.abs(this.observed.canvasImage.height * this.observed.scale - this.observed.cropSize.height) / 2
                if (offsetX < minX) {
                  offsetX = minX
                } else if (offsetX > maxX) {
                  offsetX = maxX
                }
                if (offsetY < minY) {
                  offsetY = minY
                } else if (offsetY > maxY) {
                  offsetY = maxY
                }
                if (this.observed) {
                  this.observed.offsetX = offsetX
                }
                this.observed.offsetY = offsetY
              }
            })
            .onActionEnd(() => this.onEnd()),
          // 缩放
          PinchGesture({ fingers: 2 })
            .onActionStart((event: GestureEvent) => {
              this.num = this.observed.scale
            })
            .onActionUpdate((event: GestureEvent) => {
              if (event.scale > 1) {
                // 放大
                if (this.num * event.scale >= 3) {
                  this.observed.scale = 3
                } else {
                  this.observed.scale = this.num * event.scale
                }
              } else {
                if (this.num * event.scale < 1) {
                  this.observed.scale = 1
                } else {
                  this.observed.scale = this.num * event.scale
                }
              }
            })
            .onActionEnd((event: GestureEvent) => {
              this.num = this.observed.scale
            }))
      )
    // .enabled(false)
  }

  onEnd() {
    animateTo({ duration: 200 }, () => {
      if (this.observed.horizontalImage) {
        // this.observed.offsetY = 0
        let excess = this.calculateExcess()
        this.observed.offsetX = Math.min(Math.max(this.observed.offsetX, -excess), excess)
      } else {
        // this.observed.offsetX = 0
        let excess = this.calculateExcess()
        this.observed.offsetY = Math.min(Math.max(this.observed.offsetY, -excess), excess)
      }
      this.observed.positionX = this.observed.offsetX;
      this.observed.positionY = this.observed.offsetY;
    })
  }

  calculateExcess() {
    if (this.observed.horizontalImage) {
      return (this.observed.imageSize.width - this.observed.holeWidth) / 2;
    } else {
      return (this.observed.imageSize.height - this.observed.holeWidth) / 2;
    }
  }
}

