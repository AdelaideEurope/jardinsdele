import "bootstrap";
import { toolTip } from "plugins/tooltip";
import { minuteur } from "plugins/minuteur";
import { initFlatPickr } from "plugins/flatpickr";
import { meteoWidget } from "plugins/meteowidget";

toolTip();

if (document.getElementById('play-button')) {
  minuteur();
};

if (document.getElementById('meteo-widget')) {
  meteoWidget();
};

initFlatPickr();

