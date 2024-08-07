import { util } from '@kit.ArkTS'
import { window } from '@kit.ArkUI'
import { SilkCell } from '../cell'
import { SilkDropdownMenuController } from './controller'

@Component
export struct SilkDropdownMenuItem {
  @Link
  controller: SilkDropdownMenuController
  // 参数
  @Link
  value: string | number
  @State
  title: string = ''
  @Prop
  options: SilkDropdownMenuItemInterface[] = []
  @BuilderParam
  default: () => void
  // 菜单显示方向
  directionValue: 'down' | 'up' = 'down'
  round: Length = 0
  // 动画时间
  duration: number = 300
  // 选中先颜色
  active_color: ResourceColor = $r('app.color.base_color')
  // 蒙版颜色
  overlay_color: ResourceColor = $r('app.color.overlay_bg')
  // 是否展示遮罩
  hasOverlay: boolean = true
  // 是否禁用
  @Prop
  disabled: boolean = false
  disabledColor: ResourceColor = $r('app.color.text_color_2')
  // 点击外部元素是否关闭
  close_on_click_outside: boolean = true
  // 点击遮罩是否关闭
  close_on_click_overlay: boolean = true
  private _id: string = util.generateRandomUUID()
  @State
  private showMenu: boolean = false
  @State
  private scrollTop: number = 0
  @State
  private menuHeight: number = 0
  @State
  private windowHeight: number = 0
  @State
  private windowWidth: number = 0
  @State
  private offsetLeft: number = 0

  private getWindowProperties() {
    const windowName = this.getUIContext().getWindowName()
    if (windowName) {
      const win = window.findWindow(windowName)
      this.windowHeight = px2vp(win.getWindowProperties().drawableRect.height)
      this.windowWidth = px2vp(win.getWindowProperties().drawableRect.width)
    }
  }
  // 设置标签默认值
  private setDefaultText () {
    if (!this.title) {
      if (!this.options.length || (typeof this.value === 'string' && !this.value)) {
        if (this.options.length) {
          this.title = this.options[0].text
        }
        return;
      }
      const index = this.options.findIndex(item => item.value === this.value)
      if (index > -1) {
        this.title = this.options[index].text
      }
    }
  }

  aboutToAppear(): void {
    this.getWindowProperties()
    this.setDefaultText()
    this.controller
  }

  build() {
    RelativeContainer() {
      Text(this.title)
        .fontSize(15)
        .fontColor(this.disabled ? this.disabledColor : this.controller.id === this._id ? this.active_color : '#323233')
        .lineHeight(22)
        .constraintSize({
          maxWidth: '70%'
        })
        .maxLines(1)
        .textOverflow({
          overflow: TextOverflow.Ellipsis
        })
        .id('drop_menu_text' + this._id)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
      // 三角
      Row()
        .margin({
          top: this.directionValue === 'down' ? this.controller.id === this._id ? 1 : -4 : this.controller.id === this._id ? -4 : 1
        })
        .width(0)
        .height(0)
        .border({
          width: 3,
          color: {
            top: Color.Transparent,
            right: Color.Transparent,
            bottom: this.controller.id === this._id ? this.active_color : '#dcdee0',
            left: this.controller.id === this._id ? this.active_color : '#dcdee0'
          }
        })
        .rotate({
          angle: this.directionValue === 'down' ? this.controller.id === this._id ? 135 : -45 : this.controller.id === this._id ? -45 : 135
        })
        .id('drop_menu_arrow' + this._id)
        .alignRules({
          left: { anchor: 'drop_menu_text' + this._id, align: HorizontalAlign.End },
          center: { anchor: '__container__', align: VerticalAlign.Center }
        })
        .offset({
          x: 4
        })
      // 内容区
      // 透明遮罩
      if (this.showMenu) {
        Column()
          .width(this.windowWidth)
          .height(this.scrollTop - this.menuHeight)
          .backgroundColor(Color.Transparent)
          .id('drop_menu_mask' + this._id)
          .alignRules(this.getAlignRules('transparent'))
          .offset({
            x: -this.offsetLeft
          })
          .onClick(() => {
            if (this.close_on_click_outside) {
              this.controller.toggle('')
            }
          })

        // 遮罩层
        Column() {
          if (this.controller.id === this._id) {
            Column() {
              this.DropDownMenuContent()
            }
            .id('cccc')
            .width('100%')
            .constraintSize({
              maxHeight: 0.7 * (this.windowHeight - this.scrollTop)
            })
            .borderRadius({
              topLeft: this.directionValue === 'down' ? 0 : this.round,
              topRight: this.directionValue === 'down' ? 0 : this.round,
              bottomLeft: this.directionValue === 'up' ? 0 : this.round,
              bottomRight: this.directionValue === 'up' ? 0 : this.round,
            })
            .clip(true)
            .alignRules({
              top: { anchor: 'drop_menu_content' + this._id, align: VerticalAlign.Top }
            })
            .transition(TransitionEffect.translate({
              y: this.directionValue === 'down' ? '-100%' : '100%'
            }).animation({ duration: this.duration }))
          }
        }
        .justifyContent(this.directionValue === 'down' ? FlexAlign.Start : FlexAlign.End)
        .clip(true)
        .backgroundColor(this.hasOverlay ? this.overlay_color : Color.Transparent)
        .width(this.windowWidth)
        .height(this.windowHeight - this.scrollTop)
        .id('drop_menu_content' + this._id)
        .alignRules(this.getAlignRules('overlay'))
        .offset({
          x: -this.offsetLeft
        })
        .opacity(this.controller.id === this._id ? 1 : 0)
        .animation({
          duration: this.duration,
          onFinish: () => {
            this.showMenu = false
          }
        })
        .onClick(() => {
          if (this.close_on_click_overlay) {
            this.controller.toggle('')
          }
        })

      }
    }
    .zIndex(10)
    .height('100%')
    .width('100%')
    .onAreaChange((_: Area, area: Area) => {
      this.scrollTop = (area.globalPosition.y as number)
      if (this.directionValue === 'down') {
        this.scrollTop += (area.height as number)
      }
      this.menuHeight = area.height as number
      this.offsetLeft = area.globalPosition.x as number
    })
    .onClick(() => {
      if (!this.disabled) {
        if (this.controller.id !== this._id) {
          this.showMenu = true
          this.controller.toggle(this._id)
        } else {
          this.controller.toggle('')
        }
      }

    })
  }

  // 默认列表项
  @Builder
  DefaultBuilder(): void {
    Column() {
      Text('组件内容区')
    }
  }

  // 默认弹框内容
  @Builder
  DropDownMenuContent(): void {
    if (this.options.length) {
      Scroll() {
        Column() {
          ForEach(this.options, (item: SilkDropdownMenuItemInterface, index: number) => {
            SilkCell({
              props: {
                title: item.text,
                border: index < this.options.length - 1,
                titleColor: item.value === this.value ? this.active_color : undefined,
                backgroundColor: Color.White
              },
              customRightIcon: item.value === this.value ? () => this.ActiveIcon() : undefined,
            })
              .onClick(() => {
                this.value = item.value
                this.title = item.text
                this.controller.toggle('')
              })
          })
        }
       .backgroundColor($r('app.color.white'))

      }
      .borderRadius({
        topLeft: this.directionValue === 'down' ? 0 : 16,
        topRight: this.directionValue === 'down' ? 0 : 16,
        bottomLeft: this.directionValue === 'up' ? 0 : 16,
        bottomRight: this.directionValue === 'up' ? 0 : 16
      })
      .clip(true)
      .scrollBar(BarState.Off)
      .width('100%')
      .constraintSize({
        maxHeight: '100%'
      })
    } else {
      this.default()
    }
  }

  // 勾选按钮
  @Builder
  ActiveIcon (): void {
    Image($r('app.media.success'))
      .width(14)
      .fillColor(this.active_color)
  }


  getAlignRules(type: 'overlay' | 'transparent'): AlignRuleOption {
    if (this.directionValue === 'down') {
      if (type === 'overlay') {
        return {
          left: { anchor: '__container__', align: HorizontalAlign.Start },
          top: { anchor: '__container__', align: VerticalAlign.Bottom }
        }
      } else {
        return {
          left: { anchor: '__container__', align: HorizontalAlign.Start },
          bottom: { anchor: '__container__', align: VerticalAlign.Top }
        }
      }
    } else {
      if (type === 'overlay') {
        return {
          left: { anchor: '__container__', align: HorizontalAlign.Start },
          bottom: { anchor: '__container__', align: VerticalAlign.Top }
        }
      } else {
        return {
          left: { anchor: '__container__', align: HorizontalAlign.Start },
          top: { anchor: '__container__', align: VerticalAlign.Bottom }
        }
      }
    }
  }
}

export interface SilkDropdownMenuItemInterface {
  text: string
  value: number | string
}