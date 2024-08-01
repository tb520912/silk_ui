@Component
export struct SilkCellGroup {
  // 分组标题
  title: ResourceStr = ''
  // 是否展示为圆角卡片风格
  inset: boolean = false
  // 是否展示边框 true 默认边框 BorderOptions 自定义边框 false 无边框
  borderValue: boolean | BorderOptions = true
  // 卡片风格 两侧留白
  marginValue: number = 16
  @BuilderParam
  default: () => void
  paddingValue: Padding = {
    left: 16,
    right: 16,
    top: 16,
    bottom: 16
  }
  radius: number = 8
  build() {
    Column(){
      if (this.title) {
        Text(this.title)
          .fontSize($r('app.float.font_size_md'))
          .fontColor($r('app.color.text_color_2'))
          .padding(this.paddingValue)
      }
      this.default()
    }
    .alignItems(HorizontalAlign.Start)
    .width(this.inset ? `calc(100% - ${2 * this.marginValue}vp)` : '100%')
    .margin({
      left: this.inset ? this.marginValue : 0,
      right: this.inset ? this.marginValue : 0
    })
    .borderRadius(this.inset ? this.radius : 0)
    .clip(true)
  }
}

@Component
export struct SilkCellGroupCustomTitle {
  // 分组标题
  title: ResourceStr = ''
  // 是否展示为圆角卡片风格
  inset: boolean = false
  // 是否展示边框 true 默认边框 BorderOptions 自定义边框 false 无边框
  borderValue: boolean | BorderOptions = true
  // 卡片风格 两侧留白
  marginValue: Length = 16
  @BuilderParam
  default: () => void
  // 自定义分组标题
  @BuilderParam
  CustomTitle: () => void
  build() {

  }
}