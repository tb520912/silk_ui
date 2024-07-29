import image from '@ohos.multimedia.image';
import fs from '@ohos.file.fs';
import { promptAction, Size } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { FileUtil } from './FileUtil';

@Observed
export default class CropObserved {
  winSize: Size = {
    width: 0,
    height: 0
  }
  cropSize: Size = {
    width: 0,
    height: 0
  }
  canvasImage: Size = {
    width: 0,
    height: 0
  }
  holeWidth: number = 0
  pixelMap?: image.PixelMap = undefined
  imageSize: Size = {
    width: 0, height: 0
  }
  ratio: number = 0
  verticalFlip: boolean = false
  horizontalFlip: boolean = false
  rotationAngle: number = 0
  horizontalImage: boolean = false
  positionX: number = 0
  positionY: number = 0
  offsetX: number = 0
  offsetY: number = 0
  scale: number = 1
  cropLoading: boolean = false

  async getPixel(imageURI: string, area: Area) {

    try {
      if (fs.accessSync(imageURI)) {
        let imageSource = image.createImageSource(imageURI)
        this.pixelMap = await imageSource.createPixelMap({
          editable: true,
          desiredPixelFormat: image.PixelMapFormat.BGRA_8888
        })

        this.getImageSize(area)
      }
    } catch (error) {
      console.log('error: ' + error)
    }
  }

  getImageSize(area?: Area) {

    if (!this.pixelMap) {
      return
    }
    const winWidth = area?.width as number || this.winSize.width
    const winHeight = area?.height as number || this.winSize.height
    this.winSize = {
      width: winWidth,
      height: winHeight
    }
    let width = 0
    let height = 0
    this.pixelMap.getImageInfo((error, info) => {
      let size = info.size

      if (size.width > winWidth) {
        if ((winWidth / winHeight) > (size.width / size.height)) {
          height = winHeight
          width = height * size.width / size.height
        } else {
          width = winWidth
          height = width / size.width * size.height
        }
      } else if (size.height > winHeight) {
        height = winHeight
        width = height * size.width / size.height
      } else {
        width = size.width
        height = size.height
      }
      // 显示尺寸
      this.canvasImage = {
        width: width,
        height: height
      }
      // 缩放比例
      this.ratio = size.width / width
      // 原图尺寸
      this.imageSize = size
    })
  }

  onMiniToolbar(action: number) {

    if (this.pixelMap == undefined) {
      return
    }

    if (action == 0) {
      this.verticalFlip = !this.verticalFlip
      this.pixelMap.flip(false, true, () => {
        this.pixelMapChange()
      })
    } else if (action == 1) {
      this.horizontalFlip = !this.horizontalFlip
      this.pixelMap.flip(true, false, () => {
        this.pixelMapChange()
      })
    } else {
      this.rotationAngle += 90
      this.pixelMap.rotate(90, (error) => {
        this.pixelMapChange()
        this.getImageSize()
      })
    }
  }

  pixelMapChange() {
    let temporaryPixel = this.pixelMap
    this.pixelMap = undefined
    this.pixelMap = temporaryPixel
  }

  async crop(callback: (filename: string) => void) {

    this.cropLoading = true
    if (this.pixelMap == undefined) {
      return
    }

    let imageInfo: image.ImageInfo = await this.pixelMap.getImageInfo()
    // 原图尺寸
    let height = imageInfo.size.height
    let width = imageInfo.size.width
    // 渲染尺寸
    let imageWidth = this.canvasImage.width
    let imageHeight = this.canvasImage.height
    // 画布尺寸
    let winWidth = this.winSize.width
    let winHeight = this.winSize.height
    // 裁剪区域
    let cropWidth = this.cropSize.width
    let cropHeight = this.cropSize.height
    let x = 0
    let y = 0

    x = Math.abs(cropWidth - imageWidth) / 2 + (this.scale - 1) * imageWidth / 2 - this.positionX
    y = Math.abs(imageHeight - cropHeight) / 2 + (this.scale - 1) * imageHeight / 2 - this.positionY

    let region: image.Region = {
      x: x / this.scale * height / imageHeight,
      y: y / this.scale * height / imageHeight,
      size: {
        height: this.cropSize.height / this.scale * height / imageHeight,
        width: this.cropSize.width / this.scale * height / imageHeight
      }
    }


    this.copyPixelMap(this.pixelMap).then(pixelMap => {
      pixelMap.crop(region, (error: BusinessError) => {
        if (error) {
          promptAction.showToast({ message: '裁切头像出现错误请重新尝试' })
        } else {
          let name = FileUtil.createFile('img', '.jpg') // User Id Number
          if (!pixelMap) {
            return
          }
          FileUtil.savePixelMap2File(pixelMap, name, status => {
            if (status) {
              setTimeout(() => {
                this.cropLoading = false
                callback(name)
              }, 1000)
            }
          })
        }
      })
    })
  }

  async copyPixelMap(pixelMap: PixelMap): Promise<PixelMap> {

    const imageInfo: image.ImageInfo = await pixelMap.getImageInfo()
    const buffer: ArrayBuffer = new ArrayBuffer(pixelMap.getPixelBytesNumber())

    await pixelMap.readPixelsToBuffer(buffer)

    // 知识点：通过readPixelsToBuffer实现PixelMap的深拷贝，其中readPixelsToBuffer输出为BGRA_8888
    // 知识点：readPixelsToBuffer输出为BGRA_8888,此处createPixelMap需转为RGBA_8888
    const options: image.InitializationOptions = {
      editable: true,
      pixelFormat: image.PixelMapFormat.RGBA_8888,
      size: {
        height: imageInfo.size.height,
        width: imageInfo.size.width
      }
    }
    return await image.createPixelMap(buffer, options)
  }
}