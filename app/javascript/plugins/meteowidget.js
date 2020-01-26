const meteoWidget = () => {
  const openMeteo = document.getElementById('meteo-widget');
  const widgetMeteoFrance = document.getElementById('widget-meteofrance');
  openMeteo.addEventListener('click', (event) => {
    widgetMeteoFrance.classList.toggle('hidden');
  })
};

export { meteoWidget } ;
