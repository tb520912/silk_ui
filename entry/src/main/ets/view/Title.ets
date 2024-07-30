@Builder
export function Title (title: string) {
  Text(title)
    .padding({
      top: 20,
      left: 16,
      bottom: 16
    })
    .fontSize(14)
    .fontColor($r('app.color.vandoctextcolor4'))
    .width('100%')
}