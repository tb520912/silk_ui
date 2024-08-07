export class SilkDropdownMenuController {
  count: number = 0
  id: string = ''
  toggle (id: string, value?: string | number) {
    this.id = id
  }
  append (id: string) {
    this.count++
  }
  getLength (): number {
    return this.count
  }
}