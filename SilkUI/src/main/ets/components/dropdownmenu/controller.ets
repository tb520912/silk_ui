export class SilkDropdownMenuController {
  private values: Map<string, string | number> = new Map()
  id: string = ''
  toggle (id: string, value?: string | number) {
    this.id = id
    if (value !== undefined) {
      if (this.values.has(id)) {
        this.values.set(id, value)
      }
    } else {

    }
  }
}