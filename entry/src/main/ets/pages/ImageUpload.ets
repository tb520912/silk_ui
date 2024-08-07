import { SilkUpload, SilkUploadItem } from '@ohos/silk_ui';
import { Nav } from '../view/Nav';
import { Title } from '../view/Title';

@Entry
@Component
struct ImageUpload {
  @State
  imgs1: string[] = []
  @State
  imgs2: string[] = [
    'https://fastly.jsdelivr.net/npm/@vant/assets/leaf.jpeg',
    'https://fastly.jsdelivr.net/npm/@vant/assets/tree.jpeg'
  ]
  @State
  imgs3: string[] = [
    'https://fastly.jsdelivr.net/npm/@vant/assets/leaf.jpeg',
    'https://fastly.jsdelivr.net/npm/@vant/assets/tree.jpeg'
  ]
  imagesStatus: SilkUploadItem[] = [
    new SilkUploadItem({
      filePath: '',
      url: 'https://fastly.jsdelivr.net/npm/@vant/assets/leaf.jpeg',
      status: 1
    }),
    new SilkUploadItem({
      filePath: '',
      url: 'https://fastly.jsdelivr.net/npm/@vant/assets/tree.jpeg',
      status: 2
    }),
  ]
  build() {
    Column(){
      Nav('ImageUpload')
      Scroll(){
        Column(){
          Title('基础用法')
          SilkUpload({
            images: this.imgs1,
            rows: 3
          })
            .margin({
              left: 16
            })

          Title('文件预览')
          SilkUpload({
            images: this.imgs2,
            rows: 3,
          })
            .margin({
              left: 16
            })
          Title('上传状态')
          SilkUpload({
            images: this.imgs2,
            rows: 3,
            upImgs: this.imagesStatus,
          })
            .margin({
              left: 16
            })
        }
        .justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.Start)
      }
      .layoutWeight(1)
      .backgroundColor($r('app.color.white'))
      .align(Alignment.Top)
    }
    .height('100%')
    .width('100%')
  }
}