using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Time;
using Toybox.Time.Gregorian;

class ClockView extends WatchUi
.View {
  private var _logger;

  // Private constructor
  function initialize() {
    _logger = getLogger();
    View.initialize();

    _logger.debug("ClockView", "=== ClockView initialized ===");
  }

  function onLayout(dc as Graphics.Dc) as Void {
    _logger.debug("ClockView", "=== ClockView onLayout ===");
  }

  function onUpdateHeartbeat() { WatchUi.requestUpdate(); }

  function onShow() as Void {
    _logger.debug("ClockView", "=== ClockView onShow ===");
  }

  // This is called when the view is hidden/closed
  function onHide() { _logger.debug("ClockView", "=== ClockView onHide ==="); }

  function onUpdate(dc as Graphics.Dc) as Void {
    _logger.trace("ClockView", "=== ClockView onUpdate ===");
    var width = dc.getWidth();
    var height = dc.getHeight();

    // Clear screen
    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
    dc.clear();

    // Draw Bluetooth connection status (top-right corner)
    drawBluetoothStatus(dc, width, height);

    // Draw time
    var clockTime = System.getClockTime();
    var timeString = Lang.format("$1$:$2$", [
      clockTime.hour.format("%02d"),
      clockTime.min.format("%02d"),
    ]);

    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    dc.drawText(width / 2, height / 3, Graphics.FONT_NUMBER_HOT, timeString,
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

    // Draw seconds
    dc.drawText(width / 2, height / 2, Graphics.FONT_MEDIUM,
                clockTime.sec.format("%02d"),
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

    // Draw date
    var now = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
    var dateString = Lang.format("$1$ $2$ $3$", [
      now.day_of_week,
      now.day,
      now.month,
    ]);

    dc.drawText(width / 2, (height * 2) / 3, Graphics.FONT_SMALL, dateString,
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
  }

  private function drawBluetoothStatus(dc as Graphics.Dc, width as Lang.Number,
                                       height as Lang.Number) as Void {
    var phoneConnection = getPhoneConnection();
    var status = phoneConnection.getConnectionStatus();

    var color;
    if (status == PhoneConnection.STATUS_CONNECTED) {
      color = Graphics.COLOR_GREEN;
    } else if (status == PhoneConnection.STATUS_CONNECTING) {
      color = Graphics.COLOR_YELLOW;
    } else {
      color = Graphics.COLOR_RED;
    }

    // Draw Bluetooth symbol in top-right corner
    var x = width / 2;
    var y = 30;
    var size = 16;

    _logger.debug("ClockView", "Draw bluetooth status: " + status +
                                   " at x: " + x + " y: " + y);
    drawBluetoothSymbol(dc, x, y, size, color);
  }

  private function drawBluetoothSymbol(dc as Graphics.Dc, x as Lang.Number,
                                       y as Lang.Number, size as Lang.Number,
                                       color as Lang.Number) as Void {
    dc.setColor(color, Graphics.COLOR_TRANSPARENT);
    dc.drawText(x, y, Graphics.FONT_LARGE, "\u24B7",
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
  }

  private function drawBluetoothSymbolx(
      dc as Graphics.Dc, centerX as Lang.Number, centerY as Lang.Number,
      size as Lang.Number, color as Lang.Number) as Void {
    dc.setColor(color, Graphics.COLOR_TRANSPARENT);

    var halfSize = size / 2;
    var quarterSize = size / 4;

    // Draw central vertical line
    dc.setPenWidth(2);
    dc.drawLine(centerX, centerY - halfSize, centerX, centerY + halfSize);

    // Draw upper triangle (top-right)
    dc.fillPolygon([
      [centerX, centerY - halfSize],
      [centerX + halfSize, centerY - quarterSize], [centerX, centerY]
    ]);

    // Draw lower triangle (bottom-right)
    dc.fillPolygon([
      [centerX, centerY], [centerX + halfSize, centerY + quarterSize],
      [centerX, centerY + halfSize]
    ]);

    // Draw upper left line
    dc.drawLine(centerX, centerY - halfSize, centerX - halfSize,
                centerY - quarterSize);

    // Draw lower left line
    dc.drawLine(centerX, centerY + halfSize, centerX - halfSize,
                centerY + quarterSize);
  }

  function onEnterSleep() as Void {}

  function onExitSleep() as Void {}
}
