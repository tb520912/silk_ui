import { ShowSilkConfirmDialog, ShowSilkDialog, SilkCell, SilkCellGroup } from '@ohos/silk_ui';
import { Nav } from '../view/Nav';
import { Title } from '../view/Title';

@Entry
@Component
struct Dialog {

  build() {
    Column(){
      Nav('Dialog')
      Scroll() {
        Column() {
          Title('基础用法')
          SilkCellGroup({ inset: true }){
            SilkCell({
              props: {
                title: '提示弹框',
                isLink: true
              }
            })
              .onClick(() => {
                ShowSilkDialog({
                  title: '标题',
                  message: '代码是写出来给人看的，附带能在机器上运行。',
                })
              })
            SilkCell({
              props: {
                title: '提示弹窗（无标题）',
                isLink: true
              }
            })
              .onClick(() => {
                ShowSilkDialog({
                  message: '生命远不止连轴转和忙到极限，人类的体验远比这辽阔、丰富得多。',
                })
              })
            SilkCell({
              props: {
                title: '确认弹窗',
                isLink: true
              }
            })
              .onClick(() => {
                ShowSilkConfirmDialog({
                  title: '标题',
                  message: '如果解决方法是丑陋的，那就肯定还有更好的解决方法，只是还没有发现而已。',
                })
              })
          }
          Title('圆角按钮样式')
          SilkCellGroup({ inset: true }){
            SilkCell({
              props: {
                title: '提示弹框',
                isLink: true
              }
            })
              .onClick(() => {
                ShowSilkDialog({
                  title: '标题',
                  message: '代码是写出来给人看的，附带能在机器上运行。',
                  theme: 'round-button'
                })
              })
            SilkCell({
              props: {
                title: '提示弹窗（无标题）',
                isLink: true
              }
            })
              .onClick(() => {
                ShowSilkDialog({
                  message: '生命远不止连轴转和忙到极限，人类的体验远比这辽阔、丰富得多。',
                  theme: 'round-button'
                })
              })
          }
          Title('异步关闭')
          SilkCellGroup({ inset: true }){
            SilkCell({
              props: {
                title: '异步关闭',
                isLink: true
              }
            })
              .onClick(() => {
                ShowSilkConfirmDialog({
                  title: '标题',
                  message: '如果解决方法是丑陋的，那就肯定还有更好的解决方法，只是还没有发现而已。',
                  beforeClose: (action) =>  new Promise((resolve) => {
                    setTimeout(() => {
                      // action !== 'confirm'  拦截取消操作
                      resolve(action === 'confirm');
                    }, 1000);
                })
              })
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