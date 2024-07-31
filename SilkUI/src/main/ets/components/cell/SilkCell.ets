@Component
export struct SilkCell {
  // 自定义左侧标题
  @BuilderParam
  customTitle: () => void
  // 自定义右侧内容
  @BuilderParam
  customValue: () => void
  // 自定义标题下方的描述信息
  @BuilderParam
  customLabel: () => void
  // 自定义左侧图标
  @BuilderParam
  customIcon: () => void
  // 自定义右侧图标
  @BuilderParam
  customRightIcon: () => void
  // 自定义单元格最右侧的额外内容
  @BuilderParam
  customExtra: () => void
  build() {

  }
}

interface SilkCellProps {
  title: ResourceStr
  value: ResourceStr
  label: ResourceStr
  size: 'large' | 'normal'
  icon: ResourceStr
  border: boolean | BorderOptions
  clickable: boolean
  isLink: boolean
  required: boolean
  center: boolean
  arrowDirection: 'up' | 'down' | 'left' | 'right'

}