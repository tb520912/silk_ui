import { JSON } from '@kit.ArkTS'

export class ObjectUtils {
  static assign<T extends object>(...args: T[]): T {
    if (args.length < 2) {
      throw new Error('参数不能为空')
    } else {
      const obj: T = JSON.parse(JSON.stringify(args[0])) as T
      const keys = Object.keys(args[0])
      const arr = args.slice(1)
      if (arr.length) {
        for (let index = 0; index < arr.length; index++) {
          const element = arr[index];

          if (!keys.length) {
            throw new Error('不支持空对象参数')
          }
          keys.forEach((key: string) => {
            obj[key] = element[key] || obj[key]
          })
        }
      }
      return obj
    }
  }
}