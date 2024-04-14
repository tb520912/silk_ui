interface LoadImageText {
  image: ResourceStr,
  text: ResourceStr
}

@Preview
@Component
export default struct LoadMoreLayout {
  @Link
  status: LoadMoreStatus

  getImageText(): LoadImageText {
    switch (this.status) {
      case LoadMoreStatus.Inactive:
      case LoadMoreStatus.Drag:
        return {
          image: $r('app.media.ic_pull_up_refresh'),
          text: '上拉可以加载更多'
        }
      case LoadMoreStatus.OverDrag:
        return {
          image: $r('app.media.ic_pull_down_refresh'),
          text: '松开立即加载更多'
        }
      case LoadMoreStatus.Loading:
        return {
          image: $r('app.media.ic_pull_up_load'),
          text: '正在加载更多数据'
        }
      case LoadMoreStatus.Done:
        return {
          image: '',
          text: '加载完成'
        }
      default:
        return {
          image: '',
          text: '没有更多了'
        }
    }
  }

  build() {
    if (this.status !== LoadMoreStatus.Inactive) {
      Stack({ alignContent: Alignment.Top }) {
        Row({ space: 12 }) {
          if (this.getImageText().image) {
            Image(this.getImageText().image)
              .width(14)
              .aspectRatio(1)
          }
          Text(this.getImageText().text)
            .fontSize(12)
            .fontColor($r('app.color.base_font_color9'))
        }
        .justifyContent(FlexAlign.Center)
        .width('100%')
        .height(50)

      }
      .clip(true)
      .width('100%')
      .height(50)
    } else {
      Column().height(0)
    }
  }
}

export enum LoadMoreStatus {
  Inactive, // 初始状态
  Drag, // 上拉中 未触发刷新
  OverDrag, // 上拉中 超过触发距离
  Loading, // 加载中
  Done, // 加载成功
  NO_MORE // 没有更多
}