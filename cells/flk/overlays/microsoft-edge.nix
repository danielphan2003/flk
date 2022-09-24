final: prev: {
  microsoft-edge = final.electron-utils.wrapElectron prev.microsoft-edge-beta {};
  microsoft-edge-beta = final.electron-utils.wrapElectron prev.microsoft-edge-beta {};
  microsoft-edge-dev = final.electron-utils.wrapElectron prev.microsoft-edge-dev {};
}
