import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ConvertMessage {
  static Widget showIcon(String data, double iconSize, bool themeApp) {
    final result = data.split("/");
    switch (result[0]) {
      case "TEMP":
        return FaIcon(FontAwesomeIcons.temperatureLow, size: iconSize, color: themeApp? const Color.fromARGB(255, 162, 196, 255) : Colors.green.shade400);
      case "SD":
        return FaIcon(FontAwesomeIcons.sdCard, size: iconSize, color: themeApp? const Color.fromARGB(255, 162, 196, 255) : Colors.green.shade400);
      case "AC":
        if (result[1] == "ON") {
          return FaIcon(FontAwesomeIcons.plugCircleCheck, size: iconSize, color: themeApp? const Color.fromARGB(255, 162, 196, 255) : Colors.green.shade400);
        } else {
          return FaIcon(FontAwesomeIcons.plugCircleXmark, size: iconSize, color: themeApp? const Color.fromARGB(255, 162, 196, 255) : Colors.green.shade400);
        }
      case "REPORT":
        return FaIcon(FontAwesomeIcons.file, size: iconSize, color: themeApp? const Color.fromARGB(255, 162, 196, 255) : Colors.green.shade400);
      default:
        if (result[1] == "TEMP") {
          if (result[2] == "OVER") {
            return FaIcon(FontAwesomeIcons.temperatureArrowUp, size: iconSize, color: themeApp? const Color.fromARGB(255, 162, 196, 255) : Colors.green.shade400);
          } else if (result[2] == "LOWER") {
            return FaIcon(FontAwesomeIcons.temperatureArrowDown, size: iconSize, color: themeApp? const Color.fromARGB(255, 162, 196, 255) : Colors.green.shade400);
          } else {
            return FaIcon(FontAwesomeIcons.temperatureLow, size: iconSize, color: themeApp? const Color.fromARGB(255, 162, 196, 255) : Colors.green.shade400);
          }
        } else if (result[1] == "SENSOR") {
          return FaIcon(result[2] == "ON" ? FontAwesomeIcons.check : FontAwesomeIcons.xmark, size: iconSize, color: themeApp? const Color.fromARGB(255, 162, 196, 255) : Colors.green.shade400);
        } else {
          return FaIcon(result[2] == "ON" ? FontAwesomeIcons.doorOpen : FontAwesomeIcons.doorClosed, size: iconSize, color: themeApp? const Color.fromARGB(255, 162, 196, 255) : Colors.green.shade400);
        }
    }
  }
}