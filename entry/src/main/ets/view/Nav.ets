import { router } from '@kit.ArkUI'

@Builder
export function Nav (title: string) {
  RelativeContainer(){
    Text(title)
      .fontSize(17)
      .fontWeight(600)
      .fontColor($r('app.color.vandoctextcolor2'))
      .constraintSize({
        maxWidth: `calc(100% - 112vp)`
      })
      .maxLines(1)
      .textOverflow({
        overflow: TextOverflow.Ellipsis
      })
      .id('nav_title')
      .alignRules({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        middle: { anchor: '__container__', align: HorizontalAlign.Center }
      })
    Image($r('app.media.ic_public_back'))
      .width(24)
      .aspectRatio(1)
      .id('nav_icon')
      .alignRules({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        left: { anchor: '__container__', align: HorizontalAlign.Start },
        right: { anchor: '__container__', align: HorizontalAlign.End },
        bias: {
          horizontal: 0.045
        }
      })
      .onClick(() => {
        router.back()
      })
  }
  .height(56)
}