import { SilkTabItem, SilkTabItemInterface, SilkTabStyle } from '../../utils'

@Component
export struct SilkTabs {
  @State
  showToast: boolean = false
  @State
  tabAreaObject: PopupProps = {
    widthV: 0,
    heightV: 0,
    pox: 0,
    poy: 0
  }
  // swiperController
  controller: SwiperController = new SwiperController()
  // 二级tab
  @BuilderParam
  subTabBar: () => void
  // 两侧图标
  @BuilderParam
  leftBuild: () => void
  @BuilderParam
  rightBuild: () => void
  @BuilderParam
  tarBar: ($$: SilkTabsTarBarInterface) => void = this.tarBarItem
  // tab间距
  tabSpace: number = 0
  // 接收content内容  swiper
  @State
  duration: number = 400
  @State
  activeDuration: number = 400
  @BuilderParam
  content: () => void
  // 记录每个tabbar的宽度
  @State
  @Watch('initActive')
  tabItemWidth: number[] = []
  // 记录每个tab的可见性
  tabItemStatus: boolean[] = []
  // tabitem默认padding
  scrollController: Scroller = new Scroller()
  // 设置高亮标志的偏移量
  @State
  moveLeft: number = 0
  // 设置高亮标志的宽度 仅支持背景色使用
  @State
  moveWidth: number = 0
  // swiper当前索引
  @Link
  @Watch('toMessageParent')
  currentIndex: number
  saveTime: number = 0
  // 记录swiper item宽度
  swiperWidth: number = 0
  _centerLeftV: number = 0 // 居中时 整体的左偏移量
  // 这是用户传递的
  line: ActiveLineInterface = {}
  // tabitem数组
  @Require
  @Prop
  tabItem: Object[] = [
    new SilkTabItem({
      title: '资料库0',
    }),
    new SilkTabItem({
      title: '资料库1',
    }),
  ]
  @State
  showToastFlag: boolean = false
  // tabBar样式
  private barHeight: number = 44
  private barBgc: ResourceStr | Color = $r('app.color.white')
  private barPadding: number | Padding = {
    right: 10,
    left: 10
  }
  // tabbar内容行样式
  private rowHeight: number = 44
  private rowRadius: number = 0
  private rowPadding: number | Padding = 0
  private rowBgc: ResourceStr | Color | null = null
  private rowShadow: ShadowOptions | ShadowStyle = {
    offsetX: 0,
    offsetY: 0,
    radius: 0,
    color: $r('app.color.white')
  }
  // 对齐方式
  private flexStyle: FlexAlign = FlexAlign.Center
  // BACKGROUND
  private bgcActiveRadius: number = 15
  private bgcActiveBgc: ResourceStr | Color = $r('app.color.white')
  private bgcBorder: BorderOptions = {}
  // Line
  private bgcZIndex: number = 0
  private _line: ActiveLineInterface = {}
  // 高亮类型
  private tabStyle: SilkTabStyle = SilkTabStyle.LINE
  // 记录滚动盒子的宽度
  private scrollWidth: number = 0
  // 接收传递的tab点击事件
  tabClick: ($$: SilkTabsTarBarInterface, event: ClickEvent) => void = ($$, event) => {
  }

  // 给父组件一个方法 通知父组件 索引更新了（若将currentIndex进行双向绑定 则很多无需使用的地方都要写多余的代码）
  toMessageParent() {
    this.initActive()
  }

  // 默认tab项
  @Builder
  tarBarItem($$: SilkTabsTarBarParameter): void {
    Text(($$.item as SilkTabItem).title)
      .fontSize(15)
      .fontColor($$.currentIndex === $$.index ? $r('app.color.base_font_color3') : $r('app.color.base_font_color6'))
      .fontWeight($$.currentIndex === $$.index ? 500 : 400)
      .padding({
        left: 20,
        right: 20
      })
  }

  // 初始化高亮标志的偏移和宽度
  initActive() {
    if (this.tabItemWidth.length === 0) {
      return;
    }
    const arr = this.tabItemWidth.filter((item: number) => item !== null && item !== undefined)
    if (arr.length === this.tabItem.length) {

      if (this.tabStyle === SilkTabStyle.BACKGROUND) {
        // tab完全显示完成后设置
        if (this.currentIndex === 0) {
          this.moveLeft = 0
          this.moveWidth = this.tabItemWidth[0]
        } else {
          this.moveLeft = this.tabItemWidth.slice(0, this.currentIndex)
            .reduce((pre: number, next: number) => pre + next, 0)
          this.moveWidth = this.tabItemWidth[this.currentIndex]
        }
      } else if (this.tabStyle === SilkTabStyle.LINE) {
        if (this.currentIndex === 0) {
          this.moveLeft = this.tabItemWidth[0] / 2 - (this._line.width as number) / 2
        } else {
          this.moveLeft = this.tabItemWidth.slice(0, this.currentIndex)
            .reduce((pre: number, next: number) => pre + next, 0) + this.tabItemWidth[this.currentIndex] / 2 -
            (this._line.width as number) / 2
        }
      }

    }

  }

  // 高亮标识动画函数
  tabActiveAnimate(index: number, targetIndex: number): GetTbTabbarLeftAndWidth {
    let leftW = 0
    if (targetIndex !== 0) {
      leftW = this.tabItemWidth.slice(0, targetIndex).reduce((pre: number, next: number) => pre + next, 0)
    }
    // 如果是行 计算偏移量
    let offsetX = 0
    // 行 和 背景色的计算不一样
    if (this.tabStyle === SilkTabStyle.LINE) {
      // 行
      offsetX = leftW + (this.tabItemWidth[targetIndex] - (this._line.width as number)) / 2
    } else {
      // 背景色
      offsetX = leftW
    }
    // 如是背景色 计算宽度
    let activeWidth = 0
    if (this.tabStyle === SilkTabStyle.BACKGROUND) {
      activeWidth = this.tabItemWidth[targetIndex]
    }
    console.log(`shuzu:${JSON.stringify(this.tabItemWidth)}---${leftW} -- ${activeWidth}`)

    return {
      leftW: offsetX,
      activeWidth
    }
  }

  // 传递给父组件builder函数 提供给swiper的change方法调用
  changeIndex: (index: number) => void = (index: number) => {
    this.currentIndex = index
    // 如果当前item被隐藏了 则需露出
    if (this.currentIndex === 0) {
      this.scrollController.scrollEdge(Edge.Start)
    } else if (this.currentIndex === this.tabItem.length - 1) {
      this.scrollController.scrollEdge(Edge.End)
    } else {
      let step = 0
      // if (this.tabItemStatus[this.currentIndex - 1] && !this.tabItemStatus[this.currentIndex]) {
      //   // 前一个显示 自己隐藏 则需向前滑动
      //   step = this.tabItemWidth.slice(0, this.currentIndex + 1)
      //     .reduce((pre: number, next: number) => pre + next, 0) - this.scrollWidth / 2
      // } else if (this.tabItemStatus[this.currentIndex + 1] && !this.tabItemStatus[this.currentIndex]) {
      //   // 自己隐藏 后一个显示 向后滑动
      //   step = this.tabItemWidth.slice(0, this.currentIndex)?.reduce((pre: number, next: number) => pre + next, 0) || 0
      // }
      step = this.tabItemWidth.slice(0, this.currentIndex).reduce((pre: number, next: number) => pre + next, 0) +
        this.tabItemWidth[this.currentIndex] / 2 - this.swiperWidth / 2
      this.scrollController.scrollTo({
        xOffset: step,
        yOffset: 0,
        animation: {
          duration: 300,
          curve: Curve.EaseInOut
        }
      })
    }
  }

  aboutToAppear(): void {
    // 初始化下划线样式
    if (this.tabStyle === SilkTabStyle.LINE) {
      const obj: ActiveLineInterface = {}
      obj.width = this.line.width || 7.5
      obj.stroke = this.line.stroke || 4
      obj.color = this.line.color || $r('app.color.base_color')
      this._line = obj
    }
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      // 内容
      Swiper(this.controller) {
        this.content()
      }
      .indicator(false)
      .index($$this.currentIndex)
      .loop(false)
      .duration(this.duration)
      .autoPlay(false)
      .curve(Curve.Ease)
      .effectMode(EdgeEffect.None)
      .nestedScroll(SwiperNestedScrollMode.SELF_FIRST)
      .width('100%')
      .layoutWeight(1)
      .onChange(this.changeIndex)
      .onGestureSwipe((index: number, extraInfo: SwiperAnimationEvent) => {
        this.activeDuration = 0
        if (this.swiperWidth === 0) {
          return;
        }
        // 计算宽和偏移
        // currentOffset > 0 向右滑。 < 0 向左滑
        // 计算比例
        const proper = extraInfo.currentOffset / this.swiperWidth
        let leftW = 0
        if (proper > 0) {
          leftW = this.tabItemWidth.slice(0, index - 1).reduce((pre: number, next: number) => pre + next, 0)
        } else {
          leftW = this.tabItemWidth.slice(0, index).reduce((pre: number, next: number) => pre + next, 0)
        }
        if (this.tabStyle === SilkTabStyle.LINE) {
          if (proper > 0) {
            this.moveLeft = leftW + (this.tabItemWidth[index - 1] - (this._line.width as number)) / 2 +
              this.tabItemWidth[index] * (1 - proper)
          } else {
            this.moveLeft = leftW + (this.tabItemWidth[index] - (this._line.width as number)) / 2 +
              this.tabItemWidth[index + 1] * (-proper)
          }
        } else {
          if (proper > 0) {
            this.moveLeft = leftW + this.tabItemWidth[index] * (1 - proper)
            this.moveWidth =
              this.tabItemWidth[index - 1] + (this.tabItemWidth[index] - this.tabItemWidth[index - 1]) * proper
          } else {
            this.moveLeft = leftW + this.tabItemWidth[index] * (-proper)
            this.moveWidth =
              this.tabItemWidth[index] + (this.tabItemWidth[index +  1] - this.tabItemWidth[index]) * (-proper)
          }
        }
      })
      .onAnimationStart((index: number, targetIndex: number, extraInfo: SwiperAnimationEvent) => {
        this.activeDuration = 400
        const params = this.tabActiveAnimate(index, targetIndex)
        this.moveLeft = params.leftW
        this.moveWidth = params.activeWidth
      })
      .onAreaChange((_: Area, area: Area) => {
        this.swiperWidth = area.width as number
      })
      .padding({
        top: this.barHeight
      })

      this.TbTabHeader()
    }
  }

  @Builder
  TbTabHeader() {
    Column() {
      // 顶部导航
      Row() {
        if (this.leftBuild) {
          this.leftBuild()
        }
        Scroll(this.scrollController) {
          Row() {
            Stack({
              alignContent: this.tabStyle === SilkTabStyle.BACKGROUND ? Alignment.Start : Alignment.BottomStart
            }) {
              if (this.tabStyle === SilkTabStyle.BACKGROUND) {
                Text('')
                  .width(this.moveWidth)
                  .height('100%')
                  .borderRadius(this.bgcActiveRadius)
                  .backgroundColor(this.bgcActiveBgc)
                  .border(this.bgcBorder)
                  .offset({
                    x: this.moveLeft + this._centerLeftV + this.currentIndex * this.tabSpace
                  })
                  .animation({
                    duration: this.activeDuration,
                    curve: Curve.EaseInOut
                  })
                  .zIndex(this.bgcZIndex)
              } else if (this.tabStyle === SilkTabStyle.LINE) {
                Divider()
                  .lineCap(LineCapStyle.Round)
                  .strokeWidth(this._line.stroke)
                  .color(this._line.color)
                  .width(this._line.width)
                  .offset({
                    x: this.moveLeft + this._centerLeftV + this.currentIndex * this.tabSpace
                  })
                  .animation({
                    duration: this.activeDuration,
                    curve: Curve.EaseInOut
                  })
              }
              Row({ space: this.tabSpace }) {
                ForEach(this.tabItem, (item: Object, index: number) => {
                  Row() {
                    this.tarBar({
                      item: item, index: index, currentIndex: this.currentIndex
                    })
                  }
                  .height(this.rowHeight)
                  .onVisibleAreaChange([0.0, 1.0], (isVisible: boolean) => {
                    this.tabItemStatus[index] = isVisible
                  })
                  .onAreaChange((oldV: Area, newV: Area) => {
                    this.tabItemWidth[index] = newV.width as number
                    if (index === 0 && this.flexStyle === FlexAlign.Center) {
                      this._centerLeftV = newV.position.x as number
                    }
                  })
                  .onClick(async (event) => {
                    this.tabClick({
                      item: item, index: index, currentIndex: this.currentIndex
                    }, event)
                    this.currentIndex = index
                  })
                })
              }
              .height('100%')
              .constraintSize({
                minWidth: '100%'
              })
              .justifyContent(this.flexStyle)
            }
            .height('100%')

          }
          .constraintSize({
            minWidth: '100%'
          })
          .justifyContent(FlexAlign.Start)
          .padding(this.rowPadding)
          .height(this.rowHeight)
          .borderRadius(this.rowRadius)
          .backgroundColor(this.rowBgc)
        }
        .height('100%')
        .layoutWeight(1)
        .scrollable(ScrollDirection.Horizontal)
        .scrollBar(BarState.Off)
        .onAreaChange((_: Area, newV: Area) => {
          this.scrollWidth = newV.width as number
        })

        if (this.rightBuild) {
          this.rightBuild()
        }
      }
      .width('100%')
      .height(this.barHeight)
      .padding(this.barPadding)
      .backgroundColor(this.barBgc)
      .justifyContent(FlexAlign.Start)

      if (this.subTabBar) {
        this.subTabBar()
      }
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .shadow(this.rowShadow)
    .onAreaChange((oldV: Area, newV: Area) => {
      this.tabAreaObject.widthV = newV.width as number
      this.tabAreaObject.heightV = newV.height as number
      this.tabAreaObject.pox = newV.globalPosition.x as number
      this.tabAreaObject.poy = newV.globalPosition.y as number

      // this.showToastFlag = true
    })
    .bindContentCover(this.showToastFlag, this.ToastBuilder(this.tabAreaObject),
      { modalTransition: ModalTransition.NONE })

  }

  @Builder
  ToastBuilder(props: PopupProps) {
    Column() {
      Column() {

      }
      .width('100%')
      .height(props.poy)
      .backgroundColor('rgba(0,0,0,0.8)')
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])

      Column() {
        Text('测试')
          .fontColor(Color.White)
      }
      .border({
        width: 1,
        color: Color.White
      })
      .width('100%')
      .height(props.heightV)
      .backgroundColor(Color.Transparent)

      Column()
        .width('100%')
        .layoutWeight(1)
        .backgroundColor('rgba(0,0,0,0.8)')
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    }
    .width('100%')
    .layoutWeight(1)

  }
}

interface PopupProps {
  widthV: number
  heightV: number
  pox: number
  poy: number
}

@Component
export struct SilkTabContent {
  @BuilderParam
  children: () => void

  build() {
    Column() {
      this.children()
    }
    .width('100%')
    .height('100%')
  }
}

// item builder
export interface SilkTabsTarBarInterface {
  item: Object
  index: number
  currentIndex: number
}

export class SilkTabsTarBarParameter implements SilkTabsTarBarInterface {
  item: Object = new SilkTabItem({} as SilkTabItemInterface)
  index: number = 0
  currentIndex: number = 0

  constructor(model: SilkTabsTarBarInterface) {
    this.item = model.item
    this.index = model.index
    this.currentIndex = model.currentIndex
  }
}


// 计算active的位置和宽度 返回值
interface GetTbTabbarLeftAndWidth {
  leftW: number,
  activeWidth: number
}

export interface ActiveLineInterface {
  width?: number
  stroke?: number
  color?: ResourceColor
}