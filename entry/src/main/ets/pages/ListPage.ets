import { SilkList } from '@ohos/silk_ui/src/main/ets/components/list';
import { SilkGridList } from '@ohos/silk_ui/src/main/ets/components/list/list';
import { SilkTabBar } from '@ohos/silk_ui/src/main/ets/components/tabBar';
import { SilkTabItemInterface, SilkTabsController } from '@ohos/silk_ui/src/main/ets/utils/SilkTabsController';
import { Nav } from '../view/Nav';
import { Title } from '../view/Title';
import { List } from '@kit.ArkTS';

interface ListItem {
  title: string
}
@Entry
@Component
struct ListPage {
  @State
  currentIndex: number = 0
  // @State
  tabList: SilkTabItemInterface[] = [
    {
      title: '基础用法'
    },
    {
      title: '错误提示'
    },
    {
      title: '下拉刷新'
    }
  ]
  @State
  list1: ListItem[] = []
  @State
  finished1: boolean = false
  @State
  list2: ListItem[] = []
  @State
  finished2: boolean = false
  @State
  list3: ListItem[] = []
  @State
  finished3: boolean = false
  async load (): Promise<void> {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        const arr: ListItem[] = []
        for (let index = 0; index < 10; index++) {
          arr.push({
            title: index + this.list1.length + ''
          })
        }
        this.list1 = this.list1.concat(arr)
        this.finished1 = this.list1.length > 50
        resolve()
      }, 2000)
    })
  }
  async load2 (): Promise<void> {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        const arr: ListItem[] = []
        for (let index = 0; index < 10; index++) {
          arr.push({
            title: index + this.list2.length + ''
          })
        }
        if (this.list2.length > 0 && this.status) {
          this.status = false
          reject()
          return
        }
        this.list2 = this.list2.concat(arr)
        this.finished2 = this.list2.length > 50
        resolve()
      }, 2000)
    })
  }
  status: boolean = true
  async load3 (): Promise<void> {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        const arr: ListItem[] = []
        for (let index = 0; index < 10; index++) {
          arr.push({
            title: index + this.list3.length + ''
          })
        }
        this.list3 = this.list3.concat(arr)
        this.finished3 = this.list3.length > 50
        resolve()
      }, 2000)
    })
  }
  async refresh (): Promise<void> {
    this.list3 = []
    await this.load3()
  }
  build() {
    Column(){
      Nav('List')
      Flex({ direction: FlexDirection.Column}){
        SilkTabBar({
          list: this.tabList,
          currentIndex: this.currentIndex
        })
          .width('100%')
          .height(40)
        Swiper(){
          ForEach(this.tabList, (item: SilkTabItemInterface) => {
            if (item.title === '基础用法') {
              SilkGridList({
                dataSource: this.list1,
                load: async () => this.load(),
                props: {
                  gutters: 10,
                  lanes: 2 // 混合布局 列数
                },
                irregularIndexes: [2, 5], // 单独布局索引
                children: this.Children,
                finished: this.finished1
              })
                .height('100%')
                .backgroundColor('#eee')
            } else if (item.title === '错误提示') {
              SilkGridList({
                dataSource: this.list2,
                load: async () => this.load2(),
                props: {
                  gutters: 10,
                  hasAutoLoad: true
                },
                children: this.Children,
                finished: this.finished2
              })
                .height('100%')
                .backgroundColor('#eee')
            } else {
              SilkGridList({
                dataSource: this.list3,
                load: async () => this.load3(),
                props: {
                  gutters: 10,
                  hasRefresh: true
                },
                children: this.Children,
                finished: this.finished3,
                refresh: async () => this.refresh(),
              })
                .height('100%')
                .backgroundColor('#eee')
            }
          })
        }
        .index($$this.currentIndex)
        .width('100%')
        .layoutWeight(1)
        .indicator(false)
        .loop(false)
      }
      .layoutWeight(1)
    }
    .height('100%')
    .width('100%')
  }
  @Builder
  Children ($$: object) {
    Column(){
      Text(($$ as ListItem).title)
        .fontSize(40)
    }
    .width('100%')
    .backgroundColor('#FFF')
  }
}