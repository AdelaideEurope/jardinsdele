import "bootstrap";
import { toolTip } from "plugins/tooltip";
import { minuteur } from "plugins/minuteur";
import { initFlatPickr } from "plugins/flatpickr";
import { meteoWidget } from "plugins/meteowidget";
import 'select2/dist/css/select2.css';
import { initSelect2 } from 'plugins/init_select2';

toolTip();

if (document.getElementById('play-button')) {
  minuteur();
};

if (document.getElementById('meteo-widget')) {
  meteoWidget();
};

initFlatPickr();

initSelect2();
