import { SilkCell } from '@ohos/silk_ui/src/main/ets/components/cell/SilkCell';
import { SilkCellGroup } from '@ohos/silk_ui/src/main/ets/components/cell/SilkCellGroup';
import { SilkToast } from '@ohos/silk_ui/src/main/ets/components/toast';
import { Nav } from '../view/Nav';
import { Title } from '../view/Title';

@Entry
@Component
struct ToastPage {
  @State message: string = 'Hello World';

  build() {
    Column(){
      Nav('Toast')
      Scroll(){
        Column(){
          Title('基础用法')
          SilkCellGroup({
            inset: true
          }) {
            SilkCell({
              props: {
                title: '文字提示',
                isLink: true
              }
            })
              .onClick(() => {
                SilkToast.toast('提示内容')
              })
            SilkCell({
              props: {
                title: '加载提示',
                isLink: true
              }
            })
              .onClick(() => {
                SilkToast.loading('加载中...')
              })
            SilkCell({
              props: {
                title: '成功提示',
                isLink: true
              }
            })
              .onClick(() => {
                SilkToast.success('成功文案')
              })
            SilkCell({
              props: {
                title: '失败提示',
                isLink: true,
                border: false
              }
            })
              .onClick(() => {
                SilkToast.error('失败文案')
              })
          }
        }
        .justifyContent(FlexAlign.Start)
      }
      .layoutWeight(1)
      .backgroundColor($r('app.color.vandocbackground'))
      .align(Alignment.Top)
    }
    .height('100%')
    .width('100%')
  }
}