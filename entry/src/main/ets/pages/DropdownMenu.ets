import { SilkDropDownMenu, SilkDropDownMenuItemInterface } from '@ohos/silk_ui/src/main/ets/components/dropdownmenu';
import { Nav } from '../view/Nav';
import { Title } from '../view/Title';

@Entry
@Component
struct DropdownMenu {
  @State
  menuValue1: string = ''
  @State
  menu1: boolean = false
  menu1Options: SilkDropDownMenuItemInterface[] = [
    {
      text: '全部商品',
      value: '0'
    },
    {
      text: '新款商品',
      value: '1'
    },
    {
      text: '活动商品',
      value: '2'
    }
  ]
  @State
  menuValue2: number = 0
  menu2Options: SilkDropDownMenuItemInterface[] = [
    {
      text: '默认排序',
      value: 0
    },
    {
      text: '好评排序',
      value: 1
    },
    {
      text: '销量排序',
      value: 2
    }
  ]
  build() {
    Column(){
      Nav('DropdownMenu')
      Scroll() {
        Column() {
          Title('基础用法')
          Row(){
            SilkDropDownMenu({
              value: this.menuValue1,
              options: this.menu1Options
            })
            SilkDropDownMenu({
              value: this.menuValue2,
              options: this.menu2Options
            })
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
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