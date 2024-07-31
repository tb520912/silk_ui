import { SilkCollapseProps } from '.'
import { ObjectUtils } from '../../utils/ObjectUtils'
import { SilkCollapseController } from './controller'
const DEFAULT_PROPS: SilkCollapseProps = {
  title: '',
  size: 44,
  showIcon: true
}
@Component
export struct SilkCollapseItem {
  @Consume
  paddingValue: Padding
  // 展开状态
  @Consume("silkCollapseController")
  @Watch('change')
  silkCollapseController: SilkCollapseController
  name: string = ''
  @BuilderParam
  collapseContent: () => void
  @Prop
  props: SilkCollapseProps = DEFAULT_PROPS
  @State
  collapseStatus: boolean = false
  getCollapseStatus () {
    // 如果是禁用的 只能收起
    if (this.props.disabled) {
      this.collapseStatus = false
    }
    if (typeof this.silkCollapseController.activeNames === 'string') {
      this.collapseStatus = this.silkCollapseController.activeNames === this.name
    } else {
      this.collapseStatus = this.silkCollapseController.activeNames.includes(this.name)
    }
  }
  aboutToAppear(): void {
    this.getCollapseStatus()
    if (!this.props) {
      this.props = {
        title: '标题'
      }
    }
    this.props = ObjectUtils.assign(this.props, DEFAULT_PROPS)
  }
  change () {
    this.getCollapseStatus()
  }
  build() {
    Column() {
      Row() {
          Text(this.props.title)
            .fontSize($r('app.float.font_size_md'))
            .fontColor($r('app.color.text_color'))
            .lineHeight($r('app.float.cell_line_height'))
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
              .fontSize($r('app.float.font_size_md'))
              .fontColor($r('app.color.text_color_2'))
          }
          if (this.props.showIcon !== null && this.props.showIcon !== false) {
            Image(this.props.icon ? this.props.icon : $r('app.media.arrow'))
              .width(16)
              .aspectRatio(1)
              .rotate({
                angle: this.props.icon ? this.collapseStatus ? 180 : 0 : this.collapseStatus ? -90 : 90
              })
              .fillColor($r('app.color.gray_6'))

          }
        }
        .justifyContent(FlexAlign.End)
        .layoutWeight(1)
      }
      .width('100%')
      .height(this.props.size ? this.props.size : 44)
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .opacity(this.props.disabled ? 0.4 : 1)
      .border({
        width: {
          bottom: $r('app.float.border_width')
        },
        color: $r('app.color.border_color')
      })
      .onClick(() => {
        if (!this.props.disabled && !this.props.isReadonly) {
          this.silkCollapseController.change(this.name)
        }
      })

      Column() {
        this.collapseContent()
      }
      .width('100%')
      // .height(this.collapseStatus ? 'auto' : 0)
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Start)
      // .animation({
      //   curve: Curve.EaseInOut,
      //   duration: 300
      // })
      // .transition(TransitionEffect.translate({
      //   y: '-100%'
      // }).animation({ curve: Curve.EaseInOut, duration: 3000}))

    }
    .width('100%')
    .height(this.collapseStatus ? 'auto' : this.props.size ? this.props.size : 44)
    .clip(true)
    .backgroundColor('#fff')
    .animation({
      curve: Curve.EaseInOut,
      duration: 300
    })
    .padding(this.paddingValue)
  }
}
@Component
export struct SilkCollapseItemCustomTitle {
  @Consume
  paddingValue: Padding
  // 展开状态
  @Consume("silkCollapseController")
  @Watch('change')
  silkCollapseController: SilkCollapseController
  name: string = ''
  @BuilderParam
  collapseContent: () => void
  @BuilderParam
  collapseTitle: () => void = this.DefaultTitle
  @Prop
  props: SilkCollapseProps = DEFAULT_PROPS
  @State
  collapseStatus: boolean = false
  getCollapseStatus () {
    // 如果是禁用的 只能收起
    if (this.props.disabled) {
      this.collapseStatus = false
    }
    if (typeof this.silkCollapseController.activeNames === 'string') {
      this.collapseStatus = this.silkCollapseController.activeNames === this.name
    } else {
      this.collapseStatus = this.silkCollapseController.activeNames.includes(this.name)
    }
  }
  aboutToAppear(): void {
    this.getCollapseStatus()
    this.props = ObjectUtils.assign(this.props, DEFAULT_PROPS)
  }
  change () {
    this.getCollapseStatus()
  }
  build() {
    Column() {
      Row() {
          Column(){
            this.collapseTitle()
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Start)

        Row({ space: 4 }) {
          if (this.props.value) {
            Text(this.props.value)
              .maxLines(1)
              .textOverflow({
                overflow: TextOverflow.Ellipsis
              })
              .fontSize($r('app.float.font_size_md'))
              .fontColor($r('app.color.text_color_2'))
          }
          if (this.props.showIcon !== null && this.props.showIcon !== false) {
            Image(this.props.icon ? this.props.icon : $r('app.media.arrow'))
              .width(16)
              .aspectRatio(1)
              .rotate({
                angle: this.props.icon ? this.collapseStatus ? 180 : 0 : this.collapseStatus ? -90 : 90
              })
              .fillColor($r('app.color.gray_6'))
          }
        }
        .justifyContent(FlexAlign.End)
        .layoutWeight(1)
      }
      .width('100%')
      .height(this.props.size ? this.props.size : 44)
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .opacity(this.props.disabled ? 0.4 : 1)
      .border({
        width: {
          bottom: $r('app.float.border_width')
        },
        color: $r('app.color.border_color')
      })
      .onClick(() => {
        if (!this.props.disabled && !this.props.isReadonly) {
          this.silkCollapseController.change(this.name)
        }
      })

     if (this.collapseContent) {
       Column() {
         this.collapseContent()
       }

       .width('100%')
       // .height(this.collapseStatus ? 'auto' : 0)
       .justifyContent(FlexAlign.Start)
       .alignItems(HorizontalAlign.Start)
       // .animation({
       //   curve: Curve.EaseInOut,
       //   duration: 300
       // })
       // .transition(TransitionEffect.translate({
       //   y: '-100%'
       // }).animation({ curve: Curve.EaseInOut, duration: 3000}))
     }

    }
    .padding(this.paddingValue)
    .width('100%')
    .height(this.collapseStatus ? 'auto' : this.props.size ? this.props.size : 44)
    .clip(true)
    .backgroundColor('#fff')
    .animation({
      curve: Curve.EaseInOut,
      duration: 300
    })
  }

  @Builder
  DefaultTitle () {
    Text('标题')
      .fontSize(14)
      .fontColor('#323232')
      .maxLines(1)
      .textOverflow({
        overflow: TextOverflow.Ellipsis
      })
      .layoutWeight(1)
  }
}