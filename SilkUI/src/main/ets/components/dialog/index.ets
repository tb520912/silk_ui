
@Component
export struct SilkDialog {
  // 控制弹框是否展示
  @Link
  @Watch('updateShow')
  show: boolean
  title: ResourceStr = ''
  widthValue: Length = '80%'
  message: ResourceStr = ''
  messageAlign: 'left' | 'right' | 'center' = 'center'
  theme: 'round-button' | 'default' = 'default'
  round: Length = 16
  bgcColor: ResourceColor = $r('app.color.white')
  showConfirm: boolean = true
  showCancel: boolean = false
  confirmText: ResourceStr = '确定'
  cancelText: ResourceStr = '取消'
  confirmColor: ResourceColor = '#1989fa'
  cancelColor: ResourceColor = $r('app.color.base_font_color3')
  confirmBgColor: ResourceColor = Color.Transparent
  cancelBgColor: ResourceColor = Color.Transparent
  confirmFontSize: Length = 16
  cancelFontSize: Length = 16
  @Prop
  confirmButtonDisabled: boolean = false
  @Prop
  cancelButtonDisabled: boolean = false
  showOverlay: boolean = true
  overlayColor: ResourceColor = $r('app.color.overlay_bg')
  close_on_pop_state: boolean = true
  onConfirm: () => void = () => {this.show = false}
  onCancel: () => void = () => {this.show = false}

  controller: CustomDialogController = new CustomDialogController({
    builder: DialogComp({
      props: {
        title: this.title,
        widthValue: this.widthValue,
        message: this.message,
        messageAlign: this.messageAlign,
        theme: this.theme,
        round: this.round,
        bgcColor: this.bgcColor,
        showConfirm: this.showConfirm,
        showCancel: this.showCancel,
        confirmText: this.confirmText,
        cancelText: this.cancelText,
        confirmColor: this.confirmColor,
        cancelColor: this.cancelColor,
        confirmBgColor: this.confirmBgColor,
        cancelBgColor: this.cancelBgColor,
        confirmFontSize: this.confirmFontSize,
        cancelFontSize: this.cancelFontSize,
        confirmButtonDisabled: this.confirmButtonDisabled,
        cancelButtonDisabled: this.cancelButtonDisabled,
        showOverlay: this.showOverlay,
        overlayColor: this.overlayColor,
        confirm: () => this.onConfirm(),
        cancel: () => this.onCancel()
      }
    }),
    alignment: DialogAlignment.Center,
    customStyle: true
  })

  callback (): void{
    // console.info(`navigation page switched, switchInfo: ${}`);
    this.show = false
  };
  showHandler() {
    this.controller.open()
    this.show = true
  }

  async closeHandler(): Promise<void> {
      this.controller.close()
      this.show = false
  }
  // 显示隐藏
  updateShow() {
    if (this.show) {
      this.showHandler()
      if (this.close_on_pop_state) {
        // 页面变化时关闭弹框
        this.getUIContext().getUIObserver().on('navDestinationSwitch',  () => this.callback())
      }
    } else {
      this.closeHandler()
      if (this.close_on_pop_state) {
        // 页面变化时关闭弹框
        this.getUIContext().getUIObserver().off('navDestinationSwitch', () => this.callback())
      }
    }
  }
  build() {

  }
}
@CustomDialog
@Component
struct DialogComp {
  controller: CustomDialogController
  // 自定义内容
  @BuilderParam
  default: () => void
  // 自定义标题
  @BuilderParam
  title: () => void
  // 自定义底部按钮
  @BuilderParam
  footer: () => void
  @Prop
  props: SilkDialogProps
  build() {
    Column(){
      this.HeaderBuilder()
      this.ContentBuilder()
      this.FooterBuilder()
    }
    .width(this.props.widthValue)
    .clip(true)
    .backgroundColor(this.props.bgcColor)
    .borderRadius(this.props.round)
  }
  @Builder
  HeaderBuilder () {
    if (this.title) {
      this.title()
    } else if (this.props.title) {
      Text(this.props.title)
        .width('100%')
        .fontSize(16)
        .fontWeight(600)
        .lineHeight(24)
        .fontColor($r('app.color.base_font_color3'))
        .padding({
          top: 26
        })
        .textAlign(TextAlign.Center)
    }
  }

  @Builder
  ContentBuilder () {
    if (this.default) {
      this.default()
    } else if (this.props.message) {
      Text(this.props.message)
        .width('100%')
        .fontSize(14)
        .lineHeight(20)
        .width('100%')
        .textAlign(this.getContentAlign())
        .padding({
          top: 8,
          left: 24,
          right: 24,
          bottom: 26
        })
      }
    }

  @Builder
  FooterBuilder () {
    if (this.footer) {
      this.footer()
    } else if (this.props.showConfirm || this.props.showCancel) {
      Row() {
        // 只有一个确认按钮
        if (!this.props.showCancel && this.props.showConfirm ) {
            Button(this.props.confirmText, {
              type: this.props.theme === 'default' ? ButtonType.Normal : ButtonType.Capsule
            })
              .backgroundColor(this.props.confirmBgColor)
              .fontSize(this.props.confirmFontSize)
              .fontColor(this.props.confirmColor)
              .onClick(() => {
                this.props.confirm && this.props.confirm()
              })
              .width('100%')
              .height(this.props.theme === 'default' ? 48 : 38)
        } else {
          Button(this.props.cancelText)
            .backgroundColor(this.props.cancelBgColor)
            .fontSize(this.props.cancelFontSize)
            .fontColor(this.props.cancelColor)
            .onClick(() => {
              this.props.cancel && this.props.cancel()
            })
            .layoutWeight(1)
            .height(48)
            .enabled(!this.props.cancelButtonDisabled)
          Divider()
            .strokeWidth(1)
            .color('#ebedfo')
          Button(this.props.confirmText)
            .backgroundColor(this.props.confirmBgColor)
            .fontSize(this.props.confirmFontSize)
            .fontColor(this.props.confirmColor)
            .onClick(() => {
              this.props.confirm && this.props.confirm()
            })
            .layoutWeight(1)
            .height(48)
            .enabled(!this.props.confirmButtonDisabled)
        }
      }
      .padding({
        top: this.props.theme === 'default' ? 0 : 8,
        left: this.props.theme === 'default' ? 0 : 24,
        right: this.props.theme === 'default' ? 0 : 24,
        bottom: this.props.theme === 'default' ? 0 : 16,
      })
      .width('100%')
      .border({
        width: {
          top: this.props.theme === 'default' ? '1px' : 0
        },
        color: '#ebedf0'
      })
    }
  }

  getContentAlign (): TextAlign {
    if (this.props.messageAlign === 'left') {
      return TextAlign.Start
    } else if (this.props.messageAlign === 'right') {
      return TextAlign.End
    } else {
      return TextAlign.Center
    }
  }
}

export interface SilkDialogProps {
  message?: ResourceStr
  title?: ResourceStr
  widthValue?: Length
  messageAlign?: 'left' | 'right' | 'center'
  // 圆角按钮
  theme?: 'round-button' | 'default'
  round?: Length | BorderRadiuses
  // 对话框颜色
  bgcColor?: ResourceColor
  showConfirm?: boolean
  showCancel?: boolean
  confirmText?: ResourceStr
  cancelText?: ResourceStr
  confirmColor?: ResourceColor
  cancelColor?: ResourceColor
  confirmBgColor?: ResourceColor
  cancelBgColor?: ResourceColor
  confirmFontSize?: Length
  cancelFontSize?: Length
  confirmButtonDisabled?: boolean
  cancelButtonDisabled?: boolean
  showOverlay?: boolean
  overlayColor?: ResourceColor
  // 是否在关闭时或者页面回退时自动关闭
  closeOnPopstate?: boolean
  beforeClose?: () => boolean
  transition?: TransitionEffect
  confirm?: () => void
  cancel?: () => void
}
