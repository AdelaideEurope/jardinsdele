import flatpickr from "flatpickr"
import "flatpickr/dist/flatpickr.min.css"

const flatPickr = () => {
  flatpickr(".datepicker", {
    dateFormat: "Y-m-d",
  })
};

export { flatPickr };
