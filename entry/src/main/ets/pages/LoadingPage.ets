import { SilkLoading } from '@ohos/silk_ui/src/main/ets/components/loading';
import { Nav } from '../view/Nav';
import { Title } from '../view/Title';

@Entry
@Component
struct LoadingPage {
  build() {
    Column() {
      Nav('Loading')
      Scroll() {
        Column() {
          Title('加载类型')
          Row() {
            SilkLoading()
              .margin({
                top: 5,
                right: 0,
                bottom: 5,
                left: 20
              })
            SilkLoading({
                type: 'spinner'
            })
              .margin({
                top: 5,
                right: 0,
                bottom: 5,
                left: 20
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.Start)
          Title('特定的颜色')
          Row() {
            SilkLoading({
              color: '#1989fa'
            })
              .margin({
                top: 5,
                right: 0,
                bottom: 5,
                left: 20
              })
            SilkLoading({
                type: 'spinner',
              color: '#1989fa'
            })
              .margin({
                top: 5,
                right: 0,
                bottom: 5,
                left: 20
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.Start)
          Title('大小')
          Row() {
            SilkLoading({
              sizeValue: 24
            })
              .margin({
                top: 5,
                right: 0,
                bottom: 5,
                left: 20
              })
            SilkLoading({
              type: 'spinner',
              sizeValue: 24
            })
              .margin({
                top: 5,
                right: 0,
                bottom: 5,
                left: 20
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.Start)
          Title('加载文件')
          Row() {
            SilkLoading({
              sizeValue: 24,
              text: '加载中...'
            })
              .margin({
                top: 5,
                right: 0,
                bottom: 5,
                left: 20
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.Start)
          Title('垂直')
          Row() {
            SilkLoading({
              sizeValue: 24,
              text: '加载中...',
              vertical: true
            })
              .margin({
                top: 5,
                right: 0,
                bottom: 5,
                left: 20
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.Start)
          Title('自定义文本颜色')
          Row() {
            SilkLoading({
              color: '#0094ff',
              text: '加载中...',
              vertical: true
            })
              .margin({
                top: 5,
                right: 0,
                bottom: 5,
                left: 20
              })
            SilkLoading({
              textColor: '#0094ff',
              text: '加载中...',
              vertical: true
            })
              .margin({
                top: 5,
                right: 0,
                bottom: 5,
                left: 20
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.Start)
          Title('自定义图标')
          Row() {
            SilkLoading({
              sizeValue: 24,
              text: '加载中...',
              vertical: true,
              icon: $r('app.media.star_o')
            })
              .margin({
                top: 5,
                right: 0,
                bottom: 5,
                left: 20
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.Start)
        }
      }
      .layoutWeight(1)
      .backgroundColor($r('app.color.vandocbackground'))
      .align(Alignment.Top)
    }
    .height('100%')
    .width('100%')
  }
}