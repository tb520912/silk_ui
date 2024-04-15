import promptAction from '@ohos.promptAction'
import { LazyDataSource } from '../../utils'
import { ScrollReturn } from './model'
import LoadMoreLayout, { LoadMoreStatus } from './LoadMoreLayout'
import RefreshLayout from './RefreshLayout'


// 列表分割线
interface ListDivider {
  strokeWidth: Length,
  color?:ResourceColor,
  startMargin?: Length,
  endMargin?: Length
}
@Preview
@Component
export struct CustomList {
  @Prop
  lanes: number = 1
  gutters: number = 0
  // 分割线
  divider: ListDivider | null = null
  // 间隔
  space: number | string = 16
  // 两侧留白
  paddingLr: number | string = 12
  // 背景色
  background_color: ResourceColor = $r('app.color.white')
  @State
  loading: boolean = false
  // 是否加载完毕
  @Prop
  finished: boolean
  // 数据源
  @Link
  @Watch('updateDataSource')
  dataSource: object[]
  // 懒加载
  listDataSource: LazyDataSource<object> = new LazyDataSource<object>()
  updateDataSource() {
    this.listDataSource.pushArrayData(this.dataSource)
  }
  // 触发加载距离
  offsetValue: number = 80
  // 是否开启下拉刷新
  openRefresh: boolean = false
  // 是否自动加载.
  /**
   * 自动加载：
   *     列表触底直接触发加载
   * 不自动加载：
   *      根据手指滑动距离判断是否进行加载 底部多存在上拉过程的状态
   */
  openAutoLoad: boolean = true

  onLoad: () => Promise<void> = async () => {
  }
  onRefresh: () => Promise<void> = async () => {

  }
  // 子元素
  @BuilderParam
  children: (item: object) => void

  keyGenera: (item: object, index: number) => string = (item: object, index: number) => JSON.stringify(item)
  // 二次封装加载方法
  async loadMore() {
    if (!this.finished && !this.loading) {
      this.loading = true
      await this.onLoad()
      this.loading = false
      this.isCanLoad = false
    }
  }

  // 刷新
  @State
  refreshStatus: RefreshStatus = RefreshStatus.Inactive
  @State
  isRefreshing: boolean = false
  // 加载
  @State
  loadStatus: LoadMoreStatus = LoadMoreStatus.Inactive
  // 列表状态 是否到顶
  isCanRefresh: boolean = true
  // 列表状态 能否到底
  @State
  isCanLoad: boolean = false

  getOffset(heightValue: number): string {
    return ''
  }

  @State
  target: number = 0
  // 手指抬起状态
  count: number = 0 // 记录 触底事件仅在渲染首屏时触发加载
  // 手指抬起状态
  @State
  isDown: boolean = false
  boxHeight: number = 0 // 记录盒子高度
  startY: number = 0
  isSaveTouchStart: boolean = false // 是否记录了滑动状态起始点
  images: ImageFrameInfo[] = [
    {
      src: $r('app.media.01')
    },
    {
      src: $r('app.media.02')
    },
    {
      src: $r('app.media.03')
    },
    {
      src: $r('app.media.04')
    },
    {
      src: $r('app.media.05')
    },
    {
      src: $r('app.media.06')
    },
    {
      src: $r('app.media.07')
    }
  ]

  @Builder
  customRefreshComponent() {
    Stack({ alignContent: Alignment.Bottom }) {
      Row() {
        ImageAnimator()
          .images(this.images)
          .width(50)
          .height(50)
          .iterations(-1)
          .duration(400)
          .state(
            this.refreshStatus === RefreshStatus.Drag
              ?
            AnimationStatus.Initial
              :
              this.refreshStatus === RefreshStatus.Done
                ?
              AnimationStatus.Stopped
                :
              AnimationStatus.Running)
      }

    }.width("100%")
    .backgroundColor(Color.Pink)
  }

  @Builder
  listMore() {
    LoadMoreLayout({
      status: $loadStatus
    })
  }

  // 使用方传递的监听scrollFrameBegin方法的回调
  childrenScrollFrameBegin: (offset: number, state: ScrollState) => ScrollReturn = (offset, state) => {
    return {
      offsetRemain: offset
    }
  }

  // 自用方法
  private async _reachEnd () {
    // 自动加载
    if (this.openAutoLoad) {
      if (this.loading) return;
      if (this.finished) {
        this.loadStatus = LoadMoreStatus.NO_MORE
        setTimeout(() => {
          this.loadStatus = LoadMoreStatus.Inactive
        }, 300)
      } else {
        this.loadStatus = LoadMoreStatus.Loading
        await this.loadMore()
        if (this.loadStatus === LoadMoreStatus.Loading) {
          this.loadStatus = LoadMoreStatus.Done
          setTimeout(() => {
            this.loadStatus = LoadMoreStatus.Inactive
          }, 300)
        }
      }
    }
    // 上拉加载
    else {
      this.isCanLoad = true
      // 触底触发刷新
      if (this.loading || this.finished) return;
      if (this.count > 0) return;
      this.loadStatus = LoadMoreStatus.Loading
      this.loading = true
      this.count++
      await this.onLoad()
      this.loading = false
      this.loadStatus = LoadMoreStatus.Done
      this.isCanLoad = false
      setTimeout(() => {
        this.loadStatus = LoadMoreStatus.Inactive
      }, 300)
    }
  }
  private async _areaChange (_: Area, event: Area) {
    const listHeight = event.height as number
    if (listHeight < this.boxHeight && !this.loading && !this.finished) {
      await this.loadMore()
    }
  }
  private async _touch (event: TouchEvent) {
    // 自动加载无需监听该事件
    if (this.openAutoLoad) return;
    // 列表未触底时 不执行touch事件
    if (!this.isCanLoad) return;
    if (this.loading) return;
    // 列表触底 没有更多
    if (this.finished) {
      this.loadStatus = LoadMoreStatus.NO_MORE
    }
    switch (event.type) {
      case TouchType.Down:
        this.isDown = true
        this.startY = event.touches[0].windowY
        this.isSaveTouchStart = true
        break;
      case TouchType.Move:
        const moveY = event.touches[0].windowY;
        if (!this.isSaveTouchStart) {
          this.startY = moveY
          this.isSaveTouchStart = true
        } else {
          if (!this.finished) {
            if (this.startY - moveY > this.offsetValue) {
              // 触底后 上滑超过50
              this.loadStatus = LoadMoreStatus.OverDrag
            } else {
              this.loadStatus = LoadMoreStatus.Drag
            }
          }
        }
        break;
      case TouchType.Up:
      case TouchType.Cancel:
        this.isDown = false
        this.isSaveTouchStart = false
        if (this.loadStatus === LoadMoreStatus.OverDrag) {
          this.loadStatus = LoadMoreStatus.Loading
          await this.loadMore()
          this.isCanLoad = false
          this.loadStatus = LoadMoreStatus.Done
          setTimeout(() => {
            this.loadStatus = LoadMoreStatus.Inactive
          }, 300)
        } else {
          this.loadStatus = LoadMoreStatus.Inactive
        }
        break;

    }
  }

  build() {
    if (this.openRefresh) {
      Column() {
        Refresh({ refreshing: $$this.isRefreshing, builder: this.customRefreshComponent() }) {
          Stack({ alignContent: Alignment.Bottom }) {
            List() {
              ListItemGroup({ footer: this.listMore(), space: this.space }) {
                LazyForEach(this.listDataSource, (item: object) => {
                  ListItem() {
                    if (this.children) {
                      this.children(item)
                    }
                  }
                  .backgroundColor($r('app.color.white'))
                }, this.keyGenera)
              }
              .divider(this.divider)
            }
            .width('100%')
            .height('100%')
            .lanes(this.lanes, this.gutters)
            .padding({
              left: this.paddingLr,
              right: this.paddingLr
            })
            .nestedScroll({
              scrollForward: NestedScrollMode.PARENT_FIRST,
              scrollBackward: NestedScrollMode.SELF_FIRST
            })
            .scrollBar(BarState.Off)
            .onReachEnd(() => this._reachEnd())
            .onAreaChange((_: Area, event: Area) => this._areaChange(_, event))
            // 上拉加载
            .onTouch((event: TouchEvent) => this._touch(event))
            .onScrollFrameBegin(this.childrenScrollFrameBegin)
          }
        }
        .onStateChange(async (value: RefreshStatus) => {
          if (!this.openRefresh) return;
          if (value === RefreshStatus.Refresh) {
            if (this.loading) return;
            this.loading = true
            await this.onRefresh()
            this.loading = false
            this.isRefreshing = false
          }
        })
        .backgroundColor(this.background_color)
      }
      .onAreaChange((_: Area, event: Area) => {
        this.boxHeight = event.height as number
      })
    } else {
      Column() {
        List() {
          ListItemGroup({ footer: this.listMore(), space: this.space }) {
            LazyForEach(this.listDataSource, (item: object) => {
              ListItem() {
                if (this.children) {
                  this.children(item)
                }
              }
              .backgroundColor($r('app.color.white'))
            }, this.keyGenera)
          }
          .divider(this.divider)
        }
        .width('100%')
        .height('100%')
        .padding({
          left: 15,
          right: 15
        })
        .lanes(this.lanes, this.gutters)
        .scrollBar(BarState.Off)
        .nestedScroll({
          scrollForward: NestedScrollMode.PARENT_FIRST,
          scrollBackward: NestedScrollMode.SELF_FIRST
        })
        .onReachEnd(() => this._reachEnd())
        .onAreaChange((_: Area, event: Area) => this._areaChange(_, event))
        // 上拉加载
        .onTouch((event: TouchEvent) => this._touch(event))
        .onScrollFrameBegin((offset: number, state: ScrollState) => this.childrenScrollFrameBegin(offset, state))
        .backgroundColor(this.background_color)
      }
      .onAreaChange((_: Area, event: Area) => {
        this.boxHeight = event.height as number
      })
    }
  }
}
