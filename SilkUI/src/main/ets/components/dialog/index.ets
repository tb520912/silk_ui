import { ObjectUtils } from '../../utils/ObjectUtils'
import { SilkLoading } from '../loading'
export let bottomPaddingDefault: Padding = {
  top: 8,
  left: 24,
  right: 24,
  bottom: 16
}
export let headerPaddingDefault: Padding = {
  top: 26
}
export let contentPaddingDefault: Padding = {
  top: 8,
  left: 24,
  right: 24,
  bottom: 16
}
export let contentPaddingDefaultNoTitle: Padding = {
  top: 26,
  bottom: 26,
  left: 24,
  right: 24
}
export let defaultProps: SilkDialogProps = {
  title: '',
  titleSize: 16,
  titleColor:  $r('app.color.text_color'),
  message: '',
  messageColor: $r('app.color.gray_7'),
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
  buttonHeight: 48,
  linearGradient: undefined,
  confirmFontSize: 16,
  cancelFontSize: 16,
  confirmButtonDisabled: false,
  cancelButtonDisabled: false,
  hasDivider: true,
  showOverlay: true,
  overlayColor: 'rgba(0,0,0,0.7)',
  autoCancel: false,
  beforeClose: undefined,
  // 是否在关闭时或者页面回退时自动关闭
  closeOnPopstate: true,
  headerPadding: headerPaddingDefault,
  contentPadding: contentPaddingDefault,
  bottomPadding: bottomPaddingDefault,
  transition: undefined,
  confirm: undefined,
  cancel: undefined,
  customButton: undefined,
}

export let RoundButton: SilkDialogButton = {
  confirmBgColor: '#ee0a24',
  confirmColor: $r('app.color.van_white'),
  cancelBgColor: '#ff834f55',
  cancelColor: $r('app.color.van_white'),
  buttonHeight: 36,
  linearGradient: {
    angle: 90,
    colors: [
      ['#ff6034', 0],
      ['#ee0a24', 1]
    ]
  }
}
export let NormalButton: SilkDialogButton = {
  confirmColor: '#1989fa',
  cancelColor: $r('app.color.base_font_color3'),
  confirmBgColor: Color.Transparent,
  cancelBgColor: Color.Transparent,
  buttonHeight: 48,

}
@Component
export struct SilkDialog {
  // 控制弹框是否展示
  @Link
  @Watch('updateShow')
  show: boolean
  title: ResourceStr = ''
  titleSize: Length = 16
  titleColor: ResourceColor = $r('app.color.text_color')
  message: ResourceStr = ''
  messageColor: ResourceColor = $r('app.color.gray_7')
  messageAlign: 'left' | 'right' | 'center' = 'center'
  messageSize: Length = 14
  widthValue: Length = '80%'
  messageLineHeight: Length = 20
  theme: 'round-button' | 'default' = 'default'
  round: Length = 16
  bgcColor: ResourceColor = $r('app.color.white')
  showConfirm: boolean = true
  showCancel: boolean = false
  confirmText: ResourceStr = '确定'
  cancelText: ResourceStr = '取消'
  confirmColor?: ResourceColor = undefined
  cancelColor?: ResourceColor = undefined
  confirmBgColor?: ResourceColor = undefined
  cancelBgColor?: ResourceColor = undefined
  buttonHeight?: Length = undefined
  linearGradientValue?: LinearGradient = undefined
  confirmFontSize: Length = 16
  cancelFontSize: Length = 16
  @Prop
  confirmButtonDisabled: boolean = false
  @Prop
  cancelButtonDisabled: boolean = false
  hasDivider: boolean = true
  showOverlay: boolean = true
  overlayColor: ResourceColor = $r('app.color.overlay_bg')
  autoCancel: boolean = false
  beforeClose?: (action: 'confirm' | 'cancel') => (Promise<boolean> | boolean) = undefined
  closeOnPopstate: boolean = true
  headerPadding?: Padding = undefined
  contentPadding?: Padding = undefined
  bottomPadding?: Padding = undefined
  transitionValue?: TransitionEffects
  onConfirm: () => void = () => {this.show = false}
  onCancel: () => void = () => {this.show = false}
  customButton?: SilkCustomButton = undefined
  // 自定义内容
  @BuilderParam
  defaultComp: () => void
  // 自定义标题
  @BuilderParam
  titleComp: () => void
  // 自定义底部按钮
  @BuilderParam
  footerComp: () => void

  controller?: CustomDialogController

  callback (): void{
    // console.info(`navigation page switched, switchInfo: ${}`);
    this.show = false
  };
  showHandler() {
    this.controller?.open()
    this.show = true
  }

  async closeHandler(): Promise<void> {
      this.controller?.close()
      this.show = false
  }
  // 显示隐藏
  updateShow() {
    if (this.show) {
      this.showHandler()
      if (this.closeOnPopstate) {
        // 页面变化时关闭弹框
        this.getUIContext().getUIObserver().on('navDestinationSwitch',  () => this.callback())
      }
    } else {
      this.closeHandler()
      if (this.closeOnPopstate) {
        // 页面变化时关闭弹框
        this.getUIContext().getUIObserver().off('navDestinationSwitch', () => this.callback())
      }
    }
  }

  aboutToAppear(): void {
    if (!this.contentPadding) {
      this.contentPadding = this.title ? contentPaddingDefault : contentPaddingDefaultNoTitle
    }
    if (!this.headerPadding) {
      this.headerPadding = headerPaddingDefault
    }
    if (!this.bottomPadding) {
      this.bottomPadding = bottomPaddingDefault
    }
    if (!this.confirmColor) {
      this.confirmColor = this.theme === 'round-button' ? RoundButton.confirmColor : NormalButton.confirmColor
    }
    if (!this.confirmBgColor) {
      this.confirmBgColor = this.theme === 'round-button' ? RoundButton.confirmBgColor : NormalButton.confirmBgColor
    }
    if (!this.cancelBgColor) {
      this.cancelBgColor = this.theme === 'round-button' ? RoundButton.cancelBgColor : NormalButton.cancelBgColor
    }
    if (!this.cancelColor) {
      this.cancelColor = this.theme === 'round-button' ? RoundButton.cancelColor : NormalButton.cancelColor
    }
    if (!this.buttonHeight) {
      this.buttonHeight = this.theme === 'round-button' ? RoundButton.buttonHeight : NormalButton.buttonHeight
    }
    if (!this.linearGradientValue) {
      this.linearGradientValue = this.theme === 'round-button' ? RoundButton.linearGradient : NormalButton.linearGradient
    }
    this.controller = new CustomDialogController({
      builder: DialogComp({
        props: {
          title: this.title,
          titleSize: this.titleSize,
          titleColor: this.titleColor,
          message: this.message,

          messageColor: this.messageColor,
          messageSize: this.messageSize,

          widthValue: this.widthValue,
          messageAlign: this.messageAlign,
          messageLineHeight: this.messageLineHeight,
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
          linearGradient: this.linearGradientValue,
          confirmFontSize: this.confirmFontSize,
          cancelFontSize: this.cancelFontSize,
          confirmButtonDisabled: this.confirmButtonDisabled,
          cancelButtonDisabled: this.cancelButtonDisabled,
          buttonHeight: this.buttonHeight,
          hasDivider: this.hasDivider,
          showOverlay: this.showOverlay,
          overlayColor: this.overlayColor,
          // 是否在关闭时或者页面回退时自动关闭
          closeOnPopstate: this.closeOnPopstate,
          beforeClose: this.beforeClose,
          headerPadding: this.headerPadding,
          contentPadding: this.contentPadding,
          bottomPadding: this.bottomPadding,
          customButton: this.customButton,
          confirm: () => this.onConfirm(),
          cancel: () => this.onCancel()
        },
        title: this.titleComp ? () => this.titleComp() : undefined,
        default: this.defaultComp ? () => this.defaultComp() : undefined,
        footer: this.footerComp ? () => this.footerComp() : undefined
      }),
      alignment: DialogAlignment.Center,
      customStyle: true
    })
  }
  build() {

  }
}
@CustomDialog
@Component
export struct DialogComp {
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
  @State
  private cancelLoading: boolean = false
  @State
  private okLoading: boolean = false
  build() {
    Column(){
      this.HeaderBuilder()
      Column(){
        this.ContentBuilder()
      }
      .constraintSize({
        minHeight: !this.props.title ? 104 : undefined
      })
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
        .fontSize(this.props.titleSize)
        .fontWeight(600)
        .lineHeight(24)
        .fontColor(this.props.titleColor)
        .padding(this.props.headerPadding)
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
        .fontSize(this.props.messageSize)
        .lineHeight(this.props.messageLineHeight)
        .fontColor(this.props.messageColor)
        .textAlign(this.getContentAlign())
        .padding(this.props.contentPadding)
      }
    }

  @Builder
  FooterBuilder () {
    if (this.footer) {
      this.footer()
    } else if (this.props.showConfirm || this.props.showCancel) {
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
            .onClick(async () => {
              if (this.props.beforeClose) {
                await this.props.beforeClose('confirm')
              }
              this.props.confirm && this.props.confirm()
            })
            .width(this.props.customButton?.width || '100%')
            .height(this.props.customButton?.height || this.props.buttonHeight)
            .borderRadius(this.props.customButton?.borderRadius || 0)
            .linearGradient(this.props.linearGradient ? this.props.linearGradient : undefined)
        } else {
          Stack(){
            if (!this.cancelLoading) {
              Button(this.props.cancelText)
                .type(ButtonType.Normal)
                .backgroundColor(this.props.cancelBgColor)
                .fontSize(this.props.cancelFontSize)
                .fontColor(this.props.cancelColor)
                .onClick(async () => {
                  if (this.props.beforeClose) {
                    this.cancelLoading = true
                    await this.props.beforeClose('cancel')
                    this.cancelLoading = false
                  }
                  this.props.cancel && this.props.cancel()
                })
                .layoutWeight(1)
                .height(this.props.customButton?.height || this.props.buttonHeight)
                .enabled(!this.props.cancelButtonDisabled)
            } else {
              SilkLoading({
                sizeValue: 20
              })
            }
          }
          .layoutWeight(1)
          .height(this.props.customButton?.height || this.props.buttonHeight)
          Divider()
            .vertical(true)
            .strokeWidth('1px')
            .color('#ebedfo')
            .height(this.props.customButton?.height || this.props.buttonHeight)
          Stack(){
            if (!this.okLoading) {
              Button(this.props.confirmText)
                .type(ButtonType.Normal)
                .backgroundColor(this.props.confirmBgColor)
                .fontSize(this.props.confirmFontSize)
                .fontColor(this.props.confirmColor)
                .onClick(async () => {
                  if (this.props.beforeClose) {
                    this.okLoading = true
                    await this.props.beforeClose('confirm')
                    this.okLoading = false
                  }
                  this.props.confirm && this.props.confirm()
                })
                .layoutWeight(1)
                .height(this.props.customButton?.height || this.props.buttonHeight)
                .enabled(!this.props.confirmButtonDisabled)
            } else {
              SilkLoading({
                sizeValue: 20,
                color: this.props.confirmColor
              })
            }
          }
          .layoutWeight(1)
          .height(this.props.customButton?.height || this.props.buttonHeight)
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
export interface SilkDialogButton {
  confirmColor?: ResourceColor
  cancelColor?: ResourceColor
  confirmBgColor?: ResourceColor
  cancelBgColor?: ResourceColor
  buttonHeight?: Length
  linearGradient?: LinearGradient
}
export interface SilkDialogProps extends SilkDialogButton {
  title?: ResourceStr
  titleSize?: Length//
  titleColor?: ResourceColor//
  message?: ResourceStr
  messageSize?: Length//
  messageColor?: ResourceColor//
  messageAlign?: 'left' | 'right' | 'center'
  messageLineHeight?: Length//
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
  confirmFontSize?: Length
  cancelFontSize?: Length
  confirmButtonDisabled?: boolean
  cancelButtonDisabled?: boolean
  buttonHeight?: Length//
  hasDivider?: boolean//
  showOverlay?: boolean
  autoCancel?: boolean // 点击遮罩是否关闭 默认不关//
  overlayColor?: ResourceColor
  // 是否在关闭时或者页面回退时自动关闭
  closeOnPopstate?: boolean
  beforeClose?: (action: 'cancel' | 'confirm') => (boolean | Promise<boolean>)
  transition?: TransitionEffect
  confirm?: () => void
  cancel?: () => void
  customButton?: SilkCustomButton,//
  headerPadding?: Padding//
  contentPadding?: Padding//
  bottomPadding?: Padding//
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
  contentPadding?: Padding, bottomPadding?: Padding, RoundButtonCus?: SilkDialogButton, NormalButtonCus?: SilkDialogButton) {
  defaultProps = ObjectUtils.assign<SilkDialogProps>(defaultProps, props || defaultProps)
  headerPaddingDefault = ObjectUtils.assign<Padding>(headerPaddingDefault, headerPadding || headerPaddingDefault)
  contentPaddingDefault = ObjectUtils.assign<Padding>(contentPaddingDefault, contentPadding || contentPaddingDefault)
  bottomPaddingDefault = ObjectUtils.assign<Padding>(bottomPaddingDefault, bottomPadding || bottomPaddingDefault)
  RoundButton = RoundButtonCus || RoundButton
  NormalButton = NormalButtonCus || NormalButton
}