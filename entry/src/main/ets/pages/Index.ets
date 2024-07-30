import { PageItem, PageListConstants } from '../constants/PageListConstants';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct Main {
  message: string = 'SILK_UI';

  build() {
    Column(){
      Text(this.message)
        .fontSize(40)
        .fontWeight(600)
      List({ space: 15 }){
        ForEach(PageListConstants.list, (item: PageItem) => {
          ListItem(){
            Button(item.title)
              .onClick(() => {
                router.pushUrl({
                  url: `pages/${item.name}`
                })
              })
          }
        })
      }
    }
    .width('100%')
    .height('100%')
  }
}

