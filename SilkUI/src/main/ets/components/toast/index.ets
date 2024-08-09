import { Context } from '@kit.AbilityKit'
import { ObjectUtils } from '../../utils/ObjectUtils'
import { SilkLoading } from '../loading'

export enum SilkToastType {
  WARN = 'warn',
  ERROR = 'error',
  SUCCESS = 'success',
  TOAST = 'toast',
  LOADING = 'loading'
}
interface SilkToastStyle {
  padding?: Padding | number
  backgroundColor?: ResourceColor
  radius?: Length,
  fillColor?: ResourceColor
}
interface SilkToastProps {
  message?: ResourceStr
  duration?: number
  showIcon?: boolean
  icon?: ResourceStr
  iconSize?: Length
  loadingSize?: Length
  overlay?: boolean
  loadingType?: 'circular' | 'spinner'
  showPosition?: 'top' | 'center' | 'bottom'
  wordBreak?: WordBreak,
  forbidClick?: boolean // 禁止背景点击
  toastType?: SilkToastType
  closeOnClick?: boolean // 是否在点击后关闭
  closeOnClickOverlay?: boolean
  onClose?: Function,
  onOpened?: Function,
  offset?: Length
}

class ToastDynamicController {
  setMessage?: (message: ResourceStr) => void
}
let controller: CustomDialogController | null
let DEFAULT_PROP: SilkToastProps = {
  message: '',
  duration: 3000,
  showIcon: undefined,
  icon: undefined,
  iconSize: 36,
  overlay: false,
  loadingSize: 30,
  loadingType: undefined,
  showPosition: 'center',
  wordBreak: WordBreak.BREAK_ALL,
  forbidClick: false,
  toastType: SilkToastType.TOAST,
  closeOnClick: false,
  closeOnClickOverlay: false,
  onClose: undefined,
  onOpened: undefined,
  offset: '20%'
}
let DEFAULT_STYLE: SilkToastStyle = {
  radius: 8,
  backgroundColor: $r('app.color.overlay_bg'),
  fillColor: $r('app.color.white')
}
let DEFAULT_TEXT_PADDING: Padding = {
  top: 10,
  bottom: 10,
  left: 12,
  right: 12
}
let DEFAULT_IMAGE_PADDING: Padding = {
  top: 16,
  left: 16,
  bottom: 16,
  right: 16
}
let CONSTRAINT_SIZE_TEXT: ConstraintSizeOptions = {
  minWidth: 96,
  maxWidth: '72%',
  minHeight: 0,
  maxHeight: '70%'
}
let CONSTRAINT_SIZE_IMAGE: ConstraintSizeOptions = {
  minWidth: 96,
  maxWidth: '72%',
  minHeight: 88,
  maxHeight: '70%'
}
// 单例模式
let isSingleton: boolean = true
@Component
struct ToastDialog {
  _mounted(props: SilkToastProps, type: SilkToastType, toastController?: ToastDynamicController) {
    const prop = ObjectUtils.assign(DEFAULT_PROP, props, {toastType:type})
    if (controller && isSingleton) {
      controller.close()
      controller = null
    }
    controller = new CustomDialogController({
      builder: CusDialog({
        message: prop.message,
        showIcon: prop.showIcon ?? true,
        icon: prop.icon ?? '',
        iconSize: prop.iconSize,
        type: type,
        loadingType: prop.loadingType,
        loadingSize: prop.loadingSize,
        wordBreak: prop.wordBreak,
        duration: prop.duration,
        toastController: toastController,
        onOpened: prop.onOpened,
        onClose: prop.onClose
      }),
      customStyle: true,
      autoCancel: this.getAutoCancel(prop),
      alignment: (() => this.getAlign(prop.showPosition || 'center'))(),
      offset: {
        dy: prop.showPosition === 'top' ? prop.offset! : prop.showPosition === 'bottom' ? `-${prop.offset}` : 0,
        dx: 0
      },
      isModal: prop.overlay
    })
    controller.open()
    if (prop.duration === 0) {

    } else {
      setTimeout(() => {
        controller?.close()
      }, prop.duration ?? type === SilkToastType.ERROR ? 30000 : 3000)
    }
  }

  success(props: SilkToastProps | ResourceStr) {
    if (Object.keys(props).includes('message')) {
      this._mounted(props as SilkToastProps, SilkToastType.SUCCESS)
    } else {
      this._mounted({
        message: props as ResourceStr
      }, SilkToastType.SUCCESS)
    }

    // if (typeof props === 'string') {
    //   this._mounted({
    //     message: props
    //   }, SilkToastType.SUCCESS)
    //   return
    // } else {
    //   this._mounted(props, SilkToastType.SUCCESS)
    // }

  }

  error(props: SilkToastProps | ResourceStr) {
    if (Object.keys(props).includes('message')) {
      this._mounted(props as SilkToastProps, SilkToastType.ERROR)
    } else {
      this._mounted({
        message: props as ResourceStr
      }, SilkToastType.ERROR)
    }
  }

  toast(props: SilkToastProps | ResourceStr) {
    if (Object.keys(props).includes('message')) {
      this._mounted(props as SilkToastProps, SilkToastType.TOAST)
    } else {
      this._mounted({
        message: props as ResourceStr,
      }, SilkToastType.TOAST)
    }
  }

  warn(props: SilkToastProps | ResourceStr) {
    if (Object.keys(props).includes('message')) {
      this._mounted(props as SilkToastProps, SilkToastType.WARN)
    } else {
      this._mounted({
        message: props as ResourceStr
      }, SilkToastType.WARN)
    }
  }

  loading(props: SilkToastProps | ResourceStr, controller?: ToastDynamicController) {
    if (Object.keys(props).includes('message')) {
      this._mounted(props as SilkToastProps, SilkToastType.LOADING, controller)
    } else {
      this._mounted({
        message: props as ResourceStr
      }, SilkToastType.LOADING, controller)
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
  getAutoCancel (props: SilkToastProps): boolean {
    if (props?.forbidClick) {
      return false
    } else {
      if (props?.closeOnClickOverlay) {
        return true
      } else {
        return false
      }
    }
  }

  build() {
  }
}

@CustomDialog
struct CusDialog {
  @State
  toastController: ToastDynamicController = new ToastDynamicController()
  controller: CustomDialogController
  type: SilkToastType = SilkToastType.SUCCESS
  showIcon: boolean = true
  icon: ResourceStr = ''
  @State
  message: ResourceStr = ''
  loadingType: 'circular' | 'spinner' = 'circular'
  loadingSize?: Length
  wordBreak?: WordBreak
  duration?: number = 3000
  iconSize?: Length
  style?: SilkToastStyle
  closeOnClick?: boolean
  @BuilderParam
  children: () => void
  onClose?: Function
  onOpened?: Function
  getImage(): ResourceStr {
    if (this.icon) {
      return this.icon
    }
    switch (this.type) {
      case SilkToastType.WARN:
        return $r('app.media.warning')
      case SilkToastType.ERROR:
        return $r('app.media.fail')
      case SilkToastType.SUCCESS:
        return $r('app.media.success')
      case SilkToastType.TOAST:
        return ''
      default:
        return ''
    }
  }

  aboutToAppear(): void {
    inited = true
    this.toastController.setMessage = (message: ResourceStr) => {
      this.message = message
    }
  }

  build() {
    Column({ space: 8 }) {
      if (this.children) {
        this.children()
      } else {
        if (this.showIcon && this.getImage()) {
          Image(this.getImage())
            .width(this.iconSize)
            .fillColor(this.style?.fillColor || DEFAULT_STYLE.fillColor)
        }
        if (this.type === SilkToastType.LOADING) {
          Row(){
            SilkLoading({
              color: this.style?.fillColor || DEFAULT_STYLE.fillColor,
              sizeValue: this.loadingSize,
              type: this.loadingType || 'circular'
            })
          }
          .padding(4)
        }
        Text(this.message)
          .fontSize(14)
          .fontColor($r('app.color.white'))
          .wordBreak(this.wordBreak)
          .textAlign(TextAlign.Center)
      }
    }
    .padding(
      this.style?.padding !== undefined
        ?
      this.style.padding
        :
        ((this.showIcon && this.getImage()) || this.type === SilkToastType.LOADING )
          ?
          DEFAULT_IMAGE_PADDING
          :
          DEFAULT_TEXT_PADDING
    )
    .clip(true)
    .borderRadius(this.style?.radius !== undefined ? this.style.radius : DEFAULT_STYLE.radius)
    .backgroundColor(this.style?.backgroundColor || DEFAULT_STYLE.backgroundColor)
    .constraintSize(
      (this.showIcon && this.getImage())
        ?
      CONSTRAINT_SIZE_IMAGE
        :
        CONSTRAINT_SIZE_TEXT
    )
    .onClick(() => {
      if (this.closeOnClick) {
        this.controller.close()
      }
    })
    .onAppear(() => {
      if (this.onOpened) {
        this.onOpened()
      }
    })
    .onDisAppear(() => {
      if (this.onClose) {
        this.onClose()
      }
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
  static success(props: SilkToastProps | ResourceStr) {
    if (!ToastClass.ToastComponent || !inited) {
      ToastClass.init()
    }
    ToastClass.ToastComponent?.success(props)
  }

  static error(props: SilkToastProps | ResourceStr) {
    if (!ToastClass.ToastComponent || !inited) {
      ToastClass.init()
    }
    ToastClass.ToastComponent?.error(props)
  }

  static toast(props: SilkToastProps | ResourceStr) {
    if (!ToastClass.ToastComponent || !inited) {
      ToastClass.init()
    }
    ToastClass.ToastComponent?.toast(props)
  }

  static warn(props: SilkToastProps | ResourceStr) {
    if (!ToastClass.ToastComponent || !inited) {
      ToastClass.init()
    }
    ToastClass.ToastComponent?.warn(props)
  }
  static loading(props: SilkToastProps | ResourceStr): ToastDynamicController {
    const controller: ToastDynamicController = new ToastDynamicController()
    if (!ToastClass.ToastComponent || !inited) {
      ToastClass.init()
    }
    ToastClass.ToastComponent!.loading(props, controller)
    return controller
  }
  static closeToast () {
    controller?.close()
  }

  static init(context?: Context) {
    inited = true
    ToastClass.init(context)
  }
}

@Component
export struct SilkToastComponent {
  @Link
  @Watch('update')
  show: boolean
  props?: SilkToastProps = {
    message: ''
  }
  style?: SilkToastStyle

  controller?: CustomDialogController
  @BuilderParam
  children: () => void
  update () {
    if (this.show) {
      this.controller?.open()
      setTimeout(() => {
        this.controller?.close()
        this.show = false
      }, this.props?.duration !== undefined ? this.props.duration : 3000)
    } else {
      this.controller?.close()
      this.show = false
    }
  }
  aboutToAppear(): void {
    this.props = ObjectUtils.assign(DEFAULT_PROP, this.props || {message: ''})
    this.controller = new CustomDialogController({
      builder: CusDialog({
        message: this.props.message,
        showIcon: this.props.showIcon ?? true,
        icon: this.props.icon ?? '',
        type: this.props.toastType || SilkToastType.TOAST,
        loadingType: this.props.loadingType,
        loadingSize: this.props.loadingSize,
        wordBreak: this.props.wordBreak,
        duration: this.props.duration,
        children: this.children,
        style: this.style,
        onOpened: this.props.onOpened,
        onClose: this.props.onClose
      }),
      customStyle: true,
      autoCancel: this.getAutoCancel(),
      alignment: (() => this.getAlign(this.props.showPosition!))(),
      offset: {
        dy: this.props.showPosition === 'top' ? this.props.offset! : this.props.showPosition === 'bottom' ? `-${this.props.offset}` : 0,
        dx: 0
      },
      isModal: this.props.overlay
    })
  }
  build() {

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
  getAutoCancel (): boolean {
    if (this.props?.forbidClick) {
      return false
    } else {
      if (this.props?.closeOnClickOverlay) {
        return true
      } else {
        return false
      }
    }
  }
}
// 切换非单例模式
export const allowMultipleToast = (flag?: boolean) => {
  if (flag === undefined || flag) {
    isSingleton = false
  } else {
    isSingleton = true
  }
}
// 修改默认配置
/**
 * style中的padding属性优先级高于text_padding/omage_padding
 */
export const setToastDefaultOptions = (
  props?: SilkToastProps,
  style?: SilkToastStyle,
  text_padding?: Padding,
  image_padding?: Padding,
  constraint_size_text?: ConstraintSizeOptions,
  constraint_size_image?: ConstraintSizeOptions
) => {
  props && (DEFAULT_PROP = ObjectUtils.assign(DEFAULT_PROP, props))
  style && (DEFAULT_STYLE = ObjectUtils.assign(DEFAULT_STYLE, style))
  text_padding && (DEFAULT_TEXT_PADDING = ObjectUtils.assign(DEFAULT_TEXT_PADDING, text_padding))
  image_padding && (DEFAULT_IMAGE_PADDING = ObjectUtils.assign(DEFAULT_IMAGE_PADDING, image_padding))
  constraint_size_text && (CONSTRAINT_SIZE_TEXT = ObjectUtils.assign(CONSTRAINT_SIZE_TEXT, constraint_size_text))
  constraint_size_image && (CONSTRAINT_SIZE_IMAGE = ObjectUtils.assign(CONSTRAINT_SIZE_IMAGE, constraint_size_image))
}
// 重置默认
export const resetToastDefaultOptions = () => {
  DEFAULT_PROP = {
    message: '',
    duration: 3000,
    showIcon: undefined,
    icon: undefined,
    iconSize: 36,
    overlay: false,
    loadingSize: 30,
    loadingType: undefined,
    showPosition: 'center',
    wordBreak: WordBreak.BREAK_ALL,
    forbidClick: false,
    toastType: SilkToastType.TOAST,
    closeOnClick: false,
    closeOnClickOverlay: false,
    onClose: undefined,
    onOpened: undefined,
    offset: '20%'
  }
  DEFAULT_STYLE = {
    radius: 8,
    backgroundColor: $r('app.color.overlay_bg'),
    fillColor: $r('app.color.white')
  }
  DEFAULT_TEXT_PADDING = {
    top: 10,
    bottom: 10,
    left: 12,
    right: 12
  }
  DEFAULT_IMAGE_PADDING = {
    top: 16,
    left: 16,
    bottom: 16,
    right: 16
  }
  CONSTRAINT_SIZE_TEXT = {
    minWidth: 96,
    maxWidth: '72%',
    minHeight: 0,
    maxHeight: '70%'
  }
  CONSTRAINT_SIZE_IMAGE = {
    minWidth: 96,
    maxWidth: '72%',
    minHeight: 88,
    maxHeight: '70%'
  }
}

