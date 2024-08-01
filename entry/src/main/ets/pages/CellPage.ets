import { SilkCell, SilkCellGroup } from '@ohos/silk_ui';
import { Nav } from '../view/Nav';
import { Title } from '../view/Title';

@Entry
@Component
struct CellPage {
  @State message: string = 'Hello World';

  build() {
    Column(){
      Nav('Cell')
      Scroll(){
        Column(){
          Title('基础用法')
          SilkCellGroup(){
            SilkCell({
              props: {
                title: '单元格',
                value: '内容'
              }
            })
            SilkCell({
              props: {
                title: '单元格',
                value: '内容',
                label: '描述信息'
              }
            })
          }
          Title('卡片风格')
          SilkCellGroup({ inset: true }){
            SilkCell({
              props: {
                title: '单元格',
                value: '内容'
              }
            })
            SilkCell({
              props: {
                title: '单元格',
                value: '内容',
                label: '描述信息'
              }
            })
          }
          Title('单元格大小')
          SilkCellGroup(){
            SilkCell({
              props: {
                title: '单元格',
                value: '内容',
                size: 'large'
              }
            })
            SilkCell({
              props: {
                title: '单元格',
                value: '内容',
                label: '描述信息',
                size: 'large'
              }
            })
          }
          Title('展示图标')
          SilkCellGroup(){
            SilkCell({
              props: {
                title: '单元格',
                value: '内容',
                icon: $r('app.media.location_o')
              }
            })
          }
          Title('展示箭头')
          SilkCellGroup(){
            SilkCell({
              props: {
                title: '单元格',
                isLink: true
              }
            })
            SilkCell({
              props: {
                title: '单元格',
                value: '内容',
                isLink: true
              }
            })
            SilkCell({
              props: {
                title: '单元格',
                value: '内容',
                isLink: true,
                arrowDirection: 'down'
              }
            })
          }
          Title('分组标题')
          SilkCellGroup({
            title: '分组1'
          }){
            SilkCell({
              props: {
                title: '单元格',
                value: '内容'
              }
            })
          }
          SilkCellGroup({
            title: '分组2'
          }){
            SilkCell({
              props: {
                title: '单元格',
                value: '内容'
              }
            })
          }
          Title('使用插槽')
          SilkCellGroup(){
            SilkCell({
              customTitle: this.CustomTitle,
              props: {
                value: '内容',
                isLink: true
              }
            })
            SilkCell({
              props: {
                title: '单元格',
                icon: $r('app.media.shop_o'),
              },
              customRightIcon: this.CustomValue
            })
          }
          Title('垂直居中')
          SilkCellGroup(){
            SilkCell({
              props: {
                title: '单元格',
                value: '内容',
                center: true,
                label: '描述信息'
              }
            })
          }
        }
        .justifyContent(FlexAlign.Start)
      }
      .layoutWeight(1)
      .backgroundColor($r('app.color.vandocbackground'))
      .align(Alignment.Top)
    }
    .width('100%')
    .height('100%')
  }
  @Builder
  CustomTitle () {
    Row({ space: 4 }){
      Text('单元格')
        .fontSize($r('app.float.font_size_md'))
        .fontColor($r('app.color.text_color'))
      Text('标签')
        .fontSize($r('app.float.font_size_sm'))
        .fontColor($r('app.color.white'))
        .padding({
          left: $r('app.float.padding_base'),
          right: $r('app.float.padding_base')
        })
        .borderRadius($r('app.float.radius_sm'))
        .backgroundColor($r('app.color.primary_color'))
    }
  }
  @Builder
  CustomValue () {
    Image($r('app.media.search'))
      .height(16)
      .fillColor($r('app.color.text_color'))
  }
}