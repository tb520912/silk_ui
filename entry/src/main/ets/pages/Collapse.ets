import { SilkCollapse, SilkCollapseItem, SilkCollapseItemCustomTitle,
  SilkCollapseToggleController } from '@ohos/silk_ui';
import { Nav } from '../view/Nav';
import { Title } from '../view/Title';

@Entry
@Component
struct Collapse {
  @State
  baseActiveNames: string[] = ['1']
  @State
  accordion: string = '1'
  @Builder
  Children1 (): void {
    Column(){
      SilkCollapseItem({
        name: '1',
        props: {
          title: '标题1'
        }
      }) {
        Text('代码是写出来给人看的，附带能在机器上运行附带能在机器上运行。')
          .width('100%')
          .padding({
            top: 12,
            bottom: 12,
          })
          .fontSize(14)
          .fontColor($r('app.color.vandoctextcolor4'))
          .textAlign(TextAlign.Start)
      }
      SilkCollapseItem({
        name: '2',
        props: {
          title: '标题2'
        }
      }) {
        Text('技术无非就是那些开发它的人的共同灵魂。')
          .width('100%')
          .padding({
            top: 12,
            bottom: 12,
          })
          .fontSize(14)
          .fontColor($r('app.color.vandoctextcolor4'))
          .textAlign(TextAlign.Start)
      }
      SilkCollapseItem({
        name: '3',
        props: {
          title: '标题3'
        }
      }) {
        Text('在代码阅读过程中人们说脏话的频率是衡量代码质量的唯一标准。')
          .width('100%')
          .padding({
            top: 12,
            bottom: 12,
          })
          .fontSize(14)
          .fontColor($r('app.color.vandoctextcolor4'))
          .textAlign(TextAlign.Start)
      }
    }
  }
  @Builder
  Children2 (): void {
    Column(){
      SilkCollapseItem({
        name: '1',
        props: {
          title: '标题1'
        }
      }) {
        Text('代码是写出来给人看的，附带能在机器上运行附带能在机器上运行。')
          .width('100%')
          .padding({
            top: 12,
            bottom: 12,
          })
          .fontSize(14)
          .fontColor($r('app.color.vandoctextcolor4'))
          .textAlign(TextAlign.Start)
      }
      SilkCollapseItem({
        name: '2',
        props: {
          title: '标题2',
          disabled: true
        }
      }) {
        Text('技术无非就是那些开发它的人的共同灵魂。')
          .width('100%')
          .padding({
            top: 12,
            bottom: 12,
          })
          .fontSize(14)
          .fontColor($r('app.color.vandoctextcolor4'))
          .textAlign(TextAlign.Start)
      }
      SilkCollapseItem({
        name: '3',
        props: {
          title: '标题3',
          disabled: true
        }
      }) {
        Text('在代码阅读过程中人们说脏话的频率是衡量代码质量的唯一标准。')
          .width('100%')
          .padding({
            top: 12,
            bottom: 12,
          })
          .fontSize(14)
          .fontColor($r('app.color.vandoctextcolor4'))
          .textAlign(TextAlign.Start)
      }
    }
  }
  // 注意 自定义标题时 传入的builder必须时全局的 不能使用局部的builder 否则会崩溃 this指向问题无法解决
  @Builder
  Children3 (): void {
    Column(){
      SilkCollapseItemCustomTitle({
        name: '1',
        collapseTitle: CollapseTitle1,
        collapseContent: CollapseCon
      })
    }
  }
  silkCollapseToggleController: SilkCollapseToggleController = new SilkCollapseToggleController()
  build() {
    Column(){
      Nav('Collapse')
      Scroll(){
        Column(){
          Title('基础用法')
          SilkCollapse({ activeNames: this.baseActiveNames, children: this.Children1 })
          Title('手风琴')
          SilkCollapse({ activeNames: this.accordion, accordion: true, children: this.Children1 })
          Title('禁用状态')
          SilkCollapse({ activeNames: this.accordion, accordion: true, children: this.Children2 })
          Title('自定义标题内容')
          SilkCollapse({ activeNames: this.accordion, accordion: true, children: this.Children3 })
          Title('全部展开与全部切换')
          SilkCollapse({ activeNames: this.baseActiveNames, children: this.Children1, names: ['1', '2', '3'], silkCollapseToggleController: this.silkCollapseToggleController })
          Row(){
            Button('全部展开')
              .onClick(() => {
                this.silkCollapseToggleController.toggle(true)
              })
            Button('全部切换')
              .onClick(() => {
                this.silkCollapseToggleController.toggle()
              })
            Button('全部折叠')
              .onClick(() => {
                this.silkCollapseToggleController.toggle(false)
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceAround)
          .margin({
            top: 10
          })
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

@Builder
function CollapseTitle1 (): void {
  Text() {
    Span('标题1')
    ImageSpan($r('app.media.ic_public_warn'))
      .width(12)
      .aspectRatio(1)
  }
}
@Builder
function CollapseCon (): void {
  Text('在代码阅读过程中人们说脏话的频率是衡量代码质量的唯一标准')
  .width('100%')
  .padding({
    top: 12,
    bottom: 12,
  })
  .fontSize(14)
  .fontColor($r('app.color.vandoctextcolor4'))
  .textAlign(TextAlign.Start)
}