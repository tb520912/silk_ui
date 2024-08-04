// @Entry
import { SilkGridList } from '@ohos/silk_ui'

// @Component
// struct TestPage {
//
//   build() {
//     Column() {
//       Grid(){
//         GridItem(){
//           Column(){
//             Text('1')
//           }
//           .width('100%')
//           .height(100)
//           .backgroundColor(Color.Yellow)
//         }
//         GridItem(){
//           Column(){
//             Text('2')
//           }
//           .width('100%')
//           .height(100)
//           .backgroundColor(Color.Pink)
//         }
//
//         GridItem(){
//           Column(){
//             Text('2')
//           }
//           .width('100%')
//           .height(100)
//           .backgroundColor(Color.Pink)
//         }
//       }
//       .layoutDirection(GridDirection.Column)
//       .columnsTemplate('1fr 1fr')
//       .maxCount(1)
//       .border({
//         width: 5,
//         color: Color.Blue
//       })
//       Blank()
//     }
//     .width('100%')
//     .height('100%')
//     .border({
//       width: 5,
//       color: Color.Red
//     })
//   }
// }
interface Item{
  text: string
}
@Entry
@Component
struct TestPage {
  @State
  list: Item[] = []
  @State
  finished: boolean = false
  async load (refresh?:boolean): Promise<void> {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        const arr: Item[] = []
        for (let index = 0; index < 10; index++) {
          arr.push({ text: this.list.length + index + ''})
        }
        if (refresh) {
          this.list = arr
        } else {
          this.list = this.list.concat(arr)
        }
        this.finished = 50 < this.list.length
        resolve()
      },1000)
    })
  }
  async refresh (): Promise<void> {
    this.list = []
    await this.load(true)
  }
  @Builder
  children ($$: object) {
    Column(){
      Text(($$ as Item).text)
        .fontSize(40)
    }
    .width('100%')
    .height(100)
    .backgroundColor(Color.Pink)
    .margin({
      top: 10,
      bottom: 10
    })
  }
  irregularIndexes: number[] = [4, 7]
  onGetIrregularSizeByIndex (index: number): [number, number] {
      return [1, 2]

  }
  build() {
    Column(){
      SilkGridList({
        dataSource: this.list,
        finished: this.finished,
        onLoadMore: () => this.load(),
        onRefresh: () => this.refresh(),
        children: this.children,
        irregularIndexes: this.irregularIndexes,
        props: {
          lanes: 2,
          hasRefresh: true,
        }
      })
    }
    .height('100%')
  }
}