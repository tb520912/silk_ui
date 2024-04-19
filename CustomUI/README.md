# CustomUI 简介

CustomUI 是基于HarmonyOS的UI框架，可以快速开发UI界面。兼容api11以上。

# 下载安装

ohpm install @tb_test/custom_ui

# 基础组件

## CustomPopup 抽屉

1.介绍

`抽屉组件。用于侧边抽屉或者底部、顶部的弹框`

2.引入

```arkTS
import { CustomPopup } from "@tb_test/custom_ui"
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