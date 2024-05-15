import { CustomPopup } from '@ohos/ui_component/Index';
import { PageOne } from '../view/PageOne';
import { PageTwo } from '../view/PageTwo';
@Entry
@Component
struct TestNavDialog {
  pageInfos: NavPathStack = new NavPathStack()
  isUseInterception: boolean = false;
@State
showPopupCenter: boolean = false
  @Builder
  PagesMap(name: string) {
    if (name == 'Page1') {
      PageOne()
    } else if (name == 'Page2') {
      PageTwo()
    }
  }

  build() {
    Navigation(this.pageInfos) {
      Column() {
        Button('pushPath', { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            this.pageInfos.pushPath({ name: 'Page1' }) //将name指定的NavDestination页面信息入栈
          })
        Button('showPop', { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            // this.pageInfos.pushPath({ name: 'Page2' })
            this.showPopupCenter = true
          })
        CustomPopup({
          show: this.showPopupCenter,
          showPosition: 'bottom',
          duration: 300
        }) {
          Column(){
            Text('内容区')
              .onClick(() => {
                this.pageInfos.pushPath({ name: 'Page2' })
              })
          }
          .height(400)
          .onVisibleAreaChange([0.0, 1.0], (_, area) => {
            console.log(`area_top: ${area}`)
          })
        }
      }
    }.title('NavIndex')
    .hideBackButton(true)
    .navDestination(this.PagesMap)
    .titleMode(NavigationTitleMode.Free)
    .hideTitleBar(true)
    .id('121')
  }
}