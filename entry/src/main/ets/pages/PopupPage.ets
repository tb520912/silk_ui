import { SilkCell, SilkCellGroup, SilkPopup } from '@ohos/silk_ui';
import { Nav } from '../view/Nav';
import { Title } from '../view/Title';

@Entry
@Component
struct PopupPage {
  @State
  pop1: boolean = false
  @State
  pop2: boolean = false
  @State
  pop3: boolean = false
  @State
  pop4: boolean = false
  @State
  pop5: boolean = false
  @State
  pop6: boolean = false
  @State
  pop7: boolean = false
  @State
  pop8: boolean = false
  @State
  pop9: boolean = false
  @State
  pop10: boolean = false
  @State
  pop11: boolean = false
  @State
  pop12: boolean = false
  build() {
    Column(){
      Nav('Popup')
      Scroll(){
        Column(){
          Title('基础用法')
          Column(){
            SilkCell({
              props: {
                title: '展示弹出层',
                isLink: true
              }
            })
              .onClick(() => {
                this.pop1 = true
              })
            SilkPopup({
              show: this.pop1
            }){
              Column(){
                Text('内容')
                  .fontSize(16)
                  .fontColor($r('app.color.text_color'))
              }
              .padding(64)
            }
          }
          .padding({
            left: 16,
            right: 16
          })
          .borderRadius(8)
          .clip(true)
          Title('弹出位置')
          Column(){
            Grid(){
              GridItem(){
                Column({ space: 8}){
                  Image($r('app.media.arrow_up'))
                    .width(28)
                    .aspectRatio(1)
                  Text('顶部弹出')
                    .fontSize(12)
                    .fontColor($r('app.color.text_color'))
                }
                .padding({
                  top: 16,
                  bottom: 16
                })
              }
              .backgroundColor(Color.White)
              .onClick(() => {
                this.pop2 = true
              })

              GridItem(){
                Column({ space: 8}){
                  Image($r('app.media.arrow_down'))
                    .width(28)
                    .aspectRatio(1)
                  Text('底部弹出')
                    .fontSize(12)
                    .fontColor($r('app.color.text_color'))
                }.padding({
                  top: 16,
                  bottom: 16
                })
              }
              .backgroundColor(Color.White)
              .onClick(() => {
                this.pop3 = true
              })

              GridItem(){
                Column({ space: 8}){
                  Image($r('app.media.arrow_left'))
                    .width(28)
                    .aspectRatio(1)
                  Text('左侧弹出')
                    .fontSize(12)
                    .fontColor($r('app.color.text_color'))
                }.padding({
                  top: 16,
                  bottom: 16
                })
              }
              .backgroundColor(Color.White)
              .onClick(() => {
                this.pop4 = true
              })

              GridItem(){
                Column({ space: 8}){
                  Image($r('app.media.arrow'))
                    .width(28)
                    .aspectRatio(1)
                  Text('右侧弹出')
                    .fontSize(12)
                    .fontColor($r('app.color.text_color'))
                }.padding({
                  top: 16,
                  bottom: 16
                })
              }
              .backgroundColor(Color.White)
              .onClick(() => {
                this.pop5 = true
              })
            }
            .columnsTemplate('1fr 1fr 1fr 1fr')
            .rowsGap(1)
            .borderRadius(8)
            .clip(true)
            .maxCount(1)
            SilkPopup({
              show: this.pop2,
              showPosition: 'top'
            }){
              Column(){

              }
              .width('100%')
              .height('30%')
            }
            SilkPopup({
              show: this.pop3,
              showPosition: 'bottom'
            }){
              Column(){

              }
              .width('100%')
              .height('30%')
            }
            SilkPopup({
              show: this.pop4,
              showPosition: 'left',
              widthValue: '30%'
            }){
              Column(){

              }
              .width('100%')
              .height('100%')
            }
            SilkPopup({
              show: this.pop5,
              showPosition: 'right',
              widthValue: '30%'
            }){
              Column(){

              }
              .width('100%')
              .height('100%')
            }
          }
          .padding({
            left: 16,
            right: 16
          })
          Title('关闭图标')
          SilkCellGroup({
            inset: true
          }) {
            SilkCell({
              props: {
                title: '关闭图标',
                isLink: true
              }
            })
              .onClick(() => {
                this.pop6 = true
              })
            SilkCell({
              props: {
                title: '自定义图标',
                isLink: true
              }
            })
              .onClick(() => {
                this.pop7 = true
              })
            SilkCell({
              props: {
                title: '图标位置',
                border: false,
                isLink: true
              }
            })
              .onClick(() => {
                this.pop8 = true
              })
          }
          SilkPopup({
            show: this.pop6,
            showPosition: 'bottom',
            showClose: true
          }){
            Column(){

            }
            .width('100%')
            .height('30%')
          }
          SilkPopup({
            show: this.pop7,
            showPosition: 'bottom',
            showClose: true,
            close_icon: $r('app.media.close')
          }){
            Column(){

            }
            .width('100%')
            .height('30%')
          }
          SilkPopup({
            show: this.pop8,
            showPosition: 'bottom',
            showClose: true,
            close_icon_position: 'top-left'
          }){
            Column(){

            }
            .width('100%')
            .height('30%')
          }
          Title('圆角弹窗')
          SilkCellGroup({
            inset: true
          }) {
            SilkCell({
              props: {
                title: '圆角弹窗（居中）',
                isLink: true
              }
            })
              .onClick(() => {
                this.pop9 = true
              })
            SilkCell({
              props: {
                title: '圆角弹窗（底部）',
                isLink: true
              }
            })
              .onClick(() => {
                this.pop10 = true
              })
          }
          SilkPopup({
            show: this.pop9,
            round: 16
          }){
            Column(){
              Text('内容')
                .fontSize(14)
                .fontColor($r('app.color.text_color'))
            }
            .padding(64)
          }
          SilkPopup({
            show: this.pop10,
            showPosition: 'bottom',
            round: 16
          }){
            Column(){

            }
            .width('100%')
            .height('30%')
          }
          Title('事件监听')
          SilkCellGroup({
            inset: true
          }) {
            SilkCell({
              props: {
                title: '监听点击事件',
                isLink: true
              }
            })
              .onClick(() => {
                this.pop11 = true
              })
            SilkCell({
              props: {
                title: '监听显示事件',
                isLink: true
              }
            })
              .onClick(() => {
                this.pop12 = true
              })
          }
          SilkPopup({
            show: this.pop11,
            round: 16,
            showClose: true,
            click_overlay: this.clickClose,
            click_close: this.clickCloseIcon
          }){
            Column(){
              Text('内容')
                .fontSize(14)
                .fontColor($r('app.color.text_color'))
            }
            .padding(64)
          }
          SilkPopup({
            show: this.pop12,
            showPosition: 'bottom',
            round: 16,
            open: () => {AlertDialog.show({ message: 'open'})},
            opened: () => {AlertDialog.show({ message: 'opened'})},
            close: () => {AlertDialog.show({ message: 'close'})},
            closed: () => {AlertDialog.show({ message: 'closed'})},
          }){
            Column(){

            }
            .width('100%')
            .height('30%')
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

  clickClose () {
    AlertDialog.show({
      message: 'click_overlay'
    })
  }
  clickCloseIcon () {
    AlertDialog.show({
      message: 'click_icon'
    })
  }
}