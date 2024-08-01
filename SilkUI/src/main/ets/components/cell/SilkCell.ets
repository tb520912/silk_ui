import { ObjectUtils } from '../../utils/ObjectUtils'

const DEFAULT: SilkCellProps = {
  title: '',
  value: '',
  label: undefined,
  size: 'normal',
  icon: undefined,
  border: true,
  clickable: undefined,
  isLink: false,
  required: false,
  center: false,
  arrowDirection: 'right',
  height: 44,
  backgroundColor: $r('app.color.white')
}
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
  paddingValue: Padding = {
    left: 16,
    right: 16
  }
  props: SilkCellProps = DEFAULT

  aboutToAppear(): void {
    this.props = ObjectUtils.assign<SilkCellProps>(DEFAULT, this.props)
  }
  build() {
    Column(){
      Row(){
        Column({ space: 4 }){
          if (this.customTitle) {
            this.customTitle()
          } else {
            Row(){
              if (this.customIcon) {
                this.customIcon()
              } else if (this.props.icon) {
                Image(this.props.icon)
                  .height(16)
                  .fillColor($r('app.color.gray_6'))
                  .margin({
                    right: $r('app.float.padding_base')
                  })
              }
              Text(this.props.title)
                .fontSize(this.props.size === 'normal' ? $r('app.float.font_size_md') : $r('app.float.font_size_lg'))
                .fontColor($r('app.color.text_color'))
            }
            .alignItems(VerticalAlign.Center)
            .height($r('app.float.cell_line_height'))
          }
          if (this.customLabel) {
            this.customLabel()
          } else if (this.props.label) {
            Text(this.props.label)
              .fontColor($r('app.color.text_color_2'))
              .fontSize(this.props.size === 'normal' ? $r('app.float.font_size_sm') :  $r('app.float.font_size_md'))
          }
        }
        .alignItems(HorizontalAlign.Start)
        Blank()
        Row(){
          if (this.customValue) {
            this.customValue()
          } else if (this.props.value) {
            Text(this.props.value)
              .fontColor($r('app.color.text_color_2'))
              .fontSize($r('app.float.font_size_md'))
          }
          if (this.customRightIcon) {
            this.customRightIcon()
          }else if (this.props.isLink) {
            Image($r('app.media.arrow'))
              .height(16)
              .fillColor($r('app.color.gray_6'))
              .margin({
                left: $r('app.float.padding_base')
              })
              .rotate({
                angle: this.getRotate()
              })
          }

        }
        .alignItems(VerticalAlign.Center)
        .height($r('app.float.cell_line_height'))
      }
      .width('100%')
      .border(this.props.border === true ? {
        width: {
          bottom: this.props.border ? $r('app.float.border_width') : 0
        },
        color: $r('app.color.border_color')
      } : this.props.border ? this.props.border : {
        width: 0
      })
      // .height(this.props.height)
      .padding({
        top: this.props.size === 'normal' ? 10 : 12,
        bottom: this.props.size === 'normal' ? 10 : 12
      })
      .alignItems(this.props.center ? VerticalAlign.Center : VerticalAlign.Top)
    }
    .backgroundColor(this.props.backgroundColor)
    .padding(this.paddingValue)
  }

  getRotate (): number {
    switch (this.props.arrowDirection) {
      case 'right':
        return 0
      case 'left':
        return 180
      case 'up':
        return 270
      case 'down':
        return 90
      default :
        return 0
    }
  }
}

interface SilkCellProps {
  title?: ResourceStr
  value?: ResourceStr
  backgroundColor?: ResourceColor
  height?: Length
  label?: ResourceStr
  size?: 'large' | 'normal'
  icon?: ResourceStr
  border?: boolean | BorderOptions
  clickable?: boolean
  isLink?: boolean // 控制是否展示右侧箭头
  required?: boolean
  center?: boolean
  arrowDirection?: 'up' | 'down' | 'left' | 'right' // 控制右侧图标方向
}