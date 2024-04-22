
@Component
export struct CustomDialogBox {
  // 控制弹框是否展示
  @Link
  show: boolean
  title: string = ''
  message: string = ''
  messageAlign: string = 'center'
  theme: 'round-button' | 'default' = 'default'
  bgcColor: ResourceStr = $r('app.color.white')
  showConfirm: boolean = true
  showCancel: boolean = false
  confirmText: ResourceStr = '确定'
  cancelText: ResourceStr = '取消'
  confirmColor: ResourceStr = $r('app.color.base_color')
  cancelColor: ResourceStr = $r('app.color.base_font_color3')
  confirmBgColor: ResourceColor = Color.Transparent
  cancelBgColor: ResourceColor = Color.Transparent
  confirmFontSize: number = 16
  cancelFontSize: number = 16
  confirmButtonDisabled: boolean = false
  cancelButtonDisabled: boolean = false
  overlayValue: boolean = true
  overlayColor: ResourceColor = $r('app.color.overlay_bg')
  closeOnPopstate: boolean = true

  build() {

  }
}
@CustomDialog
struct CustomDialogComp {
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
  props: CustomDialogProps
  build() {
    Column(){
      this.HeaderBuilder()
      this.ContentBuilder()
      this.FooterBuilder()
    }
    .width(this.props.width)
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
                this.controller.close
              })
              .width('100%')
              .height(this.props.theme === 'default' ? 48 : 38)
        } else {
          Button(this.props.cancelText)
            .backgroundColor(this.props.cancelBgColor)
            .fontSize(this.props.cancelFontSize)
            .fontColor(this.props.cancelColor)
            .onClick(() => {
              this.controller.close
            })
            .layoutWeight(1)
            .height(48)
          Divider()
            .strokeWidth(1)
            .color('#ebedfo')
          Button(this.props.confirmText)
            .backgroundColor(this.props.confirmBgColor)
            .fontSize(this.props.confirmFontSize)
            .fontColor(this.props.confirmColor)
            .onClick(() => {
              this.controller.close
            })
            .layoutWeight(1)
            .height(48)
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
          top: this.props.theme === 'default' ? 1 : 0
        },
        color: '#ebedfo'
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

export interface CustomDialogProps {
  message: ResourceStr
  title: ResourceStr
  width: Length
  messageAlign: 'left' | 'right' | 'center'
  // 圆角按钮
  theme: 'round-button' | 'default'
  round: Length | BorderRadiuses
  // 对话框颜色
  bgcColor: ResourceColor
  showConfirm: boolean
  showCancel: boolean
  confirmText: ResourceStr
  cancelText: ResourceStr
  confirmColor: Color
  cancelColor: Color
  confirmBgColor: Color
  cancelBgColor: Color
  confirmFontSize: number
  cancelFontSize: number
  confirmButtonDisabled: boolean
  cancelButtonDisabled: boolean
  overlay: boolean
  overlayColor: ResourceColor
  // 是否在关闭时或者页面回退时自动关闭
  closeOnPopstate: boolean
  beforeClose?: () => boolean
  transition?: TransitionEffect
  confirm?: () => void
  cancel?: () => void
  onClose?: () => void
  open?: () => void
  close?: () => void
  opened?: () => void
  closed?: () => void
}
