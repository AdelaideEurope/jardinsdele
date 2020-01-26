import $ from 'jquery';
import 'select2';

const initSelect2 = () => {
  $('.select2').select2();
  $('.select2planche').select2();
  $('.select2activite').select2();
};

export { initSelect2 };
