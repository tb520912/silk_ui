@Component
export struct SilkCellGroup {
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