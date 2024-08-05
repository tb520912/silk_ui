import { SilkLoading } from '@ohos/silk_ui/src/main/ets/components/loading';

@Entry
@Component
struct LoadingPage {
  @State message: string = 'Hello World';

  build() {
    Column() {
      SilkLoading()
    }
    .backgroundColor(Color.Pink)
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
}