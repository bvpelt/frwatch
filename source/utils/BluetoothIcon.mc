using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;

module BluetoothIcon {

  // Draw Bluetooth icon with connection status color
  function draw(dc as Graphics.Dc, x as Lang.Number, y as Lang.Number,
                size as Lang.Number) as Void {
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

    drawBluetoothSymbol(dc, x, y, size, color);
  }

  // Draw the actual Bluetooth symbol
  function drawBluetoothSymbol(dc as Graphics.Dc, centerX as Lang.Number,
                               centerY as Lang.Number, size as Lang.Number,
                               color as Lang.Number) as Void {
    dc.setColor(color, Graphics.COLOR_TRANSPARENT);

    // Bluetooth symbol is like a vertical line with two triangles
    var halfSize = size / 2;
    var quarterSize = size / 4;

    // Draw central vertical line
    dc.setPenWidth(2);
    dc.drawLine(centerX, centerY - halfSize, centerX, centerY + halfSize);

    // Draw upper triangle (top-right)
    dc.fillPolygon([
      [centerX, centerY - halfSize],               // Top center
      [centerX + halfSize, centerY - quarterSize], // Right middle
      [centerX, centerY]                           // Center
    ]);

    // Draw lower triangle (bottom-right)
    dc.fillPolygon([
      [centerX, centerY],                          // Center
      [centerX + halfSize, centerY + quarterSize], // Right middle
      [centerX, centerY + halfSize]                // Bottom center
    ]);

    // Draw upper left line
    dc.drawLine(centerX, centerY - halfSize, centerX - halfSize,
                centerY - quarterSize);

    // Draw lower left line
    dc.drawLine(centerX, centerY + halfSize, centerX - halfSize,
                centerY + quarterSize);
  }
}