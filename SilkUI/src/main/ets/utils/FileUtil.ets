import { fileIo, fileUri } from '@kit.CoreFileKit';
import util from '@ohos.util';
import { BusinessError } from '@kit.BasicServicesKit';
import Logger from './Logger';
import { image } from '@kit.ImageKit';

const TAG: string = '[FileUtil]';

export class FileUtil {
  public static createFile(type: 'img' | 'voice' | 'video', suffix: string) {
    const context = getContext()
    let basePath = context.cacheDir + '/'
    switch (type) {
      case 'img':
        basePath += 'img/'
        break
      case 'voice':
        basePath += 'voice/'
        break
      case 'video':
        basePath += 'video/'
        break
    }
    if (!fileIo.accessSync(basePath)) {
      fileIo.mkdirSync(basePath)
    }
    const filePath = basePath + util.generateRandomUUID() + (suffix ? suffix : '.jpg')
    const file = fileIo.openSync(filePath, fileIo.OpenMode.CREATE)
    fileIo.closeSync(file.fd)
    return filePath
  }

  public static deleteFile(filePath: string): void {
    Logger.info(TAG, 'rmdir deleteFile:' + filePath);
    fileIo.rmdir(filePath, (err: BusinessError) => {
      if (err) {
        Logger.error(TAG, `deleteFile failed code: ${err.code}, message: ${err.message}`);
      } else {
        Logger.info(TAG, 'deleteFile succeed');
      }
    });
  }

  public static saveBuffer2File(filePath: string, buffer: ArrayBuffer): void {
    Logger.info(TAG, 'saveBuffer2File filePath:' + filePath);
    try {
      let distFile = fileIo.openSync(filePath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
      fileIo.write(distFile.fd, buffer);
      fileIo.closeSync(distFile.fd)
      Logger.info(TAG, 'saveBuffer2File success');
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      Logger.error(TAG, `saveBuffer2File failed code: ${err.code}, message: ${err.message}`);
    }
  }

  public static getFileUri(filePath: string): string {
    return fileUri.getUriFromPath(filePath);
  }

  public static savePixelMap2File(pixelMap: PixelMap, filePath: string, callback?: (status: boolean) => void) {
    Logger.info(TAG, 'savePixelMap2File filePath:' + filePath);
    // let packOpts: image.PackingOption = { format: "image/png ", quality: 100 };
    try {
      const imagePacker = image.createImagePacker()
      const options: image.PackingOption = { format: 'image/jpeg', quality: 100 }
      imagePacker.packing(pixelMap, options, (err, buffer) => {
        if (err) {
          callback && callback(false)
        } else {
          let file = fileIo.openSync(filePath, fileIo.OpenMode.CREATE | fileIo.OpenMode.READ_WRITE);
          pixelMap.readPixelsToBufferSync(buffer)
          fileIo.writeSync(file.fd, buffer);
          fileIo.closeSync(file.fd)
          callback && callback(true)
        }
      })

    } catch (err) {
      Logger.error(TAG, `savePixelMap2File failed code: ${err.code}, message: ${err.message}`);
      callback && callback(false)
    }
    // let imagePackerApi = image.createImagePacker();
    // imagePackerApi.packToFile(pixelMap, file.fd, packOpts).then(() => {
    //   Logger.info(TAG, 'savePixelMap2File success');
    //   fileIo.closeSync(file.fd);
    //   callback && callback(true)
    // }).catch((err: BusinessError) => {
    //   fileIo.closeSync(file.fd);
    //   callback && callback(false)
    //   Logger.error(TAG, `savePixelMap2File failed code: ${err.code}, message: ${err.message}`);
    // })
  }
}