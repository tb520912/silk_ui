import request from '@ohos.request'

export const uploadFile = async (context: Context, file: request.File, data: object, uploadUrl: string) => {
  if (!file) {
    return;
  }
  const upData: request.RequestData[] = []
  const keys = Object.keys(data)
  if (keys && keys.length) {
    keys.forEach(key => {
      upData.push({
        name: key,
        value: data[key]
      })
    })
  }
  const config: request.UploadConfig = {
    url: uploadUrl,
    method: 'POST',
    header: {
      'Accept': '*/*',
      // 'Authorization': `${AppStorage.Get(TOKEN_KEY)}`,
      'Content-Type': 'multipart/form-data',
    },
    files: [file],
    data: upData
  }
  return new Promise<object>(async (resolve, reject) => {
    try {
      const UploadTask = await request.uploadFile(context, config)
      UploadTask.on('fail', (state) => {
        AlertDialog.show({
          message: '上传失败'
        })
      })
      UploadTask.on('headerReceive', (header) => {
        if (!header) {
          return;
        }
        const body = JSON.parse((header as UploadHeader).body || '{}') as UploadResponse
        if (!body) {
          reject('失败')
        }
        if (body.code === 1) {
          resolve(body.data)
        } else {
          reject(body.mag)
        }
      })
      UploadTask.on('complete', async (state) => {
        // AlertDialog.show({
        //   message: `返回值=${JSON.stringify(state)}`
        // })
      })
    } catch (error) {
      AlertDialog.show({
        message: 'ccc' + error.message
      })
    }
  })
}

interface UploadResponse {
  code: number,
  mag: string,
  data: UploadResponseImg
}

interface UploadResponseImg {
  filePath: string
}

interface UploadHeader {
  body: string
}
