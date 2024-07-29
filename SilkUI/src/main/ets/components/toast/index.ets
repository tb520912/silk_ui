import { Context } from '@kit.AbilityKit'

export enum MessageDialogType {
  WARN = 'warn',
  ERROR = 'error',
  SUCCESS = 'success',
  TOAST = 'toast'
}

interface MessageDialogProps {
  message: ResourceStr
  duration?: number
  showIcon?: boolean
  icon?: ResourceStr
  showPosition?: 'top' | 'center' | 'bottom'
}

let controller: CustomDialogController | null

@Component
struct ToastDialog {
  _mounted(props: MessageDialogProps, type: MessageDialogType) {
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
    }, props.duration ?? type === MessageDialogType.ERROR ? 30000 : 3000)
  }

  success(props: MessageDialogProps | ResourceStr) {
    if (Object.keys(props).includes('message')) {
      this._mounted(props as MessageDialogProps, MessageDialogType.SUCCESS)
    } else {
      this._mounted({
        message: props as ResourceStr
      }, MessageDialogType.SUCCESS)
    }
    // if (typeof props === 'string') {
    //   this._mounted({
    //     message: props
    //   }, MessageDialogType.SUCCESS)
    //   return
    // } else {
    //   this._mounted(props, MessageDialogType.SUCCESS)
    // }

  }

  error(props: MessageDialogProps | ResourceStr) {
    if (Object.keys(props).includes('message')) {
      this._mounted(props as MessageDialogProps, MessageDialogType.ERROR)
    } else {
      this._mounted({
        message: props as ResourceStr
      }, MessageDialogType.ERROR)
    }
  }

  toast(props: MessageDialogProps | ResourceStr) {
    if (Object.keys(props).includes('message')) {
      this._mounted(props as MessageDialogProps, MessageDialogType.TOAST)
    } else {
      this._mounted({
        message: props as ResourceStr
      }, MessageDialogType.TOAST)
    }
  }

  warn(props: MessageDialogProps | ResourceStr) {
    if (Object.keys(props).includes('message')) {
      this._mounted(props as MessageDialogProps, MessageDialogType.WARN)
    } else {
      this._mounted({
        message: props as ResourceStr
      }, MessageDialogType.WARN)
    }
  }

  getAlign(showPosition: 'top' | 'center' | 'bottom'): DialogAlignment {
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
  message: ResourceStr = ''

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

  aboutToAppear(): void {
    inited = true
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
  static ToastComponent: ToastDialog | null = null

  static init(context?: Context) {
    if (!getContext() && !context) {
      return;
    }
    ToastClass.ToastComponent = new ToastDialog()
  }
}

let inited: boolean = false

export class SilkToast {
  static success(props: MessageDialogProps | ResourceStr) {
    if (!ToastClass.ToastComponent || !inited) {
      ToastClass.init()
    }
    ToastClass.ToastComponent?.success(props)
  }

  static error(props: MessageDialogProps | ResourceStr) {
    if (!ToastClass.ToastComponent || !inited) {
      ToastClass.init()
    }
    ToastClass.ToastComponent?.error(props)
  }

  static toast(props: MessageDialogProps | ResourceStr) {
    if (!ToastClass.ToastComponent || !inited) {
      ToastClass.init()
    }
    ToastClass.ToastComponent?.toast(props)
  }

  static warn(props: MessageDialogProps | ResourceStr) {
    if (!ToastClass.ToastComponent || !inited) {
      ToastClass.init()
    }
    ToastClass.ToastComponent?.warn(props)
  }

  static init(context?: Context) {
    inited = true
    ToastClass.init(context)
  }
}
