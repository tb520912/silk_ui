export class SilkCollapseController {
  activeNames: string[] | string = []

  // 手风琴模式
  private accordion: boolean = false
  private names: string[] = []

  constructor(activeNames: string[] | string, accordion: boolean = false, names: string[] = []) {
    this.accordion = accordion
    if (accordion) {
      if (typeof activeNames === 'string') {
        this.activeNames = activeNames
      } else {
        throw new Error('activeNames应为字符串类型')
      }
    } else {
      if (!Array.isArray(activeNames) || !activeNames.every(item => typeof item === 'string')) {
        throw new Error('activeNames应为字符串数组')
      } else {
        this.activeNames = activeNames
      }
    }
    if (names) {
      this.names = names
    }
  }
  // 切换
  change (name: string) {
    if (this.accordion) {
      this.activeNames = this.activeNames === name ? '' : name
    } else {
      const arr: string[] = [...this.activeNames as string[]]
      if ((arr as string[]).includes(name)) {
        const index = arr.indexOf(name)
        index > - 1 && arr.splice(index, 1)
      } else {
        arr.push(name)
      }
      this.activeNames = arr
    }
  }
  toggleAll (flag?:boolean): void {
    // 手风琴模式不支持一键切换
    if (this.accordion) return;
    if (this.names.length === 0) {
      throw new Error('缺少names参数')
    }
    if (flag === undefined) {
      // 不传 全部切换
      const arr: string[] = [...this.activeNames as string[]]

      this.names.forEach(item => {
        if (arr.includes(item)) {
          const index = arr.indexOf(item)
          index > - 1 && arr.splice(index, 1)
        } else {
          arr.push(item)
        }
      })
      this.activeNames = arr
    } else if (flag) {
      // true 全部展开
      this.activeNames = [...this.names]
    } else {
      // false 全部收齐
      this.activeNames = []
    }
  }
}
