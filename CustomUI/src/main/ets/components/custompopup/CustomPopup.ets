import { window } from '@kit.ArkUI'

@Component
export struct CustomPopup {
  // 控制弹框是否展示
  @Link
  @Watch('updateShow')
  show: boolean
  // 是否展示遮罩
  showOverlay: boolean = true
  // 弹框展示位置
  showPosition: 'top' | 'bottom' | 'left' | 'right' | 'center' = 'center'
  // 遮罩颜色
  overlayColor: ResourceColor = $r('app.color.overlay_bg')
  // 弹框展示动画时长
  duration: number = 300
  // 是否展示圆角 有值即显示
  round: Length = 0
  widthValue: number | string = '70%'
  // 页面回退时自动关闭
  close_on_pop_state: boolean = true
  // 点击遮罩是否关闭
  close_on_click_overlay: boolean = true
  // 是否展示关闭按钮
  showClose: boolean = false
  // 关闭按钮图标
  close_icon: ResourceStr = $r('app.media.ic_public_close')
  // 关闭按钮位置
  close_icon_position: 'top-left' | 'top-right' | 'bottom-left' | 'bottom-right' = 'top-right'
  // 是否规避顶部导航栏
  safe_top: boolean = false
  // 是否避让底部导航栏
  safe_bottom: boolean = false
  @BuilderParam
  default: () => void = this.content
  controller: CustomDialogController = new CustomDialogController({
    builder: CustomDialogComp({
      props: {
        showOverlay: this.showOverlay,
        showPosition: this.showPosition,
        overlayColor: this.overlayColor,
        duration: this.duration,
        round: this.round,
        close_on_pop_state: this.close_on_pop_state,
        close_on_click_overlay: this.close_on_click_overlay,
        showClose: this.showClose,
        close_icon: this.close_icon,
        close_icon_position: this.close_icon_position,
        widthValue: this.widthValue,
        safe_top: this.safe_top,
        safe_bottom: this.safe_bottom,
        closeHandler: () => this.defaultClose()
      },
      children: this.default
    }),
    customStyle: true,
    openAnimation: { duration: 0 },
    closeAnimation: { duration: 0 },
    maskColor: Color.Transparent,
    alignment: this.getDialogAlignment()
  })

  getDialogAlignment(): DialogAlignment {
    switch (this.showPosition) {
      case 'top':
        return DialogAlignment.Top
      case 'bottom':
        return DialogAlignment.Bottom
      case 'left':
        return DialogAlignment.TopStart
      case 'right':
        return DialogAlignment.TopEnd
      case 'center':
        return DialogAlignment.Center
      default:
        return DialogAlignment.Default
    }
  }

  // 弹框内容
  @Builder
  content() {
  }

  // 关闭前回调 返回true则关闭 返回false可以阻止关闭
  before_close: () => (boolean | Promise<boolean>) = () => true
  // 弹出层点击
  click: () => void = () => {
  }
  // 遮罩点击
  click_overlay: () => void = () => {
  }
  // 关闭按钮点击
  click_close: () => void = () => {
  }
  // 显示时立即触发
  open: () => void = () => {
  }
  // 关闭时立即触发
  close: () => void = () => {
  }

  // 显示隐藏
  updateShow() {
    if (this.show) {
      this.showHandler()
    } else {
      this.closeHandler()
    }
  }

  showHandler() {
    this.controller.open()
    this.open()
    this.show = true
  }

  async closeHandler() {
    const res = await this.before_close()
    if (res) {
      this.controller.close()
      this.close()
      this.show = false
    } else {
      this.show = true
    }
  }

  // 回退 背板点击 esc退出
  defaultClose(): void {
    this.click_overlay()
    this.closeHandler()
  }

  aboutToAppear(): void {
    if (this.showPosition === 'center') {
      this.controller = new CustomDialogController({
        builder: CustomDialogCompCenter({
          round: this.round,
          children: this.default
        }),
        customStyle: true,
        openAnimation: { duration: this.duration },
        closeAnimation: { duration: this.duration },
        isModal: this.showOverlay,
        maskColor: this.overlayColor,
        cancel: this.defaultClose,
        alignment: DialogAlignment.Center
      })
    }
  }

  build() {

  }
}

const defaultProps: CustomDialogCompProps = {
  showOverlay: true,
  showPosition: 'center',
  overlayColor: $r('app.color.overlay_bg'),
  duration: 300,
  round: 0,
  close_on_pop_state: true,
  close_on_click_overlay: true,
  close_icon: $r('app.media.ic_public_close'),
  close_icon_position: 'top-right',
  widthValue: '70%'
}


@CustomDialog
struct CustomDialogComp {
  controller: CustomDialogController
  props: CustomDialogCompProps = defaultProps
  @BuilderParam
  children: () => void
  @State
  isClose: boolean = false
  @State
  safeHeight: AreaParams = {
    top: 0,
    bottom: 0
  }

  @Styles
  contentStyle() {
    .width(this.getContentWidth())
    .backgroundColor($r('app.color.white'))
    .borderRadius(this.getRadius())
    .transition(this.getTransition())
    .padding({
      top: this.props.safe_top ? this.safeHeight.top : 0,
      bottom: this.props.safe_bottom ? this.safeHeight.bottom : 0
    })
    .clip(true)
  }

  async aboutToAppear(): Promise<void> {
    if (this.props.safe_top || this.props.safe_bottom) {
      this.safeHeight = await this.getAreaHeight()
    }
  }

  build() {
    Column() {
      if (!this.isClose) {
        if (this.props.showPosition === 'top' || this.props.showPosition === 'bottom') {
          Stack({ alignContent: this.getClosePosition() }) {
            if (this.props?.showClose) {
              Image(this.props.close_icon)
                .zIndex(1)
                .width(22)
                .aspectRatio(1)
                .fillColor('#c8c9cc')
                .offset({
                  x: this.props.close_icon_position === 'top-left' || this.props.close_icon_position === 'bottom-left' ? 16 : -16,
                  y: this.props.close_icon_position === 'top-left' || this.props.close_icon_position === 'top-right' ? 16 : -16
                })
                .onClick(() => {
                  this.props.closeHandler && this.props.closeHandler()
                })
            }
            this.children()
          }
          .contentStyle()
        } else {
          Column() {
            this.children()
          }
          .height('100%')
          .contentStyle()
        }
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.props.overlayColor)
    .justifyContent(this.getJustifyContent())
    .alignItems(this.getAlignItems())
    .opacity(this.isClose ? 0 : 1)
    .onClick(() => {
      this.isClose = true
    })
    .animation({
      duration: this.isClose ? this.props.duration : 0,
      onFinish: () => this.finished(),
      curve: Curve.EaseInOut
    })
  }

  async getAreaHeight(): Promise<AreaParams> {
    const windowClass = await window.getLastWindow(getContext(this))
    const area = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
    const naviBar = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR)
    return {
      top: px2vp(area.topRect.height),
      bottom: px2vp(naviBar.bottomRect.height),
    }
  }

  getJustifyContent(): FlexAlign {
    switch (this.props.showPosition) {
      case 'top':
      case 'left':
      case 'right':
        return FlexAlign.Start
      case 'bottom':
        return FlexAlign.End
      default:
        return FlexAlign.Center
    }
  }

  getAlignItems(): HorizontalAlign {
    switch (this.props.showPosition) {
      case 'left':
        return HorizontalAlign.Start
      case 'right':
        return HorizontalAlign.End
      default:
        return HorizontalAlign.Center
    }
  }

  finished(): void {
    if (this.isClose) {
      this.props.closeHandler && this.props.closeHandler()
    }
  }

  getTransition(): TransitionEffect {
    switch (this.props.showPosition) {
      case 'bottom':
        return TransitionEffect.translate({
          y: '100%'
        }).animation({ duration: this.props.duration, curve: Curve.Linear })
      case 'top':
        return TransitionEffect.translate({
          y: '-100%'
        }).animation({ duration: this.props.duration })
      case 'left':
        return TransitionEffect.translate({
          x: `-${this.props.widthValue}`
        }).animation({ duration: this.props.duration })
      case 'right':
        return TransitionEffect.translate({
          x: this.props.widthValue
        }).animation({ duration: this.props.duration })
      default:
        return TransitionEffect.translate({
          x: '100%'
        }).animation({ duration: this.props.duration })
    }
  }

  getContentWidth(): string | number {
    if (this.props.showPosition === 'top' || this.props.showPosition === 'bottom') {
      return '100%'
    } else {
      return this.props.widthValue
    }
  }

  getRadius(): BorderRadiuses {
    if (this.props.round) {
      switch (this.props.showPosition) {
        case 'top':
          return {
            bottomLeft: this.props.round,
            bottomRight: this.props.round
          }
        case 'bottom':
          return {
            topLeft: this.props.round,
            topRight: this.props.round,
          }
        case 'left':
          return {
            topRight: this.props.round,
            bottomRight: this.props.round
          }
        case 'right':
          return {
            topLeft: this.props.round,
            bottomLeft: this.props.round
          }
        default:
          return {
            topLeft: 0,
            topRight: 0,
            bottomLeft: 0,
            bottomRight: 0
          }
      }
    } else {
      return {
        topLeft: 0,
        topRight: 0,
        bottomLeft: 0,
        bottomRight: 0
      }
    }
  }

  getClosePosition(): Alignment {
    switch (this.props.close_icon_position) {
      case 'top-left':
        return Alignment.TopStart
      case 'top-right':
        return Alignment.TopEnd
      case 'bottom-left':
        return Alignment.BottomStart
      case 'bottom-right':
        return Alignment.BottomEnd
      default:
        return Alignment.TopEnd
    }
  }
}

@CustomDialog
struct CustomDialogCompCenter {
  controller: CustomDialogController
  round: Length = 16
  @BuilderParam
  children: () => void

  build() {
    Column() {
      this.children()
      Text('居中弹框')
    }
    .constraintSize({
      maxWidth: '95%',
      maxHeight: '70%'
    })
    .borderRadius(this.round)
    .backgroundColor($r('app.color.white'))
  }
}

interface CustomDialogCompProps {
  showOverlay: boolean
  showPosition: 'top' | 'bottom' | 'left' | 'right' | 'center'
  overlayColor: ResourceColor
  duration: number
  round: Length
  close_on_pop_state: boolean
  close_on_click_overlay: boolean
  showClose?: boolean
  close_icon: ResourceStr
  close_icon_position: 'top-left' | 'top-right' | 'bottom-left' | 'bottom-right'
  widthValue: number | string
  closeHandler?: () => void
  safe_top?: boolean
  safe_bottom?: boolean
}

interface AreaParams {
  top: number
  bottom: number
}
