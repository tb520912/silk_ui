import { SilkDropdownMenu, SilkDropdownMenuItemInterface, SilkDropdownMenuItem, SilkCell } from '@ohos/silk_ui';
import { SilkDropdownMenuController } from '@ohos/silk_ui/src/main/ets/components/dropdownmenu/controller';
import { Nav } from '../view/Nav';
import { Title } from '../view/Title';

@Entry
@Component
struct DropdownMenu {
  // 横向滚动时 必须给item设置宽度
  @State
  menu1: number = 0
  @State
  menu2: string = 'a'
  options1: SilkDropdownMenuItemInterface[] = [
    {
      text: '全部商品',
      value: 0
    },
    {
      text: '新款商品',
      value: 1
    },
    {
      text: '活动商品',
      value: 2
    }
  ]
  options2: SilkDropdownMenuItemInterface[] = [
    {
      text: '默认排序',
      value: 'a'
    },
    {
      text: '好评排序',
      value: 'b'
    },
    {
      text: '销量排序',
      value: 'c'
    }
  ]
  @State
  switch1: boolean = true
  @State
  switch2: boolean = false
  // 开始思路是menu提供provider item使用consum接收控制器 后面发现一个组件接收的数据源来自于两个组件 this指向暂时无法兼容。只能将控制器手动传入
  // 多个菜单的子项不能使用同一个控制器。
  @State
  controller1: SilkDropdownMenuController = new SilkDropdownMenuController()
  @State
  controller2: SilkDropdownMenuController = new SilkDropdownMenuController()
  @State
  controller3: SilkDropdownMenuController = new SilkDropdownMenuController()
  @State
  controller4: SilkDropdownMenuController = new SilkDropdownMenuController()
  @State
  controller5: SilkDropdownMenuController = new SilkDropdownMenuController()
  @State
  controller6: SilkDropdownMenuController = new SilkDropdownMenuController()
  build() {
    Column() {
      Nav('DropdownMenu')
      Scroll() {
        Column() {
          Title('基础用法')
          SilkDropdownMenu() {
            SilkDropdownMenuItem({
              controller: this.controller1,
              value: this.menu1,
              options: this.options1,
              round: 5
            })
              .height(48)
              .layoutWeight(1)
            SilkDropdownMenuItem({
              controller: this.controller1,
              value: this.menu2,
              options: this.options2,
            })
              .height(48)
              .layoutWeight(1)
          }
          Title('自定义菜单内容')
          SilkDropdownMenu() {
            SilkDropdownMenuItem({
              controller: this.controller2,
              value: this.menu1,
              options: this.options1,
              round: 5
            })
              .height(48)
              .layoutWeight(1)
            SilkDropdownMenuItem({
              controller: this.controller2,
              value: this.menu2,
              heightValue: 48,
              layoutWeightValue: 1,
              title: '筛选'
            }) {
              Column(){
                SilkCell({
                  props: {
                    title: '包邮',
                    border: true
                  },
                  customRightIcon: () => this.SwitchComp1()
                })
                SilkCell({
                  props: {
                    title: '团购',
                    border: true
                  },
                  customRightIcon: () => this.SwitchComp2()
                })
                Button('确认')
                  .width(`calc(100% - 32vp)`)
                  .margin({
                    top: 5,
                    bottom: 5
                  })
                  .onClick(() => {
                    this.controller2.toggle('')
                  })
              }
              .backgroundColor(Color.White)
            }
          }
          Title('自定义选中态颜色')
          SilkDropdownMenu() {
            SilkDropdownMenuItem({
              controller: this.controller3,
              value: this.menu1,
              options: this.options1,
              active_color: '#ee0a24',
              round: 5
            })
              .height(48)
              .layoutWeight(1)
            SilkDropdownMenuItem({
              controller: this.controller3,
              value: this.menu2,
              options: this.options2,
              active_color: '#ee0a24',
            })
              .height(48)
              .layoutWeight(1)
          }
          Title('横向滚动')
          SilkDropdownMenu({ controller: this.controller4, swiperThreshold: 4}) {
            SilkDropdownMenuItem({
              controller: this.controller4,
              value: this.menu2,
              options: this.options2,
            })
              .height(48)
              .width('25%')
            SilkDropdownMenuItem({
              controller: this.controller4,
              value: this.menu2,
              options: this.options2,
            })
              .height(48)
              .width('25%')

            SilkDropdownMenuItem({
              controller: this.controller4,
              value: this.menu2,
              options: this.options2,
            })
              .height(48)
              .width('25%')

            SilkDropdownMenuItem({
              controller: this.controller4,
              value: this.menu2,
              options: this.options2,
            })
              .height(48)
              .width('25%')

            SilkDropdownMenuItem({
              controller: this.controller4,
              value: this.menu2,
              options: this.options2,
            })
              .height(48)
              .width('25%')

          }
          Title('向上展开')
          SilkDropdownMenu() {
            SilkDropdownMenuItem({
              controller: this.controller5,
              value: this.menu1,
              options: this.options1,
              directionValue: 'up'
            })
              .height(48)
              .layoutWeight(1)
            SilkDropdownMenuItem({
              controller: this.controller5,
              value: this.menu2,
              options: this.options2,
              directionValue: 'up'
            })
              .height(48)
              .layoutWeight(1)
          }
          Title('禁用菜单')
          SilkDropdownMenu() {
            SilkDropdownMenuItem({
              controller: this.controller6,
              value: this.menu1,
              options: this.options1,
              disabled: true
            })
              .height(48)
              .layoutWeight(1)
            SilkDropdownMenuItem({
              controller: this.controller6,
              value: this.menu2,
              options: this.options2,
              disabled: true
            })
              .height(48)
              .layoutWeight(1)
          }
        }
        .justifyContent(FlexAlign.Start)
      }
      .clip(false)
      .layoutWeight(1)
      .backgroundColor($r('app.color.vandocbackground'))
      .align(Alignment.Top)
    }
    .width('100%')
    .height('100%')
  }
  @Builder
  SwitchComp1 (): void {
   Toggle({
     type: ToggleType.Switch,
     isOn: $$this.switch1
   })
  }
  @Builder
  SwitchComp2 (): void {
    Toggle({
      type: ToggleType.Switch,
      isOn: $$this.switch2
    })
  }
}
