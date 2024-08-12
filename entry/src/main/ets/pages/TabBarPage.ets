import { SilkTabBar, SilkTabBarInterface } from '@ohos/silk_ui/src/main/ets/components/tabBar';
import {
  SilkTabItem,
  SilkTabItemInterface,
  SilkTabsController,
  SilkTabStyle } from '@ohos/silk_ui/src/main/ets/utils/SilkTabsController';
import { Nav } from '../view/Nav';
import { Title } from '../view/Title';

@Entry
@Component
struct TabBarPage {
  @State
  currentIndex: number = 0
  @State
  currentIndex2: number = 0
  // tabs支持object类型 若使用非SilkTabItemInterface类型 那么baritem需要自定义 传入Tarbar Builder方法
  tabs: SilkTabItemInterface[] = [
    {
      title: '标签1',
    }, {
    title: '标签2',
  },
    {
      title: '标签3',
    },

  ]
  tabs2: SilkTabItemInterface[] = [
    {
      title: '标签1',
    }, {
    title: '标签2',
  },
    {
      title: '标签3',
    },
    {
      title: '标签4',
    },
    {
      title: '标签5',
    },
    {
      title: '标签6',
    },
    {
      title: '标签7',
    },
    {
      title: '标签8',
    },
    {
      title:
        '标签9',
      },
      {
        title: '标签10',
      },
  ]
  silkTabsController: SilkTabsController = new SilkTabsController()
  @Builder
  MyTabBar ($$: SilkTabBarInterface): void {
    Text(($$.item as SilkTabItemInterface).title)
      .fontColor(this.currentIndex === $$.index ? Color.Red : Color.Black)
  }
  @Builder
  RightBtn (): void {
    Image($r('app.media.more_o'))
      .width(20)
  }
  build() {
    Column() {
      Nav('tabbar')
      Scroll(){
        Column(){
          Title('基本用法-下划线、标识线不跟随手势动画')
          SilkTabBar({
            list: this.tabs,
            currentIndex: this.currentIndex,
            props: {
              height: 40,
              spaceArround: false, // item平分宽度
              flexStyle: 'left' // 居左对齐 默认center
            },
          })
            .height(40)
          Title('基本用法-背景色、标识线跟随手势动画')
          SilkTabBar({
            list: this.tabs,
            currentIndex: this.currentIndex,
            props: {
              height: 40,
              indicatorStyle: SilkTabStyle.BACKGROUND,
              indicator: {
                color: '#edf5fa'
              }
            },
            silkTabsController: this.silkTabsController
          })
            .height(40)
          Swiper(){
            ForEach(this.tabs, (item: SilkTabItemInterface) => {
              Column(){
                Text(item.title)
              }
              .width('100%')
            })
          }
          .loop(false)
          .indicator(false)
          .autoPlay(false)
          .index($$this.currentIndex)
          .effectMode(EdgeEffect.None)
          .onGestureSwipe((index, event) => this.silkTabsController.gestureSwiper(index, event))
          .onAnimationStart((index, targetIndex, event) => this.silkTabsController.tabActiveAnimate(index, targetIndex))
          .onAreaChange((_, area) => {
            this.silkTabsController.setTabsSize({
              width: area.width as number,
              height: area.height as number
            })
          })
          .height(100)
          .border({
            width: 2
          })
          Title('自定义tabbar')
          SilkTabBar({
            list: this.tabs,
            currentIndex: this.currentIndex,
            TabBar: ($$) => this.MyTabBar($$)
          })
            .height(40)
          Title('自定义tabbar-点击事件')
          SilkTabBar({
            list: this.tabs,
            currentIndex: this.currentIndex,
            TabBar: ($$) => this.MyTabBar($$),
            tabClick: ($$, event) => { // 应对特殊需求 将点击事件暴露出去 并将item属性传递出去
              AlertDialog.show({
                message: JSON.stringify($$)
              })
            }
          })
            .height(40)
          Title('左右icon')
          SilkTabBar({
            list: this.tabs2,
            currentIndex: this.currentIndex2,
            props: {
              height: 40,
              spaceArround: false, // item平分宽度
              flexStyle: 'left', // 居左对齐 默认center
              marginRight: 30
            },
            RightBuilder: () => this.RightBtn()
          })
            .height(40)
        }
      }
      .scrollable(ScrollDirection.Vertical)
      .width('100%')
      .layoutWeight(1)
      .align(Alignment.Top)
    }
    .height('100%')
    .width('100%')
  }
}