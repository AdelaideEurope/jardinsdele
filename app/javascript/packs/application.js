import "bootstrap";
import { toolTip } from "plugins/tooltip";
import { minuteur } from "plugins/minuteur";
import { initFlatPickr } from "plugins/flatpickr";

toolTip();

if (document.getElementById('play-button')) {
  minuteur();
};

initFlatPickr();
