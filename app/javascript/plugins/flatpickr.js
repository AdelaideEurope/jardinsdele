import flatpickr from "flatpickr";
import "flatpickr/dist/themes/airbnb.css";
import { French } from 'flatpickr/dist/l10n/fr.js';
const initFlatPickr = () => {
  flatpickr(".datepicker", {
    locale: French,
    dateFormat: "d F Y",
  });
};

export { initFlatPickr }
