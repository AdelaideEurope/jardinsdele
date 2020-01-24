import flatpickr from "flatpickr";
import "flatpickr/dist/themes/airbnb.css";
import { French } from 'flatpickr/dist/l10n/fr.js';
const initFlatPickr = () => {
  flatpickr(".datepicker", {
    locale: French,
    altFormat: 'd M Y',
    altInput: true,
  });
};

export { initFlatPickr };
