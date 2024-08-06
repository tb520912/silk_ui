import {
  contentPaddingDefault, contentPaddingDefaultNoTitle, defaultProps,
  NormalButton,
  RoundButton,
  DialogComp, SilkDialogProps } from '.'
import { ObjectUtils } from '../../utils/ObjectUtils'


let controller: CustomDialogController | null

@Component
struct SilkDialogFunction {
  // 控制弹框是否展示
  // show: boolean = false


  _mounted(props: SilkDialogProps) {

    props = ObjectUtils.assign<SilkDialogProps>(defaultProps, props, {
      contentPadding: props.title ? contentPaddingDefault : contentPaddingDefaultNoTitle
    }, (props.theme === 'round-button' ? RoundButton : NormalButton) as SilkDialogProps)

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
          linearGradient: props.linearGradient,
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
          beforeClose: props.beforeClose,
          headerPadding: props.headerPadding,
          contentPadding: props.contentPadding,
          bottomPadding: props.bottomPadding,
          customButton: props.customButton,
          confirm: () => props.confirm!(),
          cancel: () => props.cancel!()
        }
      }),
      alignment: DialogAlignment.Center,
      customStyle: true,
      autoCancel: props.autoCancel
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

