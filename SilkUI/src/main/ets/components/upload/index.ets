import { picker } from '@kit.CoreFileKit'
import { request } from '@kit.BasicServicesKit'
import fs from '@ohos.file.fs'
import { util } from '@kit.ArkTS'
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { dataSharePredicates } from '@kit.ArkData'
import { uploadFile } from '../../utils/Upload'
import { SilkToast } from '../toast'
import { vibrator } from '@kit.SensorServiceKit'
import { showSilkImagePreview } from '../imagePreview'

const TAG = ['SILK_UPLOAD']

@Component
export struct SilkUpload {
  @Link
  @Watch('setUpImgs')
  images: string[]
  // 可以指定宫格布局时的列数 不传 默认上传单张时 占满一行 否则一行三列
  rows: number = 0
  // 组件内部使用数组
  @State
  upImgs: SilkUploadItem[] = []
  // 上传调用接口
  uploadUrl: string = ''
  // 上传额外参数
  props: object = new Object()
  // 长按排序
  hasEdit: boolean = true
  // 是否需要裁剪
  hasCrop: boolean = false
  // 上传区域图标地址 不传使用默认
  icon: ResourceStr = ''
  // 最大上传数量
  maxNumber: number = 1
  // 图片比例
  proportion: number = 1
  // 接受的文件类型
  accept: 'img' | 'video' | 'all' = 'img'
  // 是否可删除
  hasRemove: boolean = true
  // 是否可预览
  hasPreview: boolean = true
  // 默认ui
  @BuilderParam
  children: () => void
  @BuilderParam
  refresh: () => void
  refreshPosition: 'top_right' | 'center' | 'bottom' = 'bottom'
  @State
  @Watch('vibratorFn')
  currentIndex: number = -1
  @State x: number = 0
  @State y: number = 0
  @State itemWidth: number = 0
  scroller: Scroller = new Scroller()
  targetIndex: number = -1
  private dragImg: SilkUploadItem = new SilkUploadItem({
    filePath: '',
    url: ''
  })

  // 排序相关
  vibratorFn() {
    vibrator.startVibration({ effectId: vibrator.EffectId.EFFECT_CLOCK_TIMER, type: 'preset' },
      { id: 0, usage: 'physicalFeedback' })
  }

  // 上传成功回调
  success: (data: object) => string = (data) => JSON.stringify(data)
  // 裁剪方法 需要返回裁剪后的沙箱路径 用于上传.参数是cache下的路径 返回值也必须是
  cropFunction: (uri: string, callback: (data: string) => void) => void = (uri, callback) => {
    callback(uri)
  }

  aboutToAppear(): void {
    this.setUpImgs()
  }

  getTemplate(lines: number, type: 'row' | 'column'): string {
    let str = ''
    if (type === 'row') {
      for (let index = 0; index < (this.rows || lines); index++) {
        str += '1fr '
      }
    } else {
      const rows = this.rows || lines > 1 ? 3 : 1
      const cols = Math.ceil(lines / rows)
      for (let index = 0; index < cols; index++) {
        str += '1fr '
      }
    }
    return str.trimEnd()
  }

  getAlign() {
    switch (this.refreshPosition) {
      case 'top_right':
        return Alignment.TopEnd
      case 'center':
        return Alignment.Center
      case 'bottom':
        return Alignment.Bottom
    }
  }

  setCurrentIndex(index: number) {
    if (index >= this.upImgs.length) {
      return
    }
    this.x = this.scroller.getItemRect(index).x
    this.y = this.scroller.getItemRect(index).y

    this.currentIndex = index
  }

  build() {
    Column() {
      Column()
        .width(this.itemWidth)
        .height(this.itemWidth)
        .position({ x: this.x, y: this.y })
        .zIndex(2)
        .visibility(this.currentIndex === -1 ? Visibility.Hidden : Visibility.Visible)
        .border({
          width: 2,
          style: {
            left: BorderStyle.Dotted,
            right: BorderStyle.Dotted,
            top: BorderStyle.Dotted,
            bottom: BorderStyle.Dotted
          }, color: Color.Gray
        })
        .hitTestBehavior(HitTestMode.None)
      Grid(this.scroller) {
        ForEach(this.upImgs, (item: SilkUploadItem, index: number) => {
          GridItem() {
            Stack({ alignContent: this.getAlign() }) {
              SilkUploadChildren({
                imagesInfo: item,
                proportion: this.proportion,
                removeItem: (v: SilkUploadItem) => this.remove(v),
                hasRemove: this.hasRemove
              })
              if (this.refresh) {
                Row() {
                  this.refresh()
                }
                .margin({
                  top: this.refreshPosition === 'top_right' ? 5 : 0,
                  right: this.refreshPosition === 'top_right' ? 5 : 0,
                  bottom: this.refreshPosition === 'bottom' ? 14 : 0
                })
                .onClick(() => {
                  this.handler(index)
                })
              }
            }
          }
          .width('100%')
          .aspectRatio(1)
          .onClick(() => {
            if (this.hasPreview) {
              showSilkImagePreview(this.images, index)
            }
          })

        }, (item: SilkUploadItem) => item.url)
        if (this.upImgs.length < this.maxNumber) {
          GridItem() {
            if (this.children) {
              this.children()
            } else {
              this.NoContainer()
            }
          }
          .width('100%')
          .aspectRatio(1)
          .draggable(false)
          .onClick(() => {
            this.handler()
          })
          .onDrop((event: DragEvent) => {
            event.setResult(DragResult.DROP_DISABLED)
          })
        }
      }
      .supportAnimation(true)
      .columnsTemplate(this.getTemplate(this.maxNumber > 1 ? 3 : 1, 'row'))
      .rowsGap(this.rows || this.maxNumber > 1 ? 10 : 0)
      .columnsGap(this.maxNumber / (this.rows || (this.maxNumber > 1 ? 3 : 1)) > 1 ? 10 : 0)
      .editMode(this.hasEdit)
      .scrollBar(BarState.Off)
      .onItemDragStart((event: ItemDragInfo, itemIndex: number) => {
        vibrator.startVibration({ effectId: vibrator.EffectId.EFFECT_CLOCK_TIMER, type: 'preset' },
          { id: 0, usage: 'physicalFeedback' })
        if (itemIndex >= this.upImgs.length) {
          return;
        }
        this.dragImg = this.upImgs[itemIndex]
        this.itemWidth = this.scroller.getItemRect(itemIndex).width
        this.setCurrentIndex(itemIndex)
        return this.pixelMapBuilder()
      })
      .onItemDragMove((event: ItemDragInfo, itemIndex: number, insertIndex: number) => {
        // 最后一个上传按钮不参与排序 所以当元素最终被拉到该处时 拖拽事件是失败的 需要记录一下上一个占位的索引
        if (itemIndex !== insertIndex && insertIndex < this.upImgs.length) {
          this.targetIndex = insertIndex
        }
        this.setCurrentIndex(insertIndex)
      })
      .onItemDrop((event: ItemDragInfo, itemIndex: number, insertIndex: number, isSuccess: boolean) => {
        // 成功时 目标位置即插入位置
        if (isSuccess && insertIndex < this.upImgs.length) {
          this.targetIndex = insertIndex
        }
        // 如果目标位置为-1 不进行调整
        if (this.targetIndex === -1) {
          return
        }
        // 刷新数据源
        if (itemIndex < this.targetIndex) {
          this.upImgs.splice(this.targetIndex + 1, 0, this.dragImg)
          this.upImgs.splice(itemIndex, 1)
        } else {
          this.upImgs.splice(itemIndex, 1)
          this.upImgs.splice(this.targetIndex, 0, this.dragImg)
        }

        // 重置
        this.targetIndex = -1
        this.currentIndex = -1
      })

    }
  }

  @Builder
  NoContainer() {
    RelativeContainer() {
      Image($r('app.media.ic_public_camera'))
        .width(24)
        .height(24)
        .id('silk_upload_icon')
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
    }
    .width('100%')
    .aspectRatio(this.proportion)
    .backgroundColor('#eff2f5')
  }

  @Builder
  pixelMapBuilder() { //拖拽过程样式
    Column() {
      Image(this.dragImg.url)
        .width(this.itemWidth)
        .aspectRatio(this.proportion)
        .objectFit(ImageFit.Fill)
    }
  }

  // 点击上传
  async handler(index?: number) {
    const photoPicker = new picker.PhotoViewPicker()
    const options: picker.PhotoSelectOptions = {
      MIMEType: picker.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE,
      maxSelectNumber: index !== undefined || this.hasCrop ? 1 : this.maxNumber
    }
    if (this.accept === 'img') {
      options.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE
    } else if (this.accept === 'video') {
      options.MIMEType = picker.PhotoViewMIMETypes.VIDEO_TYPE
    }
    const result = await photoPicker.select(options)
    if (result && result.photoUris.length) {

      const files: request.File[] = []
      if (this.hasCrop) {
        const filePath = await this.saveLocal(result.photoUris[0])
        const basePath = getContext(this).cacheDir
        this.cropFunction(basePath + '/' + filePath, (path: string) => {
          const newFile = path.indexOf('cache/') > -1 ? path.split('cache/')[1] : path
          if (index !== undefined) {
            this.upImgs.splice(index, 1, new SilkUploadItem({
              filePath: 'file://' + basePath + '/' + newFile
            }))
          } else {
            this.upImgs.push(new SilkUploadItem({
              filePath: 'file://' + basePath + '/' + newFile
            }))
          }
          const upFile: request.File = {
            filename: newFile,
            name: 'file',
            uri: `internal://cache/${newFile}`,
            type: newFile.split('.')[1]
          }
          this.uploadFunction(upFile)
        })
      } else {
        // 遍历 存储到沙箱
        result.photoUris.forEach(async uri => {
          const basePath = getContext(this).cacheDir
          let newFile = await this.saveLocal(uri)
          if (!fs.accessSync(basePath + '/' + newFile)) {
            SilkToast.error('路径错误')
            return;
          }
          if (index !== undefined) {
            this.upImgs.splice(index, 1, new SilkUploadItem({
              filePath: 'file://' + basePath + '/' + newFile
            }))
          } else {
            this.upImgs.push(new SilkUploadItem({
              filePath: 'file://' + basePath + '/' + newFile
            }))
          }
          const upFile: request.File = {
            filename: newFile,
            name: 'file',
            uri: `internal://cache/${newFile}`,
            type: newFile.split('.')[1]
          }
          files.push(upFile)
        })
        if (files.length) {
          // 上传到云存储
          files.forEach((item) => {
            this.uploadFunction(item)
          })
        }
      }

    }
  }

  async saveLocal(uri: string): Promise<string> {
    const basePath = getContext(this).cacheDir
    let filePath = util.generateRandomUUID() + '.' + uri.split('.')[uri.split('.').length - 1]

    const file = fs.openSync(basePath + '/' + filePath, fs.OpenMode.WRITE_ONLY | fs.OpenMode.CREATE)
    const uriFile = fs.openSync(uri, fs.OpenMode.READ_ONLY)
    fs.copyFileSync(uriFile.fd, file.fd)
    fs.closeSync(file.fd)
    fs.closeSync(uriFile.fd)
    return filePath
  }

  async uploadFunction(file: request.File) {
    uploadFile(getContext(this), file, this.props, this.uploadUrl).then(res => {
      if (res) {
        const index =
          this.upImgs.findIndex(v => v.filePath === `file://${getContext(this).cacheDir}/${file.filename}`)
        if (index > -1) {
          const imageUrl = this.success(res)
          this.upImgs[index].url = imageUrl
          this.upImgs[index].status = SilkUploadStatus.SUCCESS
          this.images[index] = imageUrl
        }
      }
    }).catch((err: Error) => {
      SilkToast.error(err.message)
      const index =
        this.upImgs.findIndex(v => v.filePath === `file://${getContext(this).cacheDir}/${file.filename}`)
      if (index > -1) {
        this.upImgs[index].status = SilkUploadStatus.ERROR
      }
    })
  }

  async getMediaInfo(uri: string) {
    let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(getContext());
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    // 配置查询条件，使用PhotoViewPicker选择图片返回的uri进行查询
    predicates.equalTo('uri', uri);
    let fetchOption: photoAccessHelper.FetchOptions = {
      fetchColumns: [photoAccessHelper.PhotoKeys.PHOTO_TYPE],
      predicates: predicates
    };
    let fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.PhotoAsset> =
      await phAccessHelper.getAssets(fetchOption);
    // 得到uri对应的PhotoAsset对象，读取文件的部分信息
    const asset: photoAccessHelper.PhotoAsset = await fetchResult.getFirstObject();
    const type = asset.get(photoAccessHelper.PhotoKeys.PHOTO_TYPE) as number
    return type // 1 图片 2，视频
  }

  // 删除
  remove(item: SilkUploadItem): void {
    const index = this.upImgs.findIndex(v => v.filePath === item.filePath)
    if (index > -1) {
      this.images.splice(index, 1)
      this.upImgs.splice(index, 1)
    }
  }

  // 监听使用方传递的图片数组
  setUpImgs() {
    if (this.images.length) {
      this.images.forEach(item => {
        const index = this.upImgs.findIndex(v => v.url === item)
        if (index === -1) {
          this.upImgs.push(new SilkUploadItem({
            filePath: item,
            url: item,
            status: SilkUploadStatus.SUCCESS
          }))
        }
      })
    } else {
      this.upImgs = []
    }
  }
}

@Component
struct SilkUploadChildren {
  @ObjectLink
  imagesInfo: SilkUploadItem
  @Prop
  proportion: number = 1
  @Prop
  hasRemove: boolean = true
  removeItem: (item: SilkUploadItem) => void = (item) => {
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      Image(this.imagesInfo.url ? this.imagesInfo.url : this.imagesInfo.filePath)
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Fill)
        .draggable(false)
      if (this.imagesInfo.status === SilkUploadStatus.SUCCESS && this.hasRemove) {
        Image($r('app.media.ic_public_close_top_right'))
          .width(14)
          .aspectRatio(1)
          .onClick(() => {
            this.removeItem(this.imagesInfo)
          })
      } else {
        Column({ space: 6 }) {
          if (this.imagesInfo.status === SilkUploadStatus.LOADING) {
            LoadingProgress()
              .color('#fff')
              .width(22)
          } else if (this.imagesInfo.status === SilkUploadStatus.ERROR) {
            Image($r('app.media.ic_public_upload_error'))
              .width(22)
              .aspectRatio(1)
          }
          Text(this.imagesInfo.status === SilkUploadStatus.LOADING ? '上传中...' : '上传失败')
            .fontSize(12)
            .fontColor('#fff')
        }
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0,0,0,0.5)')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .onClick(() => {
          if (this.imagesInfo.status === SilkUploadStatus.ERROR) {
            this.removeItem(this.imagesInfo)
          }
        })
      }
    }
    .width('100%')
    .aspectRatio(this.proportion)
  }
}

interface SilkUploadItemInterface {
  filePath: string
  url?: string
  status?: SilkUploadStatus
}

enum SilkUploadStatus {
  LOADING,
  SUCCESS,
  ERROR
}

@Observed
class SilkUploadItem implements SilkUploadItemInterface {
  filePath: string
  url?: string
  status?: SilkUploadStatus

  constructor(model: SilkUploadItemInterface) {
    this.filePath = model.filePath
    this.url = model.url || ''
    this.status = model.status || SilkUploadStatus.LOADING
  }
}