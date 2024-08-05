@Preview
@Component
export struct SilkLoading {
  @State dasharray: number[] = [90 , 150];
  @State dashOffset: number | string = 0
  @State myScale: number = 1.0;
  uiContext: UIContext | undefined = undefined;

  aboutToAppear() {
    this.uiContext = this.getUIContext?.();
  }
  getDashArray (): number[] {
    const arr: number[] = []
    this.dasharray.forEach(item => {
      arr.push(item)
    })
    return arr
  }
  build() {
    Column(){
      Circle()
        .width(50)
        .height(50)
        .fill(Color.Transparent)
        .strokeWidth(3)
        .strokeLineCap(LineCapStyle.Round)
        .stroke('#c8c9cc')
        .strokeDashArray(this.dasharray)
        // .strokeDashOffset(this.dashOffset)
        .onAppear(() => {
          // this.dasharray = [1, 200]
          // this.dashOffset = 0
          // this.uiContext?.keyframeAnimateTo({ iterations: 3}, [
          //   {
          //     duration: 750,
          //     event: () => {
          //       this.dasharray = [90, 150]
          //       this.dashOffset = '-40px'
          //     }
          //   }, {
          //   duration: 750,
          //   event: () => {
          //     this.dasharray = [90, 150]
          //     this.dashOffset = '-120px'
          //   }
          // }
          // ])
        })
        .onClick(() => {
          // this.uiContext?.keyframeAnimateTo({ iterations: 30}, [
          //   {
          //     duration: 1000,
          //     event: () => {
          //       this.dasharray = [90, 150]
          //       this.dashOffset = -40
          //     }
          //   }, {
          //   duration: 1000,
          //   event: () => {
          //     this.dasharray = [1, 200]
          //     this.dashOffset = 0
          //   }
          // }
          // ])
          this.dasharray = [1, 200]
          this.uiContext?.keyframeAnimateTo({ iterations: 3 }, [
            {
              // 第一段关键帧动画时长为800ms，scale属性做从1到1.5的动画
              duration: 800,
              event: () => {
                this.dasharray = [90, 150]
              }
            },
            {
              // 第二段关键帧动画时长为500ms，scale属性做从1.5到1的动画
              duration: 500,
              event: () => {
                this.dasharray = [1, 200]
              }
            }
          ]);
        })
    }
    .width(200)
    .height(200)
    .backgroundColor(Color.Pink)
    // Column() {
    //   Circle()
    //     .width(100)
    //     .height(100)
    //     .fill("#46B1E3")
    //     .margin(100)
    //     .scale({ x: this.myScale, y: this.myScale })
    //     .onClick(() => {
    //       if (!this.uiContext) {
    //         console.info("no uiContext, keyframe failed");
    //         return;
    //       }
    //       this.myScale = 1;
    //       // 设置关键帧动画整体播放3次
    //       this.uiContext.keyframeAnimateTo({ iterations: 3 }, [
    //         {
    //           // 第一段关键帧动画时长为800ms，scale属性做从1到1.5的动画
    //           duration: 800,
    //           event: () => {
    //             this.myScale = 1.5;
    //           }
    //         },
    //         {
    //           // 第二段关键帧动画时长为500ms，scale属性做从1.5到1的动画
    //           duration: 500,
    //           event: () => {
    //             this.myScale = 1;
    //           }
    //         }
    //       ]);
    //     })
    // }.width('100%').margin({ top: 5 })
  }
}