import { CustomPopup, DropDownMenu, DropDownMenuItemInterface } from '@ohos/ui_component'
import { window } from '@kit.ArkUI'

@Entry
@Component
struct Index {
  @State
  showPopupCenter: boolean = false
  @State
  value: number | string = 0
  list: DropDownMenuItemInterface[] = [{
    text: '选项1',
    value: 0
  }, {
    text: '选项2',
    value: 1
  }, {
    text: '选项3',
    value: 2
  }]
  @State
  text: string = this.list[0].text
  @State
  menuFlag: boolean = false
  changeFlag(flag: boolean):void {
    this.menuFlag = flag
  }
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
          showPosition: 'bottom',
          duration: 300
        }) {
          Column(){
            Text('内容区')
          }
          .height(400)
          .onVisibleAreaChange([0.0, 1.0], (_, area) => {
            console.log(`area_top: ${area}`)
          })
        }

        DropDownMenu({
          value: this.value,
          options: this.list,
        })
          .margin({
            top: 300
          })

        Text(this.menuFlag + '')
        DropDownMenu({
          value: this.value,
          text: this.text,
          menuFlag: this.menuFlag,
          changeStatus: (flag: boolean) => this.changeFlag(flag)
        }) {
          Column(){
            ForEach(this.list, (item: DropDownMenuItemInterface, index: number) => {
              Row(){
                Text(item.text)
                  .fontColor(item.value === this.value ? $r('app.color.base_color') : Color.Black)
                Image($r('app.media.ic_public_ok'))
                  .width(16)
                  .aspectRatio(1)
                  .fillColor($r('app.color.base_color'))
                  .visibility(item.value === this.value ? Visibility.Visible : Visibility.Hidden)
              }
              .onClick(() => {
                this.text = item.text
                this.value = item.value as number
                this.menuFlag = false
              })
            })
          }
          .width('100%')
          .backgroundColor(Color.White)
          .borderRadius({
            bottomLeft: 16,
            bottomRight: 16
          })
        }
      }
      .justifyContent(FlexAlign.Start)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .alignItems(VerticalAlign.Top)
  }
}