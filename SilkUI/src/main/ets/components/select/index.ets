const DefaultProps: SilkSelectProps = {
  font: {
    size: 12
  },
  fontColor: $r('app.color.base_font_color3'),
  icon: $r("app.media.ic_public_triangle_down"),
  iconWidth: 9,
  space: 3,
  selectPadding: {
    top: 5,
    bottom: 5,
    left: 12,
    right: 10
  },
  menuItemPadding: {
    top: 8,
    left: 16,
    right: 16,
    bottom: 8
  },
  menuSelectFont:
  {
    size: 14
  },
  menuPadding: {
    top: 0,
    bottom: 0,
    left: 0,
    right: 0
  },
  menuSelectFontColor: $r('app.color.base_color'),
  selectRadius: 155,
  menuRadius: 4,
  menuBackground: Color.White,
  selectBackground: '#f6f7f8',
  menuFontColor: $r('app.color.base_font_color3'),
  menuFont: { size: 14 }
}

@Preview
@Component
export struct SilkSelect {
  @Link
  value: string | number
  @State
  showMenu: boolean = false
  options: SilkSelectOption[] = [
    {
      text: '选项1',
      value: '0'
    }, {
    text: '选项2',
    value: '1'
  }
  ]
  props: SilkSelectProps = {}

  getText() {
    const item = this.options.filter(item => item.value === this.value)[0]
    return item.selectText || item.text
  }

  aboutToAppear(): void {
    !this.props.font && (this.props.font = DefaultProps.font)
    !this.props.fontColor && (this.props.fontColor = DefaultProps.fontColor)
    !this.props.icon && (this.props.icon = DefaultProps.icon)
    !this.props.iconWidth && (this.props.iconWidth = DefaultProps.iconWidth)
    !this.props.space && (this.props.space = DefaultProps.space)
    !this.props.selectPadding && (this.props.selectPadding = DefaultProps.selectPadding)
    !this.props.menuItemPadding && (this.props.menuItemPadding = DefaultProps.menuItemPadding)
    !this.props.menuSelectFont && (this.props.menuSelectFont = DefaultProps.menuSelectFont)
    !this.props.menuSelectFontColor && (this.props.menuSelectFontColor = DefaultProps.menuSelectFontColor)
    !this.props.selectRadius && (this.props.selectRadius = DefaultProps.selectRadius)
    !this.props.menuRadius && (this.props.menuRadius = DefaultProps.menuRadius)
    !this.props.menuBackground && (this.props.menuBackground = DefaultProps.menuBackground)
    !this.props.menuPadding && (this.props.menuPadding = DefaultProps.menuPadding)
    !this.props.menuFontColor && (this.props.menuFontColor = DefaultProps.menuFontColor)
    !this.props.menuFont && (this.props.menuFont = DefaultProps.menuFont)
  }

  build() {
    Text() {
      Span(this.getText())
        .fontSize(this.props.font?.size)
        .fontColor(this.props.fontColor)
      ImageSpan(this.props.icon)
        .width(this.props.iconWidth)
        .aspectRatio(1)
        .verticalAlign(ImageSpanAlignment.CENTER)
        .margin({
          left: this.props.space
        })
        .rotate({
          angle: this.showMenu ? 180 : 0,
          centerX: '50%',
          centerY: '50%'
        })
    }
    .padding(this.props.selectPadding)
    .backgroundColor(this.props.selectBackground)
    .borderRadius(this.props.selectRadius)
    .bindContextMenu(this.showMenu, this.MyMenu, {
      onDisappear: () => {
        this.showMenu = false
      },
      backgroundColor: this.props.menuBackground,
      backgroundBlurStyle: BlurStyle.NONE,
      enableArrow: true,
      placement: Placement.Bottom,
      offset: {
        y: -3
      },
      borderRadius: this.props.menuRadius
    })
    .onClick(() => {
      this.showMenu = !this.showMenu
    })
  }

  @Builder
  MyMenu() {
    Column() {
      ForEach(this.options, (item: SilkSelectOption) => {
        Text() {
          Span(item.text)
            .fontSize(item.value === this.value ? this.props.menuSelectFont?.size : this.props.menuFont?.size )
            .fontColor(item.value === this.value ? this.props.menuSelectFontColor : this.props.menuFontColor)
          if (item.icon) {
            ImageSpan(item.icon)
              .width(14)
              .aspectRatio(1)
              .margin({
                right: 3
              })
          }
        }
        .padding(this.props.menuItemPadding)
        .onClick(() => {
          this.value = item.value
          this.showMenu = false
        })
      })
    }
    .padding(this.props.menuPadding)
  }
}

export interface SilkSelectOption {
  text: ResourceStr
  value: string | number
  selectText?: string
  icon?: ResourceStr
}

export interface SilkSelectProps {
  font?: Font,
  fontColor?: ResourceColor
  icon?: ResourceStr
  iconWidth?: number | string
  space?: number
  selectPadding?: Padding
  menuPadding?: Padding
  menuItemPadding?: Padding
  menuFontColor?: ResourceColor
  menuSelectFont?: Font
  menuFont?: Font
  menuSelectFontColor?: ResourceColor
  menuRadius?: number | string
  selectRadius?: number | string
  menuBackground?: ResourceColor
  selectBackground?: ResourceColor
}