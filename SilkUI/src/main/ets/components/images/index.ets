import { util } from '@kit.ArkTS'

@Component
export struct SilkImages {
  @Prop
  url: ResourceStr = ''
  waterMark: boolean = false
  default: ResourceStr = ''
  imageFormat: ImageFormatFunction = imageFormat
  imageDefault: ImageDefaultFunction = imageDefault
  uid: string = util.generateRandomUUID()
  @State
  newUrl: string = ''
  private widthValue: number = 0
  private heightValue: number = 0
  private proportion: number = 1

  onMeasureSize(selfLayoutInfo: GeometryInfo, children: Measurable[], constraint: ConstraintSizeOptions): SizeResult {
    this.widthValue = selfLayoutInfo.width
    this.heightValue = selfLayoutInfo.height
    if (this.widthValue || this.heightValue) {
      this.proportion = this.widthValue / (this.heightValue || this.widthValue)
    }
    children.forEach((child) => {
      child.measure({
        minWidth: constraint.minWidth,
        minHeight: constraint.minHeight,
        maxWidth: constraint.maxWidth,
        maxHeight: constraint.maxHeight
      })
    })
    if (!this.newUrl && this.url && typeof this.url === 'string') {
      this.getNew()
    }
    return {
      width: selfLayoutInfo.width,
      height: selfLayoutInfo.height
    }

  }

  onPlaceChildren(selfLayoutInfo: GeometryInfo, children: Layoutable[], constraint: ConstraintSizeOptions): void {
    children.forEach((child) => {
      child.layout({ x: 0, y: 0 })
    })
  }

  getNew() {
    this.newUrl = this.imageFormat(this.url as string, this.waterMark, this.widthValue, this.heightValue, this.proportion)
  }

  aboutToAppear(): void {
    const componentUtils = this.getUIContext().getComponentUtils()
    const result = componentUtils.getRectangleById(this.uid)
    this.widthValue = result.size.width
    this.heightValue = result.size.height
    if (this.widthValue || this.heightValue) {
      this.proportion = this.widthValue / (this.heightValue || this.widthValue)
    }
  }

  build() {
    Column() {
      if (this.newUrl) {
        Image(this.newUrl)
          .width('100%')
          .height('100%')
          .alt(this.default ? this.default : this.imageDefault(this.proportion))
      } else if (!this.url) {
        Image(this.default ? this.default : this.imageDefault(this.proportion))
          .width('100%')
          .height('100%')
          .alt(this.default ? this.default : this.imageDefault(this.proportion))
      } else if (typeof this.url !== 'string') {
        Image(this.url)
          .width('100%')
          .height('100%')
      }
    }
    .width('100%')
    .height('100%')
  }
}

export type ImageFormatFunction = (url: string, waterMark: boolean, width?: number, height?: number,
  proportion?: number) => string

let imageFormat: ImageFormatFunction = (url: string) => {
  return url
}

type ImageDefaultFunction = (proportion: number) => Resource
let imageDefault: ImageDefaultFunction = (proportion: number) => {
  return $r('app.media.noimage')
}

export const setImageFormat = (format: ImageFormatFunction) => {
  imageFormat = format
}

export const setImageDefault = (defaultImage: ImageDefaultFunction) => {
  imageDefault = defaultImage
}