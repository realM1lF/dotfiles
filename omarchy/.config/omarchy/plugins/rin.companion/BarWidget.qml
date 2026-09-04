import QtQuick
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "rin.companion"

  readonly property string toggleScript: Color.home + "/.config/omarchy/plugins/rin.companion/toggle.sh"
  readonly property string monkeyMood: panelLoader.item && panelLoader.item.busy ? "think" : "idle"

  function injectPanel() {
    var target = panelLoader.item
    if (!target) return
    if ("bar" in target) target.bar = root.bar
    if ("settings" in target) target.settings = root.settings
    if ("anchorItem" in target) target.anchorItem = button
    if ("hostWidget" in target) target.hostWidget = root
  }

  function togglePanel() {
    var p = panelLoader.item
    if (!p) return
    if (p.opened) {
      p.close()
      return
    }
    if (p.setTab) p.setTab(1)
    if (p.open) p.open()
  }

  function refreshPanel() {
    if (panelLoader.item && panelLoader.item.reloadFiles) panelLoader.item.reloadFiles()
  }

  function toggleAgent() {
    if (!root.bar) return
    root.bar.run(Util.shellQuote(root.toggleScript))
  }

  readonly property bool opened: panelLoader.item ? panelLoader.item.opened === true : false

  function open() {
    if (panelLoader.item && panelLoader.item.openFromHotkey) panelLoader.item.openFromHotkey()
  }

  function close() {
    if (panelLoader.item && panelLoader.item.close) panelLoader.item.close()
  }

  readonly property bool popoutSwitchClosing: panelLoader.item ? panelLoader.item.popoutSwitchClosing === true : false

  function closeForPopoutSwitch() {
    if (panelLoader.item) panelLoader.item.closeForPopoutSwitch()
  }

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  onBarChanged: injectPanel()
  onSettingsChanged: injectPanel()

  Loader {
    id: panelLoader
    active: true
    source: Qt.resolvedUrl("Panel.qml")
    visible: false
    onLoaded: {
      root.injectPanel()
      Qt.callLater(root.injectPanel)
    }
  }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    slotSize: Style.bar.statusSlot
    tooltipText: "Companion — links Agent-TUI, rechts Dateien"
    iconComponent: Component {
      Monkey {
        anchors.fill: parent
        mood: root.monkeyMood
        accent: Color.accent
      }
    }

    onPressed: function(b) {
      if (!root.bar) return
      if (b === Qt.RightButton) root.togglePanel()
      else if (b === Qt.MiddleButton) root.refreshPanel()
      else root.toggleAgent()
    }
  }
}

