using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Time;
using Toybox.Time.Gregorian;

class ClockView extends WatchUi
.View {
  private var logger;

  // Private constructor
  function initialize() {
    logger = getLogger();
    View.initialize();

    logger.debug("ClockView", "=== ClockView initialized ===");
  }

  function onLayout(dc as Graphics.Dc) as Void {
    logger.debug("ClockView", "=== ClockView onLayout ===");
  }

  function onUpdateHeartbeat() { WatchUi.requestUpdate(); }

  function onShow() as Void {
    logger.debug("ClockView", "=== ClockView onShow ===");
  }

  // This is called when the view is hidden/closed
  function onHide() { logger.debug("ClockView", "=== ClockView onHide ==="); }

  function onUpdate(dc as Graphics.Dc) as Void {
    logger.trace("ClockView", "=== ClockView onUpdate ===");
    var width = dc.getWidth();
    var height = dc.getHeight();

    // Clear screen
    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
    dc.clear();

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

  function onEnterSleep() as Void {}

  function onExitSleep() as Void {}
}
