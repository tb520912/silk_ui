import { SilkDropdownMenu, SilkDropdownMenuItemInterface } from '@ohos/silk_ui';
import { Nav } from '../view/Nav';
import { Title } from '../view/Title';

@Entry
@Component
struct DropdownMenu {
  @State
  menu1: number = 0
  @State
  menu2: string = '0'
  options1: SilkDropdownMenuItemInterface[] = [
    {
      text: '选项一',
      value: 0
    },
    {
      text: '选项二',
      value: 1
    },
    {
      text: '选项三',
      value: 2
    }
  ]
  options2: SilkDropdownMenuItemInterface[] = [
    {
      text: '选项一',
      value: '0'
    },
    {
      text: '选项二',
      value: '1'
    },
    {
      text: '选项三',
      value: '2'
    }
  ]
  build() {
    Column(){
      Nav('DropdownMenu')
      Scroll() {
        Column() {
          Title('基础用法')
          Row(){
            SilkDropdownMenu({
              value: this.menu1,
              options: this.options1
            })
            SilkDropdownMenu({
              value: this.menu2,
              options: this.options2
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