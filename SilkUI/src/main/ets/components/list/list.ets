/*
 * Copyright (C) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { LazyDataSource } from '../../utils';
import LoadMoreLayout, { LoadMoreStatus } from './LoadMoreLayout';
import { RefreshStatus } from './RefreshLayout';
import { image } from '@kit.ImageKit';
import { ValueAnimator } from '../../utils/ValueAnimator';
import { SilkListDefaultProp, SilkListProps } from './SilkListDefaultProp';
import { ObjectUtils } from '../../utils/ObjectUtils';


@Component
export struct SilkGridList {
  // 特殊处理的索引及方法
  @Prop
  irregularIndexes: number[] = []
  @Prop
  onGetIrregularSizeByIndex: (index: number) => [number, number]

  @Prop
  finished: boolean
  // 加载或刷新中
  @State
  private loading: boolean = false
  // 数据源
  @Prop
  @Require
  @Watch('updateDataSource')
  dataSource: object[] = []
  // 懒加载
  listDataSource: LazyDataSource<object> = new LazyDataSource<object>()
  updateDataSource() {
    this.listDataSource.pushArrayData(this.dataSource)
  }
  // 子元素
  @BuilderParam
  @Require
  children: (item: object) => void
  keyGenera: (item: object, index: number) => string = (item: object) => JSON.stringify(item)

  scroller: Scroller = new Scroller();
  mWidth?: Length = '100%';
  mHeight?: Length = '100%';
  refresh?: () => Promise<void> = () => {
    return new Promise<void>((resolve) => {
      setTimeout(() => {
        resolve();
      }, 1000);
    });
  };
  @Require
  load?: () => Promise<void> = () => {
    return new Promise<void>((resolve) => {
      setTimeout(() => {
        resolve();
      }, 1000);
    });
  };
  private async loadMore () {
    this.loading = true
    this.loadState = LoadMoreStatus.Loading
    this.trYBottom = 50
    if (this.load) {
      await this.load();
    }
    this.trYBottom = 0
    this.loading = false
    if (this.loadState === LoadMoreStatus.Loading) {
      this.loadState = LoadMoreStatus.Inactive;
    }
  }
  // 自定义下拉动画
  @BuilderParam customRefresh?: (() => void) | null;
  //开启自定义下拉动画
  onAnimPullDown?: (value?: number, width?: number, height?: number) => void;
  onAnimRefreshing?: (value?: number, width?: number, height?: number) => void;
  // 自定义上拉动画
  @BuilderParam customLoad?: (() => void) | null;
  onAnimPullUp?: (value?: number, width?: number, height?: number) => void;
  onAnimLoading?: (value?: number, width?: number, height?: number) => void;
  //-----------------------------以下为组件内自用属性-----------------------------//
  @State private mWidthNumber?: number = 0
  @State private mHeightNumber?: number = 0;
  @State private trYTop?: number = 0;
  @State private trYBottom?: number = 0;
  // 刷新状态
  @State
  private refreshStatus: RefreshStatus = RefreshStatus.Inactive
  // 加载更多状态
  @State
  private loadState: LoadMoreStatus = LoadMoreStatus.Inactive
  private touchYOld?: number = 0;
  private touchYNew?: number = 0;
  private listOffsetOld?: number = 0;
  private listOffsetNew?: number = 0;
  private canvasSetting?: RenderingContextSettings = new RenderingContextSettings(true);
  private canvasRefresh?: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.canvasSetting);
  private value?: number = 0;
  private timer?: number;
  private panOption: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Up | PanDirection.Down })
  reachState: boolean = false

  private animator: ValueAnimator | null = null;
  private animatorStatus: boolean = false
  private RefreshCurrentIndex: number = 0
  props?: SilkListProps
  // images: Resource[] = [
  //   $r('app.media.01'),
  //   $r('app.media.02'),
  //   $r('app.media.03'),
  //   $r('app.media.04'),
  //   $r('app.media.05'),
  //   $r('app.media.06'),
  //   $r('app.media.07')
  // ]
  private images: string[] = [
    "01.png",
    "02.png",
    "03.png",
    "04.png",
    "05.png",
    "06.png",
    "07.png"
  ]
  imagesPixelMap: PixelMap[] = []

  // 重新加载
  async reload (): Promise<void> {
    if (!this.load) return;
    try {
      this.loadState = LoadMoreStatus.Loading
      this.loading = true
      await this.load()
      this.closeLoad()
    } catch (err) {
      this.loadState = LoadMoreStatus.ERROR
    } finally {
      this.loading = false
    }
  }
  aboutToAppear() {
    if (!this.props) {
      this.props = {}
    }
    this.props = ObjectUtils.assign(SilkListDefaultProp, this.props)
    if (this.props.hasRefresh) {
      this.animator = new ValueAnimator()
      this.animator.startValue = 0
      this.animator.endValue = this.images.length - 1
      this.animator.duration = 400
      this.animator.loops = Infinity
      this.animator.fillRule = 1
      this.animator.onUpdate = (value: number) => this.updateAnimator(value)
    }
    this.imagesPixelMap = this.images.map((item) => {
      const fd = getContext().resourceManager.getRawFdSync(item)
      const imageSource = image.createImageSource(fd)
      return imageSource.createPixelMapSync()
    })
  }


  build() {
     Column() {
       // 下拉刷新动画部分
       Stack({ alignContent: Alignment.Bottom}) {
         this.headerUI()
       }
       .width('100%')
       .height(this.trYTop !== undefined ? this.trYTop : 0)
       .backgroundColor(this.props!.refreshBackgroundColor)
       .clip(true)

       // 主体列表部分
       Grid(this.scroller, {
         regularSize: [1,1],
         irregularIndexes: this.irregularIndexes,
       }){
         LazyForEach(this.listDataSource, (item: object) => {
           GridItem() {
             if (this.children) {
               this.children(item)
             }
           }
           .backgroundColor($r('app.color.white'))
         }, this.keyGenera)
       }
       .columnsTemplate(this.getColumnTemplate())
       .rowsGap(this.props!.gutters)
       .maxCount(1)
       // .edgeEffect(EdgeEffect.None)
       .onAreaChange(async (_: Area, area: Area) => {
         const height = Math.round(area.height as number)
         if ((this.refreshStatus !== RefreshStatus.Inactive && this.refreshStatus !== RefreshStatus.Refresh) || this.loading || this.finished || this.loadState !== LoadMoreStatus.Inactive) return;

         if (height < ((this.mHeightNumber || 0) - (this.trYTop || 0) - (Math.abs(this.trYBottom || 0))) && this.scroller.isAtEnd() ) {
           // TODO 内容高度不满一屏时自动加载
           // if (!this.loading && !this.finished && this.refreshStatus === RefreshStatus.Inactive && this.loadState === LoadMoreStatus.Inactive) {
             this.loading = true
            this.loadState = LoadMoreStatus.Loading
           this.trYBottom = 50
           try {
             this.load && await this.load()
             this.trYBottom = 0
             this.loadState = LoadMoreStatus.Inactive
             this.loading = false
           } catch (err) {
               this.loading = false
            this.loadState = LoadMoreStatus.ERROR
             }

           // }
         } else if (height === 0 && this.mHeightNumber === 0 ) {
           this.loading = true
           this.loadState = LoadMoreStatus.Loading
           this.trYBottom = 50
           try {
             this.load && await this.load()
             this.trYBottom = 0
             this.loadState = LoadMoreStatus.Inactive
             this.loading = false
           } catch (err) {
             this.loading = false
             this.loadState = LoadMoreStatus.ERROR
           }
         }
       })
       .onReachEnd(async () => {
         if (!this.finished &&!this.loading && (this.props && this.props.hasAutoLoad) && this.refreshStatus !== RefreshStatus.Refresh) {
           this.reachState = true
           this.loadMore()
         }
       })
       .constraintSize({
         maxHeight: `calc(100% - ${Math.abs(this.trYBottom)}vp - ${this.trYTop}vp)`
       })
       // 上拉加载动画部分
       Stack() {
         this.footerUI()
       }
       .width('100%')
       .height(this.trYBottom !== undefined ? Math.abs(this.trYBottom) : 0)
       .backgroundColor(this.props!.loadBackgroundColor)
       Blank()
     }
     .width(this.mWidth === undefined ? '100%' : this.mWidth)
     .height(this.mHeight === undefined ? '100%' : this.mHeight)
     .onAreaChange((_: Area, newValue: Area) => {
       this.mWidthNumber = Math.round(newValue.width as number);
       this.mHeightNumber = Math.round(newValue.height as number);
     })
     .parallelGesture(
       PanGesture(this.panOption)
         .onActionStart((event?: GestureEvent) => {
           if (event !== undefined) {
             this.touchYOld = event.offsetY;
           }
         })
         .onActionUpdate((event?: GestureEvent) => {
           if (event !== undefined) {
             this.onActionUpdate(event);
           }
         })
         .onActionEnd(() => {
           this.onActionEnd();
         })
     )
  }
  @Builder
  private headerUI() {
      // RefreshLayout({ status: this.refreshStatus})
    if (this.customRefresh !== undefined && this.customRefresh !== null) {
      Column() {
        this.customRefresh()
      }
      .width('100%')
      .height('100%')
      .visibility((this.refreshStatus !== RefreshStatus.Inactive) ? Visibility.Visible : Visibility.Hidden)
    } else {
      Stack({ alignContent: Alignment.Bottom }) {
        Canvas(this.canvasRefresh)
          .width(60)
          .height(60)
          .backgroundColor(Color.Transparent)
          .onReady(() => {
            this.canvasRefresh?.drawImage(this.imagesPixelMap[0], 0, 0, 60, 60)
          })
      }
      .height(80)
    }
  }

  @Builder
  private footerUI() {
    if (this.customLoad !== undefined && this.customLoad !== null) {
      Column() {
        this.customLoad()
      }
      .width('100%')
      .height('100%')
      .visibility((this.loadState !== LoadMoreStatus.Inactive ) ? Visibility.Visible : Visibility.Hidden)
    } else {
      LoadMoreLayout({ status: this.loadState, props: this.props!, load: () => this.reload() })
    }
  }

  private onActionUpdate(event: GestureEvent): void {
    if (!this.loading && this.touchYOld !== undefined) {
        let maxTranslate = this.props!.maxTranslate || 1;
        let loadImgHeight = this.props!.loadImgHeight || 1
        let refreshHeight = this.props!.refreshHeight || 1
        if (!this.scroller.currentOffset()) {
          return;
        }
        this.touchYNew = event.offsetY;

        // 当前手势是否下拉
        let distanceY = this.touchYNew - this.touchYOld;
        let isPullAction = distanceY > 0;

        //兼容页面滑动到顶部时，this.scroller.currentOffset().yOffset返回0.000000....的浮点数的情况
        let yOffset: number = this.scroller.currentOffset().yOffset;
        let isTop: boolean = yOffset == 0 ? true : false;
        if (yOffset > -0.0001 && yOffset < 0.001) {
          isTop = true;
        }

        if ((this.refreshStatus === RefreshStatus.Inactive && isTop && isPullAction ) || // 处于自由状态且列表处于顶部位置 并且 当前手势是下拉手势
          this.refreshStatus === RefreshStatus.Drag || this.refreshStatus === RefreshStatus.OverDrag) { // 处于下拉状态中
          if (this.props!.hasRefresh) {
            if (this.touchYOld !== undefined && refreshHeight !== undefined) {
              // 获取最新位移距离
              let trY = this.touchYNew - this.touchYOld;

              //防止下拉回滑时list组件底层跟着滑动
              if(trY < 0) {
                this.scroller.scrollTo({xOffset: 0, yOffset: 0})
              }

              // 计算当前需要位移的总距离
              this.trYTop = this.getTranslateYOfRefresh(trY);
              if (this.trYTop < refreshHeight) {
                this.refreshStatus = RefreshStatus.Drag;
              } else {
                this.refreshStatus = RefreshStatus.OverDrag;
              }
              // 如果没有自定义刷新动画，就执行内置动画下拉时的逻辑
              if (!this.customRefresh && maxTranslate !== undefined) {
                this.drawRefreshView(this.trYTop / refreshHeight);
              }
              // 如果有下拉中动画回调，就执行下拉中动画回调
              if (this.onAnimPullDown && maxTranslate !== undefined) {
                this.onAnimPullDown(this.trYTop / maxTranslate, this.mWidthNumber, this.trYTop);
              }
            }
          }
        } else if (this.props!.hasLoadMore && (!this.props!.hasAutoLoad || this.finished)) {
          this.listOffsetNew = this.scroller.currentOffset().yOffset;
          // 列表处于底部位置且上滑时，2.已上滑时
          try {
            if (this.touchYOld !== undefined) {
              if ((this.loadState == LoadMoreStatus.Inactive && this.listOffsetOld == this.listOffsetNew && this.listOffsetOld != 0 && this.touchYNew < this.touchYOld && this.scroller.isAtEnd()) ||
                this.loadState === LoadMoreStatus.Drag || this.loadState === LoadMoreStatus.OverDrag || this.loadState === LoadMoreStatus.NO_MORE) {
                // if ((this.loadState === LoadMoreStatus.Drag || this.loadState === LoadMoreStatus.OverDrag) && isPullAction) {
                  // 触发了上拉 显示了加载 但又下拉 grid不能触发滚动
                  this.scroller.scrollEdge(Edge.Bottom)
                // }
                // 获取最新的位移距离
                let trY = this.touchYNew - this.touchYOld;
                // 计算当前需要位移的总距离
                this.trYBottom = this.getTranslateYOfLoadMore(trY);
                if (this.finished) {
                  this.loadState = LoadMoreStatus.NO_MORE
                } else if (loadImgHeight !== undefined && this.trYBottom < -loadImgHeight) {
                  this.loadState = LoadMoreStatus.OverDrag;
                } else {
                  this.loadState = LoadMoreStatus.Drag
                }
                // 如果没有自定义加载更多动画，就执行内置动画上拉时的逻辑

                // 如果有上拉中动画回调，就执行上拉中动画回调
                if (this.onAnimPullUp) {
                  if (this.trYBottom !== undefined && maxTranslate !== undefined) {
                    this.onAnimPullUp(-this.trYBottom / loadImgHeight, this.mWidthNumber, -this.trYBottom);
                  }
                }
              }
            }
          } catch (error) {
            if (this.touchYOld !== undefined) {
              if ((this.loadState === LoadMoreStatus.Inactive && this.listOffsetOld == this.listOffsetNew && this.listOffsetOld != 0 && this.touchYNew < this.touchYOld) ||
                this.loadState === LoadMoreStatus.Drag || this.loadState === LoadMoreStatus.OverDrag) {
                if (this.touchYNew !== undefined && this.touchYOld !== undefined && loadImgHeight !== undefined) {
                  // 获取最新的位移距离
                  let trY = this.touchYNew - this.touchYOld;
                  // 计算当前需要位移的总距离
                  this.trYBottom = this.getTranslateYOfLoadMore(trY);
                  if (this.trYBottom > -loadImgHeight) {
                    this.loadState === LoadMoreStatus.OverDrag;
                  } else {
                    this.loadState === LoadMoreStatus.Drag
                  }
                }
              }
            }
          }
          this.listOffsetOld = this.listOffsetNew;
        }
        this.touchYOld = this.touchYNew;
    }
  }

  private onActionEnd(): void {
      let maxTranslate = this.props!.maxTranslate || 1
      let refreshAnimDuration = this.props!.refreshAnimDuration || 300;
      if (this.props!.listIsPlacement) {
          if (this.refreshStatus !== RefreshStatus.Inactive) {
            // 让列表归位到顶部
            this.scroller.scrollEdge(Edge.Top);
            // 让列表归位到底部
          } else if (this.loadState !== LoadMoreStatus.Inactive) {
            this.scroller.scrollEdge(Edge.Bottom);
          }
      }
      if (this.trYTop !== undefined) {
        if (this.trYTop > 0) { // 下拉结束
          if ( maxTranslate !== undefined) {
              if (this.refreshStatus === RefreshStatus.Inactive || this.refreshStatus === RefreshStatus.Drag) {
                this.closeRefresh();
              } else {
                this.refreshStatus = RefreshStatus.Refresh;
                this.trYTop = maxTranslate * 0.75;
                clearInterval(this.timer);
                this.timer = setInterval(() => {
                  if (this.value !== undefined) {
                    if (this.value >= 1) {
                      this.value -= 1;
                    } else {
                      if (refreshAnimDuration !== undefined && refreshAnimDuration !== 0) {
                        this.value += 10 / refreshAnimDuration;
                      }
                    }
                    // 保留3位小数
                    this.value = Math.round(this.value * 1000) / 1000;
                  }
                  // 刷新中动画采用系统组件，因此不用自己去执行动画
                  // 如果有刷新中动画回调，就执行刷新中动画回调
                  if (this.onAnimRefreshing) {
                    this.onAnimRefreshing(this.value, this.mWidthNumber, this.trYTop);
                  }
                }, 10);
                if (this.refresh !== undefined) {
                  this.refresh().then(() => {
                      this.refreshStatus = RefreshStatus.Done
                      setTimeout(() => {
                        this.closeRefresh();
                      }, 300)

                  }).catch(() => {
                    this.refreshStatus = RefreshStatus.Error;
                    setTimeout(() => {
                      this.closeRefresh();
                    }, 1000);
                  });
                }
              }
          }
        } else if (this.trYBottom !== undefined && this.trYBottom < 0) { // 上拉结束
          if (this.loadState !== undefined && maxTranslate !== undefined) {
              if (this.loadState === LoadMoreStatus.Inactive || this.loadState === LoadMoreStatus.Drag || this.loadState === LoadMoreStatus.NO_MORE) {
                this.closeLoad();
              } else {
                this.loadState = LoadMoreStatus.Loading;
                this.trYBottom = -maxTranslate * 0.75;

                if (this.load !== undefined && !this.finished) {
                  clearInterval(this.timer);
                  this.timer = setInterval(() => {
                    if (this.value !== undefined) {
                      if (this.value >= 1) {
                        this.value -= 1;
                      } else {
                        this.value += 0.01;
                      }
                      // 保留2位小数
                      this.value = Math.round(this.value * 100) / 100;
                      // 如果没有自定义加载中动画，就执行内置加载中动画
                    }
                    // 如果有加载中动画回调，就执行加载中动画回调
                    if (this.onAnimLoading) {
                      if (this.trYBottom !== undefined) {
                        this.onAnimLoading(this.value, this.mWidthNumber, -this.trYBottom);
                      }
                    }
                  }, 10);
                  this.load().then(() => {
                    this.loadState = LoadMoreStatus.Done;
                    this.closeLoad();
                  }).catch(() => {
                    this.loadState = LoadMoreStatus.ERROR;
                  });
                }
              }
          }
        } else {
          this.loadState = LoadMoreStatus.Inactive
          this.refreshStatus = RefreshStatus.Inactive
        }
      }
  }

  private getTranslateYOfRefresh(newTranslateY: number): number {
      let maxTranslateY = this.props!.maxTranslate || 1;
      let sensitivity = this.props!.sensitivity;
      if (maxTranslateY !== undefined && sensitivity !== undefined && this.trYTop !== undefined) {
        // 阻尼值计算
        if (this.trYTop / maxTranslateY < 0.2) {
          newTranslateY = newTranslateY * 1 * sensitivity;
        } else if (this.trYTop / maxTranslateY < 0.4) {
          newTranslateY = newTranslateY * 0.8 * sensitivity;
        } else if (this.trYTop / maxTranslateY < 0.6) {
          newTranslateY = newTranslateY * 0.6 * sensitivity;
        } else if (this.trYTop / maxTranslateY < 0.8) {
          newTranslateY = newTranslateY * 0.4 * sensitivity;
        } else {
          newTranslateY = newTranslateY * 0.2 * sensitivity;
        }
        // 下拉值计算
        if (this.trYTop + newTranslateY > maxTranslateY) {
          return maxTranslateY;
        } else if (this.trYTop + newTranslateY < 0) {
          return 0;
        } else {
          return this.trYTop + newTranslateY;
        }
      }
    return 0;
  }

  private getTranslateYOfLoadMore(newTranslateY: number): number {
      let maxTranslateY = this.props!.maxTranslate;
      let sensitivity = this.props!.sensitivity;
      if (maxTranslateY !== undefined && sensitivity !== undefined && this.trYBottom !== undefined) {
        // 阻尼值计算
        if (this.trYBottom / maxTranslateY > -0.2) {
          newTranslateY = newTranslateY * 1 * sensitivity;
        } else if (this.trYBottom / maxTranslateY > -0.4) {
          newTranslateY = newTranslateY * 0.8 * sensitivity;
        } else if (this.trYBottom / maxTranslateY > -0.6) {
          newTranslateY = newTranslateY * 0.6 * sensitivity;
        } else if (this.trYBottom / maxTranslateY > -0.8) {
          newTranslateY = newTranslateY * 0.4 * sensitivity;
        } else {
          newTranslateY = newTranslateY * 0.2 * sensitivity;
        }
        // 下拉值计算
        if (this.trYBottom + newTranslateY < -maxTranslateY) {
          return -maxTranslateY;
        } else if (this.trYBottom + newTranslateY > 0) {
          return 0;
        } else {
          return this.trYBottom + newTranslateY;
        }
      }
    return 0;
  }

  public closeRefresh(): void {
  this.animator?.stop()
    this.animatorStatus = false
      animateTo({ duration: this.props!.animDuration }, () => {
        this.trYTop = 0;
      });

      setTimeout(() => {
        this.refreshStatus = RefreshStatus.Inactive;
      }, this.props!.animDuration);
     }

  public closeLoad(): void {
      animateTo({ duration: this.props!.animDuration }, () => {
        this.trYBottom = 0;
      });
    this.loadState = LoadMoreStatus.Inactive;
  }

  private drawRefreshView(value: number): void {
    if (this.trYTop !== undefined) {
      let refreshHeight = this.props!.refreshHeight
      if (refreshHeight !== undefined && this.trYTop >= refreshHeight) {
        if (this.canvasRefresh !== undefined) {
          if (!this.animatorStatus) {
            this.animator?.start(this.RefreshCurrentIndex)
            this.animatorStatus = true
          }
        }
      } else {
        this.animator?.stop()
        this.animatorStatus = false
        const index = Math.floor(value * this.images.length);
        this.RefreshCurrentIndex = index
        this.canvasRefresh?.clearRect(0,0,60, 60)
        this.canvasRefresh?.drawImage(this.imagesPixelMap[index], 0, 0, 60, 60)
      }
    }
  }
  private updateAnimator (value: number): void {
  if (value < 0 || value >= this.images.length) return;
  this.RefreshCurrentIndex = Math.floor(value)
    const index = Math.floor(value)
    this.canvasRefresh?.clearRect(0,0,60, 60)
    this.canvasRefresh?.drawImage(this.imagesPixelMap[index], 0, 0, 60, 60)
  }

  private getColumnTemplate () {
    let str = ''
    for (let index = 0; index < (this.props!.lanes || 1); index++) {
      str += '1fr '
    }
    return str.trimEnd()
  }
}

