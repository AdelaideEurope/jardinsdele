import "bootstrap";
import { toolTip } from "plugins/tooltip";
import { minuteur } from "plugins/minuteur";
import { initFlatPickr } from "plugins/flatpickr";
import { meteoWidget } from "plugins/meteowidget";
import { autoFillPrix } from 'plugins/autofillprix';
import { autoFillPrixPanier } from 'plugins/autofillprixpanier';
import { closingWindow } from 'plugins/closingwindow';
import 'select2/dist/css/select2.css';
import { initSelect2 } from 'plugins/init_select2';
import { hideLegume } from 'plugins/hide_legumes';
import { hideLegumeShow } from 'plugins/hide_legume_show';

require("chartkick");
require("chart.js");

toolTip();


if (document.getElementById('play-button')) {
  minuteur();
};


if (document.getElementById('par-ca-legume')) {
  hideLegume();
};

if (document.getElementById('chart-legume')) {
  hideLegumeShow();
};


if (document.getElementById('meteo-widget')) {
  meteoWidget();
};

if (document.getElementById('puht')) {
  autoFillPrix();
};

if (document.querySelector('#recolte-img')) {
  autoFillPrixPanier();
};

if (document.getElementById('savebeforeleaving')) {
  closingWindow();
}



initFlatPickr();

initSelect2();
