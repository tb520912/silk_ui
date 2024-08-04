export interface SilkListProps {
  hasRefresh?: boolean // 是否具有下拉刷新功能
  hasLoadMore?: boolean // 是否具有上拉加载功能
  hasAutoLoad?: boolean
  maxTranslate?: number // 可下拉上拉的最大距离
  sensitivity?: number // 下拉上拉灵敏度
  listIsPlacement?: boolean // 滑动结束后列表是否归位
  animDuration?: number // 滑动结束后，回弹动画执行时间
  refreshHeight?: number // 下拉动画高度
  refreshColor?: string // 下拉动画颜色
  refreshBackgroundColor?: ResourceColor // 下拉动画区域背景色
  refreshTextColor?: ResourceColor // 下拉加载完毕后提示文本的字体颜色
  refreshTextSize?: number | string | Resource // 下拉加载完毕后提示文本的字体大小
  refreshAnimDuration?: number // 下拉动画执行一次的时间
  loadImgHeight?: number // 上拉图片高度
  loadBackgroundColor?: ResourceColor // 上拉动画区域背景色
  loadTextColor?: ResourceColor // 上拉文本的字体颜色
  loadTextSize?: number | string | Resource // 上拉文本的字体大小
  loadTextPullUp1?: string // 上拉1阶段文本
  loadTextPullUp2?: string // 上拉2阶段文本
  loadTextDone?: string // 上拉加载完毕后提示文本
  loadTextError?: string // 上拉失败提示文本
  loadTextLoading?: string // 上拉加载更多中时的文本
  no_more?: string
  lanes?: number // 列数
  gutters?: number // 间隔
}

export const SilkListDefaultProp: SilkListProps = {
  hasRefresh: true, // 是否具有下拉刷新功能
  hasLoadMore: true, // 是否具有上拉加载功能
  hasAutoLoad: false, // 是否开启触底自动加载
  maxTranslate: 100, // 可下拉上拉的最大距离
  sensitivity: 0.7, // 下拉上拉灵敏度
  listIsPlacement: true, // 滑动结束后列表是否归位
  animDuration: 150, // 滑动结束后，回弹动画执行时间
  refreshHeight: 80, // 下拉动画高度
  refreshColor: '#999999', // 下拉动画颜色
  refreshBackgroundColor: 'rgba(0,0,0,0)', // 下拉动画区域背景色
  refreshTextColor: '#999999', // 下拉加载完毕后提示文本的字体颜色
  refreshTextSize: 18, // 下拉加载完毕后提示文本的字体大小
  refreshAnimDuration: 1000, // 下拉动画执行一次的时间
  loadImgHeight: 50, // 上拉图片高度
  loadBackgroundColor: 'rgba(0,0,0,0)', // 上拉动画区域背景色
  loadTextColor: '#999999', // 上拉文本的字体颜色
  loadTextSize: 18, // 上拉文本的字体大小
  loadTextPullUp1: '上拉可以加载更多', // 上拉1阶段文本
  loadTextPullUp2: '松开立即加载更多', // 上拉2阶段文本
  loadTextDone: '加载完成', // 上拉加载完毕后提示文本
  loadTextError: '加载失败',
  loadTextLoading: '正在玩命加载中...', // 上拉加载更多中时的文本
  no_more: '没有更多了',
  lanes: 1, // 列数
  gutters: 0
}