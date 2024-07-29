import curves from '@ohos.curves'

@Preview
@Component
export default struct RefreshLayout {
  @Link
  status: RefreshStatus
  images: ImageFrameInfo[] = [
    {
      src: $r('app.media.01')
    },
    {
      src: $r('app.media.02')
    },
    {
      src: $r('app.media.03')
    },
    {
      src: $r('app.media.04')
    },
    {
      src: $r('app.media.05')
    },
    {
      src: $r('app.media.06')
    },
    {
      src: $r('app.media.07')
    }
  ]
@Prop
heightValue: number
  build() {
    Stack({ alignContent: Alignment.Bottom}) {
      ImageAnimator()
        .images(this.images)
        .width(60)
        .height(60)
        .iterations(-1)
        .duration(400)
        .margin({
          top: 20
        })
        .state(
            this.status === RefreshStatus.Drag
            ?
          AnimationStatus.Initial
            :
              this.status === RefreshStatus.Done
              ?
            AnimationStatus.Stopped
              :
            AnimationStatus.Running)
    }
    .clip(true)
    .width('100%')
    .backgroundColor($r('app.color.bgc_f6'))
    .height(this.heightValue)
    .border({
      width: 2
    })
    // .animation({
    //   // duration: this.status === RefreshStatus.Refresh || this.status === RefreshStatus.Done ? 300 : 0
    //   // curve: curves.springCurve(100, 1, 228, 30)
    // })
  }
}

export enum RefreshStatus {
  Inactive, // 下拉状态
  Drag, // 下拉中 未触发刷新
  OverDrag, // 下拉中 超过触发距离
  Refresh, // 下拉结束 回到刷新距离 进入刷新状态
  Done // 刷新结束 返回初始状态
}