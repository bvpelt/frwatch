using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Time;
using Toybox.Time.Gregorian;

class ClockView extends WatchUi
.View {
  private var _logger;
  private var _iconFont;
  private var _centerX;
  private var _centerY;
  private var _radius;
  private var _info;

  // Private constructor
  function initialize() {
    _logger = getLogger();
    View.initialize();

    _logger.trace("ClockView", "=== ClockView initialized ===");
  }

  function onLayout(dc as Graphics.Dc) as Void {
    _logger.trace("ClockView", "=== ClockView onLayout ===");
    _centerX = dc.getWidth() / 2;
    _centerY = dc.getHeight() / 2;
    var minDimension = _centerX < _centerY ? _centerX : _centerY;
    _radius = minDimension * 0.95;
    _iconFont = WatchUi.loadResource(Rez.Fonts.IconFont);
  }

  function onUpdateHeartbeat() { WatchUi.requestUpdate(); }

  function onShow() as Void {
    _logger.trace("ClockView", "=== ClockView onShow ===");
  }

  // This is called when the view is hidden/closed
  function onHide() { _logger.debug("ClockView", "=== ClockView onHide ==="); }

  function onUpdate(dc as Graphics.Dc) as Void {
    _logger.trace("ClockView", "=== ClockView onUpdate ===");

    _info = ActivityMonitor.getInfo();
    // var width = dc.getWidth();
    // var height = dc.getHeight();

    // Clear screen
    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
    dc.clear();

    // Draw Bluetooth connection status
    drawBluetoothStatus(dc);

    // Draw Battery status
    drawBatteryStatus(dc);

    // Draw Steps
    drawSteps(dc);

    // Draw Distance
    drawDistance(dc);

    // Draw time
    var clockTime = System.getClockTime();
    var timeString = Lang.format("$1$:$2$", [
      clockTime.hour.format("%02d"),
      clockTime.min.format("%02d"),
    ]);

    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    dc.drawText(dc.getWidth() / 2, dc.getHeight() / 3, Graphics.FONT_NUMBER_HOT,
                timeString,
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

    // Draw seconds
    dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_MEDIUM,
                clockTime.sec.format("%02d"),
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

    // Draw date
    var now = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
    var dateString = Lang.format("$1$ $2$ $3$", [
      now.day_of_week,
      now.day,
      now.month,
    ]);

    dc.drawText(dc.getWidth() / 2, (dc.getHeight() * 2) / 3,
                Graphics.FONT_SMALL, dateString,
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
  }

  private function drawBluetoothStatus(dc as Graphics.Dc) as Void {
    var phoneConnection = getPhoneConnection();
    var status = phoneConnection.getConnectionStatus();

    var x = (_centerX).toNumber() - 15;
    var y = (_centerY - _radius * 0.75).toNumber();

    _logger.trace("ClockView", "Draw bluetooth status: " + status +
                                   " at x: " + x + " y: " + y);

    ViewUtil.drawBlueTooth(dc, x, y, _iconFont, status);
  }

  private function drawBatteryStatus(dc as Graphics.Dc) {
    var loadPercentage = System.getSystemStats().battery;
    var x = (_centerX).toNumber() + 15;
    var y = (_centerY - _radius * 0.75).toNumber();

    _logger.trace("ClockView", "Draw battery percentage: " + loadPercentage +
                                   " at x: " + x + " y: " + y);

    ViewUtil.drawBattery(dc, x, y, _iconFont, loadPercentage);
  }

  private function drawSteps(dc as Graphics.Dc) {
    var x = (_centerX).toNumber();
    var y = (_centerY + _radius * 0.75).toNumber();

    _logger.trace("ClockView", "Draw steps at x: " + x + " y: " + y);

    ViewUtil.drawSteps(dc, x, y, Graphics.FONT_TINY, _info);
  }

  private function drawDistance(dc as Graphics.Dc) {
    var x = (_centerX).toNumber();
    var y = (_centerY + _radius * 0.55).toNumber();

    _logger.trace("ClockView", "Draw steps at x: " + x + " y: " + y);

    ViewUtil.drawDistance(dc, x, y, Graphics.FONT_TINY, _info);
  }

  function onEnterSleep() as Void {}

  function onExitSleep() as Void {}
}
