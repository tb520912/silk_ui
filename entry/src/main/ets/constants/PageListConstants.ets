export class PageListConstants {
  static list: PageItem[] = [
    {
      title: '单元格',
      name: 'CellPage'
    },
    {
      title: '折叠面板',
      name: 'Collapse'
    },
    {
      title: '弹出框',
      name: 'Dialog'
    },
    {
      title: 'loading',
      name: 'LoadingPage'
    },
    {
      title: '下拉菜单',
      name: 'DropdownMenu'
    },
    {
      title: '图片上传',
      name: 'ImageUpload'
    },
    {
      title: '列表',
      name: 'ListPage'
    },
    {
      title: 'popup弹出层',
      name: 'PopupPage'
    },
    {
      title: 'select菜单选择',
      name: 'SelectPage'
    },
    {
      title: 'tabbar页签栏',
      name: 'TabBarPage'
    },
    {
      title: '轻提示',
      name: 'ToastPage'
    }
  ]
}
export interface PageItem {
  title: string,
  name: string
}

