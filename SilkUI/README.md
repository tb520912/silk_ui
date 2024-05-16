# CustomUI 简介

silk_ui 是基于HarmonyOS的UI框架，可以快速开发UI界面。兼容api11以上。

# 下载安装

ohpm install silk_ui

# 基础组件

## CustomPopup 抽屉

1.介绍

`抽屉组件。用于侧边抽屉或者底部、顶部的弹框`

2.引入

```arkTS
import { CustomPopup } from "silk_ui"
```

3.使用

1. 基础用法

   `使用状态变量控制是否显示 组件内使用@Link装饰show参数接收`

   `该组件可放置于build函数或者@Builder函数内部任意合法位置，不影响其布局`

   ```arkTS
   CustomPopup({
     show: this.showPopupCenter
   }) {
     Column(){
       Text('内容区')
     }
   }
   ```

2. 设置位置

   `通过传递showPosition参数设置弹框展示位置,'top' | 'bottom' | 'left' | 'right' | 'center'不传默认'center' `

   `该参数非状态变量`

   ```arkTS
   CustomPopup({
      show: this.showPopupCenter,
      showPosition: 'left'
   }) {
      Column(){
        Text('内容区')
      }
   }
   ```

3. API

    1. props

| 参数                     | 说明                                 | 类型                                                             | 默认值         |
|:-----------------------|:-----------------------------------|:---------------------------------------------------------------|:------------|
| @Link show             | 是否展示抽屉                             | boolean                                                        | false       |
| showOverlay            | 是否展示遮罩                             | boolean                                                        | true        |
| showPosition           | 抽屉展示位置                             | _'top' \| 'bottom' \| 'left' \| 'right' \| 'center'_           | 'center'    |
| overlayColor           | 遮罩颜色                               | ResourceColor                                                  | '#B3000000' |
| duration               | 动画时长                               | number                                                         | 300         |
| round                  | 抽屉圆角                               | Length                                                         | 0           |
| widthValue             | 展示位置为'left' 'right'时 的宽度，不支持自适应撑开。 | _number \| string_                                             | '70%'       |
| close_on_click_overlay | 点击遮罩是否关闭抽屉                         | boolean                                                        | true        |
| showClose              | 是否展示关闭按钮                           | boolean                                                        | false       |
| close_icon             | 关闭按钮图标                             | ResourceStr                                                    |             |
| close_icon_position    | 关闭按钮位置                             | _'top-left' \| 'top-right' \| 'bottom-left' \| 'bottom-right'_ | 'top-right' |
| safe_top               | 是否规避状态栏                            | boolean                                                        | false       |
| safe_bottom            | 是否规避底部导航栏                          | boolean                                                        | false       |

2. event 使用方法传递（注意传递方法时的this指向）

| 参数            | 说明                            | 类型                                  | 默认值        |
|---------------|-------------------------------|-------------------------------------|------------|
| before_close  | 关闭前回调 返回true则关闭 返回false可以阻止关闭 | () => (boolean \| Promise<boolean>) | () => true |
| click_overlay | 遮罩点击                          | () => void                          | () => { }  |
| click_close   | 关闭按钮点击                        | 同上                                  |            |
| open          | 显示时立即触发                       | 同上                                  |            |
| close         | 关闭后立即触发                       | 同上                                  |            |

3. @BuilderParams

   ```arkTS
   @BuilderParam
   default: () => void
   ```

   仅此一个 推荐使用尾随闭包方式传递

## DropDownMenu 下拉菜单

1.介绍

`下拉菜单组件。用于下拉菜单的展示。和前端vant的组件功能类似`
2.引入

```arkTS
import { DropDownMenu } from "silk_ui"
```

3.使用

1. 基础用法

   `使用状态变量控制菜单的文本内容 组件内使用@Link装饰value参数接收`

   `通过options参数设置下拉菜单的选项，options为数组，数组元素为对象，对象包含text和value两个属性 导出了DropDownMenuItemInterface接口`

   ```arkTS
   import { DropDownMenu, DropDownMenuItemInterface } from '@ohos/ui_component'
      @State
      value: number = 0
      @State
      list: DropDownMenuItemInterface[] = [{
        text: '选项1',
        value: 0
      }, {
        text: '选项2',
        value: 1
      }, {
        text: '选项3',
        value: 2
      }]
  
  
   DropDownMenu({
      value: this.value,
      options: this.list,
   })
   ```

2.自定义内容

`通过传递@BuilderParam参数设置自定义内容，可使用尾随闭包方式传递`

   ```arkTS

   `该参数非状态变量`
   ` !!!注意 自定义内容时 
   需要设置菜单的文本内容，传入text属性 必传 该参数使用@Prop装饰
   需要设置菜单的状态，传入menuFlag属性 必传 该参数使用@Prop装饰
   需要设置菜单的状态改变方法，传入changeStatus属性 必传 该参数使用@Prop装饰
   并且点击事件需要自行处理。
   `
   ``

   ```arkTS
   @State // 菜单项文本
   text: string = this.list[0].text
   @State // 菜单状态
   menuFlag: boolean = false
   changeFlag(flag: boolean):void {
     this.menuFlag = flag
   }
  
   DropDownMenu({
     value: this.value,
     text: this.text,
     menuFlag: this.menuFlag,
     changeStatus: (flag: boolean) => this.changeFlag(flag)
   }) {
     Column(){
       ForEach(this.list, (item: DropDownMenuItemInterface, index: number) => {
         Row(){
           Text(item.text)
             .fontColor(item.value === this.value ? $r('app.color.base_color') : Color.Black)
           Image($r('app.media.ic_public_ok'))
             .width(16)
             .aspectRatio(1)
             .fillColor($r('app.color.base_color'))
             .visibility(item.value === this.value ? Visibility.Visible : Visibility.Hidden)
         }
         .onClick(() => {
           this.text = item.text
           this.value = item.value
           this.menuFlag = false
         })
       })
     }
     .width('100%')
     .backgroundColor(Color.White)
     .borderRadius({
       bottomLeft: 16,
       bottomRight: 16
     })
   }
   ```

3. API

    1. props

| 参数                     | 说明                           | 类型                          | 默认值                            |
|------------------------|------------------------------|-----------------------------|--------------------------------|
| @Link value            | 选中项的value属性                  | _string \| number_          | -                              |
| @Prop text             | 如果使用自定义内容区 则该参数必传            | string                      | -                              |
| @Prop options          | 列表项 如果传递 默认使用默认内容区           | DropDownMenuItemInterface[] | []                             |
| @Prop menuFlag         | 菜单展开状态 如果使用自定义内容区 则该参数必传     | boolean                     | false                          |
| @Prop changeStatus     | 修改菜单展开状态方法 如果使用自定义内容区 则该参数必传 | (flag: boolean) => void     | (flag) => this.menuFlag = flag |
| @BuilderParam  default | 自定义内容区                       | () => void                  | -                              |
| directionValue         | 菜单展开方向                       | _'down' \| 'up'_            | 'down'                         |
| duration               | 动画时长                         | number                      | 300                            |
| round                  | 菜单圆角                         | Length                      | 0                              |
| overlay_color          | 遮罩颜色                         | ResourceColor               | '#B3000000'                    |
| close_on_click_overlay | 点击遮罩是否关闭菜单                   | boolean                     | true                           |
| close_on_click_outside | 点击菜单或其它元素是否关闭菜单              | boolean                     | true                           |
| active_color           | 主题色                          | ResourceColor               | '#0581ce'                      |
| hasOverlay             | 是否有遮罩                        | boolean                     | true                           |
| @Prop disabled         | 是否禁用                         | boolean                     | false                          |

## CustomToast 对话框

1.介绍

`对话框组件。用于弹出对话框 采用函数式调用。有success error warn toast四个方法`
2.引入

```arkTS
import { CustomToast } from "silk_ui"
```

3.使用

1. 基础用法

   ```arkTS
   CustomToast.success('成功')
   ```

    2. 自定义用法

       ```arkTS
       CustomToast.success({
         message: '标题',
         duration: 1000,
         showIcon: true,
         icon: '***',
         showPosition: 'center'
       })
       ```

    3. API

| 参数           | 说明      | 类型                              | 默认值      |
|--------------|---------|---------------------------------|----------|
| message      | 内容 必传   | ResourceStr                     | ''       |
| duration     | 持续时间 毫秒 | number                          | 2000     |
| showIcon     | 是否展示图标  | boolean                         | true     |
| icon         | 自定义图标   | ResourceStr                     | -        |
| showPosition | 展示位置    | _'top' \| 'bottom' \| 'center'_ | 'center' |

## CustomList 列表

1.介绍

`列表组件。用于展示列表数据，支持下拉刷新和上拉加载更多`
2.引入

```arkTS
import { CustomList } from "silk_ui"
```

3.使用

   ```arkTS
   CustomList({
      dataSource: this.list,
      finished: this.finished,
      onLoad: () => this.load(),
      onRefresh: () => this.refresh(),
      children: (item: object) => this.children(item)
   })
   ```

4. API

| 参数                     | 说明             | 类型                                      | 默认值                                                   |
|------------------------|----------------|-----------------------------------------|-------------------------------------------------------|
| dataSource             | 数据源            | object[]                                | []                                                    |
| @Prop finished         | 是否加载了所有        | boolean                                 | false                                                 |
| onLoad                 | 加载数据源方法 触底自动执行 | () => Promise<void>                     | -                                                     |
| onRefresh              | 刷新方法           | () => Promise<void>                     | -                                                     |
| @BuilderParam children | 列表项组件          | Builder                                 | -                                                     |
| keyGenera              | 键的生成器函数        | (item: object, index: number) => string | (item: object, index: number) => JSON.stringify(item) |
| divider                | 分割线样式          | _ListDivider \| null_                   | false                                                 |
| space                  | 列表项间隔          | _number \| string_                      | 16                                                    |
| paddingLr              | 列表两侧留白         | _number \| string_                      | 12                                                    |
| background_color       | 背景色            | ResourceColor                           | '#ffffff'                                             |
| offsetValue            | 列表底部偏移量 触发加载   | number                                  | 80                                                    |
| openRefresh            | 是否开启下拉刷新       | boolean                                 | true                                                  |
| openAutoLoad           | 是否开启自动加载       | boolean                                 | true                                                  |
