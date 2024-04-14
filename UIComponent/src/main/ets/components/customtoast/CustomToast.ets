
export enum MessageDialogType {
  WARN = 'warn',
  ERROR = 'error',
  SUCCESS = 'success',
  TOAST = 'toast'
}
interface MessageDialogProps {
  message: string
  duration?: number
  showIcon?: boolean
  icon?: ResourceStr
  showPosition?: 'top' | 'center' | 'bottom'
}
let controller: CustomDialogController | null
@Component
struct ToastDialog {


  _mounted (props: MessageDialogProps, type: MessageDialogType) {
    controller = new CustomDialogController({
      builder: CusDialog({
        message: props.message,
        showIcon: props.showIcon ?? true,
        icon: props.icon ?? '',
        type: type
      }),
      customStyle: true,
      autoCancel: true,
      alignment: (() => this.getAlign(props.showPosition || 'center'))(),
      maskColor: Color.Transparent
    })
    controller.open()
    setTimeout(() => {
      controller?.close()
    }, props.duration ?? 2000)
  }

  success (props: MessageDialogProps) {
    this._mounted(props, MessageDialogType.SUCCESS)
  }

  error (props: MessageDialogProps) {
    this._mounted(props, MessageDialogType.ERROR)
  }

  toast (props: MessageDialogProps) {
    this._mounted(props, MessageDialogType.TOAST)
  }
  warn (props: MessageDialogProps) {
    this._mounted(props, MessageDialogType.WARN)
  }

  getAlign (showPosition: 'top' | 'center' | 'bottom'): DialogAlignment {
    switch (showPosition) {
      case 'top':
        return DialogAlignment.Top
      case 'center':
        return DialogAlignment.Center
      case 'bottom':
        return DialogAlignment.Bottom
    }
  }
  build() {
  }

}

@CustomDialog
struct CusDialog {
  controller: CustomDialogController

  type: MessageDialogType = MessageDialogType.SUCCESS
  showIcon: boolean = true
  icon: ResourceStr = ''
  message: string = ''


  getImage(): ResourceStr {
    if (this.icon) {
      return this.icon
    }
    switch (this.type) {
      case MessageDialogType.WARN:
        return $r('app.media.ic_public_warn')
      case MessageDialogType.ERROR:
        return $r('app.media.ic_public_error')
      case MessageDialogType.SUCCESS:
        return $r('app.media.ic_public_success')
      case MessageDialogType.TOAST:
        return ''
      default:
        return ''
    }
  }
  build() {
    this.SuccessBuilder()
  }
  @Builder
  SuccessBuilder(): void {
    Column({ space: 8 }) {
      if (this.showIcon) {
        Image(this.getImage())
          .width(36)
          .height(36)
      }
      Text(this.message)
        .fontSize(14)
        .fontColor($r('app.color.white'))
    }
    .padding(16)
    .borderRadius(8)
    .backgroundColor('#ff858282')
    .constraintSize({
      minWidth: '33.33%',
      maxWidth: '72%',
      maxHeight: '70%'
    })
  }
}

class ToastClass {
  ToastComponent: ToastDialog = new ToastDialog()
}
export const CustomToast = new ToastClass().ToastComponent
