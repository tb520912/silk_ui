/**
 * 折叠面板
 */
import { SilkCollapseController } from './controller'
import { SilkCollapseToggleController } from './toggleController'

@Component
export struct SilkCollapse {
  silkCollapseToggleController: SilkCollapseToggleController = new SilkCollapseToggleController()
  // 展开状态
  @BuilderParam
  children: () => void
  @Link
  activeNames: string | string[]
  // 如果需要使用一键切换功能 需要将所有的item的name传递过来
  names: string[] = []
  accordion: boolean = false
  @Provide({ allowOverride: 'silkCollapseController'})
  @Watch('change')
  silkCollapseController: SilkCollapseController = new SilkCollapseController([])
  @Provide
  paddingValue: Padding = {
    left: 16,
    right: 16
  }
  change () {
    this.activeNames = this.silkCollapseController.activeNames
  }
  aboutToAppear(): void {
    this.silkCollapseController = new SilkCollapseController(this.activeNames, this.accordion, this.names)
    if (this.silkCollapseToggleController && this.names.length) {
      this.silkCollapseToggleController.toggle = (flag?: boolean) => this.silkCollapseController.toggleAll(flag)
    }
  }
  build() {
      this.children()
  }
}


export interface SilkCollapseProps {
  icon?: ResourceStr
  size?: Length // 标题栏高度
  title: ResourceStr // 标题栏标题
  value?: ResourceStr // 内容
  showIcon?: boolean // 是否展示右侧图标
  disabled?: boolean // 是否禁用
  isReadonly?: boolean // 是否只读
  border?: boolean // 是否展示分割线
}
