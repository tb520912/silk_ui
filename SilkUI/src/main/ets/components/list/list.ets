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
import { PullToRefreshConfigurator } from './PullToRefreshConfigurator'
import RefreshLayout, { RefreshStatus } from './RefreshLayout';
import { image } from '@kit.ImageKit';


@Component
export struct PullList {
  // 列数
  lanes: number = 1
  // 列间距
  gutters: number = 0
  // 特殊处理的索引及方法
  @Prop
  irregularIndexes: number[] = []
  @Prop
  onGetIrregularSizeByIndex: (index: number) => [number, number]
  // 开启下拉刷新
  hasRefresh: boolean = false
  // 开启到底自动加载
  hasAutoLoad: boolean = true
  @Prop
  finished: boolean
  // 加载或刷新中
  @State
  loading: boolean = false
  // 数据源
  @Prop
  @Watch('updateDataSource')
  dataSource: object[] = []
  // 懒加载
  listDataSource: LazyDataSource<object> = new LazyDataSource<object>()
  updateDataSource() {
    this.listDataSource.pushArrayData(this.dataSource)
  }
  // 子元素
  @BuilderParam
  children: (item: object) => void
  keyGenera: (item: object, index: number) => string = (item: object, index: number) => JSON.stringify(item)

  scroller: Scroller = new Scroller();
  refreshConfigurator?: PullToRefreshConfigurator;
  mWidth?: Length = '100%';
  mHeight?: Length = '100%';
  onRefresh?: () => Promise<void> = () => {
    return new Promise<void>((resolve, reject) => {
      setTimeout(() => {
        resolve();
      }, 1000);
    });
  };
  onLoadMore?: () => Promise<void> = () => {
    return new Promise<void>((resolve, reject) => {
      setTimeout(() => {
        resolve();
      }, 1000);
    });
  };
  //-----------------------------以下为组件内自用属性-----------------------------//
  @State private mWidthNumber?: number = 0
  @State private mHeightNumber?: number = 0;
  @State private trYTop?: number = 0;
  @State private trYBottom?: number = 0;
  // 刷新状态
  @State
  refreshStatus: RefreshStatus = RefreshStatus.Inactive
  // 加载更多状态
  @State
  loadState: LoadMoreStatus = LoadMoreStatus.Inactive
  private touchYOld?: number = 0;
  private touchYNew?: number = 0;
  private listOffsetOld?: number = 0;
  private listOffsetNew?: number = 0;
  private value?: number = 0;
  private timer?: number;
  private panOption: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Up | PanDirection.Down })
  reachState: boolean = false
  aboutToAppear() {
    if (!this.refreshConfigurator) {
      this.refreshConfigurator = new PullToRefreshConfigurator();
    }
  }

  build() {
   Stack({ alignContent: Alignment.Center}){
     Column() {
       // 下拉刷新动画部分
       Stack() {
         this.headerUI()
       }
       .width('100%')
       .height(this.trYTop !== undefined ? this.trYTop : 0)
       .backgroundColor(this.refreshConfigurator !== undefined ? this.refreshConfigurator.getRefreshBackgroundColor() : 0)

       // 主体列表部分
       Grid(this.scroller, {
         regularSize: [1,1],
         irregularIndexes: this.irregularIndexes,
       }){
         LazyForEach(this.listDataSource, (item: object, index: number) => {
           GridItem() {
             if (this.children) {
               this.children(item)
             }
           }
           .backgroundColor($r('app.color.white'))
         }, this.keyGenera)
       }
       .columnsTemplate(this.getColumnTemplate())
       .rowsGap(this.gutters)
       .maxCount(1)
       // .edgeEffect(EdgeEffect.None)
       .onAreaChange(async (_: Area, area: Area) => {
         const height = Math.round(area.height as number)
         if (height < ((this.mHeightNumber || 0) - (this.trYTop || 0) - (Math.abs(this.trYBottom || 0))) && this.scroller.isAtEnd() && !this.loading && !this.finished) {
           // TODO 内容高度不满一屏时自动加载
           // if (!this.loading && !this.finished && this.refreshStatus === RefreshStatus.Inactive && this.loadState === LoadMoreStatus.Inactive) {
             this.loading = true
            this.loadState = LoadMoreStatus.Loading
           this.trYBottom = 50
             this.onLoadMore && await this.onLoadMore()
           this.trYBottom = 0
           this.loadState = LoadMoreStatus.Inactive
             this.loading = false
           // }
         } else if (height === 0 && this.mHeightNumber === 0 && !this.finished ) {
           this.loading = true
           this.loadState = LoadMoreStatus.Loading
           this.trYBottom = 50
           this.onLoadMore && await this.onLoadMore()
           this.trYBottom = 0
           this.loadState = LoadMoreStatus.Inactive
           this.loading = false
         }
       })
       .onReachEnd(async () => {
         if (!this.finished &&!this.loading && this.hasAutoLoad) {
           this.reachState = true
           this.loading = true
           this.loadState = LoadMoreStatus.Loading
           this.trYBottom = 50
           this.onLoadMore && await this.onLoadMore()
           this.trYBottom = 0
           this.loadState = LoadMoreStatus.Inactive
           this.loading = false
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
       .backgroundColor(this.refreshConfigurator !== undefined ? this.refreshConfigurator.getLoadBackgroundColor() : 0)
       Blank()
     }
     .width(this.mWidth === undefined ? '100%' : this.mWidth)
     .height(this.mHeight === undefined ? '100%' : this.mHeight)
     .onAreaChange((oldValue: Area, newValue: Area) => {
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
     Text(this.trYBottom + '--111' + this.finished)
       .fontColor(Color.Red)

   }
   .width('100%')
    .height('100%')
  }
  @Builder
  private headerUI() {
      RefreshLayout({ status: this.refreshStatus})
  }

  @Builder
  private footerUI() {
      LoadMoreLayout({ status: this.loadState})
  }

  private onActionUpdate(event: GestureEvent): void {
    if (!this.loading && this.refreshConfigurator !== undefined && this.touchYOld !== undefined) {
        let maxTranslate = this.refreshConfigurator.getMaxTranslate()
        let loadImgHeight = this.refreshConfigurator.getLoadImgHeight()
        let refreshHeight = this.refreshConfigurator.getRefreshHeight()
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
          if (this.refreshConfigurator.getHasRefresh()) {
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
            }
          }
        } else if (this.refreshConfigurator.getHasLoadMore()) {
          this.listOffsetNew = this.scroller.currentOffset().yOffset;
          // 列表处于底部位置且上滑时，2.已上滑时
          try {
            if (this.touchYOld !== undefined) {
              if ((this.loadState == LoadMoreStatus.Inactive && this.listOffsetOld == this.listOffsetNew && this.listOffsetOld != 0 && this.touchYNew < this.touchYOld && this.scroller.isAtEnd()) ||
                this.loadState === LoadMoreStatus.Drag || this.loadState === LoadMoreStatus.OverDrag || this.loadState === LoadMoreStatus.NO_MORE) {
                if ((this.loadState === LoadMoreStatus.Drag || this.loadState === LoadMoreStatus.OverDrag) && isPullAction) {
                  // 触发了上拉 显示了加载 但又下拉 grid不能触发滚动
                  this.scroller.scrollEdge(Edge.Bottom)
                }
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
    if (this.refreshConfigurator !== undefined) {
      let maxTranslate = this.refreshConfigurator.getMaxTranslate()
      let refreshAnimDuration = this.refreshConfigurator.getRefreshAnimDuration();
      if (this.refreshConfigurator.getListIsPlacement()) {
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
                this.refreshStatus === RefreshStatus.Refresh;
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

                }, 10);
                if (this.onRefresh !== undefined) {
                  this.onRefresh().then((refreshText) => {
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
                    // if (!this.customLoad) {
                    //   this.drawLoadView(false, this.value);
                    // }
                  }

                }, 10);
                if (this.onLoadMore !== undefined && !this.finished) {
                  this.onLoadMore().then((loadText) => {
                    this.closeLoad();
                  }).catch(() => {
                    this.closeLoad()
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
  }

  private getTranslateYOfRefresh(newTranslateY: number): number {
    if (this.refreshConfigurator !== undefined) {
      let maxTranslateY = this.refreshConfigurator.getMaxTranslate();
      let sensitivity = this.refreshConfigurator.getSensitivity();
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
    }
    return 0;
  }

  private getTranslateYOfLoadMore(newTranslateY: number): number {
    if (this.refreshConfigurator !== undefined) {
      let maxTranslateY = this.refreshConfigurator.getMaxTranslate();
      let sensitivity = this.refreshConfigurator.getSensitivity();
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
    }
    return 0;
  }

  public closeRefresh(): void {
    clearInterval(this.timer);
    if (this.refreshConfigurator !== undefined) {
      animateTo({ duration: this.refreshConfigurator.getAnimDuration() }, () => {
        this.trYTop = 0;
      });
    }
    if (this.refreshConfigurator !== undefined) {
      setTimeout(() => {
        this.refreshStatus = RefreshStatus.Inactive;
      }, this.refreshConfigurator.getAnimDuration());
    }
  }

  public closeLoad(): void {
    clearInterval(this.timer);
    if (this.refreshConfigurator !== undefined) {
      animateTo({ duration: this.refreshConfigurator.getAnimDuration() }, () => {
        this.trYBottom = 0;
      });
    }
    this.loadState = LoadMoreStatus.Inactive;
  }

  private getColumnTemplate () {
    let str = ''
    for (let index = 0; index < this.lanes; index++) {
      str += '1fr '
    }
    return str.trimEnd()
  }
}