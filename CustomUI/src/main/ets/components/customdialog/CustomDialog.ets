@Component
export struct CustomDialogBox {
  @State message: string = 'Hello World';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
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
    }
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
        if (this.props.showCancel) {
          Button(this.props.cancelText || '取消')
            .width('100%')
            .height(48)
            .fontSize(16)
            .fontColor(this.props.cancelColor || $r('app.color.base_font_color3'))
            .backgroundColor(this.props.cancelBgColor || $r('app.color.base_bg_color'))
            .borderRadius(this.props.round || 8)
            .onClick(() => {
              this.controller.close()
            })
        }
      }
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
  message?: ResourceStr
  title?: ResourceStr
  width?: Length
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
  confirmColor?: Color
  cancelColor?: Color
  confirmBgColor?: Color
  cancelBgColor?: Color
  confirmFontSize?: number
  cancelFontSize?: number
  confirmButtonDisabled?: boolean
  cancelButtonDisabled?: boolean
  overlay?: boolean
  overlayColor?: ResourceColor
  // 是否在关闭时或者页面回退时自动关闭
  closeOnPopstate?: boolean
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
