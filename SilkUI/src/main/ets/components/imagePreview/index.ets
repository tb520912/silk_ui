let controller: CustomDialogController | null = null

@Component
struct SilkImagePreviewComp {
  _mount(images: string[], index: number) {
    controller = new CustomDialogController({
      builder: SilkImagePreview({
        images,
        index
      }),
      customStyle: true,
      autoCancel: false
    })
    controller.open()
  }

  build() {

  }
}

@Preview
@CustomDialog
@Component
export struct SilkImagePreview {
  controller: CustomDialogController;
  @Prop images: Array<string> = []
  @Prop
  index: number = 0

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Row() {
        Swiper() {
          ForEach(this.images, (item: string | Resource) => {
            Image(item)
              .width('100%')
              .objectFit(ImageFit.Contain)
          })
        }
        .height('100%')
        .loop(false)
        .indicator(false)
        .index($$this.index)
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#323233')
      .onClick(() => {
        this.controller.close()
      })

      Text(`${this.index + 1}/${this.images.length}`)
        .margin({
          top: 40
        })
        .fontColor($r('app.color.white'))
    }
    .width('100%')
    .height('100%')
  }
}

export const showSilkImagePreview = (images: string[], index: number) => {
  const pre = new SilkImagePreviewComp()
  pre._mount(images, index)
}