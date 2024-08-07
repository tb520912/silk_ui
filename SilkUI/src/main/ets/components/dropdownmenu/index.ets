import { SilkDropdownMenuController } from './controller'

@Component
export struct SilkDropdownMenu {
  bgc: ResourceColor = Color.White
  @BuilderParam
  children: () => void
  @State
  private _h: number = 0
  @Prop
  @Watch('change')
  controller: SilkDropdownMenuController
  swiperThreshold?: number
  @State
  private widthValue: string | undefined = '100%'
  private change () {
    const length = this.controller.getLength()
    if (this.swiperThreshold) {
      this.widthValue = length > this.swiperThreshold ? undefined : '100%'
    } else {
      this.widthValue = '100%'
    }
  }
  build() {
      Stack(){
        if (this.widthValue) {
          Row(){
            this.children()
          }
          .width('100%')
          .backgroundColor(this.bgc)
          .onAreaChange((_: Area, area: Area) => {
            this._h = area.height as number
          })
        } else {
          Scroll(){
            Row(){
              this.children()
            }
            .backgroundColor(this.bgc)
            .onAreaChange((_: Area, area: Area) => {
              this._h = area.height as number
            })
          }
          .clip(false)
          .scrollBar(BarState.Off)
          .scrollable(ScrollDirection.Horizontal)
          .width('100%')
        }
        if (this._h) {
          Column()
            .width('100%')
            .height(this._h)
            .shadow({
              offsetX: 0,
              offsetY: 2,
              radius: 12,
              color: 'rgba(100, 101, 102, 0.12)'
            })
            .hitTestBehavior(HitTestMode.Transparent)
        }
      }
      .width('100%')
  }

}

