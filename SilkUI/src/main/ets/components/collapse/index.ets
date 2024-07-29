/**
 * 折叠面板
 */
@Component
export struct SilkCollapse {
  // 展开状态
  @State
  collapseStatus: boolean = false
  @BuilderParam
  collapseContent: () => void
  @Prop
  props: SilkCollapseProps

  build() {
    Column() {
      Row() {
        Text(this.props.title)
          .fontSize(14)
          .fontColor('#323232')
          .maxLines(1)
          .textOverflow({
            overflow: TextOverflow.Ellipsis
          })
          .layoutWeight(1)
        Row({ space: 4 }) {
          if (this.props.value) {
            Text(this.props.value)
              .maxLines(1)
              .textOverflow({
                overflow: TextOverflow.Ellipsis
              })
              .fontSize(14)
              .fontColor('#969799')
          }
          if (this.props.showIcon !== null && this.props.showIcon !== false) {
            Image(this.props.icon ? this.props.icon : $r('app.media.ic_public_arrow_up'))
              .width(16)
              .aspectRatio(1)
              .rotate({
                angle: this.collapseStatus ? 0 : 180
              })
          }
        }
        .justifyContent(FlexAlign.End)
        .layoutWeight(1)
      }
      .width('100%')
      .height(this.props.size ? this.props.size : 44)
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .backgroundColor('#fff')
      .opacity(this.props.disabled ? 0.4 : 1)
      .border({
        width: {
          top: 0.5
        },
        color: '#ebedf0'
      })
      .onClick(() => {
        if (!this.props.disabled && !this.props.isReadonly) {
          this.collapseStatus = !this.collapseStatus
        }
      })

      Column() {
        this.collapseContent()
      }
      .border({
        width: {
          top: 0.5
        },
        color: '#ebedf0'
      })
      .width('100%')
      .height(this.collapseStatus ? 'auto' : 0)
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Start)
      .animation({
        curve: Curve.EaseInOut,
        duration: 300
      })
    }
    .padding({
      left: 16,
      right: 16
    })
    .width('100%')
  }
}

export interface SilkCollapseProps {
  icon?: ResourceStr
  size?: Length // 标题栏高度
  title: ResourceStr // 标题栏标题
  value?: ResourceStr // 内容
  showIcon?: boolean // 是否展示右侧图标
  disabled?: boolean // 是否禁用
  isReadonly?: boolean // 是否只读
  border?: boolean // 是否展示分割线
}
