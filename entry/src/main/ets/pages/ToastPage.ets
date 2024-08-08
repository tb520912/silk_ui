import { SilkCell } from '@ohos/silk_ui/src/main/ets/components/cell/SilkCell';
import { SilkCellGroup } from '@ohos/silk_ui/src/main/ets/components/cell/SilkCellGroup';
import { ToastDynamicMessage } from '@ohos/silk_ui/src/main/ets/components/toast';
import { SilkToast } from '@ohos/silk_ui/src/main/ets/components/toast';
import { Nav } from '../view/Nav';
import { Title } from '../view/Title';

@Entry
@Component
struct ToastPage {
  @State message: ToastDynamicMessage = new ToastDynamicMessage('');
  aboutToAppear(): void {
    SilkToast.init(getContext())
  }
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
          Title('自定义图标')
          SilkCellGroup({
            inset: true
          }) {
            SilkCell({
              props: {
                title: '自定义图标',
                isLink: true
              }
            })
              .onClick(() => {
                SilkToast.toast({
                  message: '自定义图标',
                  icon: $r('app.media.like_o')
                })
              })
            SilkCell({
              props: {
                title: '自定义图片',
                isLink: true
              }
            })
              .onClick(() => {
                SilkToast.toast({
                  message: '自定义图片',
                  icon: 'https://fastly.jsdelivr.net/npm/@vant/assets/logo.png'
                })
              })
            SilkCell({
              props: {
                title: '自定义加载图标',
                isLink: true
              }
            })
              .onClick(() => {
                SilkToast.loading({
                  message: '加载中...',
                  loadingType: 'spinner'
                })
              })
          }
          Title('自定义位置')
          SilkCellGroup({
            inset: true
          }) {
            SilkCell({
              props: {
                title: '顶部展示',
                isLink: true
              }
            })
              .onClick(() => {
                SilkToast.toast({
                  message: '顶部展示',
                  showPosition: 'top'
                })
              })
            SilkCell({
              props: {
                title: '底部展示',
                isLink: true
              }
            })
              .onClick(() => {
                SilkToast.toast({
                  message: '底部展示',
                  showPosition: 'bottom'
                })
              })
          }
          Title('文字换行方式')
          SilkCellGroup({
            inset: true
          }) {
            SilkCell({
              props: {
                title: '换行时截断单词',
                isLink: true
              }
            })
              .onClick(() => {
                SilkToast.toast({
                  message: 'This message will contain a incomprehensibilities long word.',
                  wordBreak: WordBreak.BREAK_ALL
                })
              })
            SilkCell({
              props: {
                title: '换行时不截断单词',
                isLink: true
              }
            })
              .onClick(() => {
                SilkToast.toast({
                  message: 'This message will contain a incomprehensibilities long word.',
                  wordBreak: WordBreak.BREAK_WORD
                })
              })
          }
          Title('动态更新提示')
          SilkCellGroup({
            inset: true
          }) {
            SilkCell({
              props: {
                title: '动态更新提示',
                isLink: true
              }
            })
              .onClick(() => {
                const toast = SilkToast.loading({
                  duration: 0,
                  forbidClick: true,
                  message: '倒计时 3 秒'
                }, this.message)
                let second = 3
                const timer = setInterval(() => {
                  second--
                  if (second) {
                    this.message.message = `倒计时 ${second} 秒`
                  } else {
                  clearInterval(timer)
                    SilkToast.closeToast()
                  }
                }, 1000)
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