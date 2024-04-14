import { CustomPopup, DropDownMenu, DropDownMenuItemInterface } from '@ohos/ui_component'
import { window } from '@kit.ArkUI'

@Entry
@Component
struct Index {
  @State
  showPopupCenter: boolean = false
  @State
  value: number = 0
  @State
  list: DropDownMenuItemInterface[] = [{
    text: '选项1',
    value: 0
  }, {
    text: '选项2',
    value: 1
  }, {
    text: '选项3',
    value: 2
  }, {
    text: '选项4',
    value: 3
  }, {
    text: '选项5',
    value: 4
  }, {
    text: '选项6',
    value: 5
  }, {
    text: '选项7',
    value: 6
  }, {
    text: '选项8',
    value: 7
  }, {
    text: '选项9',
    value: 8
  }, {
    text: '选项10',
    value: 9
  }]
  async aboutToAppear(): Promise<void> {
    const win = await window.getLastWindow(getContext(this))
    await win.setWindowLayoutFullScreen(true)
  }
  build() {
    Row() {
      Column({ space: 20}) {
        Text('CustomUI')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Button('popup')
          .onClick(() => {
            this.showPopupCenter = true
          })
        CustomPopup({
          show: this.showPopupCenter,
          showPosition: 'left'
        }) {
          Column(){
            Text('内容区')
          }
        }

        DropDownMenu({
          value: this.value,
          options: this.list,
          directionValue: 'up',
          disabled: true
        })
          .margin({
            top: 300
          })
      }
      .justifyContent(FlexAlign.Start)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .alignItems(VerticalAlign.Top)
  }
}