import { BorderRadiuses } from '@ohos.arkui.node'
import { ObjectUtils } from '../../utils/ObjectUtils'

let controller: CustomDialogController | null
let bottomPaddingDefault: Padding = {
  top: 8,
  left: 24,
  right: 24,
  bottom: 16
}
let headerPaddingDefault: Padding = {
  top: 26
}
let contentPaddingDefault: Padding = {
  top: 8,
  left: 24,
  right: 24,
  bottom: 16
}
let circleButtonHeightDefault: number = 38
let defaultButtonHeightDefault: number = 48
let defaultProps: SilkDialogProps = {
  title: '',
  titleSize: 16,
  titleColor: '#323233',
  message: '',
  messageColor: '#646566',
  messageSize: 14,
  widthValue: '80%',
  messageAlign: 'center',
  messageLineHeight: 20,
  // 圆角按钮
  theme: 'default',
  round: 16,
  // 对话框颜色
  bgcColor: $r('app.color.white'),
  showConfirm: true,
  showCancel: false,
  confirmText: '确定',
  cancelText: '取消',
  confirmColor: '#1989fa',
  cancelColor: $r('app.color.base_font_color3'),
  confirmBgColor: Color.Transparent,
  cancelBgColor: Color.Transparent,
  confirmFontSize: 16,
  cancelFontSize: 16,
  confirmButtonDisabled: false,
  cancelButtonDisabled: false,
  buttonHeight: 48,
  hasDivider: true,
  showOverlay: true,
  overlayColor: 'rgba(0,0,0,0.7)',
  // 是否在关闭时或者页面回退时自动关闭
  closeOnPopstate: true,
  headerPadding: headerPaddingDefault,
  contentPadding: contentPaddingDefault,
  bottomPadding: bottomPaddingDefault
}

@Component
struct SilkDialogFunction {
  // 控制弹框是否展示
  // show: boolean = false


  _mounted(props: SilkDialogProps) {
    props = ObjectUtils.assign<SilkDialogProps>(defaultProps, props)
    props.buttonHeight =
      props.buttonHeight || props.theme === 'default' ? defaultButtonHeightDefault : circleButtonHeightDefault

    props.confirm = props.confirm || (() => {
      controller?.close()
    })
    props.cancel = props.cancel || (() => {
      controller?.close()
    })

    controller = new CustomDialogController({
      builder: DialogComp({
        props: {
          title: props.title,
          titleSize: props.titleSize,
          titleColor: props.titleColor,
          message: props.message,

          messageColor: props.messageColor,
          messageSize: props.messageSize,

          widthValue: props.widthValue,
          messageAlign: props.messageAlign,
          messageLineHeight: props.messageLineHeight,
          theme: props.theme,
          round: props.round,
          bgcColor: props.bgcColor,
          showConfirm: props.showConfirm,
          showCancel: props.showCancel,

          confirmText: props.confirmText,
          cancelText: props.cancelText,
          confirmColor: props.confirmColor,
          cancelColor: props.cancelColor,
          confirmBgColor: props.confirmBgColor,
          cancelBgColor: props.cancelBgColor,

          confirmFontSize: props.confirmFontSize,
          cancelFontSize: props.cancelFontSize,
          confirmButtonDisabled: props.confirmButtonDisabled,
          cancelButtonDisabled: props.cancelButtonDisabled,
          buttonHeight: props.buttonHeight,
          hasDivider: props.hasDivider,
          showOverlay: props.showOverlay,
          overlayColor: props.overlayColor,
          // 是否在关闭时或者页面回退时自动关闭
          closeOnPopstate: props.closeOnPopstate,
          headerPadding: props.headerPadding,
          contentPadding: props.contentPadding,
          bottomPadding: props.bottomPadding,
          customButton: props.customButton,
          confirm: () => props.confirm!(),
          cancel: () => props.cancel!()
        }
      }),
      alignment: DialogAlignment.Center,
      customStyle: true
    })
    controller?.open()
  }

  callback(): void {
    // console.info(`navigation page switched, switchInfo: ${}`);
    // this.show = false
  };

  showHandler() {
    controller?.open()
    // this.show = true
  }

  async closeHandler(): Promise<void> {
    controller?.close()
    // this.show = false
  }

  // 显示隐藏
  // updateShow() {
  //   if (this.show) {
  //     this.showHandler()
  //     if (this.close_on_pop_state) {
  //       // 页面变化时关闭弹框
  //       this.getUIContext().getUIObserver().on('navDestinationSwitch', () => this.callback())
  //     }
  //   } else {
  //     this.closeHandler()
  //     if (this.close_on_pop_state) {
  //       // 页面变化时关闭弹框
  //       this.getUIContext().getUIObserver().off('navDestinationSwitch', () => this.callback())
  //     }
  //   }
  // }

  build() {

  }
}

@CustomDialog
@Component
struct DialogComp {
  controller: CustomDialogController
  @Prop
  props: SilkDialogProps

  build() {
    Column() {
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
  HeaderBuilder() {
    if (this.props.title) {
      Text(this.props.title)
        .width('100%')
        .fontSize(this.props.titleSize)
        .fontWeight(600)
        .lineHeight(24)
        .fontColor(this.props.titleColor)
        .padding(headerPaddingDefault)
        .textAlign(TextAlign.Center)
    }
  }

  @Builder
  ContentBuilder() {
    Text(this.props.message)
      .width('100%')
      .fontSize(this.props.messageSize)
      .lineHeight(this.props.messageLineHeight)
      .fontColor(this.props.messageColor)
      .textAlign(this.getContentAlign())
      .padding(contentPaddingDefault)
  }

  @Builder
  FooterBuilder() {
    if (this.props.showConfirm || this.props.showCancel) {
      Row() {
        // 只有一个确认按钮
        if (!this.props.showCancel && this.props.showConfirm) {
          Button(this.props.confirmText,
            {
              type: this.props.customButton?.type ||
                (this.props.theme === 'round-button' ? ButtonType.Capsule : ButtonType.Normal)
            })
            .backgroundColor(this.props.customButton?.backgroundColor || this.props.confirmBgColor)
            .fontSize(this.props.customButton?.fontSize || this.props.confirmFontSize)
            .fontColor(this.props.customButton?.fontColor || this.props.confirmColor)
            .onClick(() => {
              this.props.confirm && this.props.confirm()
            })
            .width(this.props.customButton?.width || '100%')
            .height(this.props.customButton?.height || this.props.buttonHeight)
            .borderRadius(this.props.customButton?.borderRadius || 0)
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
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .border({
        width: {
          top: (this.props.theme === 'default' && this.props.hasDivider) ? '1px' : 0
        },
        color: '#ebedf0'
      })
      .padding(this.props.theme === 'default' ? 0 : bottomPaddingDefault)
    }
  }

  getContentAlign(): TextAlign {
    if (this.props.messageAlign === 'left') {
      return TextAlign.Start
    } else if (this.props.messageAlign === 'right') {
      return TextAlign.End
    } else {
      return TextAlign.Center
    }
  }
}

interface SilkDialogProps {
  title?: ResourceStr
  titleSize?: number
  titleColor?: ResourceColor
  message?: ResourceStr
  messageSize?: number
  messageColor?: ResourceColor
  messageAlign?: 'left' | 'right' | 'center'
  messageLineHeight?: Length
  widthValue?: Length
  round?: Length | BorderRadiuses
  // 对话框颜色
  bgcColor?: ResourceColor
  // 圆角按钮
  theme?: 'round-button' | 'default' | 'custom'
  showConfirm?: boolean
  showCancel?: boolean
  confirmText?: ResourceStr
  cancelText?: ResourceStr
  confirmColor?: ResourceColor
  confirmBgColor?: ResourceColor
  cancelColor?: ResourceColor
  cancelBgColor?: ResourceColor
  confirmFontSize?: number
  cancelFontSize?: number
  confirmButtonDisabled?: boolean
  cancelButtonDisabled?: boolean
  buttonHeight?: Length
  hasDivider?: boolean
  showOverlay?: boolean
  overlayColor?: ResourceColor
  // 是否在关闭时或者页面回退时自动关闭
  closeOnPopstate?: boolean
  beforeClose?: () => boolean
  transition?: TransitionEffect
  confirm?: () => void
  cancel?: () => void
  customButton?: SilkCustomButton,
  headerPadding?: Padding
  contentPadding?: Padding
  bottomPadding?: Padding

}

// 自定义按钮
export interface SilkCustomButton {
  fontSize?: Length
  type?: ButtonType
  fontColor?: ResourceColor
  width?: Length
  height?: Length
  borderRadius?: number
  backgroundColor?: ResourceColor
}

export function ShowSilkDialog(props: SilkDialogProps) {
  const comp = new SilkDialogFunction()
  comp._mounted(props)
}

export function ShowSilkConfirmDialog(props: SilkDialogProps) {
  if (props.showCancel === undefined) {
    props.showCancel = true
  }
  new SilkDialogFunction()._mounted(props)
}

export function resetDialogDefaultOptions() {
  bottomPaddingDefault = {
    top: 8,
    left: 24,
    right: 24,
    bottom: 16
  }
  headerPaddingDefault = {
    top: 26
  }
  contentPaddingDefault = {
    top: 8,
    left: 24,
    right: 24,
    bottom: 16
  }
  circleButtonHeightDefault = 38
  defaultButtonHeightDefault = 48
  defaultProps = {
    titleSize: 16,
    titleColor: '#323233',
    messageColor: '#646566',
    messageSize: 14,
    widthValue: '80%',
    messageAlign: 'center',
    messageLineHeight: 20,
    // 圆角按钮
    theme: 'default',
    round: 16,
    // 对话框颜色
    bgcColor: $r('app.color.white'),
    showConfirm: true,
    showCancel: false,
    confirmText: '确定',
    cancelText: '取消',
    confirmColor: '#1989fa',
    cancelColor: $r('app.color.base_font_color3'),
    confirmBgColor: Color.Transparent,
    buttonHeight: 48,
    hasDivider: true,
    cancelBgColor: Color.Transparent,
    confirmFontSize: 16,
    cancelFontSize: 16,
    confirmButtonDisabled: false,
    cancelButtonDisabled: false,
    showOverlay: true,
    overlayColor: 'rgba(0,0,0,0.7)',
    // 是否在关闭时或者页面回退时自动关闭
    closeOnPopstate: true,
  }
}

export function setDialogDefaultOptions(props?: SilkDialogProps, headerPadding?: Padding,
  contentPadding?: Padding, bottomPadding?: Padding, circleButtonHeight?: number, defaultButtonHeight?: number) {
  defaultProps = ObjectUtils.assign<SilkDialogProps>(defaultProps, props || defaultProps)
  headerPaddingDefault = ObjectUtils.assign<Padding>(headerPaddingDefault, headerPadding || headerPaddingDefault)
  contentPaddingDefault = ObjectUtils.assign<Padding>(contentPaddingDefault, contentPadding || contentPaddingDefault)
  bottomPaddingDefault = ObjectUtils.assign<Padding>(bottomPaddingDefault, bottomPadding || bottomPaddingDefault)
  circleButtonHeightDefault = circleButtonHeight || circleButtonHeightDefault
  defaultButtonHeightDefault = defaultButtonHeight || defaultButtonHeightDefault
}