export class ObjectUtils {
  static assign<T extends object>(...args: T[]): T {
    if (args.length < 2) {
      throw new Error('参数不能为空')
    } else {
      const obj = args[0]
      const arr = args.slice(1)
      const keys = Object.keys(args[1])
      if (!keys.length) {
        throw new Error('不支持空对象参数')
      }
      if (arr.length) {
        for (let index = 0; index < arr.length; index++) {
          const element = arr[index];
          keys.forEach((key: string) => {
            obj[key] = element[key] || obj[key]
          })
        }
      }
      return obj
    }
  }
}