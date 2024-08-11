import { SilkIndicatorBean, SilkTabItem, SilkTabItemInterface, SilkTabsController, SilkTabStyle } from '../../utils'

@Component
export struct SilkTabBar {
  @Link
  @Watch('changeIndex')
  currentIndex: number
  // @ObjectLink
  silkTabsController: SilkTabsController = new SilkTabsController()
  @Prop
  @Watch('updateList')
  list: SilkTabItem[] | SilkTabItemInterface[] | object[] = []
  props: SilkTabBarProps = {
    height: 40
  }
  @State
  indicatorData: SilkIndicatorBean = new SilkIndicatorBean({
    left: 0,
    width: 12
  })
  @State
  @Watch('initActive')
  tabItemWidth: number[] = []
  @State
  @Watch('initActive')
  tabItemLeft: number[] = []
  @BuilderParam
  LeftBuilder: () => void
  @BuilderParam
  RightBuilder: () => void
  @BuilderParam
  TabBar: (item: SilkTabBarInterface) => void
  tabClick?: ($$: SilkTabBarInterface, event: ClickEvent) => void

  updateList() {
    // this.tabItemWidth = []
    // this.tabItemLeft = []
    // this.silkTabsController.setTabItemWidth(this.tabItemWidth)
    // this.silkTabsController.setTabItemLeft(this.tabItemLeft)
    this.silkTabsController.setTabItemLength(this.list.length)

  }

  aboutToAppear(): void {
    if (this.props.indicator?.width) {
      this.indicatorData.width = this.props.indicator.width
    }
    if (this.props.spaceArround === undefined) {
      this.props.spaceArround = true
    }
    this.silkTabsController.setSpaceArround(this.props.spaceArround)
    this.silkTabsController.setInitIndex(this.currentIndex)
    this.silkTabsController.setTabItemLength(this.list.length)
    this.silkTabsController.setTabItemWidth(this.tabItemWidth)
    this.silkTabsController.setTabItemLeft(this.tabItemLeft)
    this.silkTabsController.setIndicator(this.indicatorData)
    this.silkTabsController.setTabStyle(this.props.indicatorStyle || SilkTabStyle.LINE)
    this.silkTabsController.setFlexStyle(this.props.flexStyle || 'center')
    this.silkTabsController.setTabSpace(this.props.tabSpace || 0)
    this.silkTabsController.setRowPadding((typeof this.props.padding === 'number' ? this.props.padding :
      this.props.padding?.left) as number || 0)
  }

  build() {
    RelativeContainer() {
      if (this.LeftBuilder) {
        Row() {
          if (this.LeftBuilder) {
            this.LeftBuilder()
          }
        }
        .width(this.props.marginLeft)
        .height('100%')
        .id('bar_left')
        .alignRules({
          left: { anchor: '__container__', align: HorizontalAlign.Start },
          center: { anchor: '__container__', align: VerticalAlign.Center }
        })
      }
      Scroll(this.silkTabsController.getScrollController()) {
        RelativeContainer() {
          Row({ space: this.props.tabSpace || 0 }) {
            ForEach(this.list, (item: SilkTabItem, index: number) => {
              Column() {
                if (this.TabBar) {
                  this.TabBar({ item: item, index: index })
                } else if (item instanceof SilkTabItem || this.getItemIsSilkTabItem(item)) {
                  Text(item.title)
                    .fontSize(16)
                    .fontColor(this.currentIndex === index ?
                      this.props.active_color ? this.props.active_color : $r('app.color.base_color') :
                      this.props.color ? this.props.color : $r('app.color.base_font_color3'))
                    .padding({
                      left: (typeof this.props.padding === 'number' ? this.props.padding : this.props.padding?.left) ||
                        10,
                      right: (typeof this.props.padding === 'number' ? this.props.padding : this.props.padding?.left) ||
                        10
                    })
                    .height('100%')
                    .maxLines(1)

                }
              }
              .visibility((item instanceof SilkTabItem && !item.show) ? Visibility.None : Visibility.Visible)
              .onClick((event) => {
                this.currentIndex = index
                if (this.tabClick) {
                  this.tabClick({
                    item,
                    index
                  }, event)
                }
              })
              .onAreaChange((oldV: Area, newV: Area) => {
                if (this.tabItemWidth[index]) {
                  this.tabItemWidth.splice(index, 1, newV.width as number)
                  this.tabItemLeft.splice(index, 1, newV.position.x as number)
                } else {
                  this.tabItemWidth[index] = newV.width as number
                  this.tabItemLeft[index] = newV.position.x as number
                }
              })
              .attributeModifier(this.silkTabsController.getModifier())

            })
          }
          .zIndex(1)
          .padding(this.props.rowPadding || 0)
          .id('bar_row')
          .height('100%')
          .constraintSize({
            minWidth: !this.props.spaceArround ? 0 : '100%'
          })
          .justifyContent(this.getAlign())

          if (this.silkTabsController.getTabStyle()) {
            if (this.silkTabsController.getTabStyle() === SilkTabStyle.LINE) {
              Row()
                .borderRadius(2)
                .width(this.indicatorData.width)
                .height(this.props.indicator?.height || 4)
                .backgroundColor(this.props.indicator?.color || $r('app.color.base_color'))
                .id('bar_line')
                .alignRules({
                  bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
                  left: { anchor: 'bar_row', align: HorizontalAlign.Start }
                })
                .offset({
                  x: this.indicatorData.left || 0
                })
                .animation({
                  duration: this.silkTabsController.getDuration(),
                  curve: Curve.EaseInOut
                })
                .zIndex(2)

            } else if (this.silkTabsController.getTabStyle() === SilkTabStyle.BACKGROUND) {
              Row()
                .width(this.indicatorData.width)
                .height(this.getBarHeight())
                .borderRadius(this.props.indicator?.radius)
                .backgroundColor(this.props.indicator?.color)
                .border({
                  width: this.props.indicator?.borderWidth || 0,
                  color: this.props.indicator?.borderColor || Color.White,
                  style: this.props.indicator?.borderStyle || BorderStyle.Solid
                })
                .id('bar_bg')
                .alignRules({
                  center: { anchor: '__container__', align: VerticalAlign.Center },
                  left: { anchor: 'bar_row', align: HorizontalAlign.Start }
                })
                .offset({
                  x: this.indicatorData.left
                })
                .animation({
                  duration: this.silkTabsController.getDuration(),
                  curve: Curve.EaseInOut
                })
                .zIndex(this.props.indicator?.zIndex || 0)
            }
          }
        }
        .constraintSize({
          minWidth: !this.props.spaceArround ? 0 : '100%'
        })
        .width('auto')
        .height(this.props.height)
        .borderRadius(this.props.radius ? this.props.radius : 0)
        .backgroundColor(this.props.bgColor ? this.props.bgColor : Color.White)
      }
      .width('calc(100% - ' + this.props.iconWidth + 'vp)')
      .height(this.props.height)
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .id('bar_container')
      .alignRules(this.getAlignRule())
      .align(this.getBarAlign())

      if (this.RightBuilder) {
        Row() {
          this.RightBuilder()
        }
        .width(this.props.marginRight)
        .height('100%')
        .id('bar_right')
        .alignRules({
          right: { anchor: '__container__', align: HorizontalAlign.End },
          center: { anchor: '__container__', align: VerticalAlign.Center }
        })
      }
    }
    .width('100%')
    .height('100%')
    .onAreaChange((_, area) => {
      this.silkTabsController.setBarSize({
        width: area.width as number,
        height: area.height as number
      })
    })
  }

  getAlignRule(): AlignRuleOption {
    if (!!this.LeftBuilder && !this.RightBuilder && this.props.flexStyle === 'right') {
      return {
        center: { anchor: '__container__', align: VerticalAlign.Center },
        right: { anchor: '__container__', align: HorizontalAlign.End },
      }
    } else if (!this.LeftBuilder && !!this.RightBuilder && this.props.flexStyle === 'left') {
      return {
        center: { anchor: '__container__', align: VerticalAlign.Center },
        left: { anchor: '__container__', align: HorizontalAlign.Start },
      }
    } else {
      return {
        center: { anchor: '__container__', align: VerticalAlign.Center },
        middle: { anchor: '__container__', align: HorizontalAlign.Center }
      }
    }
  }

  // 获取背景高度
  getBarHeight(): Length {
    if (this.props.rowPadding) {
      if (typeof this.props.rowPadding === 'number') {
        return `calc(100% - ${2 * this.props.rowPadding}vp)`
      } else {
        let top: Length = 0
        let bottom: Length = 0
        if ((this.props.rowPadding as Padding).top) {
          top = (typeof this.props.rowPadding.top === 'number' ? this.props.rowPadding.top + 'vp' :
          this.props.rowPadding.top)!
        }
        if ((this.props.rowPadding as Padding).bottom) {
          bottom = (typeof this.props.rowPadding.bottom === 'number' ? this.props.rowPadding.bottom + 'vp' :
          this.props.rowPadding.bottom)!
        }
        return `calc(100% - ${top} - ${bottom})`
      }
    } else {
      return '100%'
    }
  }

  // 判断item类型
  getItemIsSilkTabItem(item: object): boolean {
    const arr = Object.keys(item)
    const defaultKey: string[] = ['id', 'title', 'icon', 'show', 'visible']
    if (arr.length > defaultKey.length) {
      return false
    } else {
      // 判断arr中是否存在defaultArr中没有的元素
      return defaultKey.some(v =>!arr.includes(v))
    }
  }

  changeIndex() {
    this.silkTabsController.changeIndex(this.currentIndex)
  }

  initActive() {
    const l1 = this.list.length
    const l2 = this.tabItemWidth.filter(item => item !== undefined || item !== null).length
    const l3 = this.tabItemLeft.filter(item => item !== undefined || item !== null).length
    if (l1 <= l2 && l2 === l3) {
      this.silkTabsController.initActive()
    }
  }

  // 设置tabbaritem的水平对齐方式
  getAlign() {
    if (!this.silkTabsController.getIsScroll()) {
      if (this.props.spaceArround) {
        return FlexAlign.SpaceAround
      } else {
        switch (this.props.flexStyle) {
          case 'left':
            return FlexAlign.Start
          case 'right':
            return FlexAlign.End
          default:
            return FlexAlign.Center
        }
      }
    } else {
      return FlexAlign.Start
    }
  }

  getBarAlign() {
    switch (this.props.flexStyle) {
      case 'left':
        return Alignment.Start
      case 'right':
        return Alignment.End
      default:
        return Alignment.Center
    }
  }
}

export interface SilkTabBarProps {
  indicatorStyle?: SilkTabStyle
  flexStyle?: 'left' | 'center' | 'right'
  spaceArround?: boolean // 是否均分 默认在不滚动时均分
  height: Length
  width?: Length
  iconWidth?: Length
  marginLeft?: Length
  marginRight?: Length
  fontSize?: number
  fontWeight?: number
  padding?: Padding | number
  active_color?: ResourceColor
  color?: ResourceColor
  indicator?: SilkTabBarIndicator
  radius?: number
  bgColor?: ResourceColor
  tabSpace?: number
  rowPadding?: Padding | number
}

export interface SilkTabBarIndicator {
  width?: number
  height?: number
  radius?: number
  color?: ResourceColor
  borderWidth?: number
  borderColor?: ResourceColor
  borderStyle?: BorderStyle,
  zIndex?: number
}

export interface SilkTabBarInterface {
  item: SilkTabItemInterface | object
  index: number
}

