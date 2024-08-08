import { Context } from '@kit.AbilityKit'
import { SilkLoading } from '../loading'

export enum MessageDialogType {
  WARN = 'warn',
  ERROR = 'error',
  SUCCESS = 'success',
  TOAST = 'toast',
  LOADING = 'loading'
}

interface MessageDialogProps {
  message: ResourceStr
  duration?: number
  showIcon?: boolean
  icon?: ResourceStr
  loadingType?: 'circular' | 'spinner'
  showPosition?: 'top' | 'center' | 'bottom'
  wordBreak?: WordBreak,
  forbidClick?: boolean // 禁止背景点击
}
@Observed
export class ToastDynamicMessage {
  message: ResourceStr = ''

  constructor(message: ResourceStr) {
    this.message = message
  }
}
let dynamicMessage = new ToastDynamicMessage('')
let controller: CustomDialogController | null

@Component
struct ToastDialog {
  _mounted(props: MessageDialogProps, type: MessageDialogType) {
    controller = new CustomDialogController({
      builder: CusDialog({
        message: props.message,
        showIcon: props.showIcon ?? true,
        icon: props.icon ?? '',
        type: type,
        loadingType: props.loadingType,
        wordBreak: props.wordBreak,
        duration: props.duration
      }),
      customStyle: true,
      autoCancel: !props.forbidClick,
      alignment: (() => this.getAlign(props.showPosition || 'center'))(),
      offset: {
        dy: props.showPosition === 'top' ? '20%' : props.showPosition === 'bottom' ? '-20%' : 0,
        dx: 0
      },
      maskColor: Color.Transparent
    })
    controller.open()
    if (props.duration === 0) {

    } else {
      setTimeout(() => {
        controller?.close()
      }, props.duration ?? type === MessageDialogType.ERROR ? 30000 : 3000)
    }
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
        message: props as ResourceStr,
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

  loading(props: MessageDialogProps | ResourceStr) {
    if (Object.keys(props).includes('message')) {
      dynamicMessage.message = (props as MessageDialogProps).message
      this._mounted(props as MessageDialogProps, MessageDialogType.LOADING)
    } else {
      dynamicMessage.message = props as ResourceStr
      this._mounted({
        message: props as ResourceStr
      }, MessageDialogType.LOADING)
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
  @State
  dynamicMessage: ToastDynamicMessage = dynamicMessage
  controller: CustomDialogController
  type: MessageDialogType = MessageDialogType.SUCCESS
  showIcon: boolean = true
  icon: ResourceStr = ''
  message: ResourceStr = ''
  loadingType: 'circular' | 'spinner' = 'circular'
  wordBreak?: WordBreak
  duration?: number = 3000
  getImage(): ResourceStr {
    if (this.icon) {
      return this.icon
    }
    switch (this.type) {
      case MessageDialogType.WARN:
        return $r('app.media.warning')
      case MessageDialogType.ERROR:
        return $r('app.media.fail')
      case MessageDialogType.SUCCESS:
        return $r('app.media.success')
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
      if (this.showIcon && this.getImage()) {
        Image(this.getImage())
          .width(36)
          .height(36)
          .fillColor('#fff')
      }
      if (this.type === MessageDialogType.LOADING) {
        Row(){
          SilkLoading({
            color: '#fff',
            sizeValue: 30,
            type: this.loadingType || 'circular'
          })
        }
        .padding(4)
      }
      Text(this.duration === 0 ? this.dynamicMessage.message : this.message)
        .fontSize(14)
        .fontColor($r('app.color.white'))
        .wordBreak(this.wordBreak)
        .textAlign(TextAlign.Center)
    }
    .padding({
      top: ((this.showIcon && this.getImage()) || this.type === MessageDialogType.LOADING )? 16 : 10,
      bottom: ((this.showIcon && this.getImage()) || this.type === MessageDialogType.LOADING ) ? 16 : 10,
      left: ((this.showIcon && this.getImage()) || this.type === MessageDialogType.LOADING ) ? 16 : 12,
      right: ((this.showIcon && this.getImage()) || this.type === MessageDialogType.LOADING ) ? 16 : 12
    })
    .borderRadius(8)
    .backgroundColor($r('app.color.overlay_bg'))
    .constraintSize({
      minWidth: 96,
      maxWidth: '72%',
      minHeight: this.showIcon && this.getImage() ? 88 : 0,
      maxHeight: '70%'
    })
  }
}

class ToastClass {
  static ToastComponent: ToastDialog | null = null
  dynamicMessage: ToastDynamicMessage | null = null
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
  static loading(props: MessageDialogProps | ResourceStr, dynamicMessageObj?: ToastDynamicMessage): ToastDynamicMessage {
    dynamicMessage = dynamicMessageObj || new ToastDynamicMessage('')

    if (!ToastClass.ToastComponent || !inited) {
      ToastClass.init()
    }
    ToastClass.ToastComponent!.loading(props)
    return dynamicMessage
  }
  static closeToast () {
    controller?.close()
  }

  static init(context?: Context) {
    inited = true
    ToastClass.init(context)
  }
}


