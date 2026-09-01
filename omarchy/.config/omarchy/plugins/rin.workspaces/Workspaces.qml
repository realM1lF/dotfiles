import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import qs.Commons
import qs.Ui

// Workspaces widget customized for split-monitor-workspaces:
// each bar shows only the workspaces of ITS monitor (1-10, 11-20, ...),
// labeled per monitor as 1-0, and highlights the workspace that is active
// on that monitor (not just the globally focused one).
BarWidget {
  id: root
  moduleName: "rin.workspaces"

  // Name of the screen this bar instance lives on (one bar per monitor).
  readonly property string screenName: {
    var win = root.QsWindow ? root.QsWindow.window : null
    return win && win.screen ? String(win.screen.name || "") : ""
  }

  function screenMonitor() {
    var monitors = Hyprland.monitors.values
    for (var i = 0; i < monitors.length; i++) {
      if (String(monitors[i].name) === root.screenName) return monitors[i]
    }
    return null
  }

  // Workspaces living on this bar's monitor, sorted by id.
  // split-monitor-workspaces creates them persistently, so all 10 per
  // monitor are always present. Fallback while the window is not attached
  // yet (screenName unknown): workspaces 1-10, like the stock widget.
  function workspaces() {
    var result = []
    var values = Hyprland.workspaces.values
    for (var i = 0; i < values.length; i++) {
      var ws = values[i]
      if (ws.id <= 0) continue // skip special workspaces (scratchpad etc.)
      var mon = ws.monitor
      if (root.screenName === "") {
        if (ws.id <= 10) result.push(ws)
      } else if (mon && String(mon.name) === root.screenName) {
        result.push(ws)
      }
    }
    result.sort(function(left, right) { return left.id - right.id })
    return result
  }

  // Per-monitor label: workspace 11-20 on the second monitor show as 1-0.
  function label(id) {
    var n = ((id - 1) % 10) + 1
    return n === 10 ? "0" : String(n)
  }

  function focusWorkspace(id) {
    if (!root.bar) return
    root.bar.run("hyprctl dispatch " + Util.shellQuote("hl.dsp.focus({ workspace = \"" + id + "\" })"))
  }

  readonly property real trailingGap: root.vertical ? 0 : Style.spaceReal(1.5)

  implicitWidth: grid.implicitWidth + trailingGap
  implicitHeight: grid.implicitHeight

  GridLayout {
    id: grid
    anchors.fill: parent
    anchors.rightMargin: root.trailingGap
    columns: root.vertical ? 1 : root.workspaces().length
    columnSpacing: root.vertical ? 0 : Style.space(1)
    rowSpacing: root.vertical ? Style.space(2) : 0

    Repeater {
      model: root.workspaces()

      WidgetButton {
        required property var modelData

        readonly property var workspace: modelData
        readonly property bool occupied: workspace.toplevels.values.length > 0
        // Active on THIS monitor (each monitor keeps its own active workspace
        // with split-monitor-workspaces), not just globally focused.
        readonly property bool focused: {
          var mon = root.screenMonitor()
          return mon !== null && mon.activeWorkspace !== null && mon.activeWorkspace.id === workspace.id
        }

        bar: root.bar
        text: focused ? "󱓻" : root.label(workspace.id)
        opacity: occupied || focused ? 1 : 0.5
        horizontalMargin: 6
        verticalPadding: 6
        fixedWidth: root.vertical ? root.barSize : Style.space(20)
        fixedHeight: root.barSize
        onPressed: function() { root.focusWorkspace(workspace.id) }
      }
    }
  }
}
