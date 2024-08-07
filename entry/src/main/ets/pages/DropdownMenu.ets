import { SilkDropdownMenu, SilkDropdownMenuItemInterface, SilkDropdownMenuItem } from '@ohos/silk_ui';
import { SilkDropdownMenuController } from '@ohos/silk_ui/src/main/ets/components/dropdownmenu/controller';
import { Nav } from '../view/Nav';
import { Title } from '../view/Title';

@Entry
@Component
struct DropdownMenu {
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
  // 开始思路是menu提供provider item使用consum接收控制器 后面发现一个组件接收的数据源来自于两个组件 this指向暂时无法兼容。只能将控制器手动传入
  // 多个菜单的子项不能使用同一个控制器。
  @State
  controller1: SilkDropdownMenuController = new SilkDropdownMenuController()
  @State
  controller2: SilkDropdownMenuController = new SilkDropdownMenuController()
  build() {
    Column() {
      Nav('DropdownMenu')
      Scroll() {
        Column() {
          Title('基础用法')
         Stack({ alignContent: Alignment.Top}){
            Column(){
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
            }
            .zIndex(1)
           Column(){
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
                 options: this.options2,
               })
                 .height(48)
                 .layoutWeight(1)
             }
           }
           .margin({
             top: 48
           })
         }

        }
        .justifyContent(FlexAlign.Start)
      }
      .layoutWeight(1)
      .backgroundColor($r('app.color.vandocbackground'))
      .align(Alignment.Top)
    }
    .width('100%')
    .height('100%')
  }
}
