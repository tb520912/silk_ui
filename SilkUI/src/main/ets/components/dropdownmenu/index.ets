// @Component
import { util } from '@kit.ArkTS'
import { window } from '@kit.ArkUI'
import { SilkCell } from '../cell/SilkCell'
import { SilkDropdownMenuController } from './controller'

// export struct SilkDropDownMenu {
//   @Link
//   value: string | number
//   @Prop
//   text: string = ''
//   @Prop
//   options: SilkDropDownMenuItemInterface[] = []
//   @BuilderParam
//   default: () => void
//   // 菜单显示方向
//   directionValue: 'down' | 'up' = 'down'
//   round: Length = 0
//   // 动画时间
//   duration: number = 300
//   // 选中先颜色
//   active_color: ResourceColor = $r('app.color.base_color')
//   // 蒙版颜色
//   overlay_color: ResourceColor = $r('app.color.overlay_bg')
//   // 是否展示遮罩
//   hasOverlay: boolean = true
//   // 是否禁用
//   @Prop
//   disabled: boolean = false
//   // 点击外部元素是否关闭
//   close_on_click_outside: boolean = true
//   // 点击遮罩是否关闭
//   close_on_click_overlay: boolean = true
//   @State
//   scrollTop: number = 0
//   // 记录菜单显示状态
//   @Prop
//   menuFlag: boolean = false
//   changeStatus: (flag: boolean) => void = (flag) => {
//     this.menuFlag = flag
//   }
//
//   controller: CustomDialogController = new CustomDialogController({
//     builder: DropDownMenuDialog({
//       context: () => this.DropDownMenuContent(),
//       scrollTop: this.scrollTop,
//       isClose: this.menuFlag,
//       props: {
//         active_color: this.active_color,
//         overlay_color: this.overlay_color,
//         direction: this.directionValue,
//         duration: this.duration,
//         overlay: this.hasOverlay,
//         close_on_click_outside: this.close_on_click_outside,
//         close_on_click_overlay: this.close_on_click_overlay
//       }
//     }),
//     maskColor: Color.Transparent,
//     customStyle: true,
//     openAnimation: { duration: 0},
//     closeAnimation: { duration: 0},
//     alignment:  this.directionValue === 'down' ? DialogAlignment.Bottom : DialogAlignment.Top
//   })
//
//   aboutToAppear(): void {
//     if (this.options.length) {
//       const arr = this.options.filter((item) => item.value === this.value)
//       if (arr.length) {
//         this.text = arr[0].text
//       } else {
//         this.text = this.options[0].text
//       }
//     }
//   }
//   build() {
//     Row({ space: 5 }){
//       Text(this.text)
//         .fontSize(16)
//         .fontColor(this.disabled ? $r('app.color.base_font_color9') : this.menuFlag ? this.active_color : $r('app.color.base_font_color3'))
//       Row()
//         .margin({
//           top: this.menuFlag ? 1 : -4
//         })
//         .width(0)
//         .height(0)
//         .border({
//           width: 3,
//           color: {
//             top: Color.Transparent,
//             right: Color.Transparent,
//             bottom: this.menuFlag ? this.active_color : '#dcdee0',
//             left: this.menuFlag ? this.active_color : '#dcdee0'
//           }
//         })
//         .rotate({
//           angle: this.menuFlag ? 135 : 315
//         })
//     }
//     .padding({
//       top: 5,
//       bottom: 5,
//       left: 8,
//       right: 8
//     })
//     .enabled(!this.disabled)
//     .backgroundColor('#f6f6f6')
//     .borderRadius(16)
//     .onAreaChange((_: Area, area: Area) => {
//       this.scrollTop = (area.globalPosition.y as number)
//       if (this.directionValue === 'down') {
//         this.scrollTop += (area.height as number)
//       }
//     })
//     .onClick(() => {
//       if (this.menuFlag) {
//         this.changeStatus(false)
//       } else {
//         this.controller.open()
//         this.changeStatus(true)
//       }
//     })
//   }
//
//   // 默认列表项
//   @Builder
//   DefaultBuilder (): void {
//     Column(){
//       Text('组件内容区')
//     }
//   }
//   // 默认弹框内容
//   @Builder
//   DropDownMenuContent (): void {
//     if (this.options.length) {
//       Scroll(){
//         Column(){
//           ForEach(this.options, (item: SilkDropDownMenuItemInterface, index: number) => {
//             this.CustomDropDownMenuItem(item, index !== this.options.length - 1)
//           })
//         }
//         .backgroundColor(Color.White)
//
//       }
//       .borderRadius({
//         topLeft: this.directionValue === 'down' ? 0 : 16,
//         topRight: this.directionValue === 'down' ? 0 : 16,
//         bottomLeft: this.directionValue === 'up' ? 0 : 16,
//         bottomRight: this.directionValue === 'up' ? 0 : 16
//       })
//       .clip(true)
//       .scrollBar(BarState.Off)
//       .width('100%')
//       .constraintSize({
//         maxHeight: 300
//       })
//     } else {
//         this.default()
//     }
//   }
//   @Builder
//   CustomDropDownMenuItem (props: SilkDropDownMenuItemInterface, hasBorder: boolean) {
//     Column(){
//       Row(){
//         Text(props.text)
//           .fontSize(14)
//           .lineHeight(24)
//           .fontColor(props.value === this.value ? $r('app.color.base_color') : Color.Black)
//         Image($r('app.media.ic_public_ok'))
//           .width(16)
//           .aspectRatio(1)
//           .fillColor($r('app.color.base_color'))
//           .visibility(props.value === this.value ? Visibility.Visible : Visibility.Hidden)
//       }
//       .width('100%')
//       .justifyContent(FlexAlign.SpaceBetween)
//     }
//     .width('100%')
//     .padding({
//       top: 10,
//       bottom: 10,
//       left: 16,
//       right: 16
//     })
//     .border({
//       width: {
//         bottom: hasBorder ? 1 : 0,
//       },
//       color: $r('app.color.border_color')
//     })
//     .onClick(() => {
//       this.value = props.value
//       this.text = props.text
//       this.menuFlag = false
//     })
//
//
//
//   }
// }
// const defaultProps: SilkDropDownMenuProps = {
//   active_color: $r('app.color.base_color'),
//   overlay_color: $r('app.color.overlay_bg'),
//   direction: 'down',
//   duration: 300,
//   overlay: true,
//   close_on_click_outside: true,
//   close_on_click_overlay: true,
// }
// @CustomDialog
// @Component
// struct DropDownMenuDialog {
//   controller: CustomDialogController
//   @BuilderParam
//   context: () => void
//   @Prop
//   scrollTop: number = 0
//
//   @Link
//   isClose: boolean
//
//   props: SilkDropDownMenuProps = defaultProps
//   build() {
//     Column(){
//       if (this.props.direction === 'down') {
//         // Column()
//         //   .width('100%')
//         //   .height(this.scrollTop)
//         //   .backgroundColor(Color.Transparent)
//         //   .onClick(() => {
//         //     if (this.props.close_on_click_outside) {
//         //       this.isClose = false
//         //     }
//         //   })
//         Stack({ alignContent: Alignment.Top }){
//           Column()
//             .width('100%')
//             .height('100%')
//             .backgroundColor(this.props.overlay_color)
//             .onClick(() => {
//               if (this.props.close_on_click_overlay) {
//                 this.isClose = false
//               }
//             })
//             .opacity(this.isClose ? 1 : 0)
//             .animation({
//               duration: !this.isClose ? this.props.duration : 0,
//               onFinish: () => this.finished(),
//             })
//           if (this.isClose) {
//             Column(){
//               this.context()
//             }
//             .width('100%')
//             .transition(TransitionEffect.translate({
//               y: '-100%'
//             }).animation({ duration: this.props.duration }))
//           }
//         }
//
//         .padding({
//           top: 1
//         })
//         .width('100%')
//         .height('100%')
//         .clip(true)
//       } else {
//         Stack({ alignContent: Alignment.Bottom }){
//           Column()
//             .width('100%')
//             .height('100%')
//             .backgroundColor(this.props.overlay_color)
//             .opacity(this.isClose ? 1 : 0)
//             .onClick(() => {
//               if (this.props.close_on_click_overlay) {
//                 this.isClose = false
//               }
//             })
//             .animation({
//               duration: !this.isClose ? this.props.duration : 0,
//               onFinish: () => this.finished(),
//             })
//           if (this.isClose) {
//             Column(){
//               this.context()
//             }
//             .width('100%')
//             .transition(TransitionEffect.translate({
//               y: '100%'
//             }).animation({ duration: this.props.duration }))
//           }
//         }
//
//         .padding({
//           bottom: 1
//         })
//         .width('100%')
//         .height('100%')
//         .clip(true)
//         // Column()
//         //   .width('100%')
//         //   .layoutWeight(1)
//         //   .backgroundColor(Color.Transparent)
//         //   .onClick(() => {
//         //     if (this.props.close_on_click_outside) {
//         //       this.isClose = false
//         //     }
//         //   })
//       }
//     }
//     .width('100%')
//     .height(this.props.direction === 'down' ? `calc(100% - ${this.scrollTop}vp)` : this.scrollTop)
//   }
//
//   finished() {
//     if (!this.isClose) {
//       this.controller.close()
//     }
//   }
// }
// export interface SilkDropDownMenuItemInterface {
//   text: string
//   value: number | string
// }
// // 下拉菜单参数
// interface SilkDropDownMenuProps {
//   active_color?: ResourceColor
//   overlay_color?: ResourceColor
//   direction?: 'down' | 'up'
//   duration?: number
//   overlay?: boolean
//   close_on_click_outside: boolean
//   close_on_click_overlay: boolean
// }

@Component
export struct SilkDropdownMenu {
  bgc: ResourceColor = Color.White
  @BuilderParam
  children: () => void
  @State
  private _h: number = 0
  build() {
      Stack(){
        Row(){
          this.children()
        }
        .width('100%')
        .backgroundColor(this.bgc)
        .onAreaChange((_: Area, area: Area) => {
          this._h = area.height as number
        })
        if (this._h) {
          Column()
            .width('100%')
            .height(this._h)
            .shadow({
              offsetX: 0,
              offsetY: 2,
              radius: 12,
              color: 'rgba(100, 101, 102, 0.12)'
            })
            .hitTestBehavior(HitTestMode.Transparent)
        }
      }
      .width('100%')
  }

}

