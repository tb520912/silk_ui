class MyColumnModifier implements AttributeModifier<ColumnAttribute> {
  spaceArround: boolean = false

  applyNormalAttribute(instance: ColumnAttribute): void {
    if (this.spaceArround) {
      instance.layoutWeight(1)
    } else {

    }
  }
}

@Observed
export class SilkTabsController {
  private _initIndex: number = 0 // 页签初始位置
  private _tabItemLength: number = 0 // 页签数量
  private _indicator: SilkIndicatorData = {
    left: 0,
    width: 0
  }
  private myColumn: MyColumnModifier = new MyColumnModifier()
  private _tabItemWidth: number[] = [] // 由于元素的尺寸信息 无法通过接口获取 需要tabbar组件进行传递
  private _tabItemLeft: number[] = [] // 各元素距离父级左边距
  private _contentSize: ContentSize = { width: 0, height: 0 } // tabs组件宽度
  private _tabStyle: SilkTabStyle = SilkTabStyle.LINE
  private _scrollController: Scroller = new Scroller()
  private _duration: number = 300
  private _barSize: ContentSize = { width: 0, height: 0 }
  private _flexStyle: 'left' | 'center' | 'right' = 'center'
  private _tabSpace: number = 0 // 页签间距
  private _rowPadding: number = 0
  private isScroll: boolean = false
  private _spaceArround: boolean = true

  setSpaceArround(value: boolean) {
    this._spaceArround = value
  }

  getModifier() {
    return this.myColumn
  }

  getIsScroll() {
    return this.isScroll
  }

  setInitIndex(value: number) {
    this._initIndex = value
  }

  setTabItemLength(value: number) {
    this._tabItemLength = value
  }

  setIndicator(value: SilkIndicatorData) {
    this._indicator = value
  }

  setTabsSize(value: ContentSize) {
    this._contentSize = value
  }

  setTabStyle(value: SilkTabStyle) {
    this._tabStyle = value
  }

  setTabItemWidth(value: number[]) {
    this._tabItemWidth = value
  }

  setTabItemLeft(value: number[]) {
    this._tabItemLeft = value
  }

  setBarSize(value: ContentSize) {
    this._barSize = value
  }

  setFlexStyle(value: 'left' | 'center' | 'right') {
    this._flexStyle = value
  }

  setRowPadding(value: number) {
    this._rowPadding = value
  }

  getScrollController() {
    return this._scrollController
  }

  getDuration() {
    return this._duration
  }

  getTabStyle() {
    return this._tabStyle
  }

  setTabSpace(value: number) {
    this._tabSpace = value
  }

  // 初始化高亮标志的偏移和宽度
  initActive() {
    if (this._tabItemWidth.length === 0) {
      return;
    }
    const arr = this._tabItemWidth.filter((item: number) => item !== null && item !== undefined)
    if (arr.length >= this._tabItemLength) {
      this.isScroll = this._tabItemWidth.reduce((pre: number, next: number) => pre + next, 0) > this._barSize.width
      if (!this.isScroll && this._spaceArround) {
        this.myColumn.spaceArround = true
      }
      if (this._tabStyle === SilkTabStyle.BACKGROUND) {
        // tab完全显示完成后设置
        if (this._initIndex === 0) {
          // this._indicator.left = 0
          this._indicator.left = this._tabItemLeft[0]
          this._indicator.width = this._tabItemWidth[0]
        } else {
          // this._indicator.left = this._tabItemWidth.slice(0, this._initIndex)
          //   .reduce((pre: number, next: number) => pre + next, 0)
          // this._indicator.width = this._tabItemWidth[this._initIndex]
          this._indicator.left = this._tabItemLeft[this._initIndex]
          this._indicator.width = this._tabItemWidth[this._initIndex]
        }
      } else if (this._tabStyle === SilkTabStyle.LINE) {
        if (this._initIndex === 0) {
          // this._indicator.left = this._tabItemWidth[0] / 2 - this._indicator.width / 2
          this._indicator.left = this._tabItemLeft[0] + this._tabItemWidth[0] / 2 - this._indicator.width / 2
        } else {
          // this._indicator.left = this._tabItemWidth.slice(0, this._initIndex)
          //   .reduce((pre: number, next: number) => pre + next, 0) + this._tabItemWidth[this._initIndex] / 2 -
          //   this._indicator.width / 2 + this._initIndex * this._tabSpace
          this._indicator.left = this._tabItemLeft[this._initIndex] + this._tabItemWidth[this._initIndex] / 2 -
            this._indicator.width / 2
        }
      }

    }

  }

  // 如果需要在手势滑动过程中同步移动下划线 则需要在监听tab组件的onGestureSwipe事件 并执行该方法
  gestureSwiper(index: number, extraInfo: TabsAnimationEvent) {
    this._duration = 0
    if (this._contentSize.width === 0) {
      return;
    }
    // 边界滑动
    if ((index === 0 && extraInfo.currentOffset > 0) ||
      (index === this._tabItemLength - 1 && extraInfo.currentOffset < 0)) {
      return;
    }
    // 计算宽和偏移
    // currentOffset > 0 向右滑。 < 0 向左滑
    // 计算比例
    const proper = extraInfo.currentOffset / this._contentSize.width
    let leftW = 0
    if (proper > 0) {
      // leftW = this._tabItemWidth.slice(0, index - 1).reduce((pre: number, next: number) => pre + next, 0) +
      //   (index - 1) * this._tabSpace
      leftW = this._tabItemLeft[index -1]
    } else {
      // leftW =
      //   this._tabItemWidth.slice(0, index).reduce((pre: number, next: number) => pre + next, 0) + index * this._tabSpace
      leftW = this._tabItemLeft[index]
    }
    if (this._tabStyle === SilkTabStyle.LINE) {
      if (proper > 0) {
        // this._indicator.left =
        //   leftW + (this._tabItemWidth[index - 1] - this._indicator.width) / 2 +
        //     (this._tabItemWidth[index] + this._tabSpace) * (1 - proper)
        this._indicator.left = leftW + (this._tabItemWidth[index - 1] - this._indicator.width) / 2 +
          (this._tabItemLeft[index] - this._tabItemLeft[index - 1]) * (1 - proper)
      } else {
        // this._indicator.left =
        //   leftW + (this._tabItemWidth[index] - this._indicator.width) / 2 +
        //     (this._tabItemWidth[index + 1] + this._tabSpace) * (-proper)
        this._indicator.left = leftW + (this._tabItemWidth[index] - this._indicator.width) / 2 +
          (this._tabItemLeft[index + 1] - this._tabItemLeft[index]) * (-proper)
      }
    } else {
      if (proper > 0) {
        // this._indicator.left = leftW + (this._tabItemWidth[index] + this._tabSpace) * (1 - proper)
        // this._indicator.width =
        //   this._tabItemWidth[index - 1] + (this._tabItemWidth[index] - this._tabItemWidth[index - 1]) * proper
        this._indicator.left = leftW + (this._tabItemLeft[index] - this._tabItemLeft[index - 1]) * (1 - proper)
        this._indicator.width =
          this._tabItemWidth[index - 1] + (this._tabItemWidth[index] - this._tabItemWidth[index - 1]) * proper
      } else {
        // this._indicator.left = leftW + (this._tabItemWidth[index] + this._tabSpace) * (-proper)
        // this._indicator.width =
        //   this._tabItemWidth[index] + (this._tabItemWidth[index +  1] - this._tabItemWidth[index]) * (-proper)
        this._indicator.left = leftW + (this._tabItemLeft[index + 1] - this._tabItemLeft[index]) * (-proper)
        this._indicator.width =
          this._tabItemWidth[index] + (this._tabItemWidth[index + 1] - this._tabItemWidth[index]) * (-proper)
      }
    }
  }

  // 如果需要在tab在执行切换动画时同步移动下划线 则需要在监听tab组件的onAnimationStart事件 并执行该方法
  tabActiveAnimate(index: number, target: number) {
    this._duration = 300
    let leftW = this._tabItemLeft[target]

    // 如果是行 计算偏移量
    let offsetX = 0
    // 行 和 背景色的计算不一样
    if (this._tabStyle === SilkTabStyle.LINE) {
      // 行
      offsetX = leftW + (this._tabItemWidth[target] - this._indicator.width) / 2
    } else {
      // 背景色
      offsetX = leftW
    }
    // 如是背景色 计算宽度
    let activeWidth = this._indicator.width
    if (this._tabStyle === SilkTabStyle.BACKGROUND) {
      activeWidth = this._tabItemWidth[target]
    }
    this._indicator.width = activeWidth
    this._indicator.left = offsetX
  }

  // 监听激活项的变化 将激活项移到滚动容器中央的位置，并设置最终的偏移量
  changeIndex(currentIndex: number) {
    this._initIndex = currentIndex
    // 如果当前item被隐藏了 则需露出
    if (currentIndex === 0) {
      this._scrollController?.scrollEdge(Edge.Start)
      if (this._tabStyle === SilkTabStyle.BACKGROUND) {
        this._indicator.left = this._tabItemLeft[0]
        this._indicator.width = this._tabItemWidth[0]
      } else {
        this._indicator.left = this._tabItemLeft[0] + this._tabItemWidth[0] / 2 - this._indicator.width / 2
      }
    } else if (currentIndex === this._tabItemLength - 1) {
      this._scrollController?.scrollEdge(Edge.End)
      if (this._tabStyle === SilkTabStyle.BACKGROUND) {
        // this._indicator.left =
        //   this._tabItemWidth.slice(0, currentIndex).reduce((pre: number, next: number) => pre + next, 0) +
        //     (currentIndex) * this._tabSpace
        // this._indicator.width = this._tabItemWidth[this._tabItemLength - 1]
        this._indicator.left = this._tabItemLeft[currentIndex]
        this._indicator.width = this._tabItemWidth[this._tabItemLength - 1]
      } else {
        // this._indicator.left =
        //   this._tabItemWidth.slice(0, currentIndex).reduce((pre: number, next: number) => pre + next, 0) +
        //     this._tabItemWidth[this._tabItemLength - 1] / 2 - this._indicator.width / 2 +
        //     (currentIndex) * this._tabSpace
        this._indicator.left =
          this._tabItemLeft[currentIndex] + this._tabItemWidth[currentIndex] / 2 - this._indicator.width / 2
      }
    } else {
      let step = 0
      // 将激活的页签放在居中位置
      // const value = this._tabItemWidth.slice(0, currentIndex).reduce((pre: number, next: number) => pre + next, 0) +
      //   (currentIndex) * this._tabSpace
      const value = this._tabItemLeft[currentIndex]
      step = value + this._tabItemWidth[currentIndex] / 2 - this._barSize.width / 2
      if (this._tabStyle === SilkTabStyle.BACKGROUND) {
        this._indicator.left = value
        this._indicator.width = this._tabItemWidth[currentIndex]
      } else {
        this._indicator.left = step - this._indicator.width / 2 + this._barSize.width / 2
      }
      this._scrollController?.scrollTo({
        xOffset: step + this._rowPadding,
        yOffset: 0,
        animation: {
          duration: this._duration,
          curve: Curve.EaseInOut
        }
      })
    }
  }
}

interface ContentSize {
  width: number
  height: number
}

interface IndicatorPosition {
  left: number
  width: number
}

export enum SilkTabStyle {
  NONE = 'none',
  LINE = 'line',
  BACKGROUND = 'background'
}

// 导出一个对象类型 在tabbar组件中设置一个响应式数据 利用参数传递复杂类型数据传地址的特点 实现数据的同步更新

export interface SilkIndicatorData {
  left: number
  width: number
}

@Observed
export class SilkIndicatorBean implements SilkIndicatorData {
  left: number
  width: number

  constructor(model: SilkIndicatorData) {
    this.left = model.left
    this.width = model.width
  }
}

export interface SilkTabItemInterface {
  id?: string
  title: string
  icon?: ResourceStr
  show?: boolean // 是否展示
  visible?: boolean // 是否可用
}

@Observed
export class SilkTabItem implements SilkTabItemInterface {
  id?: string
  title: string = ''
  icon?: ResourceStr
  show: boolean = true
  visible: boolean = true

  constructor(model: SilkTabItemInterface) {
    this.id = model.id
    this.title = model.title
    this.icon = model.icon
    this.show = model.show || true
    this.visible = model.visible || true
  }

  // children: PropertyDecorator
}