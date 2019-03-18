export default function inject(name: string, object: any): boolean {
  const wind = window as any;
  if (wind[name]) {
    return false;
  }
  wind[name] = object;
  return true;
}
